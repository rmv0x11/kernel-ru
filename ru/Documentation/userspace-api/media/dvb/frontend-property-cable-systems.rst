.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later

.. _frontend-property-cable-systems:

*********************************************************
Свойства, используемые в кабельных системах доставки
*********************************************************


.. _dvbc-params:

Система доставки DVB-C
======================

DVB-C Annex-A — это широко используемый кабельный стандарт. Передача
использует QAM-модуляцию.

DVB-C Annex-C оптимизирован для 6 МГц и используется в Японии. Он
поддерживает подмножество типов модуляции из Annex A и коэффициент
скругления (roll-off) 0,13 вместо 0,15.

Для DVB-C Annex A/C допустимы следующие параметры:

-  :ref:`DTV_API_VERSION <DTV-API-VERSION>`

-  :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>`

-  :ref:`DTV_TUNE <DTV-TUNE>`

-  :ref:`DTV_CLEAR <DTV-CLEAR>`

-  :ref:`DTV_FREQUENCY <DTV-FREQUENCY>`

-  :ref:`DTV_MODULATION <DTV-MODULATION>`

-  :ref:`DTV_INVERSION <DTV-INVERSION>`

-  :ref:`DTV_SYMBOL_RATE <DTV-SYMBOL-RATE>`

-  :ref:`DTV_INNER_FEC <DTV-INNER-FEC>`

-  :ref:`DTV_LNA <DTV-LNA>`

Кроме того, также допустима :ref:`статистика QoS DTV <frontend-stat-properties>`.


.. _dvbc-annex-b-params:

Система доставки DVB-C Annex B
==============================

DVB-C Annex-B используется лишь в нескольких странах, таких как
Соединённые Штаты.

Для DVB-C Annex B допустимы следующие параметры:

-  :ref:`DTV_API_VERSION <DTV-API-VERSION>`

-  :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>`

-  :ref:`DTV_TUNE <DTV-TUNE>`

-  :ref:`DTV_CLEAR <DTV-CLEAR>`

-  :ref:`DTV_FREQUENCY <DTV-FREQUENCY>`

-  :ref:`DTV_MODULATION <DTV-MODULATION>`

-  :ref:`DTV_INVERSION <DTV-INVERSION>`

-  :ref:`DTV_LNA <DTV-LNA>`

Кроме того, также допустима :ref:`статистика QoS DTV <frontend-stat-properties>`.
