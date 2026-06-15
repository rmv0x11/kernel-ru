============================================
Поддержка снимков (snapshot) в Device-mapper
============================================

Device-mapper позволяет без массового копирования данных:

-  Создавать снимки (snapshot) любого блочного устройства, то есть монтируемые,
   сохранённые состояния блочного устройства, которые также доступны для записи
   без вмешательства в исходное содержимое;
-  Создавать «ответвления» (forks) устройства, то есть несколько различных версий
   одного и того же потока данных.
-  Сливать (merge) снимок блочного устройства обратно в устройство-источник этого
   снимка.

В первых двух случаях dm копирует только те фрагменты (chunks) данных, которые
изменяются, и использует для хранения отдельное блочное устройство
copy-on-write (COW).

При слиянии снимка содержимое хранилища COW сливается обратно в
устройство-источник.


Доступно три цели (targets) dm:
snapshot, snapshot-origin и snapshot-merge.

-  snapshot-origin <origin>

на которой обычно базируется один или несколько снимков.
Операции чтения отображаются непосредственно на нижележащее устройство. При каждой
записи исходные данные сохраняются в <COW device> каждого снимка, чтобы его видимое
содержимое оставалось неизменным, по крайней мере до тех пор, пока <COW device> не
заполнится.


-  snapshot <origin> <COW device> <persistent?> <chunksize>
   [<# feature args> [<arg>]*]

Создаётся снимок блочного устройства <origin>. Изменённые фрагменты размером
<chunksize> секторов будут храниться на <COW device>. Записи будут направляться
только на <COW device>. Чтение неизменённых данных будет происходить с <COW device>
или с <origin>. <COW device> часто бывает меньше источника, и если он заполнится,
снимок станет бесполезным и будет отключён, возвращая ошибки. Поэтому важно
отслеживать объём свободного пространства и расширять <COW device> до его заполнения.

<persistent?> — это P (Persistent, постоянный) или N (Not persistent, не постоянный
— не сохранится после перезагрузки). К постоянному варианту хранилища можно добавить
O (Overflow, переполнение), чтобы позволить userspace объявить о своей поддержке
отображения «Overflow» в статусе снимка. Таким образом, поддерживаемые типы хранилища
— это «P», «PO» и «N».

Разница между постоянными и временными (transient) снимками заключается в том, что
для временных снимков на диске должно сохраняться меньше метаданных — ядро может
держать их в памяти.

При загрузке или выгрузке цели snapshot соответствующая цель snapshot-origin или
snapshot-merge должна быть приостановлена. Неудачная приостановка цели-источника
может привести к повреждению данных.

Необязательные возможности:

   discard_zeroes_cow — операция discard, отправленная на устройство снимка и
   отображающаяся на целые фрагменты, обнулит соответствующее исключение
   (exception(s)) в хранилище исключений снимка.

   discard_passdown_origin — операция discard на устройство снимка передаётся вниз
   на нижележащее устройство snapshot-origin. Это не вызывает копирования (copy-out)
   в хранилище исключений снимка, поскольку цель snapshot-origin обходится.

   Возможность discard_passdown_origin зависит от того, включена ли возможность
   discard_zeroes_cow.


-  snapshot-merge <origin> <COW device> <persistent> <chunksize>
   [<# feature args> [<arg>]*]

принимает те же аргументы таблицы, что и цель snapshot, за исключением того, что она
работает только с постоянными снимками. Эта цель берёт на себя роль цели
«snapshot-origin» и не должна загружаться, если «snapshot-origin» всё ещё присутствует
для <origin>.

Создаёт сливающийся снимок, который через процедуру передачи (handover) берёт под
контроль изменённые фрагменты, хранящиеся в <COW device> существующего снимка, и
сливает эти фрагменты обратно в <origin>. После того как слияние началось (в фоновом
режиме), <origin> может быть открыт, и слияние продолжится, пока к нему идёт I/O.
Изменения <origin> откладываются до тех пор, пока соответствующие фрагменты
сливающегося снимка не будут слиты. После начала слияния устройство снимка,
связанное с целью «snapshot», при обращении к нему будет возвращать -EIO.


Как снимки используются в LVM2
==============================
Когда вы создаёте первый снимок LVM2 для тома, используются четыре устройства dm:

1) устройство, содержащее исходную таблицу отображения исходного тома;
2) устройство, используемое в качестве <COW device>;
3) устройство «snapshot», объединяющее #1 и #2, которое является видимым томом-снимком;
4) «исходный» том (который использует номер устройства, использовавшийся исходным
   исходным томом), чья таблица заменяется отображением «snapshot-origin» с
   устройства #1.

