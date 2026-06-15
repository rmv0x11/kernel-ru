.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: DTV.ca

.. _CA_GET_DESCR_INFO:

=================
CA_GET_DESCR_INFO
=================

Имя
---

CA_GET_DESCR_INFO

Синопсис
--------

.. c:macro:: CA_GET_DESCR_INFO

``int ioctl(fd, CA_GET_DESCR_INFO, struct ca_descr_info *desc)``

Аргументы
---------

``fd``
  Файловый дескриптор, возвращённый предыдущим вызовом :c:func:`open()`.

``desc``
  Указатель на struct :c:type:`ca_descr_info`.

Описание
--------

Возвращает информацию обо всех слотах дескремблеров.

Возвращаемое значение
---------------------

В случае успеха возвращается 0, и :c:type:`ca_descr_info` заполняется.

В случае ошибки возвращается -1, и переменной ``errno`` присваивается
соответствующее значение. Общие коды ошибок описаны в главе
:ref:`Общие коды ошибок <gen-errors>`.
