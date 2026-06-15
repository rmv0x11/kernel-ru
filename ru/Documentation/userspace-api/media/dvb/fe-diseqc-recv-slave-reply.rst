.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: DTV.fe

.. _FE_DISEQC_RECV_SLAVE_REPLY:

********************************
ioctl FE_DISEQC_RECV_SLAVE_REPLY
********************************

Имя
===

FE_DISEQC_RECV_SLAVE_REPLY - Принимает ответ на команду DiSEqC 2.0

Обзор
=====

.. c:macro:: FE_DISEQC_RECV_SLAVE_REPLY

``int ioctl(int fd, FE_DISEQC_RECV_SLAVE_REPLY, struct dvb_diseqc_slave_reply *argp)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращаемый функцией :c:func:`open()`.

``argp``
    указатель на структуру :c:type:`dvb_diseqc_slave_reply`.

Описание
========

Принимает ответ на команду DiSEqC 2.0.

Принятое сообщение сохраняется в буфере, на который указывает ``argp``.

Возвращаемое значение
=====================

В случае успеха возвращается 0.

В случае ошибки возвращается -1, а переменной ``errno`` присваивается
соответствующее значение.

Общие коды ошибок описаны в главе
:ref:`Общие коды ошибок <gen-errors>`.
