.. SPDX-License-Identifier: GPL-2.0

=========================================================
Модуль мониторинга производительности CXL (CPMU)
=========================================================

Спецификация CXL версии 3.0 содержит определение модуля мониторинга
производительности CXL (Performance Monitoring Unit) в разделе 13.2: Performance
Monitoring.

Компоненты CXL (например, Root Port, Switch Upstream Port, End Point) могут иметь
любое число экземпляров CPMU. Возможности CPMU полностью доступны для обнаружения
из устройств. Спецификация содержит определения событий для всех типов
протокольных сообщений CXL, а также набор дополнительных событий для величин,
обычно подсчитываемых на устройствах CXL (например, событий DRAM).

Драйвер CPMU
============

Драйвер CPMU регистрирует perf PMU с именем pmu_mem<X>.<Y> на шине CXL,
представляющий Y-й CPMU для memX.

    /sys/bus/cxl/device/pmu_mem<X>.<Y>

Связанный PMU регистрируется как

   /sys/bus/event_sources/devices/cxl_pmu_mem<X>.<Y>

Как и у других устройств шины CXL, идентификатор не имеет какого-либо особого
смысла, и связь с конкретным устройством CXL должна устанавливаться через
родительское устройство данного устройства на шине CXL.

Драйвер PMU предоставляет в sysfs описание доступных событий и опций фильтрации.

Каталог "format" описывает все форматы полей config (event vendor id, group id и
mask), config1 (threshold, filter enables) и config2 (filter parameters)
структуры perf_event_attr.  Каталог "events" описывает все документированные
события, показываемые в perf list.

События, показываемые в perf list, — это наиболее детализированные события, в
которых установлен один бит маски события. Более общие события могут быть включены
установкой нескольких битов маски в config. Например, все Device to Host Read
Requests могут быть учтены одним счётчиком установкой битов для всех из

* d2h_req_rdcurr
* d2h_req_rdown
* d2h_req_rdshared
* d2h_req_rdany
* d2h_req_rdownnodata

Пример использования::

  $#perf list
  cxl_pmu_mem0.0/clock_ticks/                        [Kernel PMU event]
  cxl_pmu_mem0.0/d2h_req_rdshared/                   [Kernel PMU event]
  cxl_pmu_mem0.0/h2d_req_snpcur/                     [Kernel PMU event]
  cxl_pmu_mem0.0/h2d_req_snpdata/                    [Kernel PMU event]
  cxl_pmu_mem0.0/h2d_req_snpinv/                     [Kernel PMU event]
  -----------------------------------------------------------

  $# perf stat -a -e cxl_pmu_mem0.0/clock_ticks/ -e cxl_pmu_mem0.0/d2h_req_rdshared/

События, специфичные для производителя, также могут быть доступны и в этом случае
могут использоваться через

  $# perf stat -a -e cxl_pmu_mem0.0/vid=VID,gid=GID,mask=MASK/

Драйвер не поддерживает сэмплирование, поэтому "perf record" не поддерживается.
Он поддерживает только общесистемный подсчёт, поэтому привязка к задаче не
поддерживается.
