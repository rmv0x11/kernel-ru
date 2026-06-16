.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: DTV.dmx

.. _DMX_GET_STC:

===========
DMX_GET_STC
===========

Имя
---

DMX_GET_STC

Обзор
-----

.. c:macro:: DMX_GET_STC

``int ioctl(int fd, DMX_GET_STC, struct dmx_stc *stc)``

Аргументы
---------

``fd``
    Файловый дескриптор, возвращённый :c:func:`open()`.

``stc``
    Указатель на :c:type:`dmx_stc`, куда должны быть сохранены данные stc.

Описание
--------

Этот вызов ioctl возвращает текущее значение системного счётчика времени
(system time counter, который управляется PES-фильтром типа :c:type:`DMX_PES_PCR <dmx_ts_pes>`).
Некоторое оборудование поддерживает более одного STC, поэтому вы должны указать,
какой именно, задав поле :c:type:`num <dmx_stc>` структуры stc перед вызовом ioctl (диапазон 0...n).
Результат возвращается в виде отношения с 64-битным числителем
и 32-битным знаменателем, поэтому реальное значение STC в 90 кГц равно
``stc->stc / stc->base``.

Возвращаемое значение
---------------------

При успехе возвращается 0.

При ошибке возвращается -1, а переменной ``errno`` присваивается
соответствующее значение.

.. tabularcolumns:: |p{2.5cm}|p{15.0cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths: 1 16

    -  .. row 1

       -  ``EINVAL``

       -  Недопустимый номер stc.

Общие коды ошибок описаны в главе
:ref:`Generic Error Codes <gen-errors>`.
