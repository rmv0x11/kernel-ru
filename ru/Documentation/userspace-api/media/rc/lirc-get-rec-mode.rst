.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-no-invariants-or-later
.. c:namespace:: RC

.. _lirc_get_rec_mode:
.. _lirc_set_rec_mode:

**********************************************
ioctls LIRC_GET_REC_MODE and LIRC_SET_REC_MODE
**********************************************

Имя
===

LIRC_GET_REC_MODE/LIRC_SET_REC_MODE - получить/установить текущий режим приёма.

Синопсис
========

.. c:macro:: LIRC_GET_REC_MODE

``int ioctl(int fd, LIRC_GET_REC_MODE, __u32 *mode)``

.. c:macro:: LIRC_SET_REC_MODE

``int ioctl(int fd, LIRC_SET_REC_MODE, __u32 *mode)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращённый функцией open().

``mode``
    Режим, используемый для приёма.

Описание
========

Получить и установить текущий режим приёма. Поддерживаются только
:ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>` и
:ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>`.
Используйте :ref:`lirc_get_features`, чтобы узнать, какие режимы поддерживает драйвер.

Возвращаемое значение
=====================

.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    -  .. row 1

       -  ``ENODEV``

       -  Устройство недоступно.

    -  .. row 2

       -  ``ENOTTY``

       -  Устройство не поддерживает приём.

    -  .. row 3

       -  ``EINVAL``

       -  Недопустимый режим или недопустимый режим для данного устройства.
