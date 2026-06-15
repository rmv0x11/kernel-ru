=========================================================================
Uncore-блок мониторинга производительности (PMU) NVIDIA Tegra SoC
=========================================================================

NVIDIA Tegra SoC включает различные системные PMU для измерения ключевых
метрик производительности, таких как пропускная способность памяти, задержка
и утилизация:

* Scalable Coherency Fabric (SCF)
* NVLink-C2C0
* NVLink-C2C1
* CNVLink
* PCIE

Драйвер PMU
-----------

PMU, описанные в этом документе, основаны на архитектуре ARM CoreSight PMU,
как описано в документе: ARM IHI 0091. Поскольку это стандартная архитектура,
PMU управляются общим драйвером "arm-cs-arch-pmu". Этот драйвер описывает
доступные события и конфигурацию каждого PMU в sysfs. Чтобы получить путь sysfs
каждого PMU, см. разделы ниже. Как и другие драйверы uncore PMU, этот драйвер
предоставляет атрибут sysfs "cpumask" для отображения id CPU, используемого
для обработки события PMU. Также есть атрибут sysfs "associated_cpus", который
содержит список CPU, ассоциированных с экземпляром PMU.

.. _SCF_PMU_Section:

SCF PMU
-------

SCF PMU отслеживает события системного кэша, трафик CPU и трафик
строго упорядоченных (SO) записей PCIE в локальную/удалённую память. Подробнее
об охвате трафика этим PMU см.
:ref:`NVIDIA_Uncore_PMU_Traffic_Coverage_Section`.

События и параметры конфигурации этого устройства PMU описаны в sysfs,
см. /sys/bus/event_source/devices/nvidia_scf_pmu_<socket-id>.

Пример использования:

* Подсчёт события с id 0x0 в сокете 0::

   perf stat -a -e nvidia_scf_pmu_0/event=0x0/

* Подсчёт события с id 0x0 в сокете 1::

   perf stat -a -e nvidia_scf_pmu_1/event=0x0/

NVLink-C2C0 PMU
--------------------

NVLink-C2C0 PMU отслеживает входящий трафик от GPU/CPU, подключённого через
интерконнект NVLink-C2C (Chip-2-Chip). Тип трафика, перехватываемого этим PMU,
зависит от конфигурации чипа:

* NVIDIA Grace Hopper Superchip: GPU Hopper подключён к Grace SoC.

  В этой конфигурации PMU перехватывает от GPU трафик, транслированный через
  GPU ATS, либо трафик EGM.

* NVIDIA Grace CPU Superchip: соединены два Grace CPU SoC.

  В этой конфигурации PMU перехватывает чтения и слабо упорядоченные (RO)
  записи от устройства PCIE удалённого SoC.

Подробнее об охвате трафика этим PMU см.
:ref:`NVIDIA_Uncore_PMU_Traffic_Coverage_Section`.

События и параметры конфигурации этого устройства PMU описаны в sysfs,
см. /sys/bus/event_source/devices/nvidia_nvlink_c2c0_pmu_<socket-id>.

Пример использования:

* Подсчёт события с id 0x0 от GPU/CPU, подключённого к сокету 0::

   perf stat -a -e nvidia_nvlink_c2c0_pmu_0/event=0x0/

* Подсчёт события с id 0x0 от GPU/CPU, подключённого к сокету 1::

   perf stat -a -e nvidia_nvlink_c2c0_pmu_1/event=0x0/

* Подсчёт события с id 0x0 от GPU/CPU, подключённого к сокету 2::

   perf stat -a -e nvidia_nvlink_c2c0_pmu_2/event=0x0/

* Подсчёт события с id 0x0 от GPU/CPU, подключённого к сокету 3::

   perf stat -a -e nvidia_nvlink_c2c0_pmu_3/event=0x0/

NVLink-C2C имеет два порта, которые могут быть подключены к одному GPU
(занимая оба порта) или к двум GPU (по одному GPU на порт). Пользователь может
использовать битовый параметр "port" для выбора порта(ов) для мониторинга.
Каждый бит представляет номер порта, например "port=0x1" соответствует порту 0,
а "port=0x3" — портам 0 и 1. По умолчанию, если не указано иное, PMU
отслеживает оба порта.

