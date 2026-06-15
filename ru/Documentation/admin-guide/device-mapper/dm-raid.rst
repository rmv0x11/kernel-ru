=======
dm-raid
=======

Target RAID device-mapper (dm-raid) предоставляет мост от DM к MD.
Он позволяет обращаться к драйверам MD RAID через интерфейс
device-mapper.


Интерфейс таблицы отображения
-----------------------------
Target называется "raid" и принимает следующие параметры::

  <raid_type> <#raid_params> <raid_params> \
    <#raid_devs> <metadata_dev0> <dev0> [.. <metadata_devN> <devN>]

<raid_type>:

  ============= ===============================================================
  raid0		Чередование RAID0 (без отказоустойчивости)
  raid1		Зеркалирование RAID1
  raid4		RAID4 с выделенным последним диском чётности
  raid5_n 	RAID5 с выделенным последним диском чётности, поддерживающий takeover из/в raid1
		То же, что и raid4

		- Промежуточная компоновка для takeover из/в raid1
  raid5_la	RAID5 left asymmetric

		- вращающаяся чётность 0 с продолжением данных
  raid5_ra	RAID5 right asymmetric

		- вращающаяся чётность N с продолжением данных
  raid5_ls	RAID5 left symmetric

		- вращающаяся чётность 0 с перезапуском данных
  raid5_rs 	RAID5 right symmetric

		- вращающаяся чётность N с перезапуском данных
  raid6_zr	RAID6 zero restart

		- вращающаяся чётность zero (слева направо) с перезапуском данных
  raid6_nr	RAID6 N restart

		- вращающаяся чётность N (справа налево) с перезапуском данных
  raid6_nc	RAID6 N continue

		- вращающаяся чётность N (справа налево) с продолжением данных
  raid6_n_6	RAID6 с выделенными дисками чётности

		- чётность и Q-syndrome на последних 2 дисках;
		  компоновка для takeover из/в raid0/raid4/raid5_n
  raid6_la_6	То же, что "raid_la", плюс выделенный последний диск Q-syndrome, поддерживающий takeover из/в raid5

		- компоновка для takeover из raid5_la из/в raid6
  raid6_ra_6	То же, что "raid5_ra", с выделенным последним диском Q-syndrome

		- компоновка для takeover из raid5_ra из/в raid6
  raid6_ls_6	То же, что "raid5_ls", с выделенным последним диском Q-syndrome

		- компоновка для takeover из raid5_ls из/в raid6
  raid6_rs_6	То же, что "raid5_rs", с выделенным последним диском Q-syndrome

		- компоновка для takeover из raid5_rs из/в raid6
  raid10        Различные алгоритмы, основанные на RAID10, выбираемые дополнительными параметрами
		(см. raid10_format и raid10_copies ниже)

		- RAID10: Striped Mirrors (он же 'Striping on top of mirrors')
		- RAID1E: Integrated Adjacent Stripe Mirroring
		- RAID1E: Integrated Offset Stripe Mirroring
		- и другие похожие варианты RAID10
  ============= ===============================================================

  Справка: глава 4
  https://www.snia.org/sites/default/files/SNIA_DDF_Technical_Position_v2.0.pdf

<#raid_params>: Число следующих далее параметров.

