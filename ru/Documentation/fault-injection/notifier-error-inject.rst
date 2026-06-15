Внедрение ошибок в notifier
===========================

Внедрение ошибок в notifier предоставляет возможность вносить искусственные ошибки в
callback-функции указанных цепочек notifier. Это полезно для тестирования обработки ошибок
при сбоях вызова цепочки notifier, которая выполняется редко. Существуют модули ядра,
которые можно использовать для тестирования следующих notifier.

 * PM notifier
 * Memory hotplug notifier
 * powerpc pSeries reconfig notifier
 * Netdevice notifier

Модуль внедрения ошибок в PM notifier
-------------------------------------
Эта функциональность управляется через интерфейс debugfs

  /sys/kernel/debug/notifier-error-inject/pm/actions/<notifier event>/error

Возможные события PM notifier, в которых можно вызвать сбой:

 * PM_HIBERNATION_PREPARE
 * PM_SUSPEND_PREPARE
 * PM_RESTORE_PREPARE

Пример: внедрение ошибки приостановки PM (-12 = -ENOMEM)::

	# cd /sys/kernel/debug/notifier-error-inject/pm/
	# echo -12 > actions/PM_SUSPEND_PREPARE/error
	# echo mem > /sys/power/state
	bash: echo: write error: Cannot allocate memory

Модуль внедрения ошибок в Memory hotplug notifier
-------------------------------------------------
Эта функциональность управляется через интерфейс debugfs

  /sys/kernel/debug/notifier-error-inject/memory/actions/<notifier event>/error

Возможные события memory notifier, в которых можно вызвать сбой:

 * MEM_GOING_ONLINE
 * MEM_GOING_OFFLINE

Пример: внедрение ошибки отключения memory hotplug (-12 == -ENOMEM)::

	# cd /sys/kernel/debug/notifier-error-inject/memory
	# echo -12 > actions/MEM_GOING_OFFLINE/error
	# echo offline > /sys/devices/system/memory/memoryXXX/state
	bash: echo: write error: Cannot allocate memory

Модуль внедрения ошибок в powerpc pSeries reconfig notifier
-----------------------------------------------------------
Эта функциональность управляется через интерфейс debugfs

  /sys/kernel/debug/notifier-error-inject/pSeries-reconfig/actions/<notifier event>/error

Возможные события pSeries reconfig notifier, в которых можно вызвать сбой:

 * PSERIES_RECONFIG_ADD
 * PSERIES_RECONFIG_REMOVE
 * PSERIES_DRCONF_MEM_ADD
 * PSERIES_DRCONF_MEM_REMOVE

Модуль внедрения ошибок в Netdevice notifier
--------------------------------------------
Эта функциональность управляется через интерфейс debugfs

  /sys/kernel/debug/notifier-error-inject/netdev/actions/<notifier event>/error

События Netdevice notifier, в которых можно вызвать сбой:

 * NETDEV_REGISTER
 * NETDEV_CHANGEMTU
 * NETDEV_CHANGENAME
 * NETDEV_PRE_UP
 * NETDEV_PRE_TYPE_CHANGE
 * NETDEV_POST_INIT
 * NETDEV_PRECHANGEMTU
 * NETDEV_PRECHANGEUPPER
 * NETDEV_CHANGEUPPER

Пример: внедрение ошибки смены mtu для netdevice (-22 == -EINVAL)::

	# cd /sys/kernel/debug/notifier-error-inject/netdev
	# echo -22 > actions/NETDEV_CHANGEMTU/error
	# ip link set eth0 mtu 1024
	RTNETLINK answers: Invalid argument

Дополнительные примеры использования
------------------------------------
В составе tools/testing/selftests есть средства, использующие возможности внедрения ошибок
в notifier для CPU и memory notifier.

 * tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
 * tools/testing/selftests/memory-hotplug/mem-on-off-test.sh

Эти сценарии сначала выполняют простые тесты включения и отключения, а затем выполняют тесты
внедрения ошибок, если доступен модуль внедрения ошибок в notifier.
