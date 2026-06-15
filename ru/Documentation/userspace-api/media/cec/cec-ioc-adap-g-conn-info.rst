.. SPDX-License-Identifier: GPL-2.0
..
.. Copyright 2019 Google LLC
..
.. c:namespace:: CEC

.. _CEC_ADAP_G_CONNECTOR_INFO:

*******************************
ioctl CEC_ADAP_G_CONNECTOR_INFO
*******************************

Имя
===

CEC_ADAP_G_CONNECTOR_INFO - Запрос информации о разъёме HDMI

Краткое описание
================

.. c:macro:: CEC_ADAP_G_CONNECTOR_INFO

``int ioctl(int fd, CEC_ADAP_G_CONNECTOR_INFO, struct cec_connector_info *argp)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращаемый :c:func:`open()`.

``argp``

Описание
========

С помощью этого ioctl приложение может узнать, какому разъёму HDMI
соответствует данное устройство CEC. При вызове этого ioctl приложение
должно предоставить указатель на структуру cec_connector_info, которая
будет заполнена ядром информацией, предоставленной драйвером адаптера. Этот
ioctl доступен только в том случае, если установлена возможность
``CEC_CAP_CONNECTOR_INFO``.

.. tabularcolumns:: |p{1.0cm}|p{4.4cm}|p{2.5cm}|p{9.2cm}|

.. c:type:: cec_connector_info

.. flat-table:: struct cec_connector_info
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 8

    * - __u32
      - ``type``
      - Тип разъёма, с которым связан этот адаптер.
    * - union {
      - ``(anonymous)``
    * - ``struct cec_drm_connector_info``
      - drm
      - :ref:`cec-drm-connector-info`
    * - }
      -

.. tabularcolumns:: |p{4.4cm}|p{2.5cm}|p{10.4cm}|

.. _connector-type:

.. flat-table:: Типы разъёмов
    :header-rows:  0
    :stub-columns: 0
    :widths:       3 1 8

    * .. _`CEC-CONNECTOR-TYPE-NO-CONNECTOR`:

      - ``CEC_CONNECTOR_TYPE_NO_CONNECTOR``
      - 0
      - С адаптером не связан ни один разъём / информация не
        предоставляется драйвером.
    * .. _`CEC-CONNECTOR-TYPE-DRM`:

      - ``CEC_CONNECTOR_TYPE_DRM``
      - 1
      - Указывает, что с этим адаптером связан разъём DRM.
        Информацию о разъёме можно найти в
	:ref:`cec-drm-connector-info`.

.. tabularcolumns:: |p{4.4cm}|p{2.5cm}|p{10.4cm}|

.. c:type:: cec_drm_connector_info

.. _cec-drm-connector-info:

.. flat-table:: struct cec_drm_connector_info
    :header-rows:  0
    :stub-columns: 0
    :widths:       3 1 8

    * .. _`CEC-DRM-CONNECTOR-TYPE-CARD-NO`:

      - __u32
      - ``card_no``
      - Номер карты DRM: число из пути карты, например 0 в случае
        /dev/card0.
    * .. _`CEC-DRM-CONNECTOR-TYPE-CONNECTOR_ID`:

      - __u32
      - ``connector_id``
      - Идентификатор разъёма DRM.
