=================================
Cgroup сетевого классификатора
=================================

Cgroup сетевого классификатора предоставляет интерфейс для
пометки сетевых пакетов идентификатором класса (classid).

Контроллер трафика (Traffic Controller, tc) можно использовать для назначения
различных приоритетов пакетам из разных cgroups.
Кроме того, Netfilter (iptables) может использовать эту метку для выполнения
действий над такими пакетами.

Создание экземпляра cgroups net_cls создаёт файл net_cls.classid.
Значение net_cls.classid инициализируется нулём.

В net_cls.classid можно записывать шестнадцатеричные значения; формат этих
значений — 0xAAAABBBB; AAAA — это старший номер дескриптора (major handle), а BBBB —
младший номер дескриптора (minor handle).
Чтение net_cls.classid возвращает результат в десятичном виде.

Пример::

	mkdir /sys/fs/cgroup/net_cls
	mount -t cgroup -onet_cls net_cls /sys/fs/cgroup/net_cls
	mkdir /sys/fs/cgroup/net_cls/0
	echo 0x100001 >  /sys/fs/cgroup/net_cls/0/net_cls.classid

- установка дескриптора 10:1::

	cat /sys/fs/cgroup/net_cls/0/net_cls.classid
	1048577

- настройка tc::

	tc qdisc add dev eth0 root handle 10: htb
	tc class add dev eth0 parent 10: classid 10:1 htb rate 40mbit

- создание класса трафика 10:1::

	tc filter add dev eth0 parent 10: protocol ip prio 10 handle 1: cgroup

настройка iptables, базовый пример::

	iptables -A OUTPUT -m cgroup ! --cgroup 0x100001 -j DROP
