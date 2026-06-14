.. SPDX-License-Identifier: GPL-2.0

=============================
Оркестратор живого обновления
=============================
:Author: Pasha Tatashin <pasha.tatashin@soleen.com>

.. kernel-doc:: kernel/liveupdate/luo_core.c
   :doc: Live Update Orchestrator (LUO)

Сессии LUO
==========
.. kernel-doc:: kernel/liveupdate/luo_session.c
   :doc: LUO Sessions

Сохранение файловых дескрипторов в LUO
======================================
.. kernel-doc:: kernel/liveupdate/luo_file.c
   :doc: LUO File Descriptors

Глобальные данные, привязанные к жизненному циклу файлов LUO
============================================================
.. kernel-doc:: kernel/liveupdate/luo_flb.c
   :doc: LUO File Lifecycle Bound Global Data

ABI оркестратора живого обновления
==================================
.. kernel-doc:: include/linux/kho/abi/luo.h
   :doc: Live Update Orchestrator ABI

Сохранять можно файловые дескрипторы следующих типов

.. toctree::
   :maxdepth: 1

   ../mm/memfd_preservation

Публичный API
=============
.. kernel-doc:: include/linux/liveupdate.h

.. kernel-doc:: include/linux/kho/abi/luo.h
   :functions:

.. kernel-doc:: kernel/liveupdate/luo_core.c
   :export:

.. kernel-doc:: kernel/liveupdate/luo_flb.c
   :export:

.. kernel-doc:: kernel/liveupdate/luo_file.c
   :export:

Внутренний API
==============
.. kernel-doc:: kernel/liveupdate/luo_core.c
   :internal:

.. kernel-doc:: kernel/liveupdate/luo_flb.c
   :internal:

.. kernel-doc:: kernel/liveupdate/luo_session.c
   :internal:

.. kernel-doc:: kernel/liveupdate/luo_file.c
   :internal:

См. также
=========

- :doc:`Live Update uAPI </userspace-api/liveupdate>`
- :doc:`/core-api/kho/index`
