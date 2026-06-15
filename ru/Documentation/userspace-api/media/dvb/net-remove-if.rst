.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: DTV.net

.. _NET_REMOVE_IF:

*******************
ioctl NET_REMOVE_IF
*******************

Имя
===

NET_REMOVE_IF - Удаляет сетевой интерфейс.

Синопсис
========

.. c:macro:: NET_REMOVE_IF

``int ioctl(int fd, NET_REMOVE_IF, int ifnum)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращаемый :c:func:`open()`.

``net_if``
    номер удаляемого интерфейса

Описание
========

ioctl NET_REMOVE_IF удаляет интерфейс, ранее созданный с помощью
:ref:`NET_ADD_IF <net>`.

Возвращаемое значение
=====================

В случае успеха возвращается 0 и заполняется :c:type:`ca_slot_info`.

В случае ошибки возвращается -1 и переменной ``errno`` присваивается
соответствующее значение.

Общие коды ошибок описаны в главе
:ref:`Общие коды ошибок <gen-errors>`.
