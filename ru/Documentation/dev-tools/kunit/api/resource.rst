.. SPDX-License-Identifier: GPL-2.0

============
Resource API
============

В этом файле описан API ресурсов KUnit.

Большинству пользователей не потребуется использовать этот API напрямую,
а опытные пользователи могут применять его для хранения состояния в рамках
отдельного теста, регистрации пользовательских действий очистки и не только.

.. kernel-doc:: include/kunit/resource.h
   :internal:

Managed Devices
---------------

Функции для использования struct device и struct device_driver, управляемых
KUnit. Подключите ``kunit/device.h``, чтобы использовать их.

.. kernel-doc:: include/kunit/device.h
   :internal:
