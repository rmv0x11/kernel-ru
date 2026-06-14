====================
API ядра Linux
====================


Базовые функции библиотеки C
============================

При написании драйверов вы, как правило, не можете использовать процедуры
из библиотеки C. Некоторые из этих функций оказались в целом полезными,
и они перечислены ниже. Поведение этих функций может несколько отличаться
от определённого стандартом ANSI, и такие отклонения отмечены в тексте.

Преобразования строк
--------------------

.. kernel-doc:: lib/vsprintf.c
   :export:

.. kernel-doc:: include/linux/kstrtox.h
   :functions: kstrtol kstrtoul

.. kernel-doc:: lib/kstrtox.c
   :export:

.. kernel-doc:: lib/string_helpers.c
   :export:

Манипуляции со строками
-----------------------

.. kernel-doc:: include/linux/fortify-string.h
   :internal:

.. kernel-doc:: lib/string.c
   :export:

.. kernel-doc:: include/linux/string.h
   :internal:

.. kernel-doc:: mm/util.c
   :functions: kstrdup kstrdup_const kstrndup kmemdup kmemdup_nul memdup_user
               vmemdup_user strndup_user memdup_user_nul

Базовые функции библиотеки ядра
===============================

Ядро Linux предоставляет дополнительные базовые служебные функции.

Битовые операции
----------------

.. kernel-doc:: include/asm-generic/bitops/instrumented-atomic.h
   :internal:

.. kernel-doc:: include/asm-generic/bitops/instrumented-non-atomic.h
   :internal:

.. kernel-doc:: include/asm-generic/bitops/instrumented-lock.h
   :internal:

Операции с битовыми картами
---------------------------

.. kernel-doc:: lib/bitmap.c
   :doc: bitmap introduction

.. kernel-doc:: include/linux/bitmap.h
   :doc: declare bitmap

.. kernel-doc:: include/linux/bitmap.h
   :doc: bitmap overview

.. kernel-doc:: include/linux/bitmap.h
   :doc: bitmap bitops

.. kernel-doc:: lib/bitmap.c
   :export:

.. kernel-doc:: lib/bitmap.c
   :internal:

.. kernel-doc:: include/linux/bitmap.h
   :internal:

Разбор командной строки
-----------------------

.. kernel-doc:: lib/cmdline.c
   :export:

Указатели на ошибки
-------------------

.. kernel-doc:: include/linux/err.h
   :internal:

Сортировка
----------

.. kernel-doc:: lib/sort.c
   :export:

.. kernel-doc:: lib/list_sort.c
   :export:

Поиск по тексту
---------------

.. kernel-doc:: lib/textsearch.c
   :doc: ts_intro

.. kernel-doc:: lib/textsearch.c
   :export:

.. kernel-doc:: include/linux/textsearch.h
   :functions: textsearch_find textsearch_next \
               textsearch_get_pattern textsearch_get_pattern_len

Функции CRC и математические функции в Linux
============================================

Проверка арифметического переполнения
-------------------------------------

.. kernel-doc:: include/linux/overflow.h
   :internal:

Функции CRC
-----------

.. kernel-doc:: lib/crc/crc4.c
   :export:

.. kernel-doc:: lib/crc/crc7.c
   :export:

.. kernel-doc:: lib/crc/crc8.c
   :export:

.. kernel-doc:: lib/crc/crc16.c
   :export:

.. kernel-doc:: lib/crc/crc-ccitt.c
   :export:

.. kernel-doc:: lib/crc/crc-itu-t.c
   :export:

.. kernel-doc:: include/linux/crc32.h

.. kernel-doc:: include/linux/crc64.h

Функции логарифма и степени по основанию 2
------------------------------------------

.. kernel-doc:: include/linux/log2.h
   :internal:

Функции целочисленного логарифма и степени
------------------------------------------

.. kernel-doc:: include/linux/int_log.h

.. kernel-doc:: lib/math/int_pow.c
   :export:

.. kernel-doc:: lib/math/int_sqrt.c
   :export:

Функции деления
---------------

.. kernel-doc:: include/asm-generic/div64.h
   :functions: do_div

.. kernel-doc:: include/linux/math64.h
   :internal:

.. kernel-doc:: lib/math/gcd.c
   :export:

UUID/GUID
---------

.. kernel-doc:: lib/uuid.c
   :export:

Средства IPC ядра
=================

Служебные функции IPC
---------------------

.. kernel-doc:: ipc/util.c
   :internal:

Буфер FIFO
==========

Интерфейс kfifo
---------------

.. kernel-doc:: include/linux/kfifo.h
   :internal:

Поддержка интерфейса relay
==========================

Поддержка интерфейса relay предназначена для предоставления эффективного
механизма, позволяющего инструментам и средствам передавать большие объёмы
данных из пространства ядра в пространство пользователя.

Интерфейс relay
---------------

.. kernel-doc:: kernel/relay.c
   :export:

.. kernel-doc:: kernel/relay.c
   :internal:

Поддержка модулей
=================

Автоматическая загрузка модулей ядра
------------------------------------

.. kernel-doc:: kernel/module/kmod.c
   :export:

Отладка модулей
---------------

.. kernel-doc:: kernel/module/stats.c
   :doc: module debugging statistics overview

dup_failed_modules - tracks duplicate failed modules
****************************************************

.. kernel-doc:: kernel/module/stats.c
   :doc: dup_failed_modules - tracks duplicate failed modules

module statistics debugfs counters
**********************************

.. kernel-doc:: kernel/module/stats.c
   :doc: module statistics debugfs counters

