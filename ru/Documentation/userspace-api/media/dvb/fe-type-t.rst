.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later

*****************
Тип фронтенда
*****************

По историческим причинам типы фронтендов именуются по типу модуляции,
используемой при передаче. Типы фронтендов задаются типом fe_type_t,
определённым следующим образом:


.. c:type:: fe_type

.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.5cm}|

.. flat-table:: Типы фронтендов
    :header-rows:  1
    :stub-columns: 0
    :widths:       3 1 4


    -  .. row 1

       -  fe_type

       -  Описание

       -  Эквивалентный тип :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>`

    -  .. row 2

       -  .. _FE-QPSK:

	  ``FE_QPSK``

       -  Для стандарта DVB-S

       -  ``SYS_DVBS``

    -  .. row 3

       -  .. _FE-QAM:

	  ``FE_QAM``

       -  Для стандарта DVB-C annex A

       -  ``SYS_DVBC_ANNEX_A``

    -  .. row 4

       -  .. _FE-OFDM:

	  ``FE_OFDM``

       -  Для стандарта DVB-T

       -  ``SYS_DVBT``

    -  .. row 5

       -  .. _FE-ATSC:

	  ``FE_ATSC``

       -  Для стандарта ATSC (наземное вещание) или для DVB-C Annex B (кабельное),
	  используемого в США.

       -  ``SYS_ATSC`` (наземное вещание) или ``SYS_DVBC_ANNEX_B`` (кабельное)


Более новые форматы, такие как DVB-S2, ISDB-T, ISDB-S и DVB-T2, не описаны
выше, поскольку они поддерживаются через новые ioctl
:ref:`FE_GET_PROPERTY/FE_GET_SET_PROPERTY <FE_GET_PROPERTY>`
с использованием параметра :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>`.

В старые времена структура :c:type:`dvb_frontend_info`
содержала поле ``fe_type_t`` для указания систем доставки,
заполняемое одним из значений ``FE_QPSK, FE_QAM, FE_OFDM`` или ``FE_ATSC``. Хотя
это поле по-прежнему заполняется для сохранения обратной совместимости, его
использование считается устаревшим, так как оно может сообщить лишь об одной
системе доставки, тогда как некоторые устройства поддерживают несколько систем
доставки. Вместо этого используйте
:ref:`DTV_ENUM_DELSYS <DTV-ENUM-DELSYS>`.

На устройствах, поддерживающих несколько систем доставки, поле структуры
:c:type:`dvb_frontend_info`::``fe_type_t`` заполняется
текущим стандартом, выбранным последним вызовом
:ref:`FE_SET_PROPERTY <FE_GET_PROPERTY>` с использованием свойства
:ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>`.
