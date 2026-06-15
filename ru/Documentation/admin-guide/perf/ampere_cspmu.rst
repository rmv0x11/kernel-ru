.. SPDX-License-Identifier: GPL-2.0

=====================================================
Блок мониторинга производительности (PMU) Ampere SoC
=====================================================

Ampere SoC PMU — это универсальный PMU IP-блок, следующий архитектуре Arm
CoreSight PMU. Поэтому драйвер реализован как подмодуль драйвера arm_cspmu. На
первом этапе он используется для подсчёта событий MCU на AmpereOne.


События MCU PMU
---------------

Драйвер PMU поддерживает установку фильтров для «rank», «bank» и «threshold».
Обратите внимание, что фильтры задаются для экземпляра PMU, а не для отдельного
события.


Пример использования инструмента perf::

  / # perf list ampere

    ampere_mcu_pmu_0/act_sent/                         [Kernel PMU event]
    <...>
    ampere_mcu_pmu_1/rd_sent/                          [Kernel PMU event]
    <...>

  / # perf stat -a -e ampere_mcu_pmu_0/act_sent,bank=5,rank=3,threshold=2/,ampere_mcu_pmu_1/rd_sent/ \
        sleep 1
