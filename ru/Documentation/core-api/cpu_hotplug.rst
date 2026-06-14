==================================
CPU hotplug в ядре
==================================

:Date: September, 2021
:Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
         Rusty Russell <rusty@rustcorp.com.au>,
         Srivatsa Vaddagiri <vatsa@in.ibm.com>,
         Ashok Raj <ashok.raj@intel.com>,
         Joel Schopp <jschopp@austin.ibm.com>,
	 Thomas Gleixner <tglx@kernel.org>

Введение
========

Современные достижения в системных архитектурах привнесли в процессоры
расширенные возможности отчётности об ошибках и их коррекции. Существует
несколько OEM-производителей, которые поддерживают NUMA-оборудование с
горячей заменой, где для физической вставки и извлечения узла требуется
поддержка CPU hotplug.

Такие достижения требуют возможности удалять доступные ядру CPU — либо по
причинам провижининга, либо в целях RAS, чтобы держать сбойный CPU вне пути
исполнения системы. Отсюда и потребность в поддержке CPU hotplug в ядре Linux.

Более новое применение поддержки CPU hotplug — её сегодняшнее использование
для поддержки suspend/resume на SMP. Поддержка двухъядерных процессоров и HT
позволяет даже ноутбуку запускать SMP-ядра, которые не поддерживали эти методы.


Ключи командной строки
======================
``maxcpus=n``
  Ограничить число загружаемых CPU значением *n*. Скажем, если у вас четыре CPU,
  то использование ``maxcpus=2`` загрузит только два. Вы можете решить вывести
  остальные CPU в online позже.

``nr_cpus=n``
  Ограничить общее количество CPU, которое будет поддерживать ядро. Если
  указанное здесь число меньше количества физически доступных CPU, то эти CPU
  не могут быть выведены в online позже.

``possible_cpus=n``
  Этот параметр устанавливает ``possible_cpus`` бит в ``cpu_possible_mask``.

  Этот параметр доступен только для архитектур X86 и S390.

``cpu0_hotplug``
  Разрешить отключение CPU0.

  Этот параметр доступен только для архитектуры X86.

Карты CPU
=========

``cpu_possible_mask``
  Битовая карта возможных CPU, которые когда-либо могут стать доступными в
  системе. Она используется для выделения некоторого объёма памяти на время
  загрузки под переменные per_cpu, которые не рассчитаны на рост/сжатие по мере
  того, как CPU становятся доступными или удаляются. После установки на фазе
  обнаружения во время загрузки карта статична, т.е. биты не добавляются и не
  удаляются в любой момент. Точное усечение её под нужды вашей системы заранее
  может сэкономить часть памяти, выделяемой при загрузке.

``cpu_online_mask``
  Битовая карта всех CPU, находящихся в данный момент в online. Она
  устанавливается в ``__cpu_up()`` после того, как CPU становится доступен для
  планирования ядром и готов принимать прерывания от устройств. Она очищается,
  когда CPU выводится из работы с помощью ``__cpu_disable()``, перед чем все
  сервисы ОС, включая прерывания, мигрируются на другой целевой CPU.

``cpu_present_mask``
  Битовая карта CPU, присутствующих в данный момент в системе. Не все из них
  могут быть в online. Когда физический hotplug обрабатывается соответствующей
  подсистемой (например, ACPI), она может меняться, и новый бит может либо
  добавляться, либо удаляться из карты в зависимости от того, является ли
  событие hot-add или hot-remove. На данный момент каких-либо правил блокировки
  пока нет. Типичное использование — инициализация топологии во время загрузки,
  когда hotplug отключён.

Вам действительно не нужно манипулировать какими-либо из системных карт CPU.
В большинстве случаев они должны быть доступны только для чтения. При настройке
ресурсов per-cpu почти всегда используйте ``cpu_possible_mask`` или
``for_each_possible_cpu()`` для итерации. Макрос ``for_each_cpu()`` можно
использовать для итерации по произвольной маске CPU.

Никогда не используйте ничего, кроме ``cpumask_t``, для представления битовой
карты CPU.


Использование CPU hotplug
=========================

