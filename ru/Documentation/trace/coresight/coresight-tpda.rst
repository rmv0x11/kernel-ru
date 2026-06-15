.. SPDX-License-Identifier: GPL-2.0

==================================================================================================================================
Агрегатор мониторинга производительности и диагностики трассировки (TPDA, trace performance monitoring and diagnostics aggregator)
==================================================================================================================================

    :Author:   Jinlong Mao <quic_jinlmao@quicinc.com>
    :Date:     January 2023

Описание оборудования
---------------------

TPDA — агрегатор мониторинга производительности и диагностики трассировки
(trace performance monitoring and diagnostics aggregator), или сокращённо
TPDA, выступает в роли движка арбитража и пакетизации для спецификации сети
мониторинга производительности и диагностики.
Основной сценарий использования TPDA — обеспечение пакетизации, объединения
(funneling) и проставления временных меток для данных Monitor.


Файлы и каталоги Sysfs
----------------------
Корень: ``/sys/bus/coresight/devices/tpda<N>``

Детали конфигурации
-------------------

Узлы tpdm и tpda следует наблюдать по пути coresight
"/sys/bus/coresight/devices".
например,
/sys/bus/coresight/devices # ls -l | grep tpd
tpda0 -> ../../../devices/platform/soc@0/6004000.tpda/tpda0
tpdm0 -> ../../../devices/platform/soc@0/6c08000.mm.tpdm/tpdm0

Для проверки TPDM можно использовать команды, аналогичные приведённым ниже.
Сначала включите приёмник (sink) coresight. Порт tpda, который подключён к
tpdm, будет включён после команд ниже.

echo 1 > /sys/bus/coresight/devices/tmc_etf0/enable_sink
echo 1 > /sys/bus/coresight/devices/tpdm0/enable_source
echo 1 > /sys/bus/coresight/devices/tpdm0/integration_test
echo 2 > /sys/bus/coresight/devices/tpdm0/integration_test

Тестовые данные будут собраны во включённом приёмнике coresight.
Если регистр rwp приёмника постоянно обновляется при выполнении
integration_test (через cat tmc_etf0/mgmt/rwp), это означает, что данные
поступают от TPDM к приёмнику.

Между tpdm и приёмником обязательно должен находиться tpda. Когда в одном
аппаратном блоке (HW block) с tpdm присутствуют другие аппаратные компоненты
событий трассировки, tpdm и эти аппаратные компоненты подключаются к
объединителю (funnel) coresight. Когда в аппаратном блоке присутствует только
аппаратура трассировки tpdm, tpdm подключается к tpda напрямую.
