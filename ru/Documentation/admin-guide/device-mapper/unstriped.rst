=====================================
Цель device-mapper «unstriped»
=====================================

Введение
========

Цель device-mapper «unstriped» предоставляет прозрачный механизм для
разбора (unstripe) цели device-mapper «striped», позволяя обращаться к
нижележащим дискам без необходимости трогать настоящее блочное устройство,
лежащее в основе.  Её также можно использовать для разбора аппаратного
RAID-0, чтобы обращаться к дискам, лежащим в его основе.

Параметры:
<number of stripes> <chunk size> <stripe #> <dev_path> <offset>

<number of stripes>
        Количество полос (stripes) в RAID 0.

<chunk size>
	Размер блока (chunk) чередования в секторах по 512 Б.

<dev_path>
	Блочное устройство, которое вы хотите разобрать.

<stripe #>
        Номер полосы в устройстве, соответствующий физическому
        накопителю, который вы хотите разобрать.  Нумерация должна начинаться с 0.


Зачем использовать этот модуль?
===============================

Пример отмены существующего dm-stripe
-------------------------------------

Этот небольшой bash-скрипт настроит 4 loop-устройства и воспользуется
существующей целью striped для объединения этих 4 устройств в одно.  Затем
он применит цель unstriped поверх устройства striped, чтобы обращаться к
отдельным нижележащим loop-устройствам.  Мы записываем данные на вновь
доступные устройства unstriped и проверяем, что записанные данные совпадают
с правильным нижележащим устройством в массиве striped::

  #!/bin/bash

  MEMBER_SIZE=$((128 * 1024 * 1024))
  NUM=4
  SEQ_END=$((${NUM}-1))
  CHUNK=256
  BS=4096

  RAID_SIZE=$((${MEMBER_SIZE}*${NUM}/512))
  DM_PARMS="0 ${RAID_SIZE} striped ${NUM} ${CHUNK}"
  COUNT=$((${MEMBER_SIZE} / ${BS}))

  for i in $(seq 0 ${SEQ_END}); do
    dd if=/dev/zero of=member-${i} bs=${MEMBER_SIZE} count=1 oflag=direct
    losetup /dev/loop${i} member-${i}
    DM_PARMS+=" /dev/loop${i} 0"
  done

  echo $DM_PARMS | dmsetup create raid0
  for i in $(seq 0 ${SEQ_END}); do
    echo "0 1 unstriped ${NUM} ${CHUNK} ${i} /dev/mapper/raid0 0" | dmsetup create set-${i}
  done;

  for i in $(seq 0 ${SEQ_END}); do
    dd if=/dev/urandom of=/dev/mapper/set-${i} bs=${BS} count=${COUNT} oflag=direct
    diff /dev/mapper/set-${i} member-${i}
  done;

  for i in $(seq 0 ${SEQ_END}); do
    dmsetup remove set-${i}
  done

  dmsetup remove raid0

  for i in $(seq 0 ${SEQ_END}); do
    losetup -d /dev/loop${i}
    rm -f member-${i}
  done

Ещё один пример
---------------

Накопители Intel NVMe содержат два ядра (core) на физическом устройстве.
Каждое ядро накопителя имеет раздельный доступ к своему диапазону LBA.
Текущая модель LBA использует блок (chunk) RAID 0 размером 128 КБ на каждом
ядре, что приводит к полосе (stripe) размером 256 КБ через два ядра::

   Core 0:       Core 1:
  __________    __________
  | LBA 512|    | LBA 768|
  | LBA 0  |    | LBA 256|
  ----------    ----------

Цель этого разбора (unstriping) — обеспечить лучший QoS в условиях шумного
соседства (noisy neighbor). Когда на агрегированном накопителе создаются два
раздела без такого разбора, чтение в одном разделе может влиять на запись в
другом разделе.  Это происходит потому, что разделы чередуются (striped)
через два ядра.  Когда мы разбираем этот аппаратный RAID 0 и создаём разделы
на каждом вновь доступном устройстве, оба раздела теперь физически разделены.

С помощью цели dm-unstriped мы можем разделить fio-скрипт, у которого
задания на чтение и запись независимы друг от друга.  По сравнению с
запуском теста на объединённом накопителе с разделами, при использовании
этой цели device mapper нам удалось добиться снижения задержки чтения
(read latency) на 92%.


Пример использования dmsetup
============================

unstriped поверх устройства Intel NVMe с 2 ядрами
-------------------------------------------------

::

  dmsetup create nvmset0 --table '0 512 unstriped 2 256 0 /dev/nvme0n1 0'
  dmsetup create nvmset1 --table '0 512 unstriped 2 256 1 /dev/nvme0n1 0'

Теперь появятся два устройства, которые открывают доступ к ядрам 0 и 1
Intel NVMe соответственно::

  /dev/mapper/nvmset0
  /dev/mapper/nvmset1

unstriped поверх striped с 4 накопителями и размером блока 128 КБ
-----------------------------------------------------------------

::

  dmsetup create raid_disk0 --table '0 512 unstriped 4 256 0 /dev/mapper/striped 0'
  dmsetup create raid_disk1 --table '0 512 unstriped 4 256 1 /dev/mapper/striped 0'
  dmsetup create raid_disk2 --table '0 512 unstriped 4 256 2 /dev/mapper/striped 0'
  dmsetup create raid_disk3 --table '0 512 unstriped 4 256 3 /dev/mapper/striped 0'