<raid_params> состоит из

    Обязательных параметров:
        <chunk_size>:
		      Размер chunk в секторах.  Этот параметр часто известен как
		      "stripe size".  Это единственный обязательный параметр, и
		      он указывается первым.

    с последующими необязательными параметрами (в любом порядке):
	[sync|nosync]
		Принудительно запустить или предотвратить инициализацию RAID.

	[rebuild <idx>]
		Перестроить накопитель с номером 'idx' (первый накопитель — 0).

	[daemon_sleep <ms>]
		Интервал между запусками демона bitmap, который
		очищает биты.  Более длинный интервал означает меньше I/O bitmap, но
		ресинхронизация после сбоя, вероятно, займёт больше времени.

	[min_recovery_rate <kB/sec/disk>]
		Ограничить скорость инициализации RAID
	[max_recovery_rate <kB/sec/disk>]
		Ограничить скорость инициализации RAID
	[write_mostly <idx>]
		Пометить накопитель с индексом 'idx' как write-mostly.
	[max_write_behind <sectors>]
		См. '--write-behind=' (man mdadm)
	[stripe_cache <sectors>]
		Размер кэша stripe (только RAID 4/5/6)
	[region_size <sectors>]
		region_size, умноженный на число регионов, даёт
		логический размер массива.  Bitmap записывает состояние
		синхронизации устройства для каждого региона.

        [raid10_copies   <# copies>], [raid10_format   <near|far|offset>]
		Эти две опции используются для изменения компоновки по умолчанию
		конфигурации RAID10.  Можно указать число копий,
		но по умолчанию оно равно 2.  Существуют также три
		варианта расположения копий — по умолчанию
		используется "near".  Копии near — это то, что большинство людей представляют
		в отношении зеркалирования.  Если эти опции оставлены неуказанными
		или заданы 'raid10_copies 2' и/или 'raid10_format near',
		то компоновки для 2, 3 и 4 устройств таковы:

		========	 ==========	   ==============
		2 drives         3 drives          4 drives
		========	 ==========	   ==============
		A1  A1           A1  A1  A2        A1  A1  A2  A2
		A2  A2           A2  A3  A3        A3  A3  A4  A4
		A3  A3           A4  A4  A5        A5  A5  A6  A6
		A4  A4           A5  A6  A6        A7  A7  A8  A8
		..  ..           ..  ..  ..        ..  ..  ..  ..
		========	 ==========	   ==============

		Компоновка для 2 устройств эквивалентна 2-way RAID1.  Компоновка для
		4 устройств — это то, как выглядел бы традиционный RAID10.  Компоновку
		для 3 устройств можно было бы назвать 'RAID1E - Integrated
		Adjacent Stripe Mirroring'.

		Если заданы 'raid10_copies 2' и 'raid10_format far', то компоновки
		для 2, 3 и 4 устройств таковы:

		========	     ============	  ===================
		2 drives             3 drives             4 drives
		========	     ============	  ===================
		A1  A2               A1   A2   A3         A1   A2   A3   A4
		A3  A4               A4   A5   A6         A5   A6   A7   A8
		A5  A6               A7   A8   A9         A9   A10  A11  A12
		..  ..               ..   ..   ..         ..   ..   ..   ..
		A2  A1               A3   A1   A2         A2   A1   A4   A3
		A4  A3               A6   A4   A5         A6   A5   A8   A7
		A6  A5               A9   A7   A8         A10  A9   A12  A11
		..  ..               ..   ..   ..         ..   ..   ..   ..
		========	     ============	  ===================

		Если заданы 'raid10_copies 2' и 'raid10_format offset', то
		компоновки для 2, 3 и 4 устройств таковы:

		========       ==========         ================
		2 drives       3 drives           4 drives
		========       ==========         ================
		A1  A2         A1  A2  A3         A1  A2  A3  A4
		A2  A1         A3  A1  A2         A2  A1  A4  A3
		A3  A4         A4  A5  A6         A5  A6  A7  A8
		A4  A3         A6  A4  A5         A6  A5  A8  A7
		A5  A6         A7  A8  A9         A9  A10 A11 A12
		A6  A5         A9  A7  A8         A10 A9  A12 A11
		..  ..         ..  ..  ..         ..  ..  ..  ..
		========       ==========         ================

		Здесь мы видим компоновки, близкие к 'RAID1E - Integrated
		Offset Stripe Mirroring'.

        [delta_disks <N>]
		Значение опции delta_disks (-251 < N < +251) запускает
		удаление устройства (отрицательное значение) или добавление устройства (положительное
		значение) для любого reshape, поддерживаемого уровнями raid 4/5/6 и 10.
		Уровни RAID 4/5/6 допускают добавление и удаление устройств
                (пара устройств metadata и data), raid10_near и raid10_offset
                допускают только добавление устройства. raid10_far вообще не поддерживает
		никакого reshaping.
		Должно сохраняться минимальное число устройств для обеспечения отказоустойчивости,
		а именно 3 устройства для raid4/5 и 4 устройства для raid6.

        [data_offset <sectors>]
		Значение этой опции задаёт смещение в каждом устройстве данных,
		с которого начинаются данные. Это используется для предоставления
		out-of-place reshaping-пространства, чтобы избежать перезаписи данных
		при изменении компоновки stripes, благодаря чему прерывание/сбой
		может произойти в любой момент без риска потери данных.
		Например, при добавлении устройств в существующий набор raid во время
		прямого reshaping out-of-place-пространство будет выделено
		в начале каждого устройства raid. MD-персоналии ядра raid4/5/6/10,
		поддерживающие такое добавление устройств, будут читать данные из
		существующих первых stripes (с меньшим числом stripes),
		начиная с data_offset, чтобы заполнить новый stripe с бо́льшим
		числом stripes, вычислять блоки избыточности (CRC/Q-syndrome)
		и записывать этот новый stripe со смещением 0. То же будет применено ко всем
		N-1 другим новым stripes. Эта схема out-of-place используется также для изменения
		типа RAID (то есть алгоритма размещения), например,
		смены raid5_ls на raid5_n.

	[journal_dev <dev>]
		Эта опция добавляет журнальное устройство в наборы raid4/5/6 и
		использует его для закрытия 'write hole', вызванной неатомарными обновлениями
		составных устройств, которые могут привести к потере данных во время восстановления.
		Журнальное устройство используется в режиме writethrough, что приводит к
		ограничению скорости записи по сравнению с наборами raid4/5/6 без журнала.
		Takeover/reshape невозможен с журнальным устройством raid4/5/6;
		его необходимо отключить перед запросом этих операций.

	[journal_mode <mode>]
		Эта опция задаёт режим кэширования для наборов raid4/5/6 с журналом
		(см. 'journal_dev <dev>' выше) в значение 'writethrough' или 'writeback'.
		Если выбран 'writeback', журнальное устройство должно быть отказоустойчивым
		и само не должно страдать от проблемы 'write hole' (например, использовать
		raid1 или raid10), чтобы избежать единой точки отказа.

<#raid_devs>: Число устройств, составляющих массив.
	Каждое устройство состоит из двух записей.  Первая — это устройство,
	содержащее метаданные (если есть); вторая — содержащее
	данные. Поддерживается максимум 64 записи устройств metadata/data
	вплоть до версии target 1.8.0.
	1.9.0 поддерживает до 253, что обеспечивается используемым MD-рантаймом ядра.

	Если накопитель отказал или отсутствует во время создания, для данной позиции
	можно указать '-' как для накопителя metadata, так и для data.


Примеры таблиц
--------------

::

  # RAID4 - 4 data drives, 1 parity (no metadata devices)
  # No metadata devices specified to hold superblock/bitmap info
  # Chunk size of 1MiB
  # (Lines separated for easy reading)

  0 1960893648 raid \
          raid4 1 2048 \
          5 - 8:17 - 8:33 - 8:49 - 8:65 - 8:81

  # RAID4 - 4 data drives, 1 parity (with metadata devices)
  # Chunk size of 1MiB, force RAID initialization,
  #       min recovery rate at 20 kiB/sec/disk

  0 1960893648 raid \
          raid4 4 2048 sync min_recovery_rate 20 \
          5 8:17 8:18 8:33 8:34 8:49 8:50 8:65 8:66 8:81 8:82


Вывод состояния
---------------
'dmsetup table' отображает таблицу, используемую для построения отображения.
Необязательные параметры всегда печатаются в перечисленном выше порядке,
причём "sync" или "nosync" всегда выводятся перед остальными
аргументами, независимо от порядка, использованного при первоначальной загрузке таблицы.
Аргументы, которые могут повторяться, упорядочиваются по значению.


'dmsetup status' выдаёт информацию о состоянии и работоспособности массива.
Вывод выглядит следующим образом (обычно одна строка, но здесь развёрнута для
ясности)::

  1: <s> <l> raid \
  2:      <raid_type> <#devices> <health_chars> \
  3:      <sync_ratio> <sync_action> <mismatch_cnt>

Строка 1 — это стандартный вывод, производимый device-mapper.

Строки 2 и 3 производятся target raid и лучше всего объясняются на примере::

        0 1960893648 raid raid4 5 AAAAA 2/490221568 init 0

Здесь мы видим, что тип RAID — raid4, имеется 5 устройств — все они
'A'живы, и массив завершён на 2/490221568 в своём начальном
восстановлении.  Вот более полное описание отдельных полей:

	=============== =========================================================
	<raid_type>     То же, что <raid_type>, использованный при создании массива.
	<health_chars>  По одному символу на каждое устройство, обозначающему:

			- 'A' = жив и синхронизирован (in-sync)
			- 'a' = жив, но не синхронизирован (not in-sync)
			- 'D' = мёртв/отказал.
	<sync_ratio>    Соотношение, показывающее, какая часть массива прошла
			процесс, описанный в 'sync_action'.  Если
			'sync_action' — это "check" или "repair", то процесс
			"resync" или "recover" можно считать завершённым.
	<sync_action>   Одно из следующих возможных состояний:

			idle
				- Никакое действие синхронизации не выполняется.
			frozen
				- Текущее действие приостановлено.
			resync
				- Массив проходит начальную синхронизацию
				  или ресинхронизируется после нечистого завершения работы
				  (возможно, с помощью bitmap).
			recover
				- Устройство в массиве перестраивается или
				  заменяется.
			check
				- Выполняется инициированная пользователем полная проверка
				  массива.  Все блоки читаются и
				  проверяются на согласованность.  Число
				  обнаруженных расхождений записывается в
				  <mismatch_cnt>.  Это действие не вносит изменений в
				  массив.
			repair
				- То же, что "check", но расхождения
				  исправляются.
			reshape
				- Массив проходит reshape.
	<mismatch_cnt>  Число расхождений, найденных между зеркальными копиями
			в RAID1/10, или неверных значений чётности, найденных в RAID4/5/6.
			Это значение действительно только после выполнения "check"
			массива.  Исправный массив имеет 'mismatch_cnt', равный 0.
	<data_offset>   Текущее смещение данных до начала пользовательских данных на
			каждом составном устройстве набора raid (см. соответствующий
			параметр raid для поддержки out-of-place reshaping).
	<journal_char>	- 'A' - активное журнальное устройство write-through.
			- 'a' - активное журнальное устройство write-back.
			- 'D' - мёртвое журнальное устройство.
			- '-' - нет журнального устройства.
	=============== =========================================================


Интерфейс сообщений
-------------------
Target dm-raid будет принимать определённые действия через интерфейс 'message'.
('man dmsetup' для получения дополнительной информации об интерфейсе message.)  Эти действия
включают:

	========= ================================================
	"idle"    Остановить текущее действие синхронизации.
	"frozen"  Заморозить текущее действие синхронизации.
	"resync"  Инициировать/продолжить resync.
	"recover" Инициировать/продолжить процесс recover.
	"check"   Инициировать проверку (то есть "scrub") массива.
	"repair"  Инициировать восстановление массива.
	========= ================================================


Поддержка discard
-----------------
Реализация поддержки discard у различных производителей оборудования различается.
Когда блок отбрасывается (discard), некоторые устройства хранения возвращают нули при
чтении этого блока.  Такие устройства устанавливают атрибут
'discard_zeroes_data'.  Другие устройства возвращают случайные данные.  Что сбивает с толку, некоторые
устройства, заявляющие 'discard_zeroes_data', не возвращают надёжно
нули при чтении отброшенных блоков!  Поскольку RAID 4/5/6 использует блоки
с ряда устройств для вычисления блоков чётности и (из соображений
производительности) полагается на надёжность 'discard_zeroes_data', важно,
чтобы устройства были согласованными.  Блоки могут быть отброшены в середине
stripe RAID 4/5/6, и если последующие результаты чтения не
согласованы, блоки чётности могут вычисляться по-разному в любой момент;
что делает блоки чётности бесполезными для избыточности.  Важно
понимать, как ваше оборудование ведёт себя с discard, если вы собираетесь
включить discard с RAID 4/5/6.

Поскольку поведение устройств хранения в этом отношении ненадёжно,
даже когда они сообщают 'discard_zeroes_data', по умолчанию поддержка
discard для RAID 4/5/6 отключена — это обеспечивает целостность данных за счёт
потери некоторой производительности.

Устройства хранения, которые корректно поддерживают 'discard_zeroes_data',
всё чаще добавляются в whitelist ядра и поэтому им можно доверять.

Для доверенных устройств можно установить следующий параметр модуля dm-raid,
чтобы безопасно включить поддержку discard для RAID 4/5/6:

    'devices_handle_discards_safely'


Поддержка takeover/reshape
--------------------------
Target нативно поддерживает эти два типа преобразований MDRAID:

o Takeover: Преобразует массив из одного уровня RAID в другой

o Reshape: Изменяет внутреннюю компоновку, сохраняя текущий уровень RAID

Каждая операция действительна только при определённых ограничениях, налагаемых компоновкой и конфигурацией существующего массива.


Takeover:
linear -> raid1 с N >= 2 зеркалами
raid0 -> raid4 (добавить выделенное устройство чётности)
raid0 -> raid5 (добавить выделенное устройство чётности)
raid0 -> raid10 с компоновкой near и N >= 2 группами зеркал (stripes raid0 должны стать первым членом внутри групп зеркал)
raid1 -> linear
raid1 -> raid5 с 2 зеркалами
raid4 -> raid5 с вращающейся чётностью
raid5 с выделенным устройством чётности -> raid4
raid5 -> raid6 (с выделенным Q-syndrome)
raid6 (с выделенным Q-syndrome) -> raid5
raid10 с компоновкой near и чётным числом дисков -> raid0 (выбирается любое синхронизированное устройство из каждой группы зеркал)

Reshape:
linear: невозможно
raid0:  невозможно
raid1:  изменить число зеркал
raid4:  добавить и удалить stripes (минимум 3), изменить stripesize
raid5:  добавить и удалить stripes (минимум 3, особый случай 2 для takeover raid1), изменить алгоритмы вращающейся чётности, изменить stripesize
raid6:  добавить и удалить stripes (минимум 4), изменить алгоритмы вращающегося syndrome, изменить stripesize
raid10 near:   добавить stripes (минимум 4), изменить stripesize, удаление stripe невозможно, переход на компоновку offset
raid10 offset: добавить stripes, изменить stripesize, удаление stripe невозможно, переход на компоновку near
raid10 far:    невозможно

Примеры строк таблицы:

### raid1 -> raid5
#
# 2 devices limitation in raid1.
# raid5 personality is able to just map 2 like raid1.
# Reshape after takeover to change to full raid5 layout

  0 1960886272 raid raid1 3 0 region_size 2048 2 /dev/dm-0 /dev/dm-1 /dev/dm-2 /dev/dm-3

# dm-0 and dm-2 are e.g. 4MiB large metadata devices, dm-1 and dm-3 have to be at least 1960886272 big.
#
# Table line to takeover to raid5

  0 1960886272 raid raid5 3 0 region_size 2048 2 /dev/dm-0 /dev/dm-1 /dev/dm-2 /dev/dm-3

# Add required out-of-place reshape space to the beginniong of the given 2 data devices,
# allocate another metadata/data device tuple with the same sizes for the parity space
# and zero the first 4K of the metadata device.
#
# Example table of the out-of-place reshape space addition for one data device, e.g. dm-1

  0 8192 linear 8:0 0 1960903888 #  <- must be free space segment
  8192 1960886272 linear 8:0 0 2048 # previous data segment

# Mapping table for e.g. raid5_rs reshape causing the size of the raid device to double-fold once the reshape finishes.
# Check the status output (e.g. "dmsetup status $RaidDev") for progress.

  0 $((2 * 1960886272)) raid raid5 7 0 region_size 2048 data_offset 8192 delta_disk 1 2 /dev/dm-0 /dev/dm-1 /dev/dm-2 /dev/dm-3


История версий
--------------

::

 1.0.0	Initial version.  Support for RAID 4/5/6
 1.1.0	Added support for RAID 1
 1.2.0	Handle creation of arrays that contain failed devices.
 1.3.0	Added support for RAID 10
 1.3.1	Allow device replacement/rebuild for RAID 10
 1.3.2	Fix/improve redundancy checking for RAID10
 1.4.0	Non-functional change.  Removes arg from mapping function.
 1.4.1	RAID10 fix redundancy validation checks (commit 55ebbb5).
 1.4.2	Add RAID10 "far" and "offset" algorithm support.
 1.5.0	Add message interface to allow manipulation of the sync_action.
	New status (STATUSTYPE_INFO) fields: sync_action and mismatch_cnt.
 1.5.1	Add ability to restore transiently failed devices on resume.
 1.5.2	'mismatch_cnt' is zero unless [last_]sync_action is "check".
 1.6.0	Add discard support (and devices_handle_discard_safely module param).
 1.7.0	Add support for MD RAID0 mappings.
 1.8.0	Explicitly check for compatible flags in the superblock metadata
	and reject to start the raid set if any are set by a newer
	target version, thus avoiding data corruption on a raid set
	with a reshape in progress.
 1.9.0	Add support for RAID level takeover/reshape/region size
	and set size reduction.
 1.9.1	Fix activation of existing RAID 4/10 mapped devices
 1.9.2	Don't emit '- -' on the status table line in case the constructor
	fails reading a superblock. Correctly emit 'maj:min1 maj:min2' and
	'D' on the status line.  If '- -' is passed into the constructor, emit
	'- -' on the table line and '-' as the status line health character.
 1.10.0	Add support for raid4/5/6 journal device
 1.10.1	Fix data corruption on reshape request
 1.11.0	Fix table line argument order
	(wrong raid10_copies/raid10_format sequence)
 1.11.1	Add raid4/5/6 journal write-back support via journal_mode option
 1.12.1	Fix for MD deadlock between mddev_suspend() and md_write_start() available
 1.13.0	Fix dev_health status at end of "recover" (was 'a', now 'A')
 1.13.1	Fix deadlock caused by early md_stop_writes().  Also fix size an
	state races.
 1.13.2	Fix raid redundancy validation and avoid keeping raid set frozen
 1.14.0	Fix reshape race on small devices.  Fix stripe adding reshape
	deadlock/potential data corruption.  Update superblock when
	specific devices are requested via rebuild.  Fix RAID leg
	rebuild errors.
 1.15.0 Fix size extensions not being synchronized in case of new MD bitmap
        pages allocated;  also fix those not occurring after previous reductions
 1.15.1 Fix argument count and arguments for rebuild/write_mostly/journal_(dev|mode)
        on the status line.
