.. SPDX-License-Identifier: GPL-2.0

Файлы прошивки для карт lmedm04
===============================

Чтобы извлечь прошивку для DM04/QQBOX, необходимо скопировать
следующие файлы в этот каталог.

Для DM04+/QQBOX LME2510C (тюнер Sharp 7395)
-------------------------------------------

Драйвер Sharp 7395 находится в windows/system32/drivers

US2A0D.sys (датирован 17 Mar 2009)


и запустить:

.. code-block:: none

	scripts/get_dvb_firmware lme2510c_s7395

будет создан dvb-usb-lme2510c-s7395.fw

Альтернативную, но более старую прошивку можно найти на диске
драйвера DVB-S_EN_3.5A в BDADriver/driver

LMEBDA_DVBS7395C.sys (датирован 18 Jan 2008)

и запустить:

.. code-block:: none

	./get_dvb_firmware lme2510c_s7395_old

будет создан dvb-usb-lme2510c-s7395.fw

Прошивку LG можно найти на диске
драйвера DM04+_5.1A[LG] в BDADriver/driver

Для DM04 LME2510 (тюнер LG)
---------------------------

LMEBDA_DVBS.sys (датирован 13 Nov 2007)

и запустить:


.. code-block:: none

	./get_dvb_firmware lme2510_lg

будет создан dvb-usb-lme2510-lg.fw


Другую прошивку LG можно извлечь вручную из US280D.sys,
который находится только в windows/system32/drivers

dd if=US280D.sys ibs=1 skip=42360 count=3924 of=dvb-usb-lme2510-lg.fw

Для DM04 LME2510C (тюнер LG)
----------------------------

.. code-block:: none

	dd if=US280D.sys ibs=1 skip=35200 count=3850 of=dvb-usb-lme2510c-lg.fw


Драйвер тюнера Sharp 0194 находится в windows/system32/drivers

US290D.sys (датирован 09 Apr 2009)

Для LME2510
-----------

.. code-block:: none

	dd if=US290D.sys ibs=1 skip=36856 count=3976 of=dvb-usb-lme2510-s0194.fw


Для LME2510C
------------


.. code-block:: none

	dd if=US290D.sys ibs=1 skip=33152 count=3697 of=dvb-usb-lme2510c-s0194.fw


Драйвер тюнера m88rs2000 находится в windows/system32/drivers

US2B0D.sys (датирован 29 Jun 2010)


.. code-block:: none

	dd if=US2B0D.sys ibs=1 skip=34432 count=3871 of=dvb-usb-lme2510c-rs2000.fw

Необходимо изменить id прошивки rs2000, иначе она выполнит тёплую загрузку с id 3344:1120.


.. code-block:: none


	echo -ne \\xF0\\x22 | dd conv=notrunc bs=1 count=2 seek=266 of=dvb-usb-lme2510c-rs2000.fw

Скопируйте файлы прошивки в /lib/firmware
