========
dm-delay
========

Цель "delay" подсистемы Device-Mapper задерживает операции чтения и/или записи
и/или сброса (flush) и при необходимости отображает их на другие устройства.

Аргументы::

    <device> <offset> <delay> [<write_device> <write_offset> <write_delay>
			       [<flush_device> <flush_offset> <flush_delay>]]

Строка таблицы должна содержать либо 3, либо 6, либо 9 аргументов:

3: применить offset и delay к операциям чтения, записи и сброса на устройстве

6: применить offset и delay к устройству, а также применить write_offset и write_delay
   к операциям записи и сброса на необязательно отличающемся устройстве write_device с
   необязательно отличающимся смещением сектора

9: то же, что и при 6 аргументах, плюс явное определение flush_offset и flush_delay
   на/с необязательно отличающимися flush_device/flush_offset.

Смещения задаются в секторах.

Задержки задаются в миллисекундах.


Примеры сценариев
=================

::
	#!/bin/sh
	#
	# Create mapped device named "delayed" delaying read, write and flush operations for 500ms.
	#
	dmsetup create delayed --table  "0 `blockdev --getsz $1` delay $1 0 500"

::
	#!/bin/sh
	#
	# Create mapped device delaying write and flush operations for 400ms and
	# splitting reads to device $1 but writes and flushes to different device $2
	# to different offsets of 2048 and 4096 sectors respectively.
	#
	dmsetup create delayed --table "0 `blockdev --getsz $1` delay $1 2048 0 $2 4096 400"

::
	#!/bin/sh
	#
	# Create mapped device delaying reads for 50ms, writes for 100ms and flushes for 333ms
	# onto the same backing device at offset 0 sectors.
	#
	dmsetup create delayed --table "0 `blockdev --getsz $1` delay $1 0 50 $2 0 100 $1 0 333"
