==========================================================
Как информация о топологии CPU экспортируется через sysfs
==========================================================

Информация о топологии CPU экспортируется через sysfs. Элементы (атрибуты)
схожи с выводом /proc/cpuinfo на некоторых архитектурах. Они располагаются в
/sys/devices/system/cpu/cpuX/topology/. Обратитесь к файлу ABI:
Documentation/ABI/stable/sysfs-devices-system-cpu.

Архитектурно-нейтральный drivers/base/topology.c экспортирует эти атрибуты.
Однако sysfs-файлы, связанные с иерархией die, cluster, book и drawer, будут
создаваться, только если архитектура предоставляет соответствующие макросы,
описанные ниже.

Чтобы архитектура поддерживала эту возможность, она должна определить некоторые
из этих макросов в include/asm-XXX/topology.h::

	#define topology_physical_package_id(cpu)
	#define topology_die_id(cpu)
	#define topology_cluster_id(cpu)
	#define topology_core_id(cpu)
	#define topology_book_id(cpu)
	#define topology_drawer_id(cpu)
	#define topology_sibling_cpumask(cpu)
	#define topology_core_cpumask(cpu)
	#define topology_cluster_cpumask(cpu)
	#define topology_die_cpumask(cpu)
	#define topology_book_cpumask(cpu)
	#define topology_drawer_cpumask(cpu)

Тип ``**_id macros`` — int.
Тип ``**_cpumask macros`` — ``(const) struct cpumask *``. Последние
соответствуют подходящим sysfs-атрибутам ``**_siblings`` (за исключением
topology_sibling_cpumask(), который соответствует thread_siblings).

Чтобы обеспечить согласованность на всех архитектурах, include/linux/topology.h
предоставляет определения по умолчанию для любого из перечисленных выше макросов,
которые не определены в include/asm-XXX/topology.h:

1) topology_physical_package_id: -1
2) topology_die_id: -1
3) topology_cluster_id: -1
4) topology_core_id: 0
5) topology_book_id: -1
6) topology_drawer_id: -1
7) topology_sibling_cpumask: только данный CPU
8) topology_core_cpumask: только данный CPU
9) topology_cluster_cpumask: только данный CPU
10) topology_die_cpumask: только данный CPU
11) topology_book_cpumask:  только данный CPU
12) topology_drawer_cpumask: только данный CPU

Кроме того, информация о топологии CPU предоставляется в
/sys/devices/system/cpu и включает следующие файлы.  Внутренний
источник для вывода указан в скобках ("[]").

    =========== ==========================================================
    kernel_max: максимальный индекс CPU, разрешённый конфигурацией ядра.
		[NR_CPUS-1]

    offline:	CPU, которые не находятся в режиме online, потому что были
		отключены через HOTPLUG или превышают предел числа CPU,
		разрешённый конфигурацией ядра (kernel_max выше).
		[~cpu_online_mask + cpus >= NR_CPUS]

    online:	CPU, которые находятся в режиме online и которым выделяется
		время планировщиком [cpu_online_mask]

    possible:	CPU, которым выделены ресурсы и которые могут быть
		переведены в режим online, если они присутствуют. [cpu_possible_mask]

    present:	CPU, которые были опознаны как присутствующие в
		системе. [cpu_present_mask]
    =========== ==========================================================

Формат приведённого выше вывода совместим с cpulist_parse()
[см. <linux/cpumask.h>].  Далее следуют несколько примеров.

В этом примере в системе 64 CPU, но cpus 32-63 превышают
максимум ядра, который ограничен диапазоном 0..31, так как параметр
конфигурации NR_CPUS равен 32.  Обратите также внимание, что CPU 2 и 4-31 не
находятся в режиме online, но могут быть переведены в него, так как они
одновременно present и possible::

     kernel_max: 31
        offline: 2,4-31,32-63
         online: 0-1,3
       possible: 0-31
        present: 0-31

В этом примере параметр конфигурации NR_CPUS равен 128, но ядро было
запущено с possible_cpus=144.  В системе 4 CPU, и cpu2
был вручную переведён в режим offline (и является единственным CPU, который
можно перевести в режим online.)::

     kernel_max: 127
        offline: 2,4-127,128-143
         online: 0-1,3
       possible: 0-127
        present: 0-3

См. Documentation/core-api/cpu_hotplug.rst для информации о параметре запуска
ядра possible_cpus=NUM, а также для более подробных сведений о различных cpumask.