Должна быть включена опция ядра *CONFIG_HOTPLUG_CPU*. В настоящее время она
доступна на нескольких архитектурах, включая ARM, MIPS, PowerPC и X86.
Настройка выполняется через интерфейс sysfs::

 $ ls -lh /sys/devices/system/cpu
 total 0
 drwxr-xr-x  9 root root    0 Dec 21 16:33 cpu0
 drwxr-xr-x  9 root root    0 Dec 21 16:33 cpu1
 drwxr-xr-x  9 root root    0 Dec 21 16:33 cpu2
 drwxr-xr-x  9 root root    0 Dec 21 16:33 cpu3
 drwxr-xr-x  9 root root    0 Dec 21 16:33 cpu4
 drwxr-xr-x  9 root root    0 Dec 21 16:33 cpu5
 drwxr-xr-x  9 root root    0 Dec 21 16:33 cpu6
 drwxr-xr-x  9 root root    0 Dec 21 16:33 cpu7
 drwxr-xr-x  2 root root    0 Dec 21 16:33 hotplug
 -r--r--r--  1 root root 4.0K Dec 21 16:33 offline
 -r--r--r--  1 root root 4.0K Dec 21 16:33 online
 -r--r--r--  1 root root 4.0K Dec 21 16:33 possible
 -r--r--r--  1 root root 4.0K Dec 21 16:33 present

Файлы *offline*, *online*, *possible*, *present* представляют маски CPU.
Каждая папка CPU содержит файл *online*, который управляет логическим состоянием
включения (1) и выключения (0). Чтобы логически отключить CPU4::

 $ echo 0 > /sys/devices/system/cpu/cpu4/online
  smpboot: CPU 4 is now offline

После отключения CPU он будет удалён из */proc/interrupts*, */proc/cpuinfo* и
также не должен отображаться командой *top*. Чтобы вернуть CPU4 в online::

 $ echo 1 > /sys/devices/system/cpu/cpu4/online
 smpboot: Booting Node 0 Processor 4 APIC 0x1

CPU снова можно использовать. Это должно работать на всех CPU, но CPU0 часто
является особым и исключён из CPU hotplug.

Координация CPU hotplug
=======================

Случай offline
--------------

После того как CPU был логически отключён, будут вызваны callback'и сворачивания
(teardown) зарегистрированных hotplug-состояний, начиная с ``CPUHP_ONLINE`` и
завершая состоянием ``CPUHP_OFFLINE``. Это включает:

* Если задачи заморожены из-за операции suspend, то *cpuhp_tasks_frozen* будет
  установлен в true.
* Все процессы мигрируются прочь с этого исходящего CPU на новые CPU. Новый CPU
  выбирается из текущего cpuset каждого процесса, который может быть
  подмножеством всех online CPU.
* Все прерывания, нацеленные на этот CPU, мигрируются на новый CPU.
* таймеры также мигрируются на новый CPU.
* После того как все сервисы мигрированы, ядро вызывает специфичную для
  архитектуры процедуру ``__cpu_disable()`` для выполнения специфичной для
  архитектуры очистки.


API CPU hotplug
===============

Конечный автомат CPU hotplug
----------------------------

CPU hotplug использует тривиальный конечный автомат с линейным пространством
состояний от CPUHP_OFFLINE до CPUHP_ONLINE. Каждое состояние имеет callback
запуска (startup) и callback сворачивания (teardown).

Когда CPU выводится в online, callback'и запуска вызываются последовательно,
пока не достигнуто состояние CPUHP_ONLINE. Они также могут вызываться при
установке callback'ов состояния или при добавлении экземпляра к
multi-instance-состоянию.

Когда CPU выводится из online, callback'и сворачивания вызываются
последовательно в обратном порядке, пока не достигнуто состояние CPUHP_OFFLINE.
Они также могут вызываться при удалении callback'ов состояния или при удалении
экземпляра из multi-instance-состояния.

Если месту использования требуется callback только в одном направлении
hotplug-операций (CPU online или CPU offline), то другой ненужный callback можно
установить в NULL при настройке состояния.

Пространство состояний делится на три секции:

* Секция PREPARE

  Секция PREPARE охватывает пространство состояний от CPUHP_OFFLINE до
  CPUHP_BRINGUP_CPU.

  Callback'и запуска в этой секции вызываются до того, как CPU запущен, в ходе
  операции вывода CPU в online. Callback'и сворачивания вызываются после того,
  как CPU стал неработоспособен, в ходе операции вывода CPU из online.

  Callback'и вызываются на управляющем CPU, так как они очевидно не могут
  выполняться на CPU, подвергающемся hotplug, который либо ещё не запущен, либо
  уже стал неработоспособным.

  Callback'и запуска используются для настройки ресурсов, которые требуются для
  успешного вывода CPU в online. Callback'и сворачивания используются для
  освобождения ресурсов или для перемещения отложенной работы на online CPU
  после того, как CPU, подвергаемый hotplug, стал неработоспособным.

  Callback'ам запуска разрешено завершаться неудачей. Если callback завершается
  неудачей, операция вывода CPU в online прерывается, и CPU снова приводится в
  предыдущее состояние (обычно CPUHP_OFFLINE).

  Callback'ам сворачивания в этой секции не разрешено завершаться неудачей.

