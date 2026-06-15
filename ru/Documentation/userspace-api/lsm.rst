.. SPDX-License-Identifier: GPL-2.0
.. Copyright (C) 2022 Casey Schaufler <casey@schaufler-ca.com>
.. Copyright (C) 2022 Intel Corporation

=====================================
Linux Security Modules
=====================================

:Author: Casey Schaufler
:Date: July 2023

Модули безопасности Linux (LSM) предоставляют механизм для реализации
дополнительных средств контроля доступа в дополнение к политикам безопасности Linux.

Различные модули безопасности могут поддерживать любой из этих атрибутов:

``LSM_ATTR_CURRENT`` — это текущий, активный контекст безопасности
процесса.
Файловая система proc предоставляет это значение в ``/proc/self/attr/current``.
Это поддерживается модулями безопасности SELinux, Smack и AppArmor.
Smack также предоставляет это значение в ``/proc/self/attr/smack/current``.
AppArmor также предоставляет это значение в ``/proc/self/attr/apparmor/current``.

``LSM_ATTR_EXEC`` — это контекст безопасности процесса на момент,
когда был выполнен текущий образ.
Файловая система proc предоставляет это значение в ``/proc/self/attr/exec``.
Это поддерживается модулями безопасности SELinux и AppArmor.
AppArmor также предоставляет это значение в ``/proc/self/attr/apparmor/exec``.

``LSM_ATTR_FSCREATE`` — это контекст безопасности процесса, используемый при
создании объектов файловой системы.
Файловая система proc предоставляет это значение в ``/proc/self/attr/fscreate``.
Это поддерживается модулем безопасности SELinux.

``LSM_ATTR_KEYCREATE`` — это контекст безопасности процесса, используемый при
создании объектов-ключей.
Файловая система proc предоставляет это значение в ``/proc/self/attr/keycreate``.
Это поддерживается модулем безопасности SELinux.

``LSM_ATTR_PREV`` — это контекст безопасности процесса на момент,
когда был установлен текущий контекст безопасности.
Файловая система proc предоставляет это значение в ``/proc/self/attr/prev``.
Это поддерживается модулями безопасности SELinux и AppArmor.
AppArmor также предоставляет это значение в ``/proc/self/attr/apparmor/prev``.

``LSM_ATTR_SOCKCREATE`` — это контекст безопасности процесса, используемый при
создании объектов-сокетов.
Файловая система proc предоставляет это значение в ``/proc/self/attr/sockcreate``.
Это поддерживается модулем безопасности SELinux.

Интерфейс ядра
==============

Установка атрибута безопасности текущего процесса
-------------------------------------------------

.. kernel-doc:: security/lsm_syscalls.c
    :identifiers: sys_lsm_set_self_attr

Получение заданных атрибутов безопасности текущего процесса
-----------------------------------------------------------

.. kernel-doc:: security/lsm_syscalls.c
    :identifiers: sys_lsm_get_self_attr

.. kernel-doc:: security/lsm_syscalls.c
    :identifiers: sys_lsm_list_modules

Дополнительная документация
===========================

* Documentation/security/lsm.rst
* Documentation/security/lsm-development.rst
