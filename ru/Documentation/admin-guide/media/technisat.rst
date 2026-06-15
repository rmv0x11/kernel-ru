.. SPDX-License-Identifier: GPL-2.0

Как настроить устройства Technisat/B2C2 Flexcop
===============================================

.. note::

   Эта документация устарела.

Автор: Uwe Bugla <uwe.bugla@gmx.de>, август 2009

Определите, какое у вас устройство
----------------------------------

Важное замечание: драйвер НЕ поддерживает устройства Technisat USB 2!

Сначала загрузите свою linux-машину со штатным ядром:

.. code-block:: none

	lspci -vvv for a PCI device (lsusb -vvv for an USB device) will show you for example:
	02:0b.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip /
	Technisat SkyStar2 DVB card (rev 02)

	dmesg | grep frontend may show you for example:
	DVB: registering frontend 0 (Conexant CX24123/CX24109)...

Компиляция ядра:
----------------

Если Flexcop / Technisat — единственное DVB / ТВ / радио-устройство в вашей машине,
избавьтесь от ненужных модулей и отметьте этот пункт:

``Multimedia support`` => ``Customise analog and hybrid tuner modules to build``

В этом разделе снимите отметку с каждого драйвера, который там включён
(кроме ``Simple tuner support`` — только для ATSC 3-го поколения -> см., пожалуйста, случай 9).

Затем, пожалуйста, активируйте:

- Часть основного модуля:

  ``Multimedia support`` => ``DVB/ATSC adapters`` => ``Technisat/B2C2 FlexcopII(b) and FlexCopIII adapters``

  #) => ``Technisat/B2C2 Air/Sky/Cable2PC PCI`` (PCI-карта) или
  #) => ``Technisat/B2C2 Air/Sky/Cable2PC USB`` (USB 1.1-адаптер)
     и для целей диагностики:
  #) => ``Enable debug for the B2C2 FlexCop drivers``

- Часть модуля Frontend / Tuner / Demodulator:

  ``Multimedia support`` => ``DVB/ATSC adapters``
   => ``Customise the frontend modules to build`` ``Customise DVB frontends`` =>

  - SkyStar DVB-S Revision 2.3:

    #) => ``Zarlink VP310/MT312/ZL10313 based``
    #) => ``Generic I2C PLL based tuners``

  - SkyStar DVB-S Revision 2.6:

    #) => ``ST STV0299 based``
    #) => ``Generic I2C PLL based tuners``

  - SkyStar DVB-S Revision 2.7:

    #) => ``Samsung S5H1420 based``
    #) => ``Integrant ITD1000 Zero IF tuner for DVB-S/DSS``
    #) => ``ISL6421 SEC controller``

  - SkyStar DVB-S Revision 2.8:

    #) => ``Conexant CX24123 based``
    #) => ``Conexant CX24113/CX24128 tuner for DVB-S/DSS``
    #) => ``ISL6421 SEC controller``

  - AirStar DVB-T card:

    #) => ``Zarlink MT352 based``
    #) => ``Generic I2C PLL based tuners``

  - CableStar DVB-C card:

    #) => ``ST STV0297 based``
    #) => ``Generic I2C PLL based tuners``

  - AirStar ATSC card 1st generation:

    #) => ``Broadcom BCM3510``

  - AirStar ATSC card 2nd generation:

    #) => ``NxtWave Communications NXT2002/NXT2004 based``
    #) => ``Generic I2C PLL based tuners``

  - AirStar ATSC card 3rd generation:

    #) => ``LG Electronics LGDT3302/LGDT3303 based``
    #) ``Multimedia support`` => ``Customise analog and hybrid tuner modules to build`` => ``Simple tuner support``
