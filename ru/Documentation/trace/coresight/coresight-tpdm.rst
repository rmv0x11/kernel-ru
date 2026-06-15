.. SPDX-License-Identifier: GPL-2.0

==========================================================
Trace performance monitoring and diagnostics monitor(TPDM)
==========================================================

    :Автор:    Jinlong Mao <quic_jinlmao@quicinc.com>
    :Дата:     Январь 2023

Описание аппаратного обеспечения
--------------------------------
TPDM — Trace performance monitoring and diagnostics monitor, или сокращённо
TPDM, выступает в роли компонента сбора данных для различных типов наборов
данных. Основной сценарий применения TPDM — сбор данных из различных
источников данных и их отправка в TPDA для пакетирования, проставления
временных меток и сведения через воронку (funneling).

Файлы и каталоги sysfs
----------------------
Корень: ``/sys/bus/coresight/devices/tpdm<N>``

----

:Файл:            ``enable_source`` (RW)
:Примечания:
    - > 0 : включить наборы данных TPDM.

    - = 0 : выключить наборы данных TPDM.

:Синтаксис:
    ``echo 1 > enable_source``

----

:Файл:            ``integration_test`` (wo)
:Примечания:
    Интеграционный тест сгенерирует тестовые данные для tpdm.

:Синтаксис:
    ``echo value > integration_test``

    value -  1 или 2.

----

.. This text is intentionally added to make Sphinx happy.
