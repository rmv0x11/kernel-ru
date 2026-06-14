================================
Документация по Core API ядра
================================

Это начало руководства по основным (core) API ядра. Преобразование
(и написание!) документов для этого руководства приветствуется!

Основные утилиты
================

Этот раздел содержит общую документацию и документацию по «ядру ядра».
Первая часть — это огромная мешанина сведений в формате kerneldoc,
оставшихся со времён docbook; когда-нибудь её действительно следует
разбить на части, когда у кого-нибудь найдутся силы это сделать.

.. toctree::
   :maxdepth: 1

   kernel-api
   workqueue
   watch_queue
   printk-basics
   printk-formats
   printk-index
   symbol-namespaces
   asm-annotations
   real-time/index
   housekeeping.rst

Структуры данных и низкоуровневые утилиты
=========================================

Библиотечная функциональность, используемая по всему ядру.

.. toctree::
   :maxdepth: 1

   kobject
   kref
   cleanup
   assoc_array
   folio_queue
   xarray
   maple_tree
   idr
   circular-buffers
   rbtree
   generic-radix-tree
   packing
   this_cpu_ops
   timekeeping
   errseq
   wrappers/atomic_t
   wrappers/atomic_bitops
   floating-point
   union_find
   min_heap
   parser
   list

Низкоуровневые вход и выход
===========================

.. toctree::
   :maxdepth: 1

   entry

Примитивы параллелизма
======================

Как Linux предотвращает одновременное выполнение всего сразу. См.
Documentation/locking/index.rst для дополнительной документации по теме.

.. toctree::
   :maxdepth: 1

   refcount-vs-atomic
   irq/index
   local_ops
   padata
   ../RCU/index
   wrappers/memory-barriers.rst

Низкоуровневое управление оборудованием
=======================================

Управление кэшем, управление горячим подключением CPU и т. п.

.. toctree::
   :maxdepth: 1

   cachetlb
   cpu_hotplug
   memory-hotplug
   genericirq
   protection-keys

Управление памятью
==================

Как выделять и использовать память в ядре. Обратите внимание, что гораздо
больше документации по управлению памятью находится в
Documentation/mm/index.rst.

.. toctree::
   :maxdepth: 1

   memory-allocation
   unaligned-memory-access
   dma-api
   dma-api-howto
   dma-attributes
   dma-isa-lpc
   swiotlb
   mm-api
   cgroup
   genalloc
   pin_user_pages
   boot-time-mm
   gfp_mask-from-fs-io
   kho/index

Интерфейсы для отладки ядра
===========================

.. toctree::
   :maxdepth: 1

   debug-objects
   tracepoint
   debugging-via-ohci1394

Всё остальное
=============

Документы, которые не подходят к другим разделам или которые ещё не были
классифицированы.

.. toctree::
   :maxdepth: 1

   librs
   liveupdate
   netlink
