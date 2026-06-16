.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-no-invariants-or-later
.. c:namespace:: RC

.. _lirc_set_rec_carrier_range:

********************************
ioctl LIRC_SET_REC_CARRIER_RANGE
********************************

Имя
===

LIRC_SET_REC_CARRIER_RANGE - Устанавливает нижнюю границу несущей, используемой для
модуляции принимаемого ИК-сигнала.

Синопсис
========

.. c:macro:: LIRC_SET_REC_CARRIER_RANGE

``int ioctl(int fd, LIRC_SET_REC_CARRIER_RANGE, __u32 *frequency)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращённый open().

``frequency``
    Частота несущей, модулирующей PWM-данные, в Гц.

Описание
========

Этот ioctl устанавливает верхнюю границу диапазона частот несущей, которая будет
распознаваться ИК-приёмником.

.. note::

   Чтобы задать диапазон, используйте :ref:`LIRC_SET_REC_CARRIER_RANGE
   <LIRC_SET_REC_CARRIER_RANGE>` с нижней границей, а затем вызовите
   :ref:`LIRC_SET_REC_CARRIER <LIRC_SET_REC_CARRIER>` с верхней границей.

Возвращаемое значение
=====================

В случае успеха возвращается 0, в случае ошибки -1, и переменная ``errno``
устанавливается соответствующим образом. Общие коды ошибок описаны в главе
:ref:`Generic Error Codes <gen-errors>`.
