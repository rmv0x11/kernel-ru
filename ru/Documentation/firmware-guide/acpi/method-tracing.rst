.. SPDX-License-Identifier: GPL-2.0
.. include:: <isonum.txt>

=====================
ACPICA Trace Facility
=====================

:Copyright: |copy| 2015, Intel Corporation
:Author: Lv Zheng <lv.zheng@intel.com>


Аннотация
=========
Этот документ описывает функции и интерфейсы средства трассировки методов
(method tracing facility).

Возможности и примеры использования
===================================

ACPICA предоставляет возможность трассировки методов. На данный момент с
использованием этой возможности реализованы две функции.

Сокращение объёма журнала
-------------------------

Подсистема ACPICA предоставляет отладочный вывод, когда включён CONFIG_ACPI_DEBUG.
Отладочные сообщения, выводимые с помощью макроса ACPI_DEBUG_PRINT(), могут быть
сокращены на 2 уровнях — на уровне отдельного компонента (известен как
debug layer, настраивается через /sys/module/acpi/parameters/debug_layer) и на
уровне отдельного типа (известен как debug level, настраивается через
/sys/module/acpi/parameters/debug_level).

Но когда конкретный layer/level применяется к вычислениям управляющих методов
(control method evaluations), количество отладочного вывода всё равно может быть
слишком большим, чтобы поместиться в буфер журнала ядра. Таким образом, была
выработана идея включать журналирование с конкретным debug layer/level (обычно
более детальное) только при запуске вычисления управляющего метода и отключать
детальное журналирование при остановке вычисления управляющего метода.

Следующие примеры команд иллюстрируют использование функциональности
«сокращения объёма журнала» («log reducer»):

a. Отфильтровать логи, соответствующие debug layer/level, при вычислении
   управляющих методов::

      # cd /sys/module/acpi/parameters
      # echo "0xXXXXXXXX" > trace_debug_layer
      # echo "0xYYYYYYYY" > trace_debug_level
      # echo "enable" > trace_state

b. Отфильтровать логи, соответствующие debug layer/level, при вычислении
   указанного управляющего метода::

      # cd /sys/module/acpi/parameters
      # echo "0xXXXXXXXX" > trace_debug_layer
      # echo "0xYYYYYYYY" > trace_debug_level
      # echo "\PPPP.AAAA.TTTT.HHHH" > trace_method_name
      # echo "method" > /sys/module/acpi/parameters/trace_state

c. Отфильтровать логи, соответствующие debug layer/level, при первом
   вычислении указанного управляющего метода::

      # cd /sys/module/acpi/parameters
      # echo "0xXXXXXXXX" > trace_debug_layer
      # echo "0xYYYYYYYY" > trace_debug_level
      # echo "\PPPP.AAAA.TTTT.HHHH" > trace_method_name
      # echo "method-once" > /sys/module/acpi/parameters/trace_state

Где:
   0xXXXXXXXX/0xYYYYYYYY
     Возможные значения масок debug layer/level см. в
     Documentation/firmware-guide/acpi/debug.rst.
   \PPPP.AAAA.TTTT.HHHH
     Полный путь управляющего метода, который можно найти в пространстве имён ACPI.
     Это не обязательно должна быть точка входа в вычисление управляющего метода.

AML-трассировщик
----------------

Средство трассировки методов добавляет специальные записи в журнал в «точках
трассировки» («trace points»), где интерпретатор AML начинает/прекращает
выполнение управляющего метода или AML-опкода. Обратите внимание, что формат
записей журнала может измениться::

   [    0.186427]   exdebug-0398 ex_trace_point        : Method Begin [0xf58394d8:\_SB.PCI0.LPCB.ECOK] execution.
   [    0.186630]   exdebug-0398 ex_trace_point        : Opcode Begin [0xf5905c88:If] execution.
   [    0.186820]   exdebug-0398 ex_trace_point        : Opcode Begin [0xf5905cc0:LEqual] execution.
   [    0.187010]   exdebug-0398 ex_trace_point        : Opcode Begin [0xf5905a20:-NamePath-] execution.
   [    0.187214]   exdebug-0398 ex_trace_point        : Opcode End [0xf5905a20:-NamePath-] execution.
   [    0.187407]   exdebug-0398 ex_trace_point        : Opcode Begin [0xf5905f60:One] execution.
   [    0.187594]   exdebug-0398 ex_trace_point        : Opcode End [0xf5905f60:One] execution.
   [    0.187789]   exdebug-0398 ex_trace_point        : Opcode End [0xf5905cc0:LEqual] execution.
   [    0.187980]   exdebug-0398 ex_trace_point        : Opcode Begin [0xf5905cc0:Return] execution.
   [    0.188146]   exdebug-0398 ex_trace_point        : Opcode Begin [0xf5905f60:One] execution.
   [    0.188334]   exdebug-0398 ex_trace_point        : Opcode End [0xf5905f60:One] execution.
   [    0.188524]   exdebug-0398 ex_trace_point        : Opcode End [0xf5905cc0:Return] execution.
   [    0.188712]   exdebug-0398 ex_trace_point        : Opcode End [0xf5905c88:If] execution.
   [    0.188903]   exdebug-0398 ex_trace_point        : Method End [0xf58394d8:\_SB.PCI0.LPCB.ECOK] execution.

