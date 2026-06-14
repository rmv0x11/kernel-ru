===========================
Привязка IRQ в SMP-системах
===========================

ChangeLog:
	- Started by Ingo Molnar <mingo@redhat.com>
	- Update by Max Krasnyansky <maxk@qualcomm.com>


/proc/irq/IRQ#/smp_affinity и /proc/irq/IRQ#/smp_affinity_list задают,
какие целевые CPU разрешены для данного источника IRQ.  Это битовая маска
(smp_affinity) или список CPU (smp_affinity_list) разрешённых CPU.  Запрещено
отключать все CPU, и если контроллер IRQ не поддерживает привязку IRQ,
то значение не изменится относительно значения по умолчанию — всех CPU.

/proc/irq/default_smp_affinity задаёт маску привязки по умолчанию, которая
применяется ко всем неактивным IRQ. Как только IRQ выделяется/активируется,
его битовая маска привязки устанавливается в маску по умолчанию. Затем её можно
изменить так, как описано выше. Маска по умолчанию равна 0xffffffff.

Ниже приведён пример ограничения IRQ44 (eth1) до CPU0-3, а затем ограничения
его до CPU4-7 (это 8-процессорная SMP-машина)::

	[root@moon 44]# cd /proc/irq/44
	[root@moon 44]# cat smp_affinity
	ffffffff

	[root@moon 44]# echo 0f > smp_affinity
	[root@moon 44]# cat smp_affinity
	0000000f
	[root@moon 44]# ping -f h
	PING hell (195.4.7.3): 56 data bytes
	...
	--- hell ping statistics ---
	6029 packets transmitted, 6027 packets received, 0% packet loss
	round-trip min/avg/max = 0.1/0.1/0.4 ms
	[root@moon 44]# cat /proc/interrupts | grep 'CPU\|44:'
		CPU0       CPU1       CPU2       CPU3      CPU4       CPU5        CPU6       CPU7
	44:       1068       1785       1785       1783         0          0           0         0    IO-APIC-level  eth1

Как видно из строки выше, IRQ44 доставлялось только первым четырём
процессорам (0-3).
Теперь давайте ограничим этот IRQ до CPU(4-7).

::

	[root@moon 44]# echo f0 > smp_affinity
	[root@moon 44]# cat smp_affinity
	000000f0
	[root@moon 44]# ping -f h
	PING hell (195.4.7.3): 56 data bytes
	..
	--- hell ping statistics ---
	2779 packets transmitted, 2777 packets received, 0% packet loss
	round-trip min/avg/max = 0.1/0.5/585.4 ms
	[root@moon 44]# cat /proc/interrupts |  'CPU\|44:'
		CPU0       CPU1       CPU2       CPU3      CPU4       CPU5        CPU6       CPU7
	44:       1068       1785       1785       1783      1784       1069        1070       1069   IO-APIC-level  eth1

На этот раз IRQ44 доставлялось только последним четырём процессорам.
То есть счётчики для CPU0-3 не изменились.

Ниже приведён пример ограничения того же IRQ (44) до CPU с 1024 по 1031::

	[root@moon 44]# echo 1024-1031 > smp_affinity_list
	[root@moon 44]# cat smp_affinity_list
	1024-1031

Обратите внимание, что для выполнения этого с помощью битовой маски потребовалось бы
32 нулевых битовых маски, следующих за соответствующей.
