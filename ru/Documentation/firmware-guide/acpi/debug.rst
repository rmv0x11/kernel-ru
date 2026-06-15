.. SPDX-License-Identifier: GPL-2.0

==========================
Отладочный вывод ACPI CA
==========================

ACPI CA может генерировать отладочный вывод. В этом документе описано, как
пользоваться этим средством.

Конфигурация на этапе компиляции
================================

Отладочный вывод ACPI CA глобально включается параметром CONFIG_ACPI_DEBUG. Если
этот параметр конфигурации не задан, отладочные сообщения даже не встраиваются в ядро.

Конфигурация на этапе загрузки и во время работы
================================================

Когда задано CONFIG_ACPI_DEBUG=y, вы можете выбрать компонент и уровень
интересующих вас сообщений. На этапе загрузки используйте параметры командной
строки ядра acpi.debug_layer и acpi.debug_level. После загрузки для управления
отладочными сообщениями можно использовать файлы debug_layer и debug_level в
/sys/module/acpi/parameters/.

debug_layer (компонент)
=======================

"debug_layer" — это маска, выбирающая интересующие компоненты, например, конкретную
часть интерпретатора ACPI. Чтобы составить битовую маску debug_layer, найдите
"#define _COMPONENT" в исходном файле ACPI.

Вы можете задать маску debug_layer на этапе загрузки с помощью аргумента командной
строки acpi.debug_layer, а изменить её после загрузки можно, записывая значения
в /sys/module/acpi/parameters/debug_layer.

Возможные компоненты определены в include/acpi/acoutput.h.

Чтение /sys/module/acpi/parameters/debug_layer показывает поддерживаемые значения маски::

    ACPI_UTILITIES                  0x00000001
    ACPI_HARDWARE                   0x00000002
    ACPI_EVENTS                     0x00000004
    ACPI_TABLES                     0x00000008
    ACPI_NAMESPACE                  0x00000010
    ACPI_PARSER                     0x00000020
    ACPI_DISPATCHER                 0x00000040
    ACPI_EXECUTER                   0x00000080
    ACPI_RESOURCES                  0x00000100
    ACPI_CA_DEBUGGER                0x00000200
    ACPI_OS_SERVICES                0x00000400
    ACPI_CA_DISASSEMBLER            0x00000800
    ACPI_COMPILER                   0x00001000
    ACPI_TOOLS                      0x00002000

debug_level
===========

"debug_level" — это маска, выбирающая различные типы сообщений, например, связанные
с инициализацией, выполнением методов, информационные сообщения и т.д.
Чтобы составить debug_level, посмотрите на уровень, указанный в выражении
ACPI_DEBUG_PRINT().

Интерпретатор ACPI использует несколько различных уровней, но ядро Linux ACPI
и драйверы ACPI обычно используют только ACPI_LV_INFO.

Вы можете задать маску debug_level на этапе загрузки с помощью аргумента командной
строки acpi.debug_level, а изменить её после загрузки можно, записывая значения
в /sys/module/acpi/parameters/debug_level.

Возможные уровни определены в include/acpi/acoutput.h. Чтение
/sys/module/acpi/parameters/debug_level показывает поддерживаемые значения маски,
в настоящее время такие::

    ACPI_LV_INIT                    0x00000001
    ACPI_LV_DEBUG_OBJECT            0x00000002
    ACPI_LV_INFO                    0x00000004
    ACPI_LV_INIT_NAMES              0x00000020
    ACPI_LV_PARSE                   0x00000040
    ACPI_LV_LOAD                    0x00000080
    ACPI_LV_DISPATCH                0x00000100
    ACPI_LV_EXEC                    0x00000200
    ACPI_LV_NAMES                   0x00000400
    ACPI_LV_OPREGION                0x00000800
    ACPI_LV_BFIELD                  0x00001000
    ACPI_LV_TABLES                  0x00002000
    ACPI_LV_VALUES                  0x00004000
    ACPI_LV_OBJECTS                 0x00008000
    ACPI_LV_RESOURCES               0x00010000
    ACPI_LV_USER_REQUESTS           0x00020000
    ACPI_LV_PACKAGE                 0x00040000
    ACPI_LV_ALLOCATIONS             0x00100000
    ACPI_LV_FUNCTIONS               0x00200000
    ACPI_LV_OPTIMIZATIONS           0x00400000
    ACPI_LV_MUTEX                   0x01000000
    ACPI_LV_THREADS                 0x02000000
    ACPI_LV_IO                      0x04000000
    ACPI_LV_INTERRUPTS              0x08000000
    ACPI_LV_AML_DISASSEMBLE         0x10000000
    ACPI_LV_VERBOSE_INFO            0x20000000
    ACPI_LV_FULL_TABLES             0x40000000
    ACPI_LV_EVENTS                  0x80000000

Примеры
=======

Например, drivers/acpi/acpica/evxfevnt.c содержит следующее::

    #define _COMPONENT          ACPI_EVENTS
    ...
    ACPI_DEBUG_PRINT((ACPI_DB_INIT, "ACPI mode disabled\n"));

Чтобы включить это сообщение, установите бит ACPI_EVENTS в acpi.debug_layer
и бит ACPI_LV_INIT в acpi.debug_level. (Выражение ACPI_DEBUG_PRINT
использует ACPI_DB_INIT, который является макросом, основанным на определении
ACPI_LV_INIT.)

Включить весь вывод AML "Debug" (запись в объект Debug при интерпретации
AML) во время загрузки::

    acpi.debug_layer=0xffffffff acpi.debug_level=0x2

Включить все сообщения ACPI, относящиеся к оборудованию::

    acpi.debug_layer=0x2 acpi.debug_level=0xffffffff

Включить все сообщения ACPI_DB_INFO после загрузки::

    # echo 0x4 > /sys/module/acpi/parameters/debug_level

Показать все допустимые значения компонентов::

    # cat /sys/module/acpi/parameters/debug_layer
