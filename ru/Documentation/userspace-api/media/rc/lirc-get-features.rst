.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-no-invariants-or-later
.. c:namespace:: RC

.. _lirc_get_features:

***********************
ioctl LIRC_GET_FEATURES
***********************

Имя
===

LIRC_GET_FEATURES - Получить возможности нижележащего аппаратного устройства

Синопсис
========

.. c:macro:: LIRC_GET_FEATURES

``int ioctl(int fd, LIRC_GET_FEATURES, __u32 *features)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращённый open().

``features``
    Битовая маска с возможностями LIRC.

Описание
========

Получить возможности нижележащего аппаратного устройства. Если драйвер не
объявляет поддержку определённых возможностей, вызов соответствующих ioctl
не определён.

Возможности LIRC
================

.. _LIRC-CAN-REC-RAW:

``LIRC_CAN_REC_RAW``

    Не используется. Сохранён только во избежание поломки uAPI.

.. _LIRC-CAN-REC-PULSE:

``LIRC_CAN_REC_PULSE``

    Не используется. Сохранён только во избежание поломки uAPI.
    :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>` может использоваться только для передачи.

.. _LIRC-CAN-REC-MODE2:

``LIRC_CAN_REC_MODE2``

    Это сырой ИК-драйвер для приёма. Это означает, что
    используется :ref:`LIRC_MODE_MODE2 <lirc-mode-MODE2>`. Это также подразумевает,
    что :ref:`LIRC_MODE_SCANCODE <lirc-mode-SCANCODE>` тоже поддерживается,
    при условии достаточно нового ядра. Для переключения режимов используйте
    :ref:`lirc_set_rec_mode`.

.. _LIRC-CAN-REC-LIRCCODE:

``LIRC_CAN_REC_LIRCCODE``

    Не используется. Сохранён только во избежание поломки uAPI.

.. _LIRC-CAN-REC-SCANCODE:

``LIRC_CAN_REC_SCANCODE``

    Это драйвер сканкодов для приёма. Это означает, что
    используется :ref:`LIRC_MODE_SCANCODE <lirc-mode-SCANCODE>`.

.. _LIRC-CAN-SET-SEND-CARRIER:

``LIRC_CAN_SET_SEND_CARRIER``

    Драйвер поддерживает изменение частоты модуляции через
    :ref:`ioctl LIRC_SET_SEND_CARRIER <LIRC_SET_SEND_CARRIER>`.

.. _LIRC-CAN-SET-SEND-DUTY-CYCLE:

``LIRC_CAN_SET_SEND_DUTY_CYCLE``

    Драйвер поддерживает изменение коэффициента заполнения с помощью
    :ref:`ioctl LIRC_SET_SEND_DUTY_CYCLE <LIRC_SET_SEND_DUTY_CYCLE>`.

.. _LIRC-CAN-SET-TRANSMITTER-MASK:

``LIRC_CAN_SET_TRANSMITTER_MASK``

    Драйвер поддерживает изменение активного(ых) передатчика(ов) с помощью
    :ref:`ioctl LIRC_SET_TRANSMITTER_MASK <LIRC_SET_TRANSMITTER_MASK>`.

.. _LIRC-CAN-SET-REC-CARRIER:

``LIRC_CAN_SET_REC_CARRIER``

    Драйвер поддерживает установку частоты несущей приёма с помощью
    :ref:`ioctl LIRC_SET_REC_CARRIER <LIRC_SET_REC_CARRIER>`.

.. _LIRC-CAN-SET-REC-CARRIER-RANGE:

``LIRC_CAN_SET_REC_CARRIER_RANGE``

    Драйвер поддерживает
    :ref:`ioctl LIRC_SET_REC_CARRIER_RANGE <LIRC_SET_REC_CARRIER_RANGE>`.

.. _LIRC-CAN-GET-REC-RESOLUTION:

``LIRC_CAN_GET_REC_RESOLUTION``

    Драйвер поддерживает
    :ref:`ioctl LIRC_GET_REC_RESOLUTION <LIRC_GET_REC_RESOLUTION>`.

.. _LIRC-CAN-SET-REC-TIMEOUT:

``LIRC_CAN_SET_REC_TIMEOUT``

    Драйвер поддерживает
    :ref:`ioctl LIRC_SET_REC_TIMEOUT <LIRC_SET_REC_TIMEOUT>`.

.. _LIRC-CAN-MEASURE-CARRIER:

``LIRC_CAN_MEASURE_CARRIER``

    Драйвер поддерживает измерение частоты модуляции с помощью
    :ref:`ioctl LIRC_SET_MEASURE_CARRIER_MODE <LIRC_SET_MEASURE_CARRIER_MODE>`.

.. _LIRC-CAN-USE-WIDEBAND-RECEIVER:

``LIRC_CAN_USE_WIDEBAND_RECEIVER``

    Драйвер поддерживает режим обучения с помощью
    :ref:`ioctl LIRC_SET_WIDEBAND_RECEIVER <LIRC_SET_WIDEBAND_RECEIVER>`.

.. _LIRC-CAN-SEND-RAW:

``LIRC_CAN_SEND_RAW``

    Не используется. Сохранён только во избежание поломки uAPI.

.. _LIRC-CAN-SEND-PULSE:

``LIRC_CAN_SEND_PULSE``

    Драйвер поддерживает отправку (также называемую IR blasting или IR TX) с помощью
    :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>`. Это подразумевает, что
    :ref:`LIRC_MODE_SCANCODE <lirc-mode-SCANCODE>` тоже поддерживается для
    передачи, при условии достаточно нового ядра. Для переключения режимов используйте
    :ref:`lirc_set_send_mode`.

.. _LIRC-CAN-SEND-MODE2:

``LIRC_CAN_SEND_MODE2``

    Не используется. Сохранён только во избежание поломки uAPI.
    :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>` может использоваться только для приёма.

.. _LIRC-CAN-SEND-LIRCCODE:

``LIRC_CAN_SEND_LIRCCODE``

    Не используется. Сохранён только во избежание поломки uAPI.

Возвращаемое значение
=====================

В случае успеха возвращается 0, в случае ошибки -1, а переменная ``errno``
устанавливается соответствующим образом. Общие коды ошибок описаны в главе
:ref:`Generic Error Codes <gen-errors>`.
