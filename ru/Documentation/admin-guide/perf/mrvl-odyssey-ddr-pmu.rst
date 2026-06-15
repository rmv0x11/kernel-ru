============================================================================
Блок мониторинга производительности Marvell Odyssey DDR PMU (PMU UNCORE)
============================================================================

Подсистема DRAM в Odyssey поддерживает восемь счётчиков для мониторинга
производительности, и программное обеспечение может программировать эти счётчики
для мониторинга любого из определённых событий производительности. Поддерживаемые
события производительности включают те, что подсчитываются на интерфейсе между
контроллером DDR и PHY, на интерфейсе между контроллером DDR и интерконнектом CHI
или внутри самого контроллера DDR.

Дополнительно DSS также поддерживает два счётчика событий производительности с
фиксированным назначением: один для операций чтения DDR, другой для операций
записи DDR.

Счётчик работает либо в ручном (manual), либо в автоматическом (auto) режиме.

Драйвер PMU предоставляет доступные события и параметры формата через sysfs::

        /sys/bus/event_source/devices/mrvl_ddr_pmu_<>/events/
        /sys/bus/event_source/devices/mrvl_ddr_pmu_<>/format/

Примеры::

        $ perf list | grep ddr
        mrvl_ddr_pmu_<>/ddr_act_bypass_access/   [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_bsm_alloc/           [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_bsm_starvation/      [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_cam_active_access/   [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_cam_mwr/             [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_cam_rd_active_access/ [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_cam_rd_or_wr_access/ [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_cam_read/            [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_cam_wr_access/       [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_cam_write/           [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_capar_error/         [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_crit_ref/            [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_ddr_reads/           [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_ddr_writes/          [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_dfi_cmd_is_retry/    [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_dfi_cycles/          [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_dfi_parity_poison/   [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_dfi_rd_data_access/  [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_dfi_wr_data_access/  [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_dqsosc_mpc/          [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_dqsosc_mrr/          [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_enter_mpsm/          [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_enter_powerdown/     [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_enter_selfref/       [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_hif_pri_rdaccess/    [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_hif_rd_access/       [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_hif_rd_or_wr_access/ [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_hif_rmw_access/      [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_hif_wr_access/       [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_hpri_sched_rd_crit_access/ [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_load_mode/           [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_lpri_sched_rd_crit_access/ [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_precharge/           [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_precharge_for_other/ [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_precharge_for_rdwr/  [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_raw_hazard/          [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_rd_bypass_access/    [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_rd_crc_error/        [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_rd_uc_ecc_error/     [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_rdwr_transitions/    [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_refresh/             [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_retry_fifo_full/     [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_spec_ref/            [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_tcr_mrr/             [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_war_hazard/          [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_waw_hazard/          [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_win_limit_reached_rd/ [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_win_limit_reached_wr/ [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_wr_crc_error/        [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_wr_trxn_crit_access/ [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_write_combine/       [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_zqcl/                [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_zqlatch/             [Kernel PMU event]
        mrvl_ddr_pmu_<>/ddr_zqstart/             [Kernel PMU event]

        $ perf stat -e ddr_cam_read,ddr_cam_write,ddr_cam_active_access,ddr_cam
          rd_or_wr_access,ddr_cam_rd_active_access,ddr_cam_mwr <workload>
