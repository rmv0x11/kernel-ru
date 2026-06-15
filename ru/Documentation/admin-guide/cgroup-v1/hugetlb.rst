==================
Контроллер HugeTLB
==================

Контроллер HugeTLB можно создать, сначала смонтировав файловую систему cgroup.

# mount -t cgroup -o hugetlb none /sys/fs/cgroup

После выполнения этого шага начальная, или родительская, группа HugeTLB
становится видимой в /sys/fs/cgroup. При загрузке системы эта группа включает
все задачи в системе. Файл /sys/fs/cgroup/tasks перечисляет задачи в данной cgroup.

Новые группы можно создавать внутри родительской группы /sys/fs/cgroup::

  # cd /sys/fs/cgroup
  # mkdir g1
  # echo $$ > g1/tasks

Приведённые выше шаги создают новую группу g1 и перемещают в неё текущий процесс
оболочки (bash).

Краткая сводка управляющих файлов::

 hugetlb.<hugepagesize>.rsvd.limit_in_bytes            # set/show limit of "hugepagesize" hugetlb reservations
 hugetlb.<hugepagesize>.rsvd.max_usage_in_bytes        # show max "hugepagesize" hugetlb reservations and no-reserve faults
 hugetlb.<hugepagesize>.rsvd.usage_in_bytes            # show current reservations and no-reserve faults for "hugepagesize" hugetlb
 hugetlb.<hugepagesize>.rsvd.failcnt                   # show the number of allocation failure due to HugeTLB reservation limit
 hugetlb.<hugepagesize>.limit_in_bytes                 # set/show limit of "hugepagesize" hugetlb faults
 hugetlb.<hugepagesize>.max_usage_in_bytes             # show max "hugepagesize" hugetlb  usage recorded
 hugetlb.<hugepagesize>.usage_in_bytes                 # show current usage for "hugepagesize" hugetlb
 hugetlb.<hugepagesize>.failcnt                        # show the number of allocation failure due to HugeTLB usage limit
 hugetlb.<hugepagesize>.numa_stat                      # show the numa information of the hugetlb memory charged to this cgroup

Для системы, поддерживающей три размера huge-страниц (64k, 32M и 1G), управляющие
файлы включают::

  hugetlb.1GB.limit_in_bytes
  hugetlb.1GB.max_usage_in_bytes
  hugetlb.1GB.numa_stat
  hugetlb.1GB.usage_in_bytes
  hugetlb.1GB.failcnt
  hugetlb.1GB.rsvd.limit_in_bytes
  hugetlb.1GB.rsvd.max_usage_in_bytes
  hugetlb.1GB.rsvd.usage_in_bytes
  hugetlb.1GB.rsvd.failcnt
  hugetlb.64KB.limit_in_bytes
  hugetlb.64KB.max_usage_in_bytes
  hugetlb.64KB.numa_stat
  hugetlb.64KB.usage_in_bytes
  hugetlb.64KB.failcnt
  hugetlb.64KB.rsvd.limit_in_bytes
  hugetlb.64KB.rsvd.max_usage_in_bytes
  hugetlb.64KB.rsvd.usage_in_bytes
  hugetlb.64KB.rsvd.failcnt
  hugetlb.32MB.limit_in_bytes
  hugetlb.32MB.max_usage_in_bytes
  hugetlb.32MB.numa_stat
  hugetlb.32MB.usage_in_bytes
  hugetlb.32MB.failcnt
  hugetlb.32MB.rsvd.limit_in_bytes
  hugetlb.32MB.rsvd.max_usage_in_bytes
  hugetlb.32MB.rsvd.usage_in_bytes
  hugetlb.32MB.rsvd.failcnt


1. Учёт страничных отказов (page fault)

::

  hugetlb.<hugepagesize>.limit_in_bytes
  hugetlb.<hugepagesize>.max_usage_in_bytes
  hugetlb.<hugepagesize>.usage_in_bytes
  hugetlb.<hugepagesize>.failcnt

