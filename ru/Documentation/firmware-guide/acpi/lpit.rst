.. SPDX-License-Identifier: GPL-2.0

===========================
Low Power Idle Table (LPIT)
===========================

Для перечисления состояний Low Power Idle платформы на платформах Intel
используется «Low Power Idle Table» (LPIT). Более подробную информацию об
этой таблице можно загрузить по адресу:
https://www.uefi.org/sites/default/files/resources/Intel_ACPI_Low_Power_S0_Idle.pdf

Время пребывания (residency) для каждого состояния низкого энергопотребления
можно прочитать через FFH (Function fixed hardware) или через интерфейс,
отображённый в память (memory mapped).

На платформах, поддерживающих состояния сна S0ix, может существовать два
типа времени пребывания:

  - CPU PKG C10 (чтение через интерфейс FFH)
  - Platform Controller Hub (PCH) SLP_S0 (чтение через интерфейс, отображённый в память)

Следующие атрибуты добавляются динамически в группу sysfs-атрибутов
cpuidle::

  /sys/devices/system/cpu/cpuidle/low_power_idle_cpu_residency_us
  /sys/devices/system/cpu/cpuidle/low_power_idle_system_residency_us

Атрибут "low_power_idle_cpu_residency_us" показывает время, проведённое
пакетом CPU в состоянии PKG C10.

Атрибут "low_power_idle_system_residency_us" показывает время пребывания
в SLP_S0, то есть системное время, проведённое с активным сигналом SLP_S0#.
Это минимально возможное системное состояние энергопотребления, достигаемое
только когда CPU находится в PKG C10, а все функциональные блоки в PCH
находятся в состоянии низкого энергопотребления.
