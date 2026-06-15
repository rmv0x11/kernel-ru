=============================================================
Модуль мониторинга производительности (PMU) StarFive StarLink
=============================================================

Модуль мониторинга производительности (PMU) StarFive StarLink находится
в составе StarLink Coherent Network on Chip (CNoC), который соединяет
несколько кластеров CPU с системой памяти L3.

Этот uncore PMU поддерживает прерывание по переполнению, до 16
программируемых 64-битных счётчиков событий и независимый 64-битный
счётчик циклов.
Доступ к PMU возможен только через Memory Mapped I/O, и он является общим
для ядер, подключённых к одному и тому же PMU.

Драйвер предоставляет поддерживаемые события PMU в директории "events"
в sysfs по пути::

  /sys/bus/event_source/devices/starfive_starlink_pmu/events/

Драйвер предоставляет cpu, используемый для обработки событий PMU, в
директории "cpumask" в sysfs по пути::

  /sys/bus/event_source/devices/starfive_starlink_pmu/cpumask/

Драйвер описывает формат config (идентификатор события) в директории
"format" в sysfs по пути::

  /sys/bus/event_source/devices/starfive_starlink_pmu/format/

Пример использования perf::

	$ perf list

	starfive_starlink_pmu/cycles/                      [Kernel PMU event]
	starfive_starlink_pmu/read_hit/                    [Kernel PMU event]
	starfive_starlink_pmu/read_miss/                   [Kernel PMU event]
	starfive_starlink_pmu/read_request/                [Kernel PMU event]
	starfive_starlink_pmu/release_request/             [Kernel PMU event]
	starfive_starlink_pmu/write_hit/                   [Kernel PMU event]
	starfive_starlink_pmu/write_miss/                  [Kernel PMU event]
	starfive_starlink_pmu/write_request/               [Kernel PMU event]
	starfive_starlink_pmu/writeback/                   [Kernel PMU event]


	$ perf stat -a -e /starfive_starlink_pmu/cycles/ sleep 1

Сэмплирование не поддерживается. Как следствие, "perf record" не
поддерживается.
Присоединение к задаче не поддерживается, поддерживается только
общесистемный подсчёт.
