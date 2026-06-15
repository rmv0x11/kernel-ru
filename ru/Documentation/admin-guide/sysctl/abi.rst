.. SPDX-License-Identifier: GPL-2.0+

==================================
Документация по /proc/sys/abi/
==================================

.. See scripts/check-sysctl-docs to keep this up to date:
.. scripts/check-sysctl-docs -vtable="abi" \
..         Documentation/admin-guide/sysctl/abi.rst \
..         $(git grep -l register_sysctl_)

Copyright (c) 2020, Stephen Kitt

Общие сведения см. в Documentation/admin-guide/sysctl/index.rst.

------------------------------------------------------------------------------

Файлы в ``/proc/sys/abi`` можно использовать для просмотра и изменения
настроек, связанных с ABI.

В настоящее время эти файлы могут (в зависимости от вашей конфигурации)
присутствовать в ``/proc/sys/kernel``:

.. contents:: :local:

vsyscall32 (x86)
================

Определяет, отображает ли ядро страницу vDSO в 32-битные процессы;
может быть установлен в 1 для включения или в 0 для отключения. По умолчанию
включено, если задан ``CONFIG_COMPAT_VDSO``, и отключено в противном случае.

Управляет той же настройкой, что и параметр загрузки ядра ``vdso32``.
