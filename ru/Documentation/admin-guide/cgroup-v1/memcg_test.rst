=================================================================
Заметка о реализации контроллера ресурсов памяти (Memcg)
=================================================================

Последнее обновление: 2010/2

Базовая версия ядра: на основе 2.6.33-rc7-mm (кандидат для 34).

Поскольку VM становится сложной (одна из причин — memcg...), поведение memcg
тоже сложное. Это документ о внутреннем поведении memcg.
Обратите внимание, что детали реализации могут меняться.

(*) Темы, касающиеся API, должны находиться в Documentation/admin-guide/cgroup-v1/memory.rst)

0. Как ведётся учёт использования?
==================================

   Используются 2 объекта.

   page_cgroup ....объект на каждую страницу.

	Выделяется при загрузке или при memory hotplug. Освобождается при
	горячем удалении памяти.

   swap_cgroup ... запись на каждую swp_entry.

	Выделяется при swapon(). Освобождается при swapoff().

   У page_cgroup есть бит USED, поэтому двойной учёт одного page_cgroup
   никогда не происходит. swap_cgroup используется только тогда, когда
   учтённая страница вытесняется в swap.

1. Учёт (Charge)
================

   страница/swp_entry может быть учтена (usage += PAGE_SIZE) в

	mem_cgroup_try_charge()

2. Снятие учёта (Uncharge)
==========================

  с страницы/swp_entry может быть снят учёт (usage -= PAGE_SIZE) при помощи

	mem_cgroup_uncharge()
	  Вызывается, когда refcount страницы достигает 0.

	mem_cgroup_uncharge_swap()
	  Вызывается, когда refcnt у swp_entry достигает 0. Учёт по swap
	  исчезает.

3. charge-commit-cancel
=======================

	Страницы memcg учитываются в два шага:

		- mem_cgroup_try_charge()
		- mem_cgroup_commit_charge() или mem_cgroup_cancel_charge()

	На этапе try_charge() нет флагов, которые говорили бы «эта страница
	учтена». В этот момент usage += PAGE_SIZE.

	На этапе commit() страница ассоциируется с memcg.

	На этапе cancel() просто usage -= PAGE_SIZE.

В приведённых ниже пояснениях мы предполагаем CONFIG_SWAP=y.

4. Анонимные страницы
=====================

	Анонимная страница вновь выделяется при
		  - page fault в отображение MAP_ANONYMOUS.
		  - Copy-On-Write.

	4.1 Swap-in.
	При swap-in страница берётся из swap-cache. Есть 2 случая.

	(a) Если SwapCache только что выделен и прочитан, для него нет учёта.
	(b) Если SwapCache был отображён процессами, он уже был
	    учтён.

	4.2 Swap-out.
	При swap-out типичный переход состояний приведён ниже.

	(a) добавление в swap cache. (помечается как SwapCache)
	    refcnt у swp_entry += 1.
	(b) полное снятие отображения.
	    refcnt у swp_entry += число ptes.
	(c) запись обратно в swap.
	(d) удаление из swap cache. (удаление из SwapCache)
	    refcnt у swp_entry -= 1.


	Наконец, при завершении задачи,
	(e) вызывается zap_pte() и refcnt у swp_entry -=1 -> 0.

5. Page Cache
=============

	Page Cache учитывается в
	- filemap_add_folio().

	Логика очень ясна. (О миграции см. ниже)

	Примечание:
	  __filemap_remove_folio() вызывается из filemap_remove_folio()
	  и __remove_mapping().

6. Page Cache для Shmem(tmpfs)
==============================

	Лучший способ понять переходы состояний страниц shmem — прочитать
	mm/shmem.c.

	Но краткое пояснение поведения memcg вокруг shmem будет
	полезно для понимания логики.

	Страница shmem (именно листовая страница, не direct/indirect block)
	может находиться в

		- radix-tree инода shmem.
		- SwapCache.
		- Одновременно в radix-tree и SwapCache. Это происходит при
		  swap-in и swap-out,

	Учёт производится, когда...

	- В radix-tree shmem добавляется новая страница.
	- Читается swp-страница. (перенос учёта из swap_cgroup в page_cgroup)

7. Миграция страниц
===================

	mem_cgroup_migrate()

8. LRU
======
	У каждого memcg есть свой собственный вектор LRU (inactive anon,
	active anon, inactive file, active file, unevictable) для страниц
	с каждого узла; каждый LRU обрабатывается под единственной блокировкой
	lru_lock для данного memcg и узла.

9. Типичные тесты.
==================

 Тесты для случаев с гонками.

9.1 Малый лимит для memcg.
--------------------------

	Когда вы проводите тест случая с гонкой, хорошим тестом будет задать
	лимит memcg очень малым, а не в ГБ. Многие гонки обнаруживаются в
	тесте при лимитах в xКБ или xxМБ.

	(Поведение памяти при ГБ и поведение памяти при МБ показывают очень
	разные ситуации.)

9.2 Shmem
---------

	Исторически обработка shmem в memcg была слабой, и здесь мы наблюдали
	некоторое количество проблем. Это потому, что shmem является
	page-cache, но может быть SwapCache. Тест с shmem/tmpfs — всегда
	хороший тест.

