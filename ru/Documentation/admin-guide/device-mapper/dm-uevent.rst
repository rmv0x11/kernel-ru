====================
device-mapper uevent
====================

Код uevent в device-mapper добавляет в device-mapper возможность создавать
и отправлять uevent'ы kobject (uevents).  Ранее события device-mapper были
доступны только через интерфейс ioctl.  Преимущество интерфейса uevents в том,
что событие содержит атрибуты окружения, обеспечивающие больше контекста для
события и избавляющие от необходимости запрашивать состояние устройства
device-mapper после получения события.

В настоящее время для событий device-mapper существуют две функции.  Первая
перечисленная функция создаёт событие, а вторая отправляет событие (события)::

  void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
                      const char *path, unsigned nr_valid_paths)

  void dm_send_uevents(struct list_head *events, struct kobject *kobj)


В окружение uevent добавляются следующие переменные:

Имя переменной: DM_TARGET
-------------------------
:Действие(я) uevent: KOBJ_CHANGE
:Тип: string
:Описание:
:Значение: Имя цели device-mapper, сгенерировавшей событие.

Имя переменной: DM_ACTION
-------------------------
:Действие(я) uevent: KOBJ_CHANGE
:Тип: string
:Описание:
:Значение: Специфичное для device-mapper действие, вызвавшее действие uevent.
	PATH_FAILED - Путь вышел из строя;
	PATH_REINSTATED - Путь восстановлен.

Имя переменной: DM_SEQNUM
-------------------------
:Действие(я) uevent: KOBJ_CHANGE
:Тип: unsigned integer
:Описание: Порядковый номер для данного конкретного устройства device-mapper.
:Значение: Допустимый диапазон беззнаковых целых чисел.

Имя переменной: DM_PATH
-----------------------
:Действие(я) uevent: KOBJ_CHANGE
:Тип: string
:Описание: Старший и младший номера устройства пути, относящегося к данному
	      событию.
:Значение: Имя пути в форме "Major:Minor"

Имя переменной: DM_NR_VALID_PATHS
---------------------------------
:Действие(я) uevent: KOBJ_CHANGE
:Тип: unsigned integer
:Описание:
:Значение: Допустимый диапазон беззнаковых целых чисел.

Имя переменной: DM_NAME
-----------------------
:Действие(я) uevent: KOBJ_CHANGE
:Тип: string
:Описание: Имя устройства device-mapper.
:Значение: Имя

Имя переменной: DM_UUID
-----------------------
:Действие(я) uevent: KOBJ_CHANGE
:Тип: string
:Описание: UUID устройства device-mapper.
:Значение: UUID. (Пустая строка, если его нет.)

Пример uevent'ов, сгенерированных и захваченных с помощью udevmonitor, показан
ниже

1.) Отказ пути::

	UEVENT[1192521009.711215] change@/block/dm-3
	ACTION=change
	DEVPATH=/block/dm-3
	SUBSYSTEM=block
	DM_TARGET=multipath
	DM_ACTION=PATH_FAILED
	DM_SEQNUM=1
	DM_PATH=8:32
	DM_NR_VALID_PATHS=0
	DM_NAME=mpath2
	DM_UUID=mpath-35333333000002328
	MINOR=3
	MAJOR=253
	SEQNUM=1130

2.) Восстановление пути::

	UEVENT[1192521132.989927] change@/block/dm-3
	ACTION=change
	DEVPATH=/block/dm-3
	SUBSYSTEM=block
	DM_TARGET=multipath
	DM_ACTION=PATH_REINSTATED
	DM_SEQNUM=2
	DM_PATH=8:32
	DM_NR_VALID_PATHS=1
	DM_NAME=mpath2
	DM_UUID=mpath-35333333000002328
	MINOR=3
	MAJOR=253
	SEQNUM=1131