* Секция STARTING

  Секция STARTING охватывает пространство состояний между CPUHP_BRINGUP_CPU + 1
  и CPUHP_AP_ONLINE.

  Callback'и запуска в этой секции вызываются на CPU, подвергаемом hotplug, с
  отключёнными прерываниями в ходе операции вывода CPU в online в коде ранней
  настройки CPU. Callback'и сворачивания вызываются с отключёнными прерываниями
  на CPU, подвергаемом hotplug, в ходе операции вывода CPU из online незадолго
  до того, как CPU будет полностью отключён.

  Callback'ам в этой секции не разрешено завершаться неудачей.

  Callback'и используются для низкоуровневой инициализации/отключения
  оборудования и для базовых подсистем.

* Секция ONLINE

  Секция ONLINE охватывает пространство состояний между CPUHP_AP_ONLINE + 1 и
  CPUHP_ONLINE.

  Callback'и запуска в этой секции вызываются на CPU, подвергаемом hotplug, в
  ходе операции вывода CPU в online. Callback'и сворачивания вызываются на CPU,
  подвергаемом hotplug, в ходе операции вывода CPU из online.

  Callback'и вызываются в контексте per-CPU hotplug-потока, который закреплён за
  CPU, подвергаемым hotplug. Callback'и вызываются с включёнными прерываниями и
  вытеснением (preemption).

  Callback'ам разрешено завершаться неудачей. Когда callback завершается
  неудачей, hotplug-операция прерывается, и CPU возвращается в предыдущее
  состояние.

Операции вывода CPU в online/offline
------------------------------------

Успешная операция вывода в online выглядит так::

  [CPUHP_OFFLINE]
  [CPUHP_OFFLINE + 1]->startup()       -> success
  [CPUHP_OFFLINE + 2]->startup()       -> success
  [CPUHP_OFFLINE + 3]                  -> skipped because startup == NULL
  ...
  [CPUHP_BRINGUP_CPU]->startup()       -> success
  === End of PREPARE section
  [CPUHP_BRINGUP_CPU + 1]->startup()   -> success
  ...
  [CPUHP_AP_ONLINE]->startup()         -> success
  === End of STARTUP section
  [CPUHP_AP_ONLINE + 1]->startup()     -> success
  ...
  [CPUHP_ONLINE - 1]->startup()        -> success
  [CPUHP_ONLINE]

Успешная операция вывода в offline выглядит так::

  [CPUHP_ONLINE]
  [CPUHP_ONLINE - 1]->teardown()       -> success
  ...
  [CPUHP_AP_ONLINE + 1]->teardown()    -> success
  === Start of STARTUP section
  [CPUHP_AP_ONLINE]->teardown()        -> success
  ...
  [CPUHP_BRINGUP_ONLINE - 1]->teardown()
  ...
  === Start of PREPARE section
  [CPUHP_BRINGUP_CPU]->teardown()
  [CPUHP_OFFLINE + 3]->teardown()
  [CPUHP_OFFLINE + 2]                  -> skipped because teardown == NULL
  [CPUHP_OFFLINE + 1]->teardown()
  [CPUHP_OFFLINE]

Неудачная операция вывода в online выглядит так::

  [CPUHP_OFFLINE]
  [CPUHP_OFFLINE + 1]->startup()       -> success
  [CPUHP_OFFLINE + 2]->startup()       -> success
  [CPUHP_OFFLINE + 3]                  -> skipped because startup == NULL
  ...
  [CPUHP_BRINGUP_CPU]->startup()       -> success
  === End of PREPARE section
  [CPUHP_BRINGUP_CPU + 1]->startup()   -> success
  ...
  [CPUHP_AP_ONLINE]->startup()         -> success
  === End of STARTUP section
  [CPUHP_AP_ONLINE + 1]->startup()     -> success
  ---
  [CPUHP_AP_ONLINE + N]->startup()     -> fail
  [CPUHP_AP_ONLINE + (N - 1)]->teardown()
  ...
  [CPUHP_AP_ONLINE + 1]->teardown()
  === Start of STARTUP section
  [CPUHP_AP_ONLINE]->teardown()
  ...
  [CPUHP_BRINGUP_ONLINE - 1]->teardown()
  ...
  === Start of PREPARE section
  [CPUHP_BRINGUP_CPU]->teardown()
  [CPUHP_OFFLINE + 3]->teardown()
  [CPUHP_OFFLINE + 2]                  -> skipped because teardown == NULL
  [CPUHP_OFFLINE + 1]->teardown()
  [CPUHP_OFFLINE]

