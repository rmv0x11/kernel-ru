.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later

.. _frontend-property-terrestrial-systems:

************************************************************
Свойства, используемые в наземных системах доставки
************************************************************


.. _dvbt-params:

Система доставки DVB-T
======================

Для DVB-T допустимы следующие параметры:

-  :ref:`DTV_API_VERSION <DTV-API-VERSION>`

-  :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>`

-  :ref:`DTV_TUNE <DTV-TUNE>`

-  :ref:`DTV_CLEAR <DTV-CLEAR>`

-  :ref:`DTV_FREQUENCY <DTV-FREQUENCY>`

-  :ref:`DTV_MODULATION <DTV-MODULATION>`

-  :ref:`DTV_BANDWIDTH_HZ <DTV-BANDWIDTH-HZ>`

-  :ref:`DTV_INVERSION <DTV-INVERSION>`

-  :ref:`DTV_CODE_RATE_HP <DTV-CODE-RATE-HP>`

-  :ref:`DTV_CODE_RATE_LP <DTV-CODE-RATE-LP>`

-  :ref:`DTV_GUARD_INTERVAL <DTV-GUARD-INTERVAL>`

-  :ref:`DTV_TRANSMISSION_MODE <DTV-TRANSMISSION-MODE>`

-  :ref:`DTV_HIERARCHY <DTV-HIERARCHY>`

-  :ref:`DTV_LNA <DTV-LNA>`

Кроме того, действительна также :ref:`статистика QoS DTV <frontend-stat-properties>`.


.. _dvbt2-params:

Система доставки DVB-T2
=======================

Поддержка DVB-T2 в настоящее время находится на ранних стадиях разработки,
поэтому следует ожидать, что этот раздел может разрастаться и становиться
более подробным со временем.

Для DVB-T2 допустимы следующие параметры:

-  :ref:`DTV_API_VERSION <DTV-API-VERSION>`

-  :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>`

-  :ref:`DTV_TUNE <DTV-TUNE>`

-  :ref:`DTV_CLEAR <DTV-CLEAR>`

-  :ref:`DTV_FREQUENCY <DTV-FREQUENCY>`

-  :ref:`DTV_MODULATION <DTV-MODULATION>`

-  :ref:`DTV_BANDWIDTH_HZ <DTV-BANDWIDTH-HZ>`

-  :ref:`DTV_INVERSION <DTV-INVERSION>`

-  :ref:`DTV_CODE_RATE_HP <DTV-CODE-RATE-HP>`

-  :ref:`DTV_CODE_RATE_LP <DTV-CODE-RATE-LP>`

-  :ref:`DTV_GUARD_INTERVAL <DTV-GUARD-INTERVAL>`

-  :ref:`DTV_TRANSMISSION_MODE <DTV-TRANSMISSION-MODE>`

-  :ref:`DTV_HIERARCHY <DTV-HIERARCHY>`

-  :ref:`DTV_STREAM_ID <DTV-STREAM-ID>`

-  :ref:`DTV_LNA <DTV-LNA>`

Кроме того, действительна также :ref:`статистика QoS DTV <frontend-stat-properties>`.


.. _isdbt:

Система доставки ISDB-T
=======================

Это расширение API ISDB-T/ISDB-Tsb должно отражать всю информацию, необходимую
для настройки любого оборудования ISDB-T/ISDB-Tsb. Разумеется, возможно, что
некоторым очень сложным устройствам определённые параметры для настройки не
понадобятся.

Приведённая здесь информация должна помочь авторам приложений понять, как
работать с оборудованием ISDB-T и ISDB-Tsb с использованием Linux Digital TV API.

Изложенные здесь сведения об ISDB-T и ISDB-Tsb достаточны лишь для того, чтобы
в основном показать зависимости между необходимыми значениями параметров, но,
безусловно, часть информации опущена. Более подробную информацию см. в следующих
документах:

ARIB STD-B31 - "Transmission System for Digital Terrestrial Television
Broadcasting" и

ARIB TR-B14 - "Operational Guidelines for Digital Terrestrial Television
Broadcasting".

