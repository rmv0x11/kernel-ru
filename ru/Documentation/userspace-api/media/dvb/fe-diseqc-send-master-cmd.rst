.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: DTV.fe

.. _FE_DISEQC_SEND_MASTER_CMD:

*******************************
ioctl FE_DISEQC_SEND_MASTER_CMD
*******************************

Имя
===

FE_DISEQC_SEND_MASTER_CMD - отправляет команду DiSEqC

Синопсис
========

.. c:macro:: FE_DISEQC_SEND_MASTER_CMD

``int ioctl(int fd, FE_DISEQC_SEND_MASTER_CMD, struct dvb_diseqc_master_cmd *argp)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращённый :c:func:`open()`.

``argp``
    указатель на структуру
    :c:type:`dvb_diseqc_master_cmd`

Описание
========

Отправляет команду DiSEqC, на которую указывает :c:type:`dvb_diseqc_master_cmd`,
антенной подсистеме.

Возвращаемое значение
=====================

В случае успеха возвращается 0.

В случае ошибки возвращается -1, а переменной ``errno`` присваивается
соответствующее значение.

Общие коды ошибок описаны в главе
:ref:`Общие коды ошибок <gen-errors>`.