Неудачная операция вывода в offline выглядит так::

  [CPUHP_ONLINE]
  [CPUHP_ONLINE - 1]->teardown()       -> success
  ...
  [CPUHP_ONLINE - N]->teardown()       -> fail
  [CPUHP_ONLINE - (N - 1)]->startup()
  ...
  [CPUHP_ONLINE - 1]->startup()
  [CPUHP_ONLINE]

Рекурсивные неудачи не могут быть обработаны разумным образом. Рассмотрите
следующий пример рекурсивной неудачи из-за неудачной операции вывода в
offline: ::

  [CPUHP_ONLINE]
  [CPUHP_ONLINE - 1]->teardown()       -> success
  ...
  [CPUHP_ONLINE - N]->teardown()       -> fail
  [CPUHP_ONLINE - (N - 1)]->startup()  -> success
  [CPUHP_ONLINE - (N - 2)]->startup()  -> fail

Конечный автомат CPU hotplug останавливается прямо здесь и не пытается снова
спуститься вниз, потому что это, вероятно, привело бы к бесконечному циклу::

  [CPUHP_ONLINE - (N - 1)]->teardown() -> success
  [CPUHP_ONLINE - N]->teardown()       -> fail
  [CPUHP_ONLINE - (N - 1)]->startup()  -> success
  [CPUHP_ONLINE - (N - 2)]->startup()  -> fail
  [CPUHP_ONLINE - (N - 1)]->teardown() -> success
  [CPUHP_ONLINE - N]->teardown()       -> fail

Намылить, смыть и повторить. В этом случае CPU остаётся в состоянии::

  [CPUHP_ONLINE - (N - 1)]

что по крайней мере позволяет системе продвигаться вперёд и даёт пользователю
шанс отладить или даже разрешить ситуацию.

Выделение состояния
-------------------

Существует два способа выделить CPU hotplug-состояние:

* Статическое выделение

  Статическое выделение должно использоваться, когда у подсистемы или драйвера
  есть требования к порядку относительно других CPU hotplug-состояний.
  Например, callback запуска ядра PERF должен быть вызван до callback'ов запуска
  драйвера PERF в ходе операции вывода CPU в online. В ходе операции вывода CPU
  в offline callback'и сворачивания драйвера должны быть вызваны до callback'а
  сворачивания ядра. Статически выделяемые состояния описываются константами в
  enum cpuhp_state, который можно найти в include/linux/cpuhotplug.h.

  Вставьте состояние в enum в нужном месте, чтобы требования к порядку были
  выполнены. Константа состояния должна использоваться для настройки и удаления
  состояния.

  Статическое выделение также требуется, когда callback'и состояния не
  устанавливаются во время выполнения и являются частью инициализатора массива
  CPU hotplug-состояний в kernel/cpu.c.

* Динамическое выделение

  Когда для callback'ов состояния нет требований к порядку, предпочтительным
  методом является динамическое выделение. Номер состояния выделяется функцией
  настройки и возвращается вызывающей стороне при успехе.

  Только секции PREPARE и ONLINE предоставляют диапазон для динамического
  выделения. Секция STARTING — нет, так как большинство callback'ов в этой
  секции имеют явные требования к порядку.

Настройка CPU hotplug-состояния
-------------------------------

Базовый код предоставляет следующие функции для настройки состояния:

* cpuhp_setup_state(state, name, startup, teardown)
* cpuhp_setup_state_nocalls(state, name, startup, teardown)
* cpuhp_setup_state_cpuslocked(state, name, startup, teardown)
* cpuhp_setup_state_nocalls_cpuslocked(state, name, startup, teardown)

Для случаев, когда у драйвера или подсистемы есть несколько экземпляров и одни и
те же callback'и CPU hotplug-состояния должны вызываться для каждого экземпляра,
ядро CPU hotplug предоставляет поддержку multi-instance. Преимущество перед
специфичными для драйвера списками экземпляров в том, что связанные с
экземплярами функции полностью сериализованы относительно CPU hotplug-операций
и обеспечивают автоматические вызовы callback'ов состояния при добавлении и
удалении. Для настройки такого multi-instance-состояния доступна следующая
функция:

* cpuhp_setup_state_multi(state, name, startup, teardown)

Аргумент @state — это либо статически выделенное состояние, либо одна из
констант для динамически выделяемых состояний — CPUHP_BP_PREPARE_DYN,
CPUHP_AP_ONLINE_DYN — в зависимости от секции состояния (PREPARE, ONLINE), для
которой должно быть выделено динамическое состояние.

Аргумент @name используется для вывода в sysfs и для инструментирования.
Соглашение об именовании — "subsys:mode" или "subsys/driver:mode",
например "perf:mode" или "perf/x86:mode". Распространённые имена режимов:

======== =======================================================
prepare  Для состояний в секции PREPARE

dead     Для состояний в секции PREPARE, которые не предоставляют
         callback запуска

starting Для состояний в секции STARTING

dying    Для состояний в секции STARTING, которые не предоставляют
         callback запуска

online   Для состояний в секции ONLINE

offline  Для состояний в секции ONLINE, которые не предоставляют
         callback запуска
======== =======================================================

Поскольку аргумент @name используется только для sysfs и инструментирования,
можно использовать и другие дескрипторы режима, если они описывают природу
состояния лучше, чем распространённые.

Примеры аргументов @name: "perf/online", "perf/x86:prepare",
"RCU/tree:dying", "sched/waitempty"

Аргумент @startup — это указатель на функцию-callback, который должен
вызываться в ходе операции вывода CPU в online. Если месту использования не
требуется callback запуска, установите указатель в NULL.

Аргумент @teardown — это указатель на функцию-callback, который должен
вызываться в ходе операции вывода CPU в offline. Если месту использования не
требуется callback сворачивания, установите указатель в NULL.

Функции различаются способом, которым обрабатываются установленные callback'и:

  * cpuhp_setup_state_nocalls(), cpuhp_setup_state_nocalls_cpuslocked()
    и cpuhp_setup_state_multi() только устанавливают callback'и

  * cpuhp_setup_state() и cpuhp_setup_state_cpuslocked() устанавливают
    callback'и и вызывают callback @startup (если он не NULL) для всех online
    CPU, которые в данный момент имеют состояние больше, чем вновь
    установленное состояние. В зависимости от секции состояния callback
    вызывается либо на текущем CPU (секция PREPARE), либо на каждом online CPU
    (секция ONLINE) в контексте hotplug-потока этого CPU.

    Если callback завершается неудачей для CPU N, то callback сворачивания для
    CPU 0 .. N-1 вызывается для отката операции. Настройка состояния
    завершается неудачей, callback'и для состояния не устанавливаются, а в
    случае динамического выделения выделенное состояние освобождается.

Настройка состояния и вызовы callback'ов сериализованы относительно CPU
hotplug-операций. Если функция настройки должна вызываться из области с
read-блокировкой CPU hotplug, то должны использоваться варианты _cpuslocked().
Эти функции нельзя использовать изнутри CPU hotplug-callback'ов.

Возвращаемые значения функции:
  ======== ===================================================================
  0        Статически выделенное состояние было успешно настроено

  >0       Динамически выделенное состояние было успешно настроено.

           Возвращённое число — это номер состояния, который был выделен. Если
           callback'и состояния должны быть удалены позже, например при
           выгрузке модуля, то это число должно быть сохранено вызывающей
           стороной и использовано как аргумент @state для функции удаления
           состояния. Для multi-instance-состояний динамически выделенный
           номер состояния также требуется как аргумент @state для операций
           добавления/удаления экземпляра.

  <0	   Операция завершилась неудачей
  ======== ===================================================================

Удаление CPU hotplug-состояния
------------------------------

Для удаления ранее настроенного состояния предоставляются следующие функции:

* cpuhp_remove_state(state)
* cpuhp_remove_state_nocalls(state)
* cpuhp_remove_state_nocalls_cpuslocked(state)
* cpuhp_remove_multi_state(state)

Аргумент @state — это либо статически выделенное состояние, либо номер
состояния, который был выделен в динамическом диапазоне функцией
cpuhp_setup_state*(). Если состояние находится в динамическом диапазоне, то
номер состояния освобождается и снова становится доступен для динамического
выделения.

