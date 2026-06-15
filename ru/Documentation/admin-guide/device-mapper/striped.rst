=========
dm-stripe
=========

Цель «striped» подсистемы Device-Mapper используется для создания чередующегося
(striped, т.е. RAID-0) устройства поверх одного или нескольких базовых устройств.
Данные записываются «порциями» (chunks), при этом последовательные порции
поочерёдно распределяются между базовыми устройствами. Это потенциально может
повысить пропускную способность ввода-вывода за счёт параллельного использования
нескольких физических устройств.

Параметры: <num devs> <chunk size> [<dev path> <offset>]+
    <num devs>:
	Число базовых устройств.
    <chunk size>:
	Размер каждой порции данных. Должен быть не менее
        системного PAGE_SIZE.
    <dev path>:
	Полное путевое имя базового блочного устройства либо
	номер устройства в виде «major:minor».
    <offset>:
	Начальный сектор внутри устройства.

Может быть указано одно или несколько базовых устройств. Размер чередующегося
устройства должен быть кратен размеру порции, умноженному на число базовых устройств.


Примеры скриптов
================

::

  #!/usr/bin/perl -w
  # Create a striped device across any number of underlying devices. The device
  # will be called "stripe_dev" and have a chunk-size of 128k.

  my $chunk_size = 128 * 2;
  my $dev_name = "stripe_dev";
  my $num_devs = @ARGV;
  my @devs = @ARGV;
  my ($min_dev_size, $stripe_dev_size, $i);

  if (!$num_devs) {
          die("Specify at least one device\n");
  }

  $min_dev_size = `blockdev --getsz $devs[0]`;
  for ($i = 1; $i < $num_devs; $i++) {
          my $this_size = `blockdev --getsz $devs[$i]`;
          $min_dev_size = ($min_dev_size < $this_size) ?
                          $min_dev_size : $this_size;
  }

  $stripe_dev_size = $min_dev_size * $num_devs;
  $stripe_dev_size -= $stripe_dev_size % ($chunk_size * $num_devs);

  $table = "0 $stripe_dev_size striped $num_devs $chunk_size";
  for ($i = 0; $i < $num_devs; $i++) {
          $table .= " $devs[$i] 0";
  }

  `echo $table | dmsetup create $dev_name`;