Пример фильтрации по портам:

* Подсчёт события с id 0x0 от GPU, подключённого к сокету 0, на порту 0::

   perf stat -a -e nvidia_nvlink_c2c0_pmu_0/event=0x0,port=0x1/

* Подсчёт события с id 0x0 от GPU, подключённых к сокету 0, на портах 0 и 1::

   perf stat -a -e nvidia_nvlink_c2c0_pmu_0/event=0x0,port=0x3/

NVLink-C2C1 PMU
-------------------

NVLink-C2C1 PMU отслеживает входящий трафик от GPU, подключённого через
интерконнект NVLink-C2C (Chip-2-Chip). Этот PMU перехватывает нетранслированный
трафик GPU, в отличие от NvLink-C2C0 PMU, который перехватывает трафик,
транслированный через ATS. Подробнее об охвате трафика этим PMU см.
:ref:`NVIDIA_Uncore_PMU_Traffic_Coverage_Section`.

События и параметры конфигурации этого устройства PMU описаны в sysfs,
см. /sys/bus/event_source/devices/nvidia_nvlink_c2c1_pmu_<socket-id>.

Пример использования:

* Подсчёт события с id 0x0 от GPU, подключённого к сокету 0::

   perf stat -a -e nvidia_nvlink_c2c1_pmu_0/event=0x0/

* Подсчёт события с id 0x0 от GPU, подключённого к сокету 1::

   perf stat -a -e nvidia_nvlink_c2c1_pmu_1/event=0x0/

* Подсчёт события с id 0x0 от GPU, подключённого к сокету 2::

   perf stat -a -e nvidia_nvlink_c2c1_pmu_2/event=0x0/

* Подсчёт события с id 0x0 от GPU, подключённого к сокету 3::

   perf stat -a -e nvidia_nvlink_c2c1_pmu_3/event=0x0/

NVLink-C2C имеет два порта, которые могут быть подключены к одному GPU
(занимая оба порта) или к двум GPU (по одному GPU на порт). Пользователь может
использовать битовый параметр "port" для выбора порта(ов) для мониторинга.
Каждый бит представляет номер порта, например "port=0x1" соответствует порту 0,
а "port=0x3" — портам 0 и 1. По умолчанию, если не указано иное, PMU
отслеживает оба порта.

Пример фильтрации по портам:

* Подсчёт события с id 0x0 от GPU, подключённого к сокету 0, на порту 0::

   perf stat -a -e nvidia_nvlink_c2c1_pmu_0/event=0x0,port=0x1/

* Подсчёт события с id 0x0 от GPU, подключённых к сокету 0, на портах 0 и 1::

   perf stat -a -e nvidia_nvlink_c2c1_pmu_0/event=0x0,port=0x3/

CNVLink PMU
---------------

CNVLink PMU отслеживает трафик от GPU и устройства PCIE на удалённых сокетах
в локальную память. Для трафика PCIE этот PMU перехватывает трафик чтений и
слабо упорядоченных (RO) записей. Подробнее об охвате трафика этим PMU см.
:ref:`NVIDIA_Uncore_PMU_Traffic_Coverage_Section`.

События и параметры конфигурации этого устройства PMU описаны в sysfs,
см. /sys/bus/event_source/devices/nvidia_cnvlink_pmu_<socket-id>.

Каждый сокет SoC может быть подключён к одному или нескольким сокетам через
CNVLink. Пользователь может использовать битовый параметр "rem_socket" для
выбора удалённого сокета(ов) для мониторинга. Каждый бит представляет номер
сокета, например "rem_socket=0xE" соответствует сокетам с 1 по 3. По умолчанию,
если не указано иное, PMU отслеживает все удалённые сокеты.
/sys/bus/event_source/devices/nvidia_cnvlink_pmu_<socket-id>/format/rem_socket
показывает допустимые биты, которые могут быть установлены в параметре
"rem_socket".

PMU не может различить инициатора удалённого трафика, поэтому не предоставляет
фильтр для выбора отслеживаемого источника трафика. Он сообщает совокупный
трафик от удалённых GPU и устройств PCIE.

Пример использования:

* Подсчёт события с id 0x0 для трафика от удалённых сокетов 1, 2 и 3 к сокету 0::

   perf stat -a -e nvidia_cnvlink_pmu_0/event=0x0,rem_socket=0xE/

* Подсчёт события с id 0x0 для трафика от удалённых сокетов 0, 2 и 3 к сокету 1::

   perf stat -a -e nvidia_cnvlink_pmu_1/event=0x0,rem_socket=0xD/

* Подсчёт события с id 0x0 для трафика от удалённых сокетов 0, 1 и 3 к сокету 2::

   perf stat -a -e nvidia_cnvlink_pmu_2/event=0x0,rem_socket=0xB/

* Подсчёт события с id 0x0 для трафика от удалённых сокетов 0, 1 и 2 к сокету 3::

   perf stat -a -e nvidia_cnvlink_pmu_3/event=0x0,rem_socket=0x7/


PCIE PMU
------------

PCIE PMU отслеживает весь трафик чтений/записей от корневых портов PCIE в
локальную/удалённую память. Подробнее об охвате трафика этим PMU см.
:ref:`NVIDIA_Uncore_PMU_Traffic_Coverage_Section`.

События и параметры конфигурации этого устройства PMU описаны в sysfs,
см. /sys/bus/event_source/devices/nvidia_pcie_pmu_<socket-id>.

Каждый сокет SoC может поддерживать несколько корневых портов. Пользователь
может использовать битовый параметр "root_port" для выбора порта(ов) для
мониторинга, то есть "root_port=0xF" соответствует корневым портам с 0 по 3.
По умолчанию, если не указано иное, PMU отслеживает все корневые порты.
/sys/bus/event_source/devices/nvidia_pcie_pmu_<socket-id>/format/root_port
показывает допустимые биты, которые могут быть установлены в параметре
"root_port".

Пример использования:

* Подсчёт события с id 0x0 от корневых портов 0 и 1 сокета 0::

   perf stat -a -e nvidia_pcie_pmu_0/event=0x0,root_port=0x3/

* Подсчёт события с id 0x0 от корневых портов 0 и 1 сокета 1::

   perf stat -a -e nvidia_pcie_pmu_1/event=0x0,root_port=0x3/

.. _NVIDIA_Uncore_PMU_Traffic_Coverage_Section:

Охват трафика
-------------

Охват трафика PMU может варьироваться в зависимости от конфигурации чипа:

* **NVIDIA Grace Hopper Superchip**: GPU Hopper подключён к Grace SoC.

  Пример конфигурации с двумя Grace SoC::

   *********************************          *********************************
   * SOCKET-A                      *          * SOCKET-B                      *
   *                               *          *                               *
   *                     ::::::::  *          *  ::::::::                     *
   *                     : PCIE :  *          *  : PCIE :                     *
   *                     ::::::::  *          *  ::::::::                     *
   *                         |     *          *      |                        *
   *                         |     *          *      |                        *
   *  :::::::            ::::::::: *          *  :::::::::            ::::::: *
   *  :     :            :       : *          *  :       :            :     : *
   *  : GPU :<--NVLink-->: Grace :<---CNVLink--->: Grace :<--NVLink-->: GPU : *
   *  :     :    C2C     :  SoC  : *          *  :  SoC  :    C2C     :     : *
   *  :::::::            ::::::::: *          *  :::::::::            ::::::: *
   *     |                   |     *          *      |                   |    *
   *     |                   |     *          *      |                   |    *
   *  &&&&&&&&           &&&&&&&&  *          *   &&&&&&&&           &&&&&&&& *
   *  & GMEM &           & CMEM &  *          *   & CMEM &           & GMEM & *
   *  &&&&&&&&           &&&&&&&&  *          *   &&&&&&&&           &&&&&&&& *
   *                               *          *                               *
   *********************************          *********************************

   GMEM = GPU Memory (e.g. HBM)
   CMEM = CPU Memory (e.g. LPDDR5X)

  |
  | Следующая таблица содержит охват трафика PMU Grace SoC в socket-A:

  ::

   +--------------+-------+-----------+-----------+-----+----------+----------+
   |              |                        Source                             |
   +              +-------+-----------+-----------+-----+----------+----------+
   | Destination  |       |GPU ATS    |GPU Not-ATS|     | Socket-B | Socket-B |
   |              |PCI R/W|Translated,|Translated | CPU | CPU/PCIE1| GPU/PCIE2|
   |              |       |EGM        |           |     |          |          |
   +==============+=======+===========+===========+=====+==========+==========+
   | Local        | PCIE  |NVLink-C2C0|NVLink-C2C1| SCF | SCF PMU  | CNVLink  |
   | SYSRAM/CMEM  | PMU   |PMU        |PMU        | PMU |          | PMU      |
   +--------------+-------+-----------+-----------+-----+----------+----------+
   | Local GMEM   | PCIE  |    N/A    |NVLink-C2C1| SCF | SCF PMU  | CNVLink  |
   |              | PMU   |           |PMU        | PMU |          | PMU      |
   +--------------+-------+-----------+-----------+-----+----------+----------+
   | Remote       | PCIE  |NVLink-C2C0|NVLink-C2C1| SCF |          |          |
   | SYSRAM/CMEM  | PMU   |PMU        |PMU        | PMU |   N/A    |   N/A    |
   | over CNVLink |       |           |           |     |          |          |
   +--------------+-------+-----------+-----------+-----+----------+----------+
   | Remote GMEM  | PCIE  |NVLink-C2C0|NVLink-C2C1| SCF |          |          |
   | over CNVLink | PMU   |PMU        |PMU        | PMU |   N/A    |   N/A    |
   +--------------+-------+-----------+-----------+-----+----------+----------+

   PCIE1 traffic represents strongly ordered (SO) writes.
   PCIE2 traffic represents reads and relaxed ordered (RO) writes.

* **NVIDIA Grace CPU Superchip**: соединены два Grace CPU SoC.

  Пример конфигурации с двумя Grace SoC::

   *******************             *******************
   * SOCKET-A        *             * SOCKET-B        *
   *                 *             *                 *
   *    ::::::::     *             *    ::::::::     *
   *    : PCIE :     *             *    : PCIE :     *
   *    ::::::::     *             *    ::::::::     *
   *        |        *             *        |        *
   *        |        *             *        |        *
   *    :::::::::    *             *    :::::::::    *
   *    :       :    *             *    :       :    *
   *    : Grace :<--------NVLink------->: Grace :    *
   *    :  SoC  :    *     C2C     *    :  SoC  :    *
   *    :::::::::    *             *    :::::::::    *
   *        |        *             *        |        *
   *        |        *             *        |        *
   *     &&&&&&&&    *             *     &&&&&&&&    *
   *     & CMEM &    *             *     & CMEM &    *
   *     &&&&&&&&    *             *     &&&&&&&&    *
   *                 *             *                 *
   *******************             *******************

   GMEM = GPU Memory (e.g. HBM)
   CMEM = CPU Memory (e.g. LPDDR5X)

  |
  | Следующая таблица содержит охват трафика PMU Grace SoC в socket-A:

  ::

   +-----------------+-----------+---------+----------+-------------+
   |                 |                      Source                  |
   +                 +-----------+---------+----------+-------------+
   | Destination     |           |         | Socket-B | Socket-B    |
   |                 |  PCI R/W  |   CPU   | CPU/PCIE1| PCIE2       |
   |                 |           |         |          |             |
   +=================+===========+=========+==========+=============+
   | Local           |  PCIE PMU | SCF PMU | SCF PMU  | NVLink-C2C0 |
   | SYSRAM/CMEM     |           |         |          | PMU         |
   +-----------------+-----------+---------+----------+-------------+
   | Remote          |           |         |          |             |
   | SYSRAM/CMEM     |  PCIE PMU | SCF PMU |   N/A    |     N/A     |
   | over NVLink-C2C |           |         |          |             |
   +-----------------+-----------+---------+----------+-------------+

   PCIE1 traffic represents strongly ordered (SO) writes.
   PCIE2 traffic represents reads and relaxed ordered (RO) writes.
