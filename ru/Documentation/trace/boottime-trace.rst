.. SPDX-License-Identifier: GPL-2.0

=============================
Трассировка во время загрузки
=============================

:Author: Masami Hiramatsu <mhiramat@kernel.org>

Обзор
=====

Трассировка во время загрузки (boot-time tracing) позволяет пользователям
трассировать процесс загрузки, включая инициализацию устройств, с полным набором
возможностей ftrace, включая пофайловые (per-event) фильтры и действия,
гистограммы, kprobe-события и синтетические события, а также экземпляры
трассировки (trace instances).
Поскольку командной строки ядра недостаточно для управления этими сложными
возможностями, для описания настройки трассировки используется файл bootconfig.

Параметры в Boot Config
=======================

Ниже приведён список доступных параметров трассировки во время загрузки в файле
boot config [1]_. Все параметры имеют префикс "ftrace." или "kernel.". См.
параметры ядра для параметров, начинающихся с префикса "kernel." [2]_.

.. [1] См. :ref:`Documentation/admin-guide/bootconfig.rst <bootconfig>`
.. [2] См. :ref:`Documentation/admin-guide/kernel-parameters.rst <kernelparameters>`

Глобальные параметры Ftrace
---------------------------

Глобальные параметры ftrace имеют в boot config префикс "kernel.", что означает,
что эти параметры передаются как часть устаревшей (legacy) командной строки ядра.

kernel.tp_printk
   Выводить данные trace-event также в буфер printk.

kernel.dump_on_oops [= MODE]
   Сбрасывать ftrace при Oops. Если MODE = 1 или не задан, сбрасывать буфер
   трассировки на всех CPU. Если MODE = 2, сбрасывать буфер на том CPU, который
   вызвал Oops.

kernel.traceoff_on_warning
   Остановить трассировку при возникновении WARN_ON().

kernel.fgraph_max_depth = MAX_DEPTH
   Установить MAX_DEPTH как максимальную глубину трассировщика fgraph.

kernel.fgraph_filters = FILTER[, FILTER2...]
   Добавить фильтры трассируемых функций для fgraph.

kernel.fgraph_notraces = FILTER[, FILTER2...]
   Добавить фильтры нетрассируемых функций для fgraph.


Параметры Ftrace для экземпляра
-------------------------------

Эти параметры можно использовать для каждого экземпляра, включая глобальный узел
ftrace.

ftrace.[instance.INSTANCE.]options = OPT1[, OPT2[...]]
   Включить заданные параметры ftrace.

ftrace.[instance.INSTANCE.]tracing_on = 0|1
   Включить/выключить трассировку на этом экземпляре при запуске трассировки во
   время загрузки.
   (вы можете включить её с помощью действия триггера события "traceon")

ftrace.[instance.INSTANCE.]trace_clock = CLOCK
   Установить заданный CLOCK в качестве trace_clock для ftrace.

ftrace.[instance.INSTANCE.]buffer_size = SIZE
   Настроить размер буфера ftrace равным SIZE. Для SIZE можно использовать "KB"
   или "MB".

ftrace.[instance.INSTANCE.]alloc_snapshot
   Выделить буфер снимков (snapshot).

ftrace.[instance.INSTANCE.]cpumask = CPUMASK
   Установить CPUMASK в качестве cpu-маски трассировки.

ftrace.[instance.INSTANCE.]events = EVENT[, EVENT2[...]]
   Включить заданные события при загрузке. В EVENT можно использовать символ
   подстановки (wild card).

ftrace.[instance.INSTANCE.]tracer = TRACER
   Установить TRACER в качестве текущего трассировщика при загрузке.
   (например, function)

ftrace.[instance.INSTANCE.]ftrace.filters
   Принимает массив правил фильтрации трассируемых функций.

ftrace.[instance.INSTANCE.]ftrace.notraces
   Принимает массив правил фильтрации НЕтрассируемых функций.


Параметры Ftrace для отдельного события
----------------------------------------

Эти параметры задают параметры для отдельного события.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.enable
   Включить трассировку GROUP:EVENT.

ftrace.[instance.INSTANCE.]event.GROUP.enable
   Включить трассировку всех событий в составе GROUP.

ftrace.[instance.INSTANCE.]event.enable
   Включить трассировку всех событий.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.filter = FILTER
   Установить правило FILTER для GROUP:EVENT.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.actions = ACTION[, ACTION2[...]]
   Установить ACTION для GROUP:EVENT.

ftrace.[instance.INSTANCE.]event.kprobes.EVENT.probes = PROBE[, PROBE2[...]]
   Определяет новое kprobe-событие на основе PROBE. Можно определить несколько
   проб (probes) для одного события, но они должны иметь одинаковый тип
   аргументов. Этот параметр доступен только для события, имя группы которого —
   "kprobes".

ftrace.[instance.INSTANCE.]event.synthetic.EVENT.fields = FIELD[, FIELD2[...]]
   Определяет новое синтетическое событие с полями FIELD. Каждое поле должно
   иметь вид "type varname".

Обратите внимание, что определения kprobe- и синтетических событий могут быть
записаны под узлом экземпляра, но они также видны из других экземпляров. Поэтому
обращайте внимание на конфликты имён событий.

Параметры гистограмм Ftrace
---------------------------