Чтобы понять специфичные для ISDB параметры, необходимо иметь некоторое
представление о структуре канала в ISDB-T и ISDB-Tsb. То есть читателю должно
быть известно, что канал ISDB-T состоит из 13 сегментов, что он может иметь до
3 слоёв, разделяющих эти сегменты, и тому подобное.

Для ISDB-T допустимы следующие параметры:

-  :ref:`DTV_API_VERSION <DTV-API-VERSION>`

-  :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>`

-  :ref:`DTV_TUNE <DTV-TUNE>`

-  :ref:`DTV_CLEAR <DTV-CLEAR>`

-  :ref:`DTV_FREQUENCY <DTV-FREQUENCY>`

-  :ref:`DTV_BANDWIDTH_HZ <DTV-BANDWIDTH-HZ>`

-  :ref:`DTV_INVERSION <DTV-INVERSION>`

-  :ref:`DTV_GUARD_INTERVAL <DTV-GUARD-INTERVAL>`

-  :ref:`DTV_TRANSMISSION_MODE <DTV-TRANSMISSION-MODE>`

-  :ref:`DTV_ISDBT_LAYER_ENABLED <DTV-ISDBT-LAYER-ENABLED>`

-  :ref:`DTV_ISDBT_PARTIAL_RECEPTION <DTV-ISDBT-PARTIAL-RECEPTION>`

-  :ref:`DTV_ISDBT_SOUND_BROADCASTING <DTV-ISDBT-SOUND-BROADCASTING>`

-  :ref:`DTV_ISDBT_SB_SUBCHANNEL_ID <DTV-ISDBT-SB-SUBCHANNEL-ID>`

-  :ref:`DTV_ISDBT_SB_SEGMENT_IDX <DTV-ISDBT-SB-SEGMENT-IDX>`

-  :ref:`DTV_ISDBT_SB_SEGMENT_COUNT <DTV-ISDBT-SB-SEGMENT-COUNT>`

-  :ref:`DTV_ISDBT_LAYERA_FEC <DTV-ISDBT-LAYER-FEC>`

-  :ref:`DTV_ISDBT_LAYERA_MODULATION <DTV-ISDBT-LAYER-MODULATION>`

-  :ref:`DTV_ISDBT_LAYERA_SEGMENT_COUNT <DTV-ISDBT-LAYER-SEGMENT-COUNT>`

-  :ref:`DTV_ISDBT_LAYERA_TIME_INTERLEAVING <DTV-ISDBT-LAYER-TIME-INTERLEAVING>`

-  :ref:`DTV_ISDBT_LAYERB_FEC <DTV-ISDBT-LAYER-FEC>`

-  :ref:`DTV_ISDBT_LAYERB_MODULATION <DTV-ISDBT-LAYER-MODULATION>`

-  :ref:`DTV_ISDBT_LAYERB_SEGMENT_COUNT <DTV-ISDBT-LAYER-SEGMENT-COUNT>`

-  :ref:`DTV_ISDBT_LAYERB_TIME_INTERLEAVING <DTV-ISDBT-LAYER-TIME-INTERLEAVING>`

-  :ref:`DTV_ISDBT_LAYERC_FEC <DTV-ISDBT-LAYER-FEC>`

-  :ref:`DTV_ISDBT_LAYERC_MODULATION <DTV-ISDBT-LAYER-MODULATION>`

-  :ref:`DTV_ISDBT_LAYERC_SEGMENT_COUNT <DTV-ISDBT-LAYER-SEGMENT-COUNT>`

-  :ref:`DTV_ISDBT_LAYERC_TIME_INTERLEAVING <DTV-ISDBT-LAYER-TIME-INTERLEAVING>`

Кроме того, действительна также :ref:`статистика QoS DTV <frontend-stat-properties>`.


.. _atsc-params:

Система доставки ATSC
=====================

Для ATSC допустимы следующие параметры:

-  :ref:`DTV_API_VERSION <DTV-API-VERSION>`

-  :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>`

-  :ref:`DTV_TUNE <DTV-TUNE>`

-  :ref:`DTV_CLEAR <DTV-CLEAR>`

-  :ref:`DTV_FREQUENCY <DTV-FREQUENCY>`