Поддержка взаимодействия между модулями
---------------------------------------

Дополнительную информацию см. в файлах каталога kernel/module/.

Аппаратные интерфейсы
=====================

Каналы DMA
----------

.. kernel-doc:: kernel/dma.c
   :export:

Управление ресурсами
--------------------

.. kernel-doc:: kernel/resource.c
   :internal:

.. kernel-doc:: kernel/resource.c
   :export:

Обработка MTRR
--------------

.. kernel-doc:: arch/x86/kernel/cpu/mtrr/mtrr.c
   :export:

Платформа безопасности
======================

.. kernel-doc:: security/security.c
   :internal:

.. kernel-doc:: security/inode.c
   :export:

Интерфейсы аудита
=================

.. kernel-doc:: kernel/audit.c
   :export:

.. kernel-doc:: kernel/auditsc.c
   :internal:

.. kernel-doc:: kernel/auditfilter.c
   :internal:

Платформа учёта (accounting)
============================

.. kernel-doc:: kernel/acct.c
   :internal:

Блочные устройства
==================

.. kernel-doc:: include/linux/bio.h
.. kernel-doc:: block/blk-core.c
   :export:

.. kernel-doc:: block/blk-core.c
   :internal:

.. kernel-doc:: block/blk-map.c
   :export:

.. kernel-doc:: block/blk-sysfs.c
   :internal:

.. kernel-doc:: block/blk-settings.c
   :export:

.. kernel-doc:: block/blk-flush.c
   :export:

.. kernel-doc:: block/blk-lib.c
   :export:

.. kernel-doc:: block/blk-integrity.c
   :export:

.. kernel-doc:: kernel/trace/blktrace.c
   :internal:

.. kernel-doc:: block/genhd.c
   :internal:

.. kernel-doc:: block/genhd.c
   :export:

.. kernel-doc:: block/bdev.c
   :export:

Символьные устройства
=====================

.. kernel-doc:: fs/char_dev.c
   :export:

Платформа тактирования (clock framework)
========================================

Платформа тактирования определяет программные интерфейсы для поддержки
программного управления деревом системных тактовых сигналов. Эта платформа
широко используется на платформах System-On-Chip (SOC) для поддержки управления
энергопотреблением и различных устройств, которым могут потребоваться
нестандартные частоты тактирования. Обратите внимание, что эти «тактовые
сигналы» не относятся к учёту времени или часам реального времени (RTC),
для каждого из которых существуют отдельные платформы. Эти экземпляры
:c:type:`struct clk <clk>` могут использоваться для управления, например,
сигналом 96 МГц, который применяется для побитовой передачи данных в
периферийные устройства и шины и обратно либо иным образом запускает
синхронные переходы конечных автоматов в системном оборудовании.

Управление энергопотреблением поддерживается за счёт явного программного
гейтирования тактовых сигналов: неиспользуемые тактовые сигналы отключаются,
поэтому система не тратит энергию на изменение состояния транзисторов, которые
не задействованы. На некоторых системах это может подкрепляться аппаратным
гейтированием тактовых сигналов, при котором сигналы гейтируются без отключения
программными средствами. Участки микросхем, на которые подаётся питание, но не
подаётся тактовый сигнал, могут сохранять своё последнее состояние. Это
состояние пониженного энергопотребления часто называют *режимом удержания*
(retention mode). В этом режиме всё ещё возникают токи утечки, особенно при
более тонких геометриях схем, однако для КМОП-схем (CMOS) энергия в основном
расходуется на тактируемые изменения состояния.

Драйверы, учитывающие энергопотребление, включают свои тактовые сигналы только
тогда, когда управляемое ими устройство активно используется. Кроме того,
состояния сна системы часто различаются в зависимости от того, какие тактовые
домены активны: если состояние «standby» может допускать пробуждение из
нескольких активных доменов, то состояние «mem» (suspend-to-RAM) может требовать
более полного отключения тактовых сигналов, производных от более
высокоскоростных PLL и генераторов, что ограничивает число возможных источников
событий пробуждения. Метод suspend драйвера может нуждаться в учёте специфичных
для системы ограничений на тактирование в целевом состоянии сна.

Некоторые платформы поддерживают программируемые генераторы тактовых сигналов.
Они могут использоваться внешними микросхемами различного рода, такими как
другие CPU, мультимедийные кодеки и устройства со строгими требованиями к
тактированию интерфейса.

.. kernel-doc:: include/linux/clk.h
   :internal:

Примитивы синхронизации
=======================

Read-Copy Update (RCU)
----------------------

.. kernel-doc:: include/linux/rcupdate.h

.. kernel-doc:: kernel/rcu/tree.c

.. kernel-doc:: kernel/rcu/tree_exp.h

.. kernel-doc:: kernel/rcu/update.c

.. kernel-doc:: include/linux/srcu.h

.. kernel-doc:: kernel/rcu/srcutree.c

.. kernel-doc:: include/linux/rculist_bl.h

.. kernel-doc:: include/linux/rculist.h

.. kernel-doc:: include/linux/rculist_nulls.h

.. kernel-doc:: include/linux/rcu_sync.h

.. kernel-doc:: kernel/rcu/sync.c

.. kernel-doc:: kernel/rcu/tasks.h

.. kernel-doc:: kernel/rcu/tree_stall.h

.. kernel-doc:: include/linux/rcupdate_trace.h

.. kernel-doc:: include/linux/rcupdate_wait.h

.. kernel-doc:: include/linux/rcuref.h

.. kernel-doc:: include/linux/rcutree.h