Функции различаются способом, которым обрабатываются установленные callback'и:

  * cpuhp_remove_state_nocalls(), cpuhp_remove_state_nocalls_cpuslocked()
    и cpuhp_remove_multi_state() только удаляют callback'и.

  * cpuhp_remove_state() удаляет callback'и и вызывает callback сворачивания
    (если он не NULL) для всех online CPU, которые в данный момент имеют
    состояние больше, чем удаляемое состояние. В зависимости от секции
    состояния callback вызывается либо на текущем CPU (секция PREPARE), либо на
    каждом online CPU (секция ONLINE) в контексте hotplug-потока этого CPU.

    Чтобы завершить удаление, callback сворачивания не должен завершаться
    неудачей.

Удаление состояния и вызовы callback'ов сериализованы относительно CPU
hotplug-операций. Если функция удаления должна вызываться из области с
read-блокировкой CPU hotplug, то должны использоваться варианты _cpuslocked().
Эти функции нельзя использовать изнутри CPU hotplug-callback'ов.

Если удаляется multi-instance-состояние, то вызывающая сторона должна сначала
удалить все экземпляры.

Управление экземплярами multi-instance-состояния
------------------------------------------------

После того как multi-instance-состояние настроено, к состоянию можно добавлять
экземпляры:

  * cpuhp_state_add_instance(state, node)
  * cpuhp_state_add_instance_nocalls(state, node)

Аргумент @state — это либо статически выделенное состояние, либо номер
состояния, который был выделен в динамическом диапазоне функцией
cpuhp_setup_state_multi().

Аргумент @node — это указатель на hlist_node, встроенный в структуру данных
экземпляра. Указатель передаётся callback'ам multi-instance-состояния и может
использоваться callback'ом для извлечения экземпляра через container_of().

Функции различаются способом, которым обрабатываются установленные callback'и:

  * cpuhp_state_add_instance_nocalls() только добавляет экземпляр в список узлов
    multi-instance-состояния.

  * cpuhp_state_add_instance() добавляет экземпляр и вызывает callback запуска
    (если он не NULL), связанный с @state, для всех online CPU, которые в данный
    момент имеют состояние больше, чем @state. Callback вызывается только для
    добавляемого экземпляра. В зависимости от секции состояния callback
    вызывается либо на текущем CPU (секция PREPARE), либо на каждом online CPU
    (секция ONLINE) в контексте hotplug-потока этого CPU.

    Если callback завершается неудачей для CPU N, то callback сворачивания для
    CPU 0 .. N-1 вызывается для отката операции, функция завершается неудачей, и
    экземпляр не добавляется в список узлов multi-instance-состояния.

Для удаления экземпляра из списка узлов состояния доступны эти функции:

  * cpuhp_state_remove_instance(state, node)
  * cpuhp_state_remove_instance_nocalls(state, node)

Аргументы те же, что и для вариантов cpuhp_state_add_instance*() выше.

Функции различаются способом, которым обрабатываются установленные callback'и:

  * cpuhp_state_remove_instance_nocalls() только удаляет экземпляр из списка
    узлов состояния.

  * cpuhp_state_remove_instance() удаляет экземпляр и вызывает callback
    сворачивания (если он не NULL), связанный с @state, для всех online CPU,
    которые в данный момент имеют состояние больше, чем @state.  Callback
    вызывается только для удаляемого экземпляра.  В зависимости от секции
    состояния callback вызывается либо на текущем CPU (секция PREPARE), либо на
    каждом online CPU (секция ONLINE) в контексте hotplug-потока этого CPU.

    Чтобы завершить удаление, callback сворачивания не должен завершаться
    неудачей.

Операции добавления/удаления списка узлов и вызовы callback'ов сериализованы
относительно CPU hotplug-операций. Эти функции нельзя использовать изнутри CPU
hotplug-callback'ов и областей с read-блокировкой CPU hotplug.

Примеры
-------

Настройка и сворачивание статически выделенного состояния в секции STARTING для
уведомлений об операциях online и offline::

   ret = cpuhp_setup_state(CPUHP_SUBSYS_STARTING, "subsys:starting", subsys_cpu_starting, subsys_cpu_dying);
   if (ret < 0)
        return ret;
   ....
   cpuhp_remove_state(CPUHP_SUBSYS_STARTING);

Настройка и сворачивание динамически выделенного состояния в секции ONLINE для
уведомлений об операциях offline::

   state = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "subsys:offline", NULL, subsys_cpu_offline);
   if (state < 0)
       return state;
   ....
   cpuhp_remove_state(state);

