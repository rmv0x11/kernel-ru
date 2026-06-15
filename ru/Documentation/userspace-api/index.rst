=====================================================================
Руководство по API ядра Linux для пространства пользователя
=====================================================================

.. _man-pages: https://www.kernel.org/doc/man-pages/

Хотя значительная часть API ядра для пространства пользователя описана в других
местах (в частности, в проекте man-pages_), некоторую информацию о пространстве
пользователя можно найти и в самом дереве исходников ядра.  Цель настоящего
руководства — стать тем местом, где эта информация собрана воедино.


Системные вызовы
================

.. toctree::
   :maxdepth: 1

   unshare
   futex2
   ebpf/index
   ioctl/index
   mseal
   rseq

Интерфейсы, связанные с безопасностью
=====================================

.. toctree::
   :maxdepth: 1

   no_new_privs
   seccomp_filter
   landlock
   lsm
   mfd_noexec
   spec_ctrl
   tee
   check_exec

Устройства и ввод-вывод
=======================

.. toctree::
   :maxdepth: 1

   accelerators/ocxl
   dma-buf-heaps
   dma-buf-alloc-exchange
   fwctl/index
   gpio/index
   iommufd
   media/index
   dcdbas
   vduse
   isapnp

Всё остальное
=============

.. toctree::
   :maxdepth: 1

   ELF
   liveupdate
   netlink/index
   sysfs-platform_profile
   vduse
   futex2
   perf_ring_buffer
   ntsync