-  :ref:`DTV_MODULATION <DTV-MODULATION>`

-  :ref:`DTV_BANDWIDTH_HZ <DTV-BANDWIDTH-HZ>`

Кроме того, действительна также :ref:`статистика QoS DTV <frontend-stat-properties>`.


.. _atscmh-params:

Система доставки ATSC-MH
========================

Для ATSC-MH допустимы следующие параметры:

-  :ref:`DTV_API_VERSION <DTV-API-VERSION>`

-  :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>`

-  :ref:`DTV_TUNE <DTV-TUNE>`

-  :ref:`DTV_CLEAR <DTV-CLEAR>`

-  :ref:`DTV_FREQUENCY <DTV-FREQUENCY>`

-  :ref:`DTV_BANDWIDTH_HZ <DTV-BANDWIDTH-HZ>`

-  :ref:`DTV_ATSCMH_FIC_VER <DTV-ATSCMH-FIC-VER>`

-  :ref:`DTV_ATSCMH_PARADE_ID <DTV-ATSCMH-PARADE-ID>`

-  :ref:`DTV_ATSCMH_NOG <DTV-ATSCMH-NOG>`

-  :ref:`DTV_ATSCMH_TNOG <DTV-ATSCMH-TNOG>`

-  :ref:`DTV_ATSCMH_SGN <DTV-ATSCMH-SGN>`

-  :ref:`DTV_ATSCMH_PRC <DTV-ATSCMH-PRC>`

-  :ref:`DTV_ATSCMH_RS_FRAME_MODE <DTV-ATSCMH-RS-FRAME-MODE>`

-  :ref:`DTV_ATSCMH_RS_FRAME_ENSEMBLE <DTV-ATSCMH-RS-FRAME-ENSEMBLE>`

-  :ref:`DTV_ATSCMH_RS_CODE_MODE_PRI <DTV-ATSCMH-RS-CODE-MODE-PRI>`

-  :ref:`DTV_ATSCMH_RS_CODE_MODE_SEC <DTV-ATSCMH-RS-CODE-MODE-SEC>`

-  :ref:`DTV_ATSCMH_SCCC_BLOCK_MODE <DTV-ATSCMH-SCCC-BLOCK-MODE>`

-  :ref:`DTV_ATSCMH_SCCC_CODE_MODE_A <DTV-ATSCMH-SCCC-CODE-MODE-A>`

-  :ref:`DTV_ATSCMH_SCCC_CODE_MODE_B <DTV-ATSCMH-SCCC-CODE-MODE-B>`

-  :ref:`DTV_ATSCMH_SCCC_CODE_MODE_C <DTV-ATSCMH-SCCC-CODE-MODE-C>`

-  :ref:`DTV_ATSCMH_SCCC_CODE_MODE_D <DTV-ATSCMH-SCCC-CODE-MODE-D>`

Кроме того, действительна также :ref:`статистика QoS DTV <frontend-stat-properties>`.


.. _dtmb-params:

Система доставки DTMB
=====================

Для DTMB допустимы следующие параметры:

-  :ref:`DTV_API_VERSION <DTV-API-VERSION>`

-  :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>`

-  :ref:`DTV_TUNE <DTV-TUNE>`

-  :ref:`DTV_CLEAR <DTV-CLEAR>`

-  :ref:`DTV_FREQUENCY <DTV-FREQUENCY>`

-  :ref:`DTV_MODULATION <DTV-MODULATION>`

-  :ref:`DTV_BANDWIDTH_HZ <DTV-BANDWIDTH-HZ>`

-  :ref:`DTV_INVERSION <DTV-INVERSION>`

-  :ref:`DTV_INNER_FEC <DTV-INNER-FEC>`

-  :ref:`DTV_GUARD_INTERVAL <DTV-GUARD-INTERVAL>`

-  :ref:`DTV_TRANSMISSION_MODE <DTV-TRANSMISSION-MODE>`

-  :ref:`DTV_INTERLEAVING <DTV-INTERLEAVING>`

-  :ref:`DTV_LNA <DTV-LNA>`

Кроме того, действительна также :ref:`статистика QoS DTV <frontend-stat-properties>`.
