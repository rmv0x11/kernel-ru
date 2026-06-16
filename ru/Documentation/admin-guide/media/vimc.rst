.. SPDX-License-Identifier: GPL-2.0

Драйвер Virtual Media Controller (vimc)
=======================================

Драйвер vimc эмулирует сложное видеооборудование с помощью API V4L2 и Media
API. Он имеет устройство захвата (capture device) и три подустройства: sensor,
debayer и scaler.

Топология
---------

Топология жёстко задана в коде, хотя её можно изменить в vimc-core и
перекомпилировать драйвер, чтобы получить собственную топологию. Это топология
по умолчанию:

.. _vimc_topology_graph:

.. kernel-figure:: vimc.dot
    :alt:   Diagram of the default media pipeline topology
    :align: center

    Граф медиаконвейера в vimc

Настройка топологии
~~~~~~~~~~~~~~~~~~~~

Каждое подустройство поставляется со своей конфигурацией по умолчанию
(pixelformat, height, width, ...). Топологию необходимо настроить так, чтобы
конфигурация на каждом связанном подустройстве совпадала, и поток кадров мог
проходить через конвейер. Если конфигурация не совпадает, поток завершится
с ошибкой. Пакет ``v4l-utils`` представляет собой набор приложений
пространства пользователя, в который входят ``media-ctl`` и ``v4l2-ctl``,
позволяющие настраивать конфигурацию vimc. Эта последовательность команд
подходит для топологии по умолчанию:

.. code-block:: bash

        media-ctl -d platform:vimc -V '"Sensor A":0[fmt:SBGGR8_1X8/640x480]'
        media-ctl -d platform:vimc -V '"Debayer A":0[fmt:SBGGR8_1X8/640x480]'
        media-ctl -d platform:vimc -V '"Scaler":0[fmt:RGB888_1X24/640x480]'
        media-ctl -d platform:vimc -V '"Scaler":0[crop:(100,50)/400x150]'
        media-ctl -d platform:vimc -V '"Scaler":1[fmt:RGB888_1X24/300x700]'
        v4l2-ctl -z platform:vimc -d "RGB/YUV Capture" -v width=300,height=700
        v4l2-ctl -z platform:vimc -d "Raw Capture 0" -v pixelformat=BA81

Подустройства
-------------

Подустройства определяют поведение сущности (entity) в топологии. В зависимости
от подустройства сущность может иметь несколько падов (pad) типа source или sink.

vimc-sensor:
	Генерирует изображения в нескольких форматах, используя генератор
	тестовых видеотаблиц (video test pattern generator).
	Предоставляет:

	* 1 Pad source

vimc-lens:
	Вспомогательная линза (lens) для сенсора. Поддерживает управление
	автофокусом. Связано с vimc-sensor через вспомогательную связь
	(ancillary link). Линза поддерживает управление FOCUS_ABSOLUTE.

.. code-block:: bash

	media-ctl -p
	...
	- entity 28: Lens A (0 pad, 0 link)
			type V4L2 subdev subtype Lens flags 0
			device node name /dev/v4l-subdev6
	- entity 29: Lens B (0 pad, 0 link)
			type V4L2 subdev subtype Lens flags 0
			device node name /dev/v4l-subdev7
	v4l2-ctl -d /dev/v4l-subdev7 -C focus_absolute
	focus_absolute: 0


vimc-debayer:
	Преобразует изображения в формате bayer в формат, отличный от bayer.
	Предоставляет:

	* 1 Pad sink
	* 1 Pad source

vimc-scaler:
	Изменяет размер изображения, чтобы соответствовать разрешению пада
	source. Например: если пад sync настроен на 360x480, а source — на
	1280x720, изображение будет растянуто под разрешение source. Работает
	для любого разрешения в пределах ограничений vimc (включая уменьшение
	изображения при необходимости).
	Предоставляет:

	* 1 Pad sink
	* 1 Pad source

vimc-capture:
	Предоставляет узел /dev/videoX, чтобы пространство пользователя могло
	захватывать поток.
	Предоставляет:

	* 1 Pad sink
	* 1 Pad source

Параметры модуля
----------------

Vimc имеет параметр модуля для настройки драйвера.

* ``allocator=<unsigned int>``

	выбор аллокатора памяти, по умолчанию 0. Задаёт способ выделения
	буферов.

		- 0: vmalloc
		- 1: dma-contig