Разработчики могут использовать эти специальные записи журнала для отслеживания
интерпретации AML, тем самым облегчая отладку проблем и тонкую настройку
производительности. Обратите внимание, что, поскольку логи «AML-трассировщика»
(«AML tracer») реализованы через макрос ACPI_DEBUG_PRINT(), для включения логов
«AML-трассировщика» также требуется, чтобы был включён CONFIG_ACPI_DEBUG.

Следующие примеры команд иллюстрируют использование функциональности
«AML-трассировщика»:

a. Отфильтровать логи «AML-трассировщика» о начале/остановке метода при
   вычислении управляющих методов::

      # cd /sys/module/acpi/parameters
      # echo "0x80" > trace_debug_layer
      # echo "0x10" > trace_debug_level
      # echo "enable" > trace_state

b. Отфильтровать «AML-трассировщик» о начале/остановке метода при вычислении
   указанного управляющего метода::

      # cd /sys/module/acpi/parameters
      # echo "0x80" > trace_debug_layer
      # echo "0x10" > trace_debug_level
      # echo "\PPPP.AAAA.TTTT.HHHH" > trace_method_name
      # echo "method" > trace_state

c. Отфильтровать логи «AML-трассировщика» о начале/остановке метода при первом
   вычислении указанного управляющего метода::

      # cd /sys/module/acpi/parameters
      # echo "0x80" > trace_debug_layer
      # echo "0x10" > trace_debug_level
      # echo "\PPPP.AAAA.TTTT.HHHH" > trace_method_name
      # echo "method-once" > trace_state

d. Отфильтровать «AML-трассировщик» о начале/остановке метода/опкода при
   вычислении указанного управляющего метода::

      # cd /sys/module/acpi/parameters
      # echo "0x80" > trace_debug_layer
      # echo "0x10" > trace_debug_level
      # echo "\PPPP.AAAA.TTTT.HHHH" > trace_method_name
      # echo "opcode" > trace_state

e. Отфильтровать «AML-трассировщик» о начале/остановке метода/опкода при первом
   вычислении указанного управляющего метода::

      # cd /sys/module/acpi/parameters
      # echo "0x80" > trace_debug_layer
      # echo "0x10" > trace_debug_level
      # echo "\PPPP.AAAA.TTTT.HHHH" > trace_method_name
      # echo "opcode-opcode" > trace_state

Обратите внимание, что все вышеперечисленные параметры модуля, относящиеся к
средству трассировки методов, могут использоваться в качестве параметров
загрузки, например::

   acpi.trace_debug_layer=0x80 acpi.trace_debug_level=0x10 \
   acpi.trace_method_name=\_SB.LID0._LID acpi.trace_state=opcode-once


Описания интерфейсов
====================

Все функции трассировки методов могут быть настроены через параметры модуля
ACPI, доступные в /sys/module/acpi/parameters/:

trace_method_name
  Полный путь AML-метода, который пользователь хочет трассировать.

  Обратите внимание, что полный путь не должен содержать завершающих символов
  "_" в сегментах имён, но может содержать "\" для формирования абсолютного пути.

trace_debug_layer
  Временный debug_layer, используемый при включённой функции трассировки.

  По умолчанию используется ACPI_EXECUTER (0x80), который является debug_layer,
  применяемым для сопоставления всех логов «AML-трассировщика».

trace_debug_level
  Временный debug_level, используемый при включённой функции трассировки.

  По умолчанию используется ACPI_LV_TRACE_POINT (0x10), который является
  debug_level, применяемым для сопоставления всех логов «AML-трассировщика».

trace_state
  Состояние функции трассировки.

  Пользователи могут включать/отключать эту функцию отладочной трассировки,
  выполнив следующую команду::

   # echo string > /sys/module/acpi/parameters/trace_state

Где "string" должно быть одним из следующих значений:

"disable"
  Отключить функцию трассировки методов.

"enable"
  Включить функцию трассировки методов.

  Отладочные сообщения ACPICA, соответствующие "trace_debug_layer/trace_debug_level"
  во время выполнения любого метода, будут записаны в журнал.

"method"
  Включить функцию трассировки методов.

  Отладочные сообщения ACPICA, соответствующие "trace_debug_layer/trace_debug_level"
  во время выполнения метода "trace_method_name", будут записаны в журнал.

"method-once"
  Включить функцию трассировки методов.

  Отладочные сообщения ACPICA, соответствующие "trace_debug_layer/trace_debug_level"
  во время выполнения метода "trace_method_name", будут записаны в журнал только один раз.

"opcode"
  Включить функцию трассировки методов.

  Отладочные сообщения ACPICA, соответствующие "trace_debug_layer/trace_debug_level"
  во время выполнения метода/опкода "trace_method_name", будут записаны в журнал.

"opcode-once"
  Включить функцию трассировки методов.

  Отладочные сообщения ACPICA, соответствующие "trace_debug_layer/trace_debug_level"
  во время выполнения метода/опкода "trace_method_name", будут записаны в журнал
  только один раз.

Обратите внимание, что разница между "enable" и другими параметрами включения
функции состоит в следующем:

1. Когда указано "enable", поскольку
   "trace_debug_layer/trace_debug_level" должны применяться ко всем вычислениям
   управляющих методов, после настройки "trace_state" в "enable"
   "trace_method_name" будет сброшено в NULL.
2. Когда указано "method/opcode", если
   "trace_method_name" равно NULL в момент настройки "trace_state" в
   эти параметры, то "trace_debug_layer/trace_debug_level" будут
   применяться ко всем вычислениям управляющих методов.
