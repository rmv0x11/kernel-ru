=========
dm-linear
=========

Target «linear» подсистемы Device-Mapper отображает линейный диапазон
устройства Device-Mapper на линейный диапазон другого устройства.  Это
базовый строительный блок менеджеров логических томов.

Параметры: <dev path> <offset>
    <dev path>:
	Полный путь к нижележащему блочному устройству или номер
        устройства в формате «major:minor».
    <offset>:
	Начальный сектор внутри устройства.


Примеры скриптов
================

::

  #!/bin/sh
  # Create an identity mapping for a device
  echo "0 `blockdev --getsz $1` linear $1 0" | dmsetup create identity

::

  #!/bin/sh
  # Join 2 devices together
  size1=`blockdev --getsz $1`
  size2=`blockdev --getsz $2`
  echo "0 $size1 linear $1 0
  $size1 $size2 linear $2 0" | dmsetup create joined

::

  #!/usr/bin/perl -w
  # Split a device into 4M chunks and then join them together in reverse order.

  my $name = "reverse";
  my $extent_size = 4 * 1024 * 2;
  my $dev = $ARGV[0];
  my $table = "";
  my $count = 0;

  if (!defined($dev)) {
          die("Please specify a device.\n");
  }

  my $dev_size = `blockdev --getsz $dev`;
  my $extents = int($dev_size / $extent_size) -
                (($dev_size % $extent_size) ? 1 : 0);

  while ($extents > 0) {
          my $this_start = $count * $extent_size;
          $extents--;
          $count++;
          my $this_offset = $extents * $extent_size;

          $table .= "$this_start $extent_size linear $dev $this_offset\n";
  }

  `echo \"$table\" | dmsetup create $name`;
