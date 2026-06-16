.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-no-invariants-or-later
.. c:namespace:: RC

.. _lirc_get_send_mode:
.. _lirc_set_send_mode:

************************************************
ioctls LIRC_GET_SEND_MODE and LIRC_SET_SEND_MODE
************************************************

Имя
===

LIRC_GET_SEND_MODE/LIRC_SET_SEND_MODE - получить/установить текущий режим передачи.

Обзор
=====

.. c:macro:: LIRC_GET_SEND_MODE

``int ioctl(int fd, LIRC_GET_SEND_MODE, __u32 *mode)``

.. c:macro:: LIRC_SET_SEND_MODE

``int ioctl(int fd, LIRC_SET_SEND_MODE, __u32 *mode)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращённый open().

``mode``
    Режим, используемый для передачи.

Описание
========

Получить/установить текущий режим передачи.

Для отправки ИК-сигнала поддерживаются только :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>` и
:ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>`, в зависимости от драйвера. Используйте
:ref:`lirc_get_features`, чтобы узнать, какие режимы поддерживает драйвер.

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

       -  Устройство не поддерживает передачу.

    -  .. row 3

       -  ``EINVAL``

       -  Недопустимый режим или недопустимый режим для данного устройства.
