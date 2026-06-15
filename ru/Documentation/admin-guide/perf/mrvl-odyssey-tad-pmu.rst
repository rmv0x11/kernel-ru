=============================================================================
Модуль мониторинга производительности Marvell Odyssey LLC-TAD (PMU UNCORE)
=============================================================================

Каждый TAD предоставляет восемь 64-битных счётчиков для мониторинга
поведения кэша. Драйвер всегда настраивает один и тот же счётчик для
всех TAD. В результате пользователь фактически резервирует один из
восьми счётчиков в каждом TAD, чтобы наблюдать сразу за всеми TAD.
Возникновения событий агрегируются и предоставляются пользователю
по завершении выполнения рабочей нагрузки. Драйвер не предоставляет
способа разбиения TAD на разделы, чтобы разные TAD использовались для
разных приложений.

События производительности отражают различные внутренние или интерфейсные
активности. Комбинируя значения из нескольких счётчиков производительности,
производительность кэша можно измерять в таких терминах, как: частота
промахов кэша, выделения кэша, частота повторных попыток интерфейса,
занятость внутренних ресурсов и т.д.

Драйвер PMU предоставляет доступные события и параметры формата через sysfs::

        /sys/bus/event_source/devices/tad/events/
        /sys/bus/event_source/devices/tad/format/

Примеры::

   $ perf list | grep tad
        tad/tad_alloc_any/                                 [Kernel PMU event]
        tad/tad_alloc_dtg/                                 [Kernel PMU event]
        tad/tad_alloc_ltg/                                 [Kernel PMU event]
        tad/tad_hit_any/                                   [Kernel PMU event]
        tad/tad_hit_dtg/                                   [Kernel PMU event]
        tad/tad_hit_ltg/                                   [Kernel PMU event]
        tad/tad_req_msh_in_exlmn/                          [Kernel PMU event]
        tad/tad_tag_rd/                                    [Kernel PMU event]
        tad/tad_tot_cycle/                                 [Kernel PMU event]

   $ perf stat -e tad_alloc_dtg,tad_alloc_ltg,tad_alloc_any,tad_hit_dtg,tad_hit_ltg,tad_hit_any,tad_tag_rd <workload>