Поскольку записывать действие гистограммы строкой в параметре действия
отдельного события слишком длинно, для действий гистограммы предусмотрены
древовидные (tree-style) параметры под подключом 'hist' отдельного события.
Подробности о каждом параметре см. в документации по гистограммам событий
(Documentation/trace/histogram.rst)

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]keys = KEY1[, KEY2[...]]
  Установить параметры ключей гистограммы. (Обязательно)
  'N' — это строка цифр для нескольких гистограмм. Её можно опустить, если для
  события задана одна гистограмма.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]values = VAL1[, VAL2[...]]
  Установить параметры значений гистограммы.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]sort = SORT1[, SORT2[...]]
  Установить параметры сортировки гистограммы.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]size = NR_ENTRIES
  Установить размер гистограммы (число записей).

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]name = NAME
  Установить имя гистограммы.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]var.VARIABLE = EXPR
  Определить новую переменную VARIABLE выражением EXPR.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]<pause|continue|clear>
  Установить параметр управления гистограммой. Можно задать один из них.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]onmatch.[M.]event = GROUP.EVENT
  Установить параметр события сопоставления для обработчика 'onmatch' гистограммы.
  'M' — это строка цифр для нескольких обработчиков 'onmatch'. Её можно опустить,
  если для этой гистограммы задан один обработчик 'onmatch'.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]onmatch.[M.]trace = EVENT[, ARG1[...]]
  Установить действие 'trace' для 'onmatch' гистограммы.
  EVENT должно быть именем синтетического события, а ARG1... — параметрами для
  этого события. Обязательно, если задан параметр 'onmatch.event'.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]onmax.[M.]var = VAR
  Установить параметр переменной для обработчика 'onmax' гистограммы.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]onchange.[M.]var = VAR
  Установить параметр переменной для обработчика 'onchange' гистограммы.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]<onmax|onchange>.[M.]save = ARG1[, ARG2[...]]
  Установить параметры действия 'save' гистограммы для обработчика 'onmax' или
  'onchange'.
  Этот параметр или приведённый ниже параметр 'snapshot' обязателен, если задан
  параметр 'onmax.var' или 'onchange.var'.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.[N.]<onmax|onchange>.[M.]snapshot
  Установить действие 'snapshot' гистограммы для обработчика 'onmax' или
  'onchange'.
  Этот параметр или приведённый выше параметр 'save' обязателен, если задан
  параметр 'onmax.var' или 'onchange.var'.

ftrace.[instance.INSTANCE.]event.GROUP.EVENT.hist.filter = FILTER_EXPR
  Установить выражение фильтра гистограммы. В FILTER_EXPR не нужно указывать 'if'.

Обратите внимание, что этот параметр 'hist' может конфликтовать с параметром
'actions' отдельного события, если параметр 'actions' содержит действие
гистограммы.


Когда начинается трассировка
============================

Все параметры трассировки во время загрузки, начинающиеся с ``ftrace``, будут
включены в конце core_initcall. Это означает, что вы можете трассировать события
начиная с postcore_initcall. Большинство подсистем и зависящих от архитектуры
драйверов будут инициализированы после этого (arch_initcall или subsys_initcall).
Таким образом, вы можете трассировать их с помощью трассировки во время загрузки.
Если вы хотите трассировать события до core_initcall, можно использовать
параметры, начинающиеся с ``kernel``. Некоторые из них будут включены раньше,
чем обработка initcall (например, ``kernel.ftrace=function`` и
``kernel.trace_event`` запустятся до initcall.)


Примеры
=======

Например, чтобы добавить фильтр и действия для каждого события, определить
kprobe-события и синтетические события с гистограммой, запишите boot config так,
как показано ниже::

  ftrace.event {
        task.task_newtask {
                filter = "pid < 128"
                enable
        }
        kprobes.vfs_read {
                probes = "vfs_read $arg1 $arg2"
                filter = "common_pid < 200"
                enable
        }
        synthetic.initcall_latency {
                fields = "unsigned long func", "u64 lat"
                hist {
                        keys = func.sym, lat
                        values = lat
                        sort = lat
                }
        }
        initcall.initcall_start.hist {
                keys = func
                var.ts0 = common_timestamp.usecs
        }
        initcall.initcall_finish.hist {
                keys = func
                var.lat = common_timestamp.usecs - $ts0
                onmatch {
                        event = initcall.initcall_start
                        trace = initcall_latency, func, $lat
                }
        }
  }

Кроме того, трассировка во время загрузки поддерживает узел "instance", что
позволяет одновременно запускать несколько трассировщиков для разных целей.
Например, если один трассировщик предназначен для трассировки функций,
начинающихся с "user\_", а другие — для трассировки функций "kernel\_", вы можете
записать boot config так, как показано ниже::

  ftrace.instance {
        foo {
                tracer = "function"
                ftrace.filters = "user_*"
        }
        bar {
                tracer = "function"
                ftrace.filters = "kernel_*"
        }
  }

Узел instance также принимает узлы событий, так что каждый экземпляр может
настроить свою трассировку событий.

С помощью действия триггера и kprobes вы можете трассировать function-graph во
время вызова функции. Например, это позволит трассировать все вызовы функций
внутри pci_proc_init()::

  ftrace {
        tracing_on = 0
        tracer = function_graph
        event.kprobes {
                start_event {
                        probes = "pci_proc_init"
                        actions = "traceon"
                }
                end_event {
                        probes = "pci_proc_init%return"
                        actions = "traceoff"
                }
        }
  }


Эта трассировка во время загрузки также поддерживает параметры ядра ftrace через
boot config.
Например, следующие параметры ядра::

 trace_options=sym-addr trace_event=initcall:* tp_printk trace_buf_size=1M ftrace=function ftrace_filter="vfs*"

могут быть записаны в boot config так, как показано ниже::

  kernel {
        trace_options = sym-addr
        trace_event = "initcall:*"
        tp_printk
        trace_buf_size = 1M
        ftrace = function
        ftrace_filter = "vfs*"
  }

Обратите внимание, что параметры начинаются с префикса "kernel" вместо "ftrace".