Используется фиксированная схема именования, поэтому при следующих командах::

  lvcreate -L 1G -n base volumeGroup
  lvcreate -L 100M --snapshot -n snap volumeGroup/base

мы получим следующую ситуацию (с томами в указанном выше порядке)::

  # dmsetup table|grep volumeGroup

  volumeGroup-base-real: 0 2097152 linear 8:19 384
  volumeGroup-snap-cow: 0 204800 linear 8:19 2097536
  volumeGroup-snap: 0 2097152 snapshot 254:11 254:12 P 16
  volumeGroup-base: 0 2097152 snapshot-origin 254:11

  # ls -lL /dev/mapper/volumeGroup-*
  brw-------  1 root root 254, 11 29 ago 18:15 /dev/mapper/volumeGroup-base-real
  brw-------  1 root root 254, 12 29 ago 18:15 /dev/mapper/volumeGroup-snap-cow
  brw-------  1 root root 254, 13 29 ago 18:15 /dev/mapper/volumeGroup-snap
  brw-------  1 root root 254, 10 29 ago 18:14 /dev/mapper/volumeGroup-base


Как snapshot-merge используется в LVM2
======================================
Сливающийся снимок при слиянии берёт на себя роль «snapshot-origin». При этом
«snapshot-origin» заменяется на «snapshot-merge». Устройство «-real» не изменяется,
а устройство «-cow» переименовывается в <origin name>-cow, чтобы помочь LVM2 в очистке
сливающегося снимка после его завершения. «snapshot», передающий своё устройство COW
цели «snapshot-merge», деактивируется (если не используется lvchange --refresh); но
если он остаётся активным, он будет просто возвращать ошибки I/O.

Снимок будет слит в свой источник следующей командой::

  lvconvert --merge volumeGroup/snap

теперь мы получим следующую ситуацию::

  # dmsetup table|grep volumeGroup

  volumeGroup-base-real: 0 2097152 linear 8:19 384
  volumeGroup-base-cow: 0 204800 linear 8:19 2097536
  volumeGroup-base: 0 2097152 snapshot-merge 254:11 254:12 P 16

  # ls -lL /dev/mapper/volumeGroup-*
  brw-------  1 root root 254, 11 29 ago 18:15 /dev/mapper/volumeGroup-base-real
  brw-------  1 root root 254, 12 29 ago 18:16 /dev/mapper/volumeGroup-base-cow
  brw-------  1 root root 254, 10 29 ago 18:16 /dev/mapper/volumeGroup-base


Как определить, когда слияние завершено
=======================================
Строки статуса snapshot-merge и snapshot заканчиваются на:

  <sectors_allocated>/<total_sectors> <metadata_sectors>

И <sectors_allocated>, и <total_sectors> включают как данные, так и метаданные.
Во время слияния количество выделенных секторов становится всё меньше и меньше.
Слияние завершено, когда количество секторов, содержащих данные, равно нулю, иными
словами <sectors_allocated> == <metadata_sectors>.

Вот практический пример (с использованием смеси команд lvm и dmsetup)::

  # lvs
    LV      VG          Attr   LSize Origin  Snap%  Move Log Copy%  Convert
    base    volumeGroup owi-a- 4.00g
    snap    volumeGroup swi-a- 1.00g base  18.97

  # dmsetup status volumeGroup-snap
  0 8388608 snapshot 397896/2097152 1560
                                    ^^^^ metadata sectors

  # lvconvert --merge -b volumeGroup/snap
    Merging of volume snap started.

  # lvs volumeGroup/snap
    LV      VG          Attr   LSize Origin  Snap%  Move Log Copy%  Convert
    base    volumeGroup Owi-a- 4.00g          17.23

  # dmsetup status volumeGroup-base
  0 8388608 snapshot-merge 281688/2097152 1104

  # dmsetup status volumeGroup-base
  0 8388608 snapshot-merge 180480/2097152 712

  # dmsetup status volumeGroup-base
  0 8388608 snapshot-merge 16/2097152 16

Слияние завершено.

::

  # lvs
    LV      VG          Attr   LSize Origin  Snap%  Move Log Copy%  Convert
    base    volumeGroup owi-a- 4.00g