Настройка и сворачивание динамически выделенного состояния в секции ONLINE для
уведомлений об операциях online без вызова callback'ов::

   state = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "subsys:online", subsys_cpu_online, NULL);
   if (state < 0)
       return state;
   ....
   cpuhp_remove_state_nocalls(state);

Настройка, использование и сворачивание динамически выделенного
multi-instance-состояния в секции ONLINE для уведомлений об операциях online и
offline::

   state = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "subsys:online", subsys_cpu_online, subsys_cpu_offline);
   if (state < 0)
       return state;
   ....
   ret = cpuhp_state_add_instance(state, &inst1->node);
   if (ret)
        return ret;
   ....
   ret = cpuhp_state_add_instance(state, &inst2->node);
   if (ret)
        return ret;
   ....
   cpuhp_remove_instance(state, &inst1->node);
   ....
   cpuhp_remove_instance(state, &inst2->node);
   ....
   cpuhp_remove_multi_state(state);


Тестирование hotplug-состояний
==============================

Один из способов проверить, работает ли произвольное состояние так, как
ожидается, или нет — отключить CPU и затем снова вывести его в online. Также
возможно перевести CPU в определённое состояние (например, *CPUHP_AP_ONLINE*) и
затем вернуться в *CPUHP_ONLINE*. Это смоделировало бы ошибку на одно состояние
после *CPUHP_AP_ONLINE*, которая привела бы к откату в online-состояние.

Все зарегистрированные состояния перечислены в
``/sys/devices/system/cpu/hotplug/states`` ::

 $ tail /sys/devices/system/cpu/hotplug/states
 138: mm/vmscan:online
 139: mm/vmstat:online
 140: lib/percpu_cnt:online
 141: acpi/cpu-drv:online
 142: base/cacheinfo:online
 143: virtio/net:online
 144: x86/mce:online
 145: printk:online
 168: sched:active
 169: online

Чтобы откатить CPU4 до ``lib/percpu_cnt:online`` и снова в online, просто
выполните::

  $ cat /sys/devices/system/cpu/cpu4/hotplug/state
  169
  $ echo 140 > /sys/devices/system/cpu/cpu4/hotplug/target
  $ cat /sys/devices/system/cpu/cpu4/hotplug/state
  140

Важно отметить, что callback сворачивания состояния 140 был вызван. А теперь
вернёмся в online::

  $ echo 169 > /sys/devices/system/cpu/cpu4/hotplug/target
  $ cat /sys/devices/system/cpu/cpu4/hotplug/state
  169

С включёнными trace-событиями отдельные шаги также видны::

  #  TASK-PID   CPU#    TIMESTAMP  FUNCTION
  #     | |       |        |         |
      bash-394  [001]  22.976: cpuhp_enter: cpu: 0004 target: 140 step: 169 (cpuhp_kick_ap_work)
   cpuhp/4-31   [004]  22.977: cpuhp_enter: cpu: 0004 target: 140 step: 168 (sched_cpu_deactivate)
   cpuhp/4-31   [004]  22.990: cpuhp_exit:  cpu: 0004  state: 168 step: 168 ret: 0
   cpuhp/4-31   [004]  22.991: cpuhp_enter: cpu: 0004 target: 140 step: 144 (mce_cpu_pre_down)
   cpuhp/4-31   [004]  22.992: cpuhp_exit:  cpu: 0004  state: 144 step: 144 ret: 0
   cpuhp/4-31   [004]  22.993: cpuhp_multi_enter: cpu: 0004 target: 140 step: 143 (virtnet_cpu_down_prep)
   cpuhp/4-31   [004]  22.994: cpuhp_exit:  cpu: 0004  state: 143 step: 143 ret: 0
   cpuhp/4-31   [004]  22.995: cpuhp_enter: cpu: 0004 target: 140 step: 142 (cacheinfo_cpu_pre_down)
   cpuhp/4-31   [004]  22.996: cpuhp_exit:  cpu: 0004  state: 142 step: 142 ret: 0
      bash-394  [001]  22.997: cpuhp_exit:  cpu: 0004  state: 140 step: 169 ret: 0
      bash-394  [005]  95.540: cpuhp_enter: cpu: 0004 target: 169 step: 140 (cpuhp_kick_ap_work)
   cpuhp/4-31   [004]  95.541: cpuhp_enter: cpu: 0004 target: 169 step: 141 (acpi_soft_cpu_online)
   cpuhp/4-31   [004]  95.542: cpuhp_exit:  cpu: 0004  state: 141 step: 141 ret: 0
   cpuhp/4-31   [004]  95.543: cpuhp_enter: cpu: 0004 target: 169 step: 142 (cacheinfo_cpu_online)
   cpuhp/4-31   [004]  95.544: cpuhp_exit:  cpu: 0004  state: 142 step: 142 ret: 0
   cpuhp/4-31   [004]  95.545: cpuhp_multi_enter: cpu: 0004 target: 169 step: 143 (virtnet_cpu_online)
   cpuhp/4-31   [004]  95.546: cpuhp_exit:  cpu: 0004  state: 143 step: 143 ret: 0
   cpuhp/4-31   [004]  95.547: cpuhp_enter: cpu: 0004 target: 169 step: 144 (mce_cpu_online)
   cpuhp/4-31   [004]  95.548: cpuhp_exit:  cpu: 0004  state: 144 step: 144 ret: 0
   cpuhp/4-31   [004]  95.549: cpuhp_enter: cpu: 0004 target: 169 step: 145 (console_cpu_notify)
   cpuhp/4-31   [004]  95.550: cpuhp_exit:  cpu: 0004  state: 145 step: 145 ret: 0
   cpuhp/4-31   [004]  95.551: cpuhp_enter: cpu: 0004 target: 169 step: 168 (sched_cpu_activate)
   cpuhp/4-31   [004]  95.552: cpuhp_exit:  cpu: 0004  state: 168 step: 168 ret: 0
      bash-394  [005]  95.553: cpuhp_exit:  cpu: 0004  state: 169 step: 140 ret: 0

