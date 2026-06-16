.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-no-invariants-or-later
.. c:namespace:: RC

.. _lirc_set_send_carrier:

***************************
ioctl LIRC_SET_SEND_CARRIER
***************************

Имя
===

LIRC_SET_SEND_CARRIER - Задать несущую частоту передачи, используемую для модуляции ИК-передачи (IR TX).

Синопсис
========

.. c:macro:: LIRC_SET_SEND_CARRIER

``int ioctl(int fd, LIRC_SET_SEND_CARRIER, __u32 *frequency)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращённый функцией open().

``frequency``
    Частота модулируемой несущей, в Гц.

Описание
========

Задаёт несущую частоту передачи, используемую для модуляции ИК-импульсов (IR PWM) и пауз.

Возвращаемое значение
=====================

В случае успеха возвращается 0, в случае ошибки -1, и переменная ``errno``
устанавливается соответствующим образом. Общие коды ошибок описаны в главе
:ref:`Generic Error Codes <gen-errors>`.
