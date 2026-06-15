.. SPDX-License-Identifier: GPL-2.0

Прошивка Opera
==============

Автор: Marco Gittler <g.marco@freenet.de>

Чтобы извлечь прошивку для Opera DVB-S1 USB-Box,
вам нужно скопировать файлы:

2830SCap2.sys
2830SLoad2.sys

с диска windriver в этот каталог.

Затем выполните:

.. code-block:: none

	scripts/get_dvb_firmware opera1

после чего у вас появятся 2 файла:

dvb-usb-opera-01.fw
dvb-usb-opera1-fpga-01.fw

здесь.

Скопируйте их в /lib/firmware/ .

После этого драйвер сможет загрузить прошивку
(если вы включили загрузку прошивки
в конфигурации ядра и у вас запущен hotplug).
