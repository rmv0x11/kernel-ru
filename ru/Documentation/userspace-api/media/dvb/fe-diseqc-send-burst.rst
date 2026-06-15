.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: DTV.fe

.. _FE_DISEQC_SEND_BURST:

**************************
ioctl FE_DISEQC_SEND_BURST
**************************

Имя
===

FE_DISEQC_SEND_BURST - отправляет тональную посылку 22 кГц для выбора спутника по упрощённому протоколу DiSEqC (mini DiSEqC) в схеме 2x1.

Синопсис
========

.. c:macro:: FE_DISEQC_SEND_BURST

``int ioctl(int fd, FE_DISEQC_SEND_BURST, enum fe_sec_mini_cmd tone)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращённый :c:func:`open()`.

``tone``
    Целочисленное перечислимое значение, описанное в :c:type:`fe_sec_mini_cmd`.

Описание
========

Этот ioctl используется для управления генерацией тональной посылки 22 кГц
для выбора спутника по упрощённому протоколу DiSEqC (mini DiSEqC) в коммутаторах
2x1. Этот вызов требует прав на чтение/запись.

Он обеспечивает поддержку того, что описано в
`Digital Satellite Equipment Control (DiSEqC) - Simple "ToneBurst" Detection Circuit specification. <http://www.eutelsat.com/files/contributed/satellites/pdf/Diseqc/associated%20docs/simple_tone_burst_detec.pdf>`__

Возвращаемое значение
=====================

В случае успеха возвращается 0.

В случае ошибки возвращается -1, а переменной ``errno`` присваивается
соответствующее значение.

Общие коды ошибок описаны в главе
:ref:`Общие коды ошибок <gen-errors>`.