Как можно видеть, CPU4 опускался вниз до момента времени 22.996 и затем
поднимался обратно вверх до 95.552. Все вызванные callback'и, включая их коды
возврата, видны в трассировке.

Требования архитектуры
======================

Требуются следующие функции и конфигурации:

``CONFIG_HOTPLUG_CPU``
  Эта запись должна быть включена в Kconfig

``__cpu_up()``
  Интерфейс архитектуры для запуска CPU

``__cpu_disable()``
  Интерфейс архитектуры для отключения CPU; после возврата процедуры ядро больше
  не может обрабатывать прерывания. Это включает отключение таймера.

``__cpu_die()``
  Эта функция фактически должна обеспечить смерть CPU. Посмотрите на какой-нибудь
  пример кода в другой архитектуре, которая реализует CPU hotplug. Процессор
  выводится из работы из цикла ``idle()`` для этой конкретной архитектуры.
  ``__cpu_die()`` обычно ожидает установки какого-либо per_cpu-состояния, чтобы
  убедиться наверняка, что процедура смерти процессора вызвана.

Уведомление пространства пользователя
=====================================

После успешного вывода CPU в online или offline отправляются события udev.
Правило udev вида::

  SUBSYSTEM=="cpu", DRIVERS=="processor", DEVPATH=="/devices/system/cpu/*", RUN+="the_hotplug_receiver.sh"

будет получать все события. Скрипт вида::

  #!/bin/sh

  if [ "${ACTION}" = "offline" ]
  then
      echo "CPU ${DEVPATH##*/} offline"

  elif [ "${ACTION}" = "online" ]
  then
      echo "CPU ${DEVPATH##*/} online"

  fi

может обрабатывать событие далее.

Когда происходят изменения CPU в системе, файл sysfs
/sys/devices/system/cpu/crash_hotplug содержит '1', если ядро обновляет список
CPU в kdump capture kernel самостоятельно (через elfcorehdr и другие
соответствующие kexec-сегменты), или '0', если пространство пользователя должно
обновить список CPU в kdump capture kernel.

Доступность зависит от опции конфигурации ядра CONFIG_HOTPLUG_CPU.

Чтобы пропустить обработку пространством пользователя событий горячего
подключения/отключения CPU для kdump (т.е. выгрузку с последующей повторной
загрузкой для получения текущего списка CPU), этот файл sysfs можно использовать
в правиле udev следующим образом:

 SUBSYSTEM=="cpu", ATTRS{crash_hotplug}=="1", GOTO="kdump_reload_end"

Для события горячего подключения/отключения CPU, если архитектура поддерживает
обновления ядром elfcorehdr (который содержит список CPU) и других
соответствующих kexec-сегментов, то правило пропускает выгрузку с последующей
повторной загрузкой kdump capture kernel.

Справочник по встроенной документации ядра
==========================================

.. kernel-doc:: include/linux/cpuhotplug.h
