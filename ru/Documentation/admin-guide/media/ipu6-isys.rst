.. SPDX-License-Identifier: GPL-2.0

.. include:: <isonum.txt>

============================================================================
Драйвер системы ввода Intel Image Processing Unit 6 (IPU6) (Input System)
============================================================================

Copyright |copy| 2023--2024 Intel Corporation

Введение
========

Этот файл документирует драйверы системы ввода (Input System, приёмник MIPI
CSI2) Intel IPU6 (Image Processing Unit 6-го поколения), расположенные в
drivers/media/pci/intel/ipu6.

Intel IPU6 присутствует в некоторых Intel SoC, но не во всех SKU:

* Tiger Lake
* Jasper Lake
* Alder Lake
* Raptor Lake
* Meteor Lake

Intel IPU6 состоит из двух компонентов — системы ввода (Input System, ISYS) и
системы обработки (Processing System, PSYS).

Система ввода работает в основном как приёмник MIPI CSI-2, который принимает и
обрабатывает данные изображения от сенсоров и выводит кадры в память.

Существует 2 модуля драйвера — intel-ipu6 и intel-ipu6-isys. intel-ipu6 — это
общий драйвер IPU6, который выполняет конфигурацию PCI, загрузку и разбор
прошивки (firmware), аутентификацию прошивки, отображение DMA и конфигурацию
IPU-MMU (внутреннего блока отображения памяти, Memory mapping Unit).
intel_ipu6_isys реализует интерфейсы V4L2, Media Controller и V4L2 sub-device.
Драйвер IPU6 ISYS поддерживает сенсоры камер, подключённые к IPU6 ISYS через
драйверы сенсоров V4L2 sub-device.

.. Note:: Дополнительную информацию об аппаратной части IPU6 см. в
	  Documentation/driver-api/media/drivers/ipu6.rst.

Драйвер системы ввода
=====================

Драйвер системы ввода в основном конфигурирует CSI-2 D-PHY, формирует
конфигурацию потоков прошивки, отправляет команды прошивке, получает ответ от
аппаратуры и прошивки и затем возвращает буферы пользователю.  ISYS представлена
как несколько V4L2 sub-device, а также видеоузлов.

.. kernel-figure::  ipu6_isys_graph.svg
   :alt: ipu6 isys media graph with multiple streams support

   Медиа-граф IPU6 ISYS с поддержкой нескольких потоков

Граф был получен с помощью следующей команды:

.. code-block:: none

   fdp -Gsplines=true -Tsvg < dot > dot.svg

Захват кадров с помощью IPU6 ISYS
---------------------------------

IPU6 ISYS используется для захвата кадров от сенсоров камер, подключённых к
портам CSI2. Поддерживаемые входные форматы ISYS перечислены в таблице ниже:

.. tabularcolumns:: |p{0.8cm}|p{4.0cm}|p{4.0cm}|

.. flat-table::
    :header-rows: 1

    * - Поддерживаемые входные форматы IPU6 ISYS

    * - RGB565, RGB888

    * - UYVY8, YUYV8

    * - RAW8, RAW10, RAW12

.. _ipu6_isys_capture_examples:

Примеры
~~~~~~~

Ниже приведён пример сырого (raw) захвата IPU6 ISYS на ноутбуке Dell XPS 9315.
На этой машине сенсор ov01a10 подключён к порту CSI-2 2 IPU ISYS, который может
генерировать изображения в формате sBGGR10 с разрешением 1280x800.

С помощью API media controller мы можем сконфигурировать сенсор ov01a10
посредством media-ctl [#f1]_ и yavta [#f2]_ для передачи кадров в IPU6 ISYS.

.. code-block:: none

    # Example 1 capture frame from ov01a10 camera sensor
    # This example assumes /dev/media0 as the IPU ISYS media device
    export MDEV=/dev/media0

    # Establish the link for the media devices using media-ctl
    media-ctl -d $MDEV -l "\"ov01a10 3-0036\":0 -> \"Intel IPU6 CSI2 2\":0[1]"

    # Set the format for the media devices
    media-ctl -d $MDEV -V "ov01a10:0 [fmt:SBGGR10/1280x800]"
    media-ctl -d $MDEV -V "Intel IPU6 CSI2 2:0 [fmt:SBGGR10/1280x800]"
    media-ctl -d $MDEV -V "Intel IPU6 CSI2 2:1 [fmt:SBGGR10/1280x800]"

После того как медиа-конвейер сконфигурирован, можно задать желаемые
специфичные для сенсора настройки (такие как настройки экспозиции и усиления) с
помощью утилиты yavta.

например

.. code-block:: none

    # and that ov01a10 sensor is connected to i2c bus 3 with address 0x36
    export SDEV=$(media-ctl -d $MDEV -e "ov01a10 3-0036")

    yavta -w 0x009e0903 400 $SDEV
    yavta -w 0x009e0913 1000 $SDEV
    yavta -w 0x009e0911 2000 $SDEV

После того как желаемые настройки сенсора заданы, захват кадров можно выполнить,
как показано ниже.

например

.. code-block:: none

    yavta --data-prefix -u -c10 -n5 -I -s 1280x800 --file=/tmp/frame-#.bin \
            -f SBGGR10 $(media-ctl -d $MDEV -e "Intel IPU6 ISYS Capture 0")

С помощью приведённой выше команды захватываются 10 кадров с разрешением
1280x800 в формате sBGGR10. Захваченные кадры доступны в виде файлов
/tmp/frame-#.bin.

Ниже приведён ещё один пример захвата RAW и метаданных IPU6 ISYS с сенсора камеры
ov2740 на ноутбуке Lenovo X1 Yoga.

.. code-block:: none

    media-ctl -l "\"ov2740 14-0036\":0 -> \"Intel IPU6 CSI2 1\":0[1]"
    media-ctl -l "\"Intel IPU6 CSI2 1\":1 -> \"Intel IPU6 ISYS Capture 0\":0[1]"
    media-ctl -l "\"Intel IPU6 CSI2 1\":2 -> \"Intel IPU6 ISYS Capture 1\":0[1]"

    # set routing
    media-ctl -R "\"Intel IPU6 CSI2 1\" [0/0->1/0[1],0/1->2/1[1]]"

    media-ctl -V "\"Intel IPU6 CSI2 1\":0/0 [fmt:SGRBG10/1932x1092]"
    media-ctl -V "\"Intel IPU6 CSI2 1\":0/1 [fmt:GENERIC_8/97x1]"
    media-ctl -V "\"Intel IPU6 CSI2 1\":1/0 [fmt:SGRBG10/1932x1092]"
    media-ctl -V "\"Intel IPU6 CSI2 1\":2/1 [fmt:GENERIC_8/97x1]"

    CAPTURE_DEV=$(media-ctl -e "Intel IPU6 ISYS Capture 0")
    ./yavta --data-prefix -c100 -n5 -I -s1932x1092 --file=/tmp/frame-#.bin \
        -f SGRBG10 ${CAPTURE_DEV}

    CAPTURE_META=$(media-ctl -e "Intel IPU6 ISYS Capture 1")
    ./yavta --data-prefix -c100 -n5 -I -s97x1 -B meta-capture \
        --file=/tmp/meta-#.bin -f GENERIC_8 ${CAPTURE_META}

Ссылки
======

.. [#f1] https://git.ideasonboard.org/media-ctl.git
.. [#f2] https://git.ideasonboard.org/yavta.git