Контроллер HugeTLB позволяет пользователям ограничивать использование HugeTLB
(страничный отказ) для каждой control group и применяет ограничение во время
страничного отказа. Поскольку HugeTLB не поддерживает освобождение страниц
(page reclaim), применение ограничения во время страничного отказа означает,
что приложение получит сигнал SIGBUS, если попытается отобразить (fault in)
страницы HugeTLB сверх своего лимита. Поэтому приложению необходимо заранее
точно знать, сколько страниц HugeTLB оно использует, а системному администратору
необходимо убедиться, что на машине доступно достаточно страниц для всех
пользователей, чтобы избежать получения процессами SIGBUS.


2. Учёт резервирований (reservation)

::

  hugetlb.<hugepagesize>.rsvd.limit_in_bytes
  hugetlb.<hugepagesize>.rsvd.max_usage_in_bytes
  hugetlb.<hugepagesize>.rsvd.usage_in_bytes
  hugetlb.<hugepagesize>.rsvd.failcnt

Контроллер HugeTLB позволяет ограничивать резервирования HugeTLB для каждой
control group и применяет ограничение контроллера во время резервирования, а
также при страничном отказе для памяти HugeTLB, для которой резервирование
отсутствует. Поскольку ограничения на резервирование применяются во время
резервирования (при mmap или shget), ограничения на резервирование никогда не
приводят к получению приложением сигнала SIGBUS, если память была зарезервирована
заранее. Для выделений MAP_NORESERVE ограничение на резервирование ведёт себя так
же, как и ограничение по страничному отказу, применяя контроль использования
памяти во время страничного отказа и приводя к получению приложением SIGBUS, если
оно превышает свой лимит.

Ограничения на резервирование превосходят описанные выше ограничения по страничным
отказам, поскольку ограничения на резервирование применяются во время
резервирования (при mmap или shget) и никогда не приводят к получению приложением
сигнала SIGBUS, если память была зарезервирована заранее. Это позволяет проще
переходить к альтернативам, например к памяти, отличной от HugeTLB. В случае учёта
по страничным отказам очень трудно избежать получения процессами SIGBUS, поскольку
системному администратору необходимо точно знать использование HugeTLB всеми
задачами в системе и убедиться, что имеется достаточно страниц для удовлетворения
всех запросов. Избежать получения задачами SIGBUS на системах с избыточным
выделением (overcommitted) практически невозможно при учёте по страничным отказам.


3. Особенности при работе с разделяемой памятью

Для разделяемой памяти HugeTLB как резервирование HugeTLB, так и страничные отказы
относятся (charged) на первую задачу, вызвавшую резервирование или страничный отказ
памяти, а все последующие использования этой зарезервированной или отображённой
памяти выполняются без начисления.

Разделяемая память HugeTLB освобождается от начисления (uncharged) только при
снятии резервирования или освобождении. Обычно это происходит при удалении файла
HugeTLB, а не при завершении задачи, вызвавшей резервирование или страничный отказ.


4. Особенности при переходе cgroup HugeTLB в офлайн.

Когда cgroup HugeTLB переходит в офлайн, при этом некоторые резервирования или
страничные отказы всё ещё начислены на неё, поведение следующее:

- начисления за страничные отказы переносятся на родительскую cgroup HugeTLB
  (reparented),
- начисления за резервирование остаются на офлайн-cgroup HugeTLB.

Это означает, что если cgroup HugeTLB переводится в офлайн, в то время как на неё
всё ещё начислены резервирования HugeTLB, эта cgroup сохраняется как зомби, пока
все резервирования HugeTLB не будут списаны. Резервирования HugeTLB ведут себя
подобным образом, чтобы соответствовать контроллеру памяти, cgroup которого также
сохраняются как зомби, пока вся начисленная память не будет списана. Кроме того,
отслеживание резервирований HugeTLB несколько сложнее по сравнению с отслеживанием
страничных отказов HugeTLB, поэтому значительно труднее переносить резервирования
на родителя в момент перехода в офлайн.