9.3 Миграция
------------

	Для NUMA миграция — это ещё один особый случай. Для простого теста
	полезен cpuset. Ниже приведён пример скрипта для выполнения миграции::

		mount -t cgroup -o cpuset none /opt/cpuset

		mkdir /opt/cpuset/01
		echo 1 > /opt/cpuset/01/cpuset.cpus
		echo 0 > /opt/cpuset/01/cpuset.mems
		echo 1 > /opt/cpuset/01/cpuset.memory_migrate
		mkdir /opt/cpuset/02
		echo 1 > /opt/cpuset/02/cpuset.cpus
		echo 1 > /opt/cpuset/02/cpuset.mems
		echo 1 > /opt/cpuset/02/cpuset.memory_migrate

	В приведённом выше наборе, когда вы перемещаете задачу из 01 в 02,
	произойдёт миграция страниц с узла 0 на узел 1. Ниже приведён скрипт
	для миграции всего, что находится под cpuset.::

		--
		move_task()
		{
		for pid in $1
		do
			/bin/echo $pid >$2/tasks 2>/dev/null
			echo -n $pid
			echo -n " "
		done
		echo END
		}

		G1_TASK=`cat ${G1}/tasks`
		G2_TASK=`cat ${G2}/tasks`
		move_task "${G1_TASK}" ${G2} &
		--

9.4 Memory hotplug
------------------

	Тест memory hotplug — один из хороших тестов.

	чтобы перевести память в offline, выполните следующее::

		# echo offline > /sys/devices/system/memory/memoryXXX/state

	(XXX — местоположение памяти)

	Это также простой способ протестировать миграцию страниц.

9.5 вложенные cgroup
--------------------

	Для тестирования вложенных cgroup используйте тесты вроде следующего::

		mkdir /opt/cgroup/01/child_a
		mkdir /opt/cgroup/01/child_b

		set limit to 01.
		add limit to 01/child_b
		run jobs under child_a and child_b

	создавайте/удаляйте случайным образом следующие группы во время
	выполнения заданий::

		/opt/cgroup/01/child_a/child_aa
		/opt/cgroup/01/child_b/child_bb
		/opt/cgroup/01/child_c

	запуск новых заданий в новой группе тоже хорош.

9.6 Монтирование с другими подсистемами
---------------------------------------

	Монтирование с другими подсистемами — хороший тест, потому что есть
	гонка и зависимость по блокировкам с другими подсистемами cgroup.

	пример::

		# mount -t cgroup none /cgroup -o cpuset,memory,cpu,devices

	и выполняйте перемещение задач, mkdir, rmdir и т.д. под этим.

9.7 swapoff
-----------

	Помимо того что управление swap — одна из сложных частей memcg,
	путь вызова swap-in при swapoff не совпадает с обычным путём swap-in..
	Стоит протестировать его явно.

	Например, хорош тест вроде следующего:

	(Shell-A)::

		# mount -t cgroup none /cgroup -o memory
		# mkdir /cgroup/test
		# echo 40M > /cgroup/test/memory.limit_in_bytes
		# echo 0 > /cgroup/test/tasks

	Запустите под этим программу malloc(100M). Вы увидите 60M swap-а.

	(Shell-B)::

		# move all tasks in /cgroup/test to /cgroup
		# /sbin/swapoff -a
		# rmdir /cgroup/test
		# kill malloc task.

	Разумеется, тест tmpfs против swapoff тоже следует протестировать.

9.8 OOM-Killer
--------------

	Out-of-memory, вызванный лимитом memcg, убьёт задачи под этим
	memcg. Когда используется иерархия, задача под иерархией
	будет убита ядром.

	В этом случае panic_on_oom не должен срабатывать, а задачи
	в других группах не должны быть убиты.

	Вызвать OOM под memcg несложно следующим образом.

	Случай A) когда вы можете выполнить swapoff::

		#swapoff -a
		#echo 50M > /memory.limit_in_bytes

	запустите malloc на 51M

	Случай B) когда вы используете ограничение mem+swap::

		#echo 50M > memory.limit_in_bytes
		#echo 50M > memory.memsw.limit_in_bytes

	запустите malloc на 51M

9.9 Перенос учёта при миграции задач
------------------------------------

	Учёт, связанный с задачей, может переноситься вместе с миграцией задачи.

	(Shell-A)::

		#mkdir /cgroup/A
		#echo $$ >/cgroup/A/tasks

	запустите в /cgroup/A несколько программ, использующих некоторый объём памяти.

	(Shell-B)::

		#mkdir /cgroup/B
		#echo 1 >/cgroup/B/memory.move_charge_at_immigrate
		#echo "pid of the program running in group A" >/cgroup/B/tasks

	Вы можете убедиться, что учёт был перенесён, прочитав ``*.usage_in_bytes`` или
	memory.stat обеих групп A и B.

	См. раздел 8.2 в Documentation/admin-guide/cgroup-v1/memory.rst, чтобы узнать, какое значение следует
	записать в move_charge_at_immigrate.

9.10 Пороги памяти
------------------

	Контроллер памяти реализует пороги памяти при помощи API уведомлений
	cgroups. Для тестирования вы можете использовать tools/cgroup/cgroup_event_listener.c.

	(Shell-A) Создайте cgroup и запустите слушатель событий::

		# mkdir /cgroup/A
		# ./cgroup_event_listener /cgroup/A/memory.usage_in_bytes 5M

	(Shell-B) Добавьте задачу в cgroup и попробуйте выделить и освободить память::

		# echo $$ >/cgroup/A/tasks
		# a="$(dd if=/dev/zero bs=1M count=10)"
		# a=

	Вы будете видеть сообщение от cgroup_event_listener каждый раз, когда
	пересекаете пороги.

	Используйте /cgroup/A/memory.memsw.usage_in_bytes для тестирования порогов memsw.

	Хорошая идея — протестировать также корневой cgroup.
