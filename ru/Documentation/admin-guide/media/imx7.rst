.. SPDX-License-Identifier: GPL-2.0

Драйвер видеозахвата i.MX7
==========================

Введение
--------

i.MX7, в отличие от семейства i.MX5/6, не содержит блока обработки изображений
(Image Processing Unit, IPU); из-за этого его возможности по выполнению операций
или манипуляций над захваченными кадрами менее богаты функциями.

Для захвата изображения в i.MX7 есть три блока:
- интерфейс CMOS-сенсора (CMOS Sensor Interface, CSI)
- видеомультиплексор (Video Multiplexer)
- приёмник MIPI CSI-2 (MIPI CSI-2 Receiver)

.. code-block:: none

   MIPI Camera Input ---> MIPI CSI-2 --- > |\
                                           | \
                                           |  \
                                           | M |
                                           | U | ------>  CSI ---> Capture
                                           | X |
                                           |  /
   Parallel Camera Input ----------------> | /
                                           |/

За дополнительной информацией обращайтесь к последним версиям справочного
руководства i.MX7 [#f1]_.

Сущности
--------

imx-mipi-csi2
--------------

Это сущность приёмника MIPI CSI-2. У неё есть один входной pad для приёма данных
пикселей от сенсора камеры MIPI CSI-2. У неё есть один источниковый pad,
соответствующий виртуальному каналу 0. Этот модуль совместим с предыдущей версией
Samsung D-phy и поддерживает две приёмные линии данных D-PHY.

csi-mux
-------

Это видеомультиплексор. У него есть два входных pad'а для выбора либо сенсора
камеры с параллельным интерфейсом, либо виртуального канала 0 MIPI CSI-2. У него
есть один источниковый pad, который направляется в CSI.

csi
---

CSI позволяет чипу подключаться напрямую к внешнему CMOS-сенсору изображения. CSI
может напрямую взаимодействовать с параллельной шиной и шиной MIPI CSI-2. У него
есть FIFO размером 256 x 64 для хранения принятых данных пикселей изображения и
встроенные DMA-контроллеры для передачи данных из FIFO через шину AHB.

У этой сущности есть один входной pad, который принимает данные от сущности
csi-mux, и один источниковый pad, который направляет видеокадры напрямую в буферы
памяти. Этот pad направляется на узел устройства захвата.

Замечания по использованию
--------------------------

Для облегчения настройки и для обратной совместимости с приложениями V4L2,
которые обращаются к элементам управления только через узлы видеоустройств,
интерфейсы устройства захвата наследуют элементы управления от активных сущностей
в текущем конвейере, поэтому к элементам управления можно обращаться либо напрямую
через subdev, либо через интерфейс активного устройства захвата. Например, элементы
управления сенсором доступны либо через subdev'ы сенсора, либо через активное
устройство захвата.

Warp7 с OV2680
--------------

На этой платформе модуль OV2680 MIPI CSI-2 подключён к внутреннему приёмнику
MIPI CSI-2. В следующем примере настраивается конвейер видеозахвата с выходом
800x600 и 10-битным форматом Байера BGGR:

.. code-block:: none

   # Setup links
   media-ctl -l "'ov2680 1-0036':0 -> 'imx7-mipi-csis.0':0[1]"
   media-ctl -l "'imx7-mipi-csis.0':1 -> 'csi-mux':1[1]"
   media-ctl -l "'csi-mux':2 -> 'csi':0[1]"
   media-ctl -l "'csi':1 -> 'csi capture':0[1]"

   # Configure pads for pipeline
   media-ctl -V "'ov2680 1-0036':0 [fmt:SBGGR10_1X10/800x600 field:none]"
   media-ctl -V "'csi-mux':1 [fmt:SBGGR10_1X10/800x600 field:none]"
   media-ctl -V "'csi-mux':2 [fmt:SBGGR10_1X10/800x600 field:none]"
   media-ctl -V "'imx7-mipi-csis.0':0 [fmt:SBGGR10_1X10/800x600 field:none]"
   media-ctl -V "'csi':0 [fmt:SBGGR10_1X10/800x600 field:none]"

После этого можно запускать потоковую передачу. Утилиту v4l2-ctl можно
использовать для выбора любого из разрешений, поддерживаемых сенсором.

.. code-block:: none

	# media-ctl -p
	Media controller API version 5.2.0

	Media device information
	------------------------
	driver          imx7-csi
	model           imx-media
	serial
	bus info
	hw revision     0x0
	driver version  5.2.0

	Device topology
	- entity 1: csi (2 pads, 2 links)
	            type V4L2 subdev subtype Unknown flags 0
	            device node name /dev/v4l-subdev0
	        pad0: Sink
	                [fmt:SBGGR10_1X10/800x600 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:full-range]
	                <- "csi-mux":2 [ENABLED]
	        pad1: Source
	                [fmt:SBGGR10_1X10/800x600 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:full-range]
	                -> "csi capture":0 [ENABLED]

	- entity 4: csi capture (1 pad, 1 link)
	            type Node subtype V4L flags 0
	            device node name /dev/video0
	        pad0: Sink
	                <- "csi":1 [ENABLED]

	- entity 10: csi-mux (3 pads, 2 links)
	             type V4L2 subdev subtype Unknown flags 0
	             device node name /dev/v4l-subdev1
	        pad0: Sink
	                [fmt:Y8_1X8/1x1 field:none]
	        pad1: Sink
	               [fmt:SBGGR10_1X10/800x600 field:none]
	                <- "imx7-mipi-csis.0":1 [ENABLED]
	        pad2: Source
	                [fmt:SBGGR10_1X10/800x600 field:none]
	                -> "csi":0 [ENABLED]

	- entity 14: imx7-mipi-csis.0 (2 pads, 2 links)
	             type V4L2 subdev subtype Unknown flags 0
	             device node name /dev/v4l-subdev2
	        pad0: Sink
	                [fmt:SBGGR10_1X10/800x600 field:none]
	                <- "ov2680 1-0036":0 [ENABLED]
	        pad1: Source
	                [fmt:SBGGR10_1X10/800x600 field:none]
	                -> "csi-mux":1 [ENABLED]

	- entity 17: ov2680 1-0036 (1 pad, 1 link)
	             type V4L2 subdev subtype Sensor flags 0
	             device node name /dev/v4l-subdev3
	        pad0: Source
	                [fmt:SBGGR10_1X10/800x600@1/30 field:none colorspace:srgb]
	                -> "imx7-mipi-csis.0":0 [ENABLED]

i.MX6ULL-EVK с OV5640
---------------------

На этой платформе параллельный сенсор OV5640 подключён к порту CSI. В следующем
примере настраивается конвейер видеозахвата с выходом 640x480 и форматом
UYVY8_2X8:

.. code-block:: none

   # Setup links
   media-ctl -l "'ov5640 1-003c':0 -> 'csi':0[1]"
   media-ctl -l "'csi':1 -> 'csi capture':0[1]"

   # Configure pads for pipeline
   media-ctl -v -V "'ov5640 1-003c':0 [fmt:UYVY8_2X8/640x480 field:none]"

После этого можно запускать потоковую передачу:

.. code-block:: none

   gst-launch-1.0 -v v4l2src device=/dev/video1 ! video/x-raw,format=UYVY,width=640,height=480 ! v4l2convert ! fbdevsink

.. code-block:: none

	# media-ctl -p
	Media controller API version 5.14.0

	Media device information
	------------------------
	driver          imx7-csi
	model           imx-media
	serial
	bus info
	hw revision     0x0
	driver version  5.14.0

	Device topology
	- entity 1: csi (2 pads, 2 links)
	            type V4L2 subdev subtype Unknown flags 0
	            device node name /dev/v4l-subdev0
	        pad0: Sink
	                [fmt:UYVY8_2X8/640x480 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:full-range]
	                <- "ov5640 1-003c":0 [ENABLED,IMMUTABLE]
	        pad1: Source
	                [fmt:UYVY8_2X8/640x480 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:full-range]
	                -> "csi capture":0 [ENABLED,IMMUTABLE]

	- entity 4: csi capture (1 pad, 1 link)
	            type Node subtype V4L flags 0
	            device node name /dev/video1
	        pad0: Sink
	                <- "csi":1 [ENABLED,IMMUTABLE]

	- entity 10: ov5640 1-003c (1 pad, 1 link)
	             type V4L2 subdev subtype Sensor flags 0
	             device node name /dev/v4l-subdev1
	        pad0: Source
	                [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb xfer:srgb ycbcr:601 quantization:full-range]
	                -> "csi":0 [ENABLED,IMMUTABLE]

Ссылки
------

.. [#f1] https://www.nxp.com/docs/en/reference-manual/IMX7SRM.pdf
