.. SPDX-License-Identifier: GPL-2.0

===============================
API живой правки (livepatching)
===============================

Включение живой правки (livepatch)
==================================

.. kernel-doc:: kernel/livepatch/core.c
   :export:


Теневые переменные
==================

.. kernel-doc:: kernel/livepatch/shadow.c
   :export:

Изменения состояния системы
===========================

.. kernel-doc:: kernel/livepatch/state.c
   :export:

Типы объектов
=============

.. kernel-doc:: include/linux/livepatch.h
   :identifiers: klp_patch klp_object klp_func klp_callbacks klp_state
