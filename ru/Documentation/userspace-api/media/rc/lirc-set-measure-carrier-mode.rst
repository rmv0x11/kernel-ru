.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-no-invariants-or-later
.. c:namespace:: RC

.. _lirc_set_measure_carrier_mode:

***********************************
ioctl LIRC_SET_MEASURE_CARRIER_MODE
***********************************

Имя
===

LIRC_SET_MEASURE_CARRIER_MODE - включение или отключение режима измерения

Синопсис
========

.. c:macro:: LIRC_SET_MEASURE_CARRIER_MODE

``int ioctl(int fd, LIRC_SET_MEASURE_CARRIER_MODE, __u32 *enable)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращённый функцией open().

``enable``
    enable = 1 означает включение режима измерения, enable = 0 означает отключение
    режима измерения.

Описание
========

.. _lirc-mode2-frequency:

Включает или отключает режим измерения. Если режим включён, то начиная со
следующего нажатия клавиши драйвер будет отправлять пакеты ``LIRC_MODE2_FREQUENCY``.
По умолчанию этот режим должен быть отключён.

Возвращаемое значение
=====================

В случае успеха возвращается 0, в случае ошибки — -1, при этом соответствующим
образом устанавливается переменная ``errno``. Общие коды ошибок описаны в главе
:ref:`Generic Error Codes <gen-errors>`.
