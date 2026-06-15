.. SPDX-License-Identifier: GPL-2.0

==========================================
Обновление таблиц ACPI с помощью initrd
==========================================

О чём это
=========

Если параметр компиляции ACPI_TABLE_UPGRADE имеет значение true, появляется
возможность обновлять среду исполнения ACPI, заданную таблицами ACPI, путём
замены таблиц ACPI, предоставляемых BIOS, на инструментированную,
модифицированную, более свежую версию, либо устанавливать совершенно новые
таблицы ACPI.

При сборке initrd и ядра в едином образе для работы этой возможности параметр
ACPI_TABLE_OVERRIDE_VIA_BUILTIN_INITRD также должен иметь значение true.

Полный список таблиц ACPI, которые можно обновить или установить, смотрите в
определении char `*table_sigs[MAX_ACPI_SIGNATURE];` в файле
drivers/acpi/tables.c.

Все таблицы ACPI, известные iasl (компилятору и дизассемблеру ACPI от Intel),
должны поддаваться переопределению, за исключением:

  - ACPI_SIG_RSDP (имеет сигнатуру длиной 6 байт)
  - ACPI_SIG_FACS (не имеет обычного заголовка таблицы ACPI)

Оба варианта тоже можно было бы реализовать.


Для чего это нужно
==================

Жалуйтесь поставщику вашей платформы или BIOS, если вы обнаружили настолько
серьёзную ошибку, что обходной путь не принимается в ядро Linux. А этот механизм
позволяет вам обновить ошибочные таблицы до того, как поставщик вашей платформы
или BIOS выпустит обновлённый двоичный образ BIOS.

Этот механизм может использоваться поставщиками платформ или BIOS для
предоставления совместимой с Linux среды без изменения базовой прошивки
платформы (firmware).

Этот механизм также предоставляет мощное средство для лёгкой отладки и проверки
совместимости таблиц ACPI BIOS с ядром Linux путём модификации старых таблиц
ACPI, предоставляемых платформой, или вставки новых таблиц ACPI.

Его можно и нужно включать в любом ядре, поскольку при неинструментированных
initrd функциональных изменений не происходит.


Как это работает
================
::

  # Extract the machine's ACPI tables:
  cd /tmp
  acpidump >acpidump
  acpixtract -a acpidump
  # Disassemble, modify and recompile them:
  iasl -d *.dat
  # For example add this statement into a _PRT (PCI Routing Table) function
  # of the DSDT:
  Store("HELLO WORLD", debug)
  # And increase the OEM Revision. For example, before modification:
  DefinitionBlock ("DSDT.aml", "DSDT", 2, "INTEL ", "TEMPLATE", 0x00000000)
  # After modification:
  DefinitionBlock ("DSDT.aml", "DSDT", 2, "INTEL ", "TEMPLATE", 0x00000001)
  iasl -sa dsdt.dsl
  # Add the raw ACPI tables to an uncompressed cpio archive.
  # They must be put into a /kernel/firmware/acpi directory inside the cpio
  # archive. Note that if the table put here matches a platform table
  # (similar Table Signature, and similar OEMID, and similar OEM Table ID)
  # with a more recent OEM Revision, the platform table will be upgraded by
  # this table. If the table put here doesn't match a platform table
  # (dissimilar Table Signature, or dissimilar OEMID, or dissimilar OEM Table
  # ID), this table will be appended.
  mkdir -p kernel/firmware/acpi
  cp dsdt.aml kernel/firmware/acpi
  # A maximum of "NR_ACPI_INITRD_TABLES (64)" tables are currently allowed
  # (see osl.c):
  iasl -sa facp.dsl
  iasl -sa ssdt1.dsl
  cp facp.aml kernel/firmware/acpi
  cp ssdt1.aml kernel/firmware/acpi
  # The uncompressed cpio archive must be the first. Other, typically
  # compressed cpio archives, must be concatenated on top of the uncompressed
  # one. Following command creates the uncompressed cpio archive and
  # concatenates the original initrd on top:
  find kernel | cpio -H newc --create > /boot/instrumented_initrd
  cat /boot/initrd >>/boot/instrumented_initrd
  # reboot with increased acpi debug level, e.g. boot params:
  acpi.debug_level=0x2 acpi.debug_layer=0xFFFFFFFF
  # and check your syslog:
  [    1.268089] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
  [    1.272091] [ACPI Debug]  String [0x0B] "HELLO WORLD"

iasl способен дизассемблировать и перекомпилировать довольно много различных,
в том числе статических таблиц ACPI.


Где взять утилиты пространства пользователя
===========================================

iasl и acpixtract являются частью проекта ACPICA от Intel:
https://acpica.org/

и должны поставляться дистрибутивами (например, в пакете acpica
в SUSE).

acpidump можно найти в pmtools Лена Брауна (Len Brown):
ftp://kernel.org/pub/linux/kernel/people/lenb/acpi/utils/pmtools/acpidump

Эта утилита также входит в состав пакета acpica в SUSE.
Кроме того, в свежих версиях ядра используемые таблицы ACPI можно получить через sysfs:
/sys/firmware/acpi/tables
