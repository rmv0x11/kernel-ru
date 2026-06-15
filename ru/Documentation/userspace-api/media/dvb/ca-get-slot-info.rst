.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: DTV.ca

.. _CA_GET_SLOT_INFO:

================
CA_GET_SLOT_INFO
================

Имя
---

CA_GET_SLOT_INFO

Синопсис
--------

.. c:macro:: CA_GET_SLOT_INFO

``int ioctl(fd, CA_GET_SLOT_INFO, struct ca_slot_info *info)``

Аргументы
---------

``fd``
  Файловый дескриптор, возвращённый предыдущим вызовом :c:func:`open()`.

``info``
  Указатель на struct :c:type:`ca_slot_info`.

Описание
--------

Возвращает информацию о слоте CA, идентифицируемом
:c:type:`ca_slot_info`.slot_num.

Возвращаемое значение
---------------------

В случае успеха возвращается 0, и :c:type:`ca_slot_info` заполняется.

В случае ошибки возвращается -1, и переменной ``errno`` присваивается
соответствующее значение.

.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths: 1 16

    -  -  ``ENODEV``
       -  слот недоступен.

Общие коды ошибок описаны в главе
:ref:`Общие коды ошибок <gen-errors>`.
