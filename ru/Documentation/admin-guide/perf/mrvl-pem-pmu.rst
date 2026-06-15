============================================================================
Блок мониторинга производительности Marvell Odyssey PEM (PMU UNCORE)
============================================================================

С интерфейсными блоками PCI Express (PEM) связан соответствующий блок
мониторинга. В него входят счётчики производительности для отслеживания
различных характеристик данных, передаваемых по каналу PCIe.

Счётчики отслеживают входящие и исходящие транзакции, что включает отдельные
счётчики для posted/non-posted/completion TLP. Также можно отслеживать
входящие и исходящие запросы чтения памяти вместе с их задержками. Кроме того,
отслеживаются события Address Translation Services (ATS), такие как ATS
Translation, ATS Page Request, ATS Invalidation, вместе с соответствующими им
задержками.

Для измерения posted/non-posted/completion TLP во входящих и исходящих
транзакциях предусмотрены отдельные 64-битные счётчики. События ATS измеряются
разными счётчиками.

Драйвер PMU предоставляет доступные события и параметры формата через sysfs,
/sys/bus/event_source/devices/mrvl_pcie_rc_pmu_<>/events/
/sys/bus/event_source/devices/mrvl_pcie_rc_pmu_<>/format/

Примеры::

  # perf list | grep mrvl_pcie_rc_pmu
  mrvl_pcie_rc_pmu_<>/ats_inv/             [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ats_inv_latency/     [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ats_pri/             [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ats_pri_latency/     [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ats_trans/           [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ats_trans_latency/   [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ib_inflight/         [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ib_reads/            [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ib_req_no_ro_ebus/   [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ib_req_no_ro_ncb/    [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ib_tlp_cpl_partid/   [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ib_tlp_dwords_cpl_partid/ [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ib_tlp_dwords_npr/   [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ib_tlp_dwords_pr/    [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ib_tlp_npr/          [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ib_tlp_pr/           [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ob_inflight_partid/  [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ob_merges_cpl_partid/ [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ob_merges_npr_partid/ [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ob_merges_pr_partid/ [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ob_reads_partid/     [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ob_tlp_cpl_partid/   [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ob_tlp_dwords_cpl_partid/ [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ob_tlp_dwords_npr_partid/ [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ob_tlp_dwords_pr_partid/ [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ob_tlp_npr_partid/   [Kernel PMU event]
  mrvl_pcie_rc_pmu_<>/ob_tlp_pr_partid/    [Kernel PMU event]


  # perf stat -e ib_inflight,ib_reads,ib_req_no_ro_ebus,ib_req_no_ro_ncb <workload>
