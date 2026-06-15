===============
dm-queue-length
===============

dm-queue-length — это модуль селектора путей для целей device-mapper,
который выбирает путь с наименьшим числом незавершённых операций ввода-вывода.
Имя селектора путей — 'queue-length'.

Параметры таблицы для каждого пути: [<repeat_count>]

::

	<repeat_count>: The number of I/Os to dispatch using the selected
			path before switching to the next path.
			If not given, internal default is used. To check
			the default value, see the activated table.

Статус для каждого пути: <status> <fail-count> <in-flight>

::

	<status>: 'A' if the path is active, 'F' if the path is failed.
	<fail-count>: The number of path failures.
	<in-flight>: The number of in-flight I/Os on the path.


Алгоритм
========

dm-queue-length увеличивает/уменьшает 'in-flight' при отправке/завершении
операции ввода-вывода соответственно.
dm-queue-length выбирает путь с минимальным значением 'in-flight'.


Примеры
=======
В случае, когда используются 2 пути (sda и sdb) с repeat_count == 128.

::

  # echo "0 10 multipath 0 0 1 1 queue-length 0 2 1 8:0 128 8:16 128" \
    dmsetup create test
  #
  # dmsetup table
  test: 0 10 multipath 0 0 1 1 queue-length 0 2 1 8:0 128 8:16 128
  #
  # dmsetup status
  test: 0 10 multipath 2 0 0 0 1 1 E 0 2 1 8:0 A 0 0 8:16 A 0 0
