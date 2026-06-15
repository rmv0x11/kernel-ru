============================
Контроллер числа процессов
============================

Аннотация
---------

Контроллер числа процессов используется для того, чтобы позволить иерархии cgroup
останавливать создание любых новых задач через fork() или clone() после достижения
определённого предела.

Поскольку достичь предела числа задач, не упёршись ни в один из действующих
ограничений kmemcg, тривиально просто, PID являются фундаментальным ресурсом.
Поэтому исчерпание PID должно быть предотвратимо в рамках иерархии cgroup путём
ограничения ресурса в виде числа задач в cgroup.

Использование
-------------

Чтобы использовать контроллер `pids`, задайте максимальное число задач в
pids.max (по очевидным причинам он недоступен в корневой cgroup). Число процессов,
находящихся в cgroup в данный момент, указывается в pids.current.

Организационные операции не блокируются политиками cgroup, поэтому возможна
ситуация, когда pids.current > pids.max. Этого можно добиться либо установив предел
меньше, чем pids.current, либо присоединив к cgroup достаточно процессов, чтобы
pids.current > pids.max. Однако нарушить политику cgroup через fork() или clone()
невозможно. fork() и clone() вернут -EAGAIN, если создание нового процесса привело бы
к нарушению политики cgroup.

Чтобы у cgroup не было предела, установите pids.max в значение "max". Это значение
по умолчанию для всех новых cgroup (N.B. пределы PID иерархичны, поэтому соблюдается
наиболее строгий предел в иерархии).

pids.current отслеживает все дочерние иерархии cgroup, так что parent/pids.current
является надмножеством parent/child/pids.current.

Файл pids.events содержит счётчики событий:

  - max: Количество раз, когда fork завершился неудачно в cgroup из-за того, что был
    достигнут предел в самой cgroup или у её предков.

Пример
------

Сначала смонтируем контроллер pids::

	# mkdir -p /sys/fs/cgroup/pids
	# mount -t cgroup -o pids none /sys/fs/cgroup/pids

Затем создадим иерархию, установим пределы и присоединим к ней процессы::

	# mkdir -p /sys/fs/cgroup/pids/parent/child
	# echo 2 > /sys/fs/cgroup/pids/parent/pids.max
	# echo $$ > /sys/fs/cgroup/pids/parent/cgroup.procs
	# cat /sys/fs/cgroup/pids/parent/pids.current
	2
	#

Следует отметить, что попытки превысить установленный предел (в данном случае 2)
завершатся неудачей::

	# cat /sys/fs/cgroup/pids/parent/pids.current
	2
	# ( /bin/echo "Here's some processes for you." | cat )
	sh: fork: Resource temporary unavailable
	#

Даже если мы перейдём в дочернюю cgroup (у которой нет установленного предела), мы
не сможем превысить наиболее строгий предел в иерархии (в данном случае предел
родителя)::

	# echo $$ > /sys/fs/cgroup/pids/parent/child/cgroup.procs
	# cat /sys/fs/cgroup/pids/parent/pids.current
	2
	# cat /sys/fs/cgroup/pids/parent/child/pids.current
	2
	# cat /sys/fs/cgroup/pids/parent/child/pids.max
	max
	# ( /bin/echo "Here's some processes for you." | cat )
	sh: fork: Resource temporary unavailable
	#

Мы можем установить предел меньше, чем pids.current, что вообще остановит создание
любых новых процессов через fork (обратите внимание, что сама оболочка учитывается
в pids.current)::

	# echo 1 > /sys/fs/cgroup/pids/parent/pids.max
	# /bin/echo "We can't even spawn a single process now."
	sh: fork: Resource temporary unavailable
	# echo 0 > /sys/fs/cgroup/pids/parent/pids.max
	# /bin/echo "We can't even spawn a single process now."
	sh: fork: Resource temporary unavailable
	#
