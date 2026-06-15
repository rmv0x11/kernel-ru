.. SPDX-License-Identifier: GPL-2.0

============================================================
Руководство пользователя Intel(R) Speed Select Technology
============================================================

Технология Intel(R) Speed Select Technology (Intel(R) SST) предоставляет
мощный новый набор возможностей, которые дают более тонкий контроль над
производительностью CPU. С помощью Intel(R) SST один сервер можно настроить
по энергопотреблению и производительности под разнообразные требования
различных рабочих нагрузок.

Для общего обзора технологии обратитесь к ссылкам ниже:

- https://www.intel.com/content/www/us/en/architecture-and-technology/speed-select-technology-article.html
- https://builders.intel.com/docs/networkbuilders/intel-speed-select-technology-base-frequency-enhancing-performance.pdf

Эти возможности дополнительно расширены в некоторых из более новых поколений
серверных платформ, где данные функции можно перечислять и контролировать
динамически без предварительной настройки через опции BIOS setup. Эта
динамическая конфигурация выполняется через mailbox-команды к оборудованию.
Один из способов перечислять и настраивать эти функции — использовать утилиту
Intel Speed Select.

Этот документ объясняет, как использовать инструмент Intel Speed Select для
перечисления и контроля функций Intel(R) SST. Документ приводит примеры команд
и объясняет, как эти команды изменяют профиль энергопотребления и
производительности тестируемой системы. Используя этот инструмент в качестве
примера, заказчики могут воспроизвести обмен сообщениями, реализованный в
инструменте, в своём промышленном ПО.

Инструмент настройки intel-speed-select
=======================================

Большинство пакетов дистрибутивов Linux могут включать инструмент
"intel-speed-select". Если нет, его можно собрать, загрузив дерево исходного
кода ядра Linux с kernel.org. После загрузки инструмент можно собрать без
сборки полного ядра.

Из дерева ядра выполните следующие команды::

# cd tools/power/x86/intel-speed-select/
# make
# make install

Получение справки
-----------------

Чтобы получить справку по инструменту, выполните команду ниже::

# intel-speed-select --help

Справка верхнего уровня описывает аргументы и функции. Обратите внимание, что
в инструменте есть многоуровневая структура справки. Например, чтобы получить
справку по функции "perf-profile"::

# intel-speed-select perf-profile --help

Чтобы получить справку по команде, предоставляется ещё один уровень справки.
Например, по команде info "info"::

# intel-speed-select perf-profile info --help

Сводка возможностей платформы
-----------------------------
Чтобы проверить текущие возможности платформы и драйвера, выполните::

#intel-speed-select --info

Например, на тестовой системе::

 # intel-speed-select --info
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 Platform: API version : 1
 Platform: Driver version : 1
 Platform: mbox supported : 1
 Platform: mmio supported : 1
 Intel(R) SST-PP (feature perf-profile) is supported
 TDP level change control is unlocked, max level: 4
 Intel(R) SST-TF (feature turbo-freq) is supported
 Intel(R) SST-BF (feature base-freq) is not supported
 Intel(R) SST-CP (feature core-power) is supported

Intel(R) Speed Select Technology - Performance Profile (Intel(R) SST-PP)
------------------------------------------------------------------------

Эта функция позволяет динамически настраивать сервер на основе требований к
производительности рабочей нагрузки. Это помогает пользователям при
развёртывании, поскольку им не нужно статически выбирать конкретную
конфигурацию сервера. Эта функция Intel(R) Speed Select Technology -
Performance Profile (Intel(R) SST-PP) вводит механизм, который позволяет иметь
несколько оптимизированных профилей производительности на систему. Каждый
профиль определяет набор CPU, которые должны быть в сети (online), а остальные
вне сети (offline), чтобы поддерживать гарантированную базовую частоту. После
того как пользователь выдаёт команду использовать конкретный профиль
производительности и выполняет требование к online/offline CPU, пользователь
может ожидать динамического изменения базовой частоты. Эта функция называется
"perf-profile" при использовании инструмента Intel Speed Select.

Количество уровней производительности
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

В системе может быть несколько профилей производительности. Чтобы получить
число профилей, выполните команду ниже::

 # intel-speed-select perf-profile get-config-levels
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
        get-config-levels:4
 package-1
  die-0
    cpu-14
        get-config-levels:4

На этой тестируемой системе есть 4 профиля производительности в дополнение к
базовому профилю производительности (который является уровнем
производительности 0).

Статус блокировки/разблокировки
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Даже если есть несколько профилей производительности, возможно, что они
заблокированы. Если они заблокированы, пользователи не могут выдать команду на
изменение состояния производительности. Возможно, что есть настройка BIOS для
разблокировки, либо проверьте у поставщика вашей системы.

Чтобы проверить, заблокирована ли система, выполните следующую команду::

 # intel-speed-select perf-profile get-lock-status
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
        get-lock-status:0
 package-1
  die-0
    cpu-14
        get-lock-status:0

В этом случае статус блокировки равен 0, что означает, что система
разблокирована.

Свойства уровня производительности
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы получить свойства конкретного уровня производительности (например, для
уровня 0, ниже), выполните команду ниже::

 # intel-speed-select perf-profile info -l 0
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
      perf-profile-level-0
        cpu-count:28
        enable-cpu-mask:000003ff,f0003fff
        enable-cpu-list:0,1,2,3,4,5,6,7,8,9,10,11,12,13,28,29,30,31,32,33,34,35,36,37,38,39,40,41
        thermal-design-power-ratio:26
        base-frequency(MHz):2600
        speed-select-turbo-freq:disabled
        speed-select-base-freq:disabled
	...
	...

Здесь опция -l используется для указания уровня производительности.

Если опция -l опущена, то эта команда выведет информацию обо всех уровнях
производительности. Приведённая выше команда выводит свойства уровня
производительности 0.

Для этого профиля производительности список CPU, отображаемый
"enable-cpu-mask/enable-cpu-list", в максимуме может быть "online". Когда это
условие выполнено, тогда может поддерживаться базовая частота 2600 МГц. Чтобы
понять лучше, выполните "intel-speed-select perf-profile info" для уровня
производительности 4::

 # intel-speed-select perf-profile info -l 4
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
      perf-profile-level-4
        cpu-count:28
        enable-cpu-mask:000000fa,f0000faf
        enable-cpu-list:0,1,2,3,5,7,8,9,10,11,28,29,30,31,33,35,36,37,38,39
        thermal-design-power-ratio:28
        base-frequency(MHz):2800
        speed-select-turbo-freq:disabled
        speed-select-base-freq:unsupported
	...
	...

В "enable-cpu-mask/enable-cpu-list" меньше CPU. Следовательно, если
пользователь оставляет в сети (online) только эти CPU, а остальные — вне сети
(offline), то базовая частота повышается до 2.8 ГГц по сравнению с 2.6 ГГц на
уровне производительности 0.

Получение текущего уровня производительности
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы получить текущий уровень производительности, выполните::

 # intel-speed-select perf-profile get-config-current-level
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
        get-config-current_level:0

Сначала убедитесь, что base_frequency, отображаемая sysfs cpufreq, корректна::

 # cat /sys/devices/system/cpu/cpu0/cpufreq/base_frequency
 2600000

Это соответствует значению поля base-frequency (MHz), отображаемому командой
"perf-profile info" для уровня производительности 0 (частота cpufreq указана в
КГц).

Чтобы проверить, равна ли средняя частота базовой частоте для рабочей нагрузки
со 100% занятостью, отключите turbo::

# echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo

Затем запустите нагружающую рабочую нагрузку на всех CPU, например::

#stress -c 64

Чтобы проверить базовую частоту, запустите turbostat::

 #turbostat -c 0-13 --show Package,Core,CPU,Bzy_MHz -i 1

  Package	Core	CPU	Bzy_MHz
		-	-	2600
  0		0	0	2600
  0		1	1	2600
  0		2	2	2600
  0		3	3	2600
  0		4	4	2600
  .		.	.	.


Изменение уровня производительности
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы изменить уровень производительности на 4, выполните::

 # intel-speed-select -d perf-profile set-config-level -l 4 -o
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
      perf-profile
        set_tdp_level:success

В приведённой выше команде "-o" необязателен. Если он указан, то он также
переведёт вне сети (offline) те CPU, которых нет в enable_cpu_mask для этого
уровня производительности.

Теперь, если проверить base_frequency::

 #cat /sys/devices/system/cpu/cpu0/cpufreq/base_frequency
 2800000

Что показывает, что базовая частота теперь увеличилась с 2600 МГц на уровне
производительности 0 до 2800 МГц на уровне производительности 4. В результате
любая рабочая нагрузка, которая может использовать меньше CPU, может получить
прирост в 200 МГц по сравнению с уровнем производительности 0.

Изменение уровня производительности через интерфейс BMC
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Возможно изменить уровень SST-PP, используя внеполосный (out of band, OOB)
агент (через какую-либо удалённую консоль управления, через интерфейс BMC
"Baseboard Management Controller"). Этот режим поддерживается, начиная с
поколения процессоров Sapphire Rapids. Изменение в ядре и инструменте для
поддержки этого режима добавлено в ядро Linux версии 5.18. Чтобы включить эту
функцию, требуется конфигурация ядра "CONFIG_INTEL_HFI_THERMAL". Минимальная
версия инструмента для поддержки этой функции — "v1.12", которая является
частью ядра Linux версии 5.18.

Для поддержки такой конфигурации этот инструмент можно использовать как демон.
Добавьте опцию командной строки --oob::

 # intel-speed-select --oob
 Intel(R) Speed Select Technology
 Executing on CPU model:143[0x8f]
 OOB mode is enabled and will run as daemon

В этом режиме инструмент будет переводить CPU в сеть/вне сети (online/offline)
на основе нового уровня производительности.

Проверка наличия других функций Intel(R) SST
--------------------------------------------

Каждый из профилей производительности также указывает, есть ли поддержка двух
других функций Intel(R) SST (Intel(R) Speed Select Technology - Base Frequency
(Intel(R) SST-BF) и Intel(R) Speed Select Technology - Turbo Frequency (Intel
SST-TF)).

Например, из вывода "perf-profile info" выше, для уровня 0 и уровня 4:

Для уровня 0::
       speed-select-turbo-freq:disabled
       speed-select-base-freq:disabled

Для уровня 4::
       speed-select-turbo-freq:disabled
       speed-select-base-freq:unsupported

Учитывая эти результаты, "speed-select-base-freq" (Intel(R) SST-BF) на уровне
4 изменился с "disabled" на "unsupported" по сравнению с уровнем
производительности 0.

Это означает, что на уровне производительности 4 функция
"speed-select-base-freq" не поддерживается. Однако на уровне
производительности 0 эта функция "supported", но в данный момент "disabled",
то есть пользователь не активировал эту функцию. Тогда как
"speed-select-turbo-freq" (Intel(R) SST-TF) поддерживается на обоих уровнях
производительности, но в данный момент не активирована пользователем.

Функции Intel(R) SST-BF и Intel(R) SST-TF построены на фундаментальной
технологии под названием Intel(R) Speed Select Technology - Core Power
(Intel(R) SST-CP). Прошивка платформы включает эту функцию, когда на платформе
поддерживается Intel(R) SST-BF или Intel(R) SST-TF.

Intel(R) Speed Select Technology Core Power (Intel(R) SST-CP)
---------------------------------------------------------------

Intel(R) Speed Select Technology Core Power (Intel(R) SST-CP) — это интерфейс,
который позволяет пользователям определять приоритет на уровне ядра (per
core). Он определяет механизм распределения энергии между ядрами в сценарии с
ограничением энергопотребления. Он определяет конфигурацию класса
обслуживания (class of service, CLOS).

Пользователь может настроить до 4 конфигураций класса обслуживания. Каждая
конфигурация группы CLOS позволяет задавать параметры, которые влияют на то,
как может ограничиваться частота и распределяться энергия. Каждое ядро CPU
можно привязать к классу обслуживания и, следовательно, к связанному
приоритету. Гранулярность находится на уровне ядра, а не на уровне отдельного
CPU.

Включение приоритизации на основе CLOS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы использовать функцию приоритизации на основе CLOS, прошивку необходимо
проинформировать о включении и использовании типа приоритета. Существует тип
приоритета по умолчанию для каждой платформы, который можно изменить с помощью
необязательного параметра командной строки.

Чтобы включить и проверить опции, выполните::

 # intel-speed-select core-power enable --help
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 Enable core-power for a package/die
	Clos Enable: Specify priority type with [--priority|-p]
		 0: Proportional, 1: Ordered

Существует два типа приоритета:

- Ordered

Приоритет для упорядоченного троттлинга (ordered throttling) определяется на
основе индекса назначенной группы CLOS. При этом CLOS0 получает наивысший
приоритет (троттлится последним).

Порядок приоритета следующий:
CLOS0 > CLOS1 > CLOS2 > CLOS3.

- Proportional

Когда используется пропорциональный приоритет, есть дополнительный параметр
под названием frequency_weight, который можно задать для каждой группы CLOS.
Цель пропорционального приоритета — предоставить каждому ядру запрошенный
минимум, а затем распределить весь оставшийся бюджет (избыток/дефицит)
пропорционально заданному весу. Этот пропорциональный приоритет можно
настроить с помощью команды "core-power config".

Чтобы включить с типом приоритета по умолчанию для платформы, выполните::

 # intel-speed-select core-power enable
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
      core-power
        enable:success
 package-1
  die-0
    cpu-6
      core-power
        enable:success

Область действия (scope) этого включения — на уровне package или die, когда
package содержит несколько die. Чтобы проверить, включён ли CLOS, и получить
тип приоритета, можно использовать команду "core-power info". Например, чтобы
проверить статус функции core-power на CPU 0, выполните::

 # intel-speed-select -c 0 core-power info
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
      core-power
        support-status:supported
        enable-status:enabled
        clos-enable-status:enabled
        priority-type:proportional
 package-1
  die-0
    cpu-24
      core-power
        support-status:supported
        enable-status:enabled
        clos-enable-status:enabled
        priority-type:proportional

Настройка групп CLOS
~~~~~~~~~~~~~~~~~~~~~

Каждая группа CLOS имеет свои собственные атрибуты, включая min, max,
freq_weight и desired. Эти параметры можно настроить с помощью команды
"core-power config". Будут использованы значения по умолчанию, если
пользователь пропускает установку параметра, кроме clos id, который является
обязательным. Чтобы проверить опции core-power config, выполните::

 # intel-speed-select core-power config --help
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 Set core-power configuration for one of the four clos ids
	Specify targeted clos id with [--clos|-c]
	Specify clos Proportional Priority [--weight|-w]
	Specify clos min in MHz with [--min|-n]
	Specify clos max in MHz with [--max|-m]

Например::

 # intel-speed-select core-power config -c 0
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 clos epp is not specified, default: 0
 clos frequency weight is not specified, default: 0
 clos min is not specified, default: 0 MHz
 clos max is not specified, default: 25500 MHz
 clos desired is not specified, default: 0
 package-0
  die-0
    cpu-0
      core-power
        config:success
 package-1
  die-0
    cpu-6
      core-power
        config:success

У пользователя есть возможность изменить значения по умолчанию. Например,
пользователь может изменить "min" и установить базовую частоту так, чтобы
всегда получать гарантированную базовую частоту.

Получение текущей конфигурации CLOS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы проверить текущую конфигурацию, можно использовать
"core-power get-config". Например, чтобы получить конфигурацию CLOS 0::

 # intel-speed-select core-power get-config -c 0
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
      core-power
        clos:0
        epp:0
        clos-proportional-priority:0
        clos-min:0 MHz
        clos-max:Max Turbo frequency
        clos-desired:0 MHz
 package-1
  die-0
    cpu-24
      core-power
        clos:0
        epp:0
        clos-proportional-priority:0
        clos-min:0 MHz
        clos-max:Max Turbo frequency
        clos-desired:0 MHz

Привязка CPU к группе CLOS
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы привязать CPU к группе CLOS, можно использовать команду
"core-power assoc"::

 # intel-speed-select core-power assoc --help
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 Associate a clos id to a CPU
	Specify targeted clos id with [--clos|-c]


Например, чтобы привязать CPU 10 к группе CLOS 3, выполните::

 # intel-speed-select -c 10 core-power assoc -c 3
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-10
      core-power
        assoc:success

После того как CPU привязан, его родственные (sibling) CPU также
привязываются к группе CLOS. После привязки избегайте изменения ограничений
частоты масштабирования подсистемы "cpufreq" Linux.

Чтобы проверить существующую привязку для CPU, можно использовать команду
"core-power get-assoc". Например, чтобы получить привязку CPU 10, выполните::

 # intel-speed-select -c 10 core-power get-assoc
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-1
  die-0
    cpu-10
      get-assoc
        clos:3

Это показывает, что CPU 10 входит в группу CLOS 3.


Отключение приоритизации на основе CLOS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы отключить, выполните::

# intel-speed-select core-power disable

Некоторые функции, такие как Intel(R) SST-TF, можно включить только тогда,
когда включена приоритизация на основе CLOS. По этой причине отключение, когда
Intel(R) SST-TF включён, может привести к сбою Intel(R) SST-TF. Это приведёт к
тому, что команда "disable" отобразит ошибку, если Intel(R) SST-TF уже
включён. В свою очередь, чтобы отключить, функцию Intel(R) SST-TF необходимо
сначала отключить.

Intel(R) Speed Select Technology - Base Frequency (Intel(R) SST-BF)
-------------------------------------------------------------------

Функция Intel(R) Speed Select Technology - Base Frequency (Intel(R) SST-BF)
позволяет пользователю контролировать базовую частоту. Если некоторые
критические потоки рабочей нагрузки требуют постоянной высокой гарантированной
производительности, то эту функцию можно использовать для исполнения потока на
более высокой базовой частоте на определённых наборах CPU (высокоприоритетных
CPU) ценой более низкой базовой частоты (низкоприоритетных CPU) на других CPU.
Эта функция не требует перевода низкоприоритетных CPU вне сети (offline).

Поддержка Intel(R) SST-BF зависит от конфигурации уровня производительности
Intel(R) Speed Select Technology - Performance Profile (Intel(R) SST-PP).
Возможно, что только определённые уровни производительности поддерживают
Intel(R) SST-BF. Также возможно, что только базовый уровень производительности
(level = 0) имеет поддержку Intel(R) SST-BF. Следовательно, сначала выберите
желаемый уровень производительности, чтобы включить эту функцию.

В тестируемой здесь системе Intel(R) SST-BF поддерживается на базовом уровне
производительности 0, но в данный момент отключён. Например, для уровня 0::

 # intel-speed-select -c 0 perf-profile info -l 0
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
      perf-profile-level-0
        ...

        speed-select-base-freq:disabled
	...

Перед включением Intel(R) SST-BF и измерением его влияния на производительность
рабочей нагрузки выполните некоторую рабочую нагрузку, измерьте
производительность и получите базовую (baseline) производительность для
сравнения.

Здесь пользователь хочет более гарантированную производительность. По этой
причине вероятно, что turbo отключён. Чтобы отключить turbo, выполните::

#echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo

На основе вывода "intel-speed-select perf-profile info -l 0" базовая частота
гарантированной частоты составляет 2600 МГц.


Измерение базовой производительности для сравнения
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Для сравнения выберите многопоточную рабочую нагрузку, где каждый поток может
быть запланирован на отдельных CPU. Тест "Hackbench pipe" — хороший пример
того, как улучшить производительность с помощью Intel(R) SST-BF.

Ниже рабочая нагрузка измеряет среднюю задержку (latency) пробуждения
планировщика, поэтому меньшее число означает лучшую производительность::

 # taskset -c 3,4 perf bench -r 100 sched pipe
 # Running 'sched/pipe' benchmark:
 # Executed 1000000 pipe operations between two processes
     Total time: 6.102 [sec]
       6.102445 usecs/op
         163868 ops/sec

При выполнении приведённого выше теста, если мы возьмём вывод turbostat, он
покажет нам, что 2 из CPU заняты и достигают макс. частоты (которая была бы
базовой частотой, поскольку turbo отключён). Вывод turbostat::

 #turbostat -c 0-13 --show Package,Core,CPU,Bzy_MHz -i 1
 Package	Core	CPU	Bzy_MHz
 0		0	0	1000
 0		1	1	1005
 0		2	2	1000
 0		3	3	2600
 0		4	4	2600
 0		5	5	1000
 0		6	6	1000
 0		7	7	1005
 0		8	8	1005
 0		9	9	1000
 0		10	10	1000
 0		11	11	995
 0		12	12	1000
 0		13	13	1000

Из приведённого выше вывода turbostat оба CPU 3 и 4 очень заняты и достигают
полной гарантированной частоты 2600 МГц.

Возможности Intel(R) SST-BF
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы получить возможности Intel(R) SST-BF для текущего уровня
производительности 0, выполните::

 # intel-speed-select base-freq info -l 0
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
      speed-select-base-freq
        high-priority-base-frequency(MHz):3000
        high-priority-cpu-mask:00000216,00002160
        high-priority-cpu-list:5,6,8,13,33,34,36,41
        low-priority-base-frequency(MHz):2400
        tjunction-temperature(C):125
        thermal-design-power(W):205

Приведённые выше возможности показывают, что в этой системе есть некоторые CPU,
которые могут предложить базовую частоту 3000 МГц по сравнению со стандартной
базовой частотой на этих уровнях производительности. Тем не менее, эти CPU
фиксированы, и они представлены через high-priority-cpu-list/
high-priority-cpu-mask. Но если выбрана эта функция Intel(R) SST-BF, то
низкоприоритетные CPU (которые не входят в high-priority-cpu-list) могут
предложить только до 2400 МГц. В результате, если такое урезание (clipping)
низкоприоритетных CPU приемлемо, то пользователь может включить функцию Intel
SST-BF в частности для приведённой выше рабочей нагрузки "sched pipe",
поскольку используются только два CPU, их можно запланировать на
высокоприоритетных CPU и получить прирост в 400 МГц.

Включение Intel(R) SST-BF
~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы включить функцию Intel(R) SST-BF, выполните::

 # intel-speed-select base-freq enable -a
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
      base-freq
        enable:success
 package-1
  die-0
    cpu-14
      base-freq
        enable:success

В этом случае опция -a необязательна. Это не только включает Intel(R) SST-BF,
но также регулирует приоритет ядер, используя функции Intel(R) Speed Select
Technology Core Power (Intel(R) SST-CP). Эта опция устанавливает минимальную
производительность каждого класса Intel(R) Speed Select Technology -
Performance Profile (Intel(R) SST-PP) на максимальную производительность, так
что оборудование даст максимально возможную производительность для каждого CPU.

Если опция -a не используется, то перед включением Intel(R) SST-BF требуются
следующие шаги:

- Обнаружить Intel(R) SST-BF и отметить низко- и высокоприоритетную базовую частоту
- Отметить список высокоприоритетных CPU
- Включить CLOS, используя набор функций core-power
- Настроить параметры CLOS. Используйте CLOS.min для установки на минимальную производительность
- Подписать желаемые CPU на группы CLOS

С этой конфигурацией, если та же рабочая нагрузка исполняется путём закрепления
рабочей нагрузки на высокоприоритетных CPU (CPU 5 и 6 в данном случае)::

 #taskset -c 5,6 perf bench -r 100 sched pipe
 # Running 'sched/pipe' benchmark:
 # Executed 1000000 pipe operations between two processes
     Total time: 5.627 [sec]
       5.627922 usecs/op
         177685 ops/sec

Таким образом, путём включения Intel(R) SST-BF производительность этого
бенчмарка улучшается (задержка снижается) на 7.79%. Из вывода turbostat можно
наблюдать, что высокоприоритетные CPU достигли 3000 МГц по сравнению с 2600
МГц. Вывод turbostat::

 #turbostat -c 0-13 --show Package,Core,CPU,Bzy_MHz -i 1
 Package	Core	CPU	Bzy_MHz
 0		0	0	2151
 0		1	1	2166
 0		2	2	2175
 0		3	3	2175
 0		4	4	2175
 0		5	5	3000
 0		6	6	3000
 0		7	7	2180
 0		8	8	2662
 0		9	9	2176
 0		10	10	2175
 0		11	11	2176
 0		12	12	2176
 0		13	13	2661

Отключение Intel(R) SST-BF
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы отключить функцию Intel(R) SST-BF, выполните::

# intel-speed-select base-freq disable -a


Intel(R) Speed Select Technology - Turbo Frequency (Intel(R) SST-TF)
--------------------------------------------------------------------

Эта функция предоставляет возможность устанавливать различные "All core turbo
ratio limits" для ядер на основе приоритета. Используя эту функцию, некоторые
ядра можно настроить на получение более высокой turbo-частоты, обозначив их как
высокоприоритетные, ценой более низкой turbo-частоты или её отсутствия на
низкоприоритетных ядрах.

По этой причине эта функция полезна только тогда, когда система занята,
используя все CPU, но пользователь хочет некоторую настраиваемую опцию для
получения высокой производительности на некоторых CPU.

Поддержка Intel(R) Speed Select Technology - Turbo Frequency (Intel(R) SST-TF)
зависит от конфигурации уровня производительности Intel(R) Speed Select
Technology - Performance Profile (Intel SST-PP). Возможно, что только
определённый уровень производительности поддерживает Intel(R) SST-TF. Также
возможно, что только базовый уровень производительности (level = 0) имеет
поддержку Intel(R) SST-TF. Следовательно, сначала выберите желаемый уровень
производительности, чтобы включить эту функцию.

В тестируемой здесь системе Intel(R) SST-TF поддерживается на базовом уровне
производительности 0, но в данный момент отключён::

 # intel-speed-select -c 0 perf-profile info -l 0
 Intel(R) Speed Select Technology
 package-0
  die-0
    cpu-0
      perf-profile-level-0
        ...
        ...
        speed-select-turbo-freq:disabled
        ...
        ...


Чтобы проверить, можно ли улучшить производительность с помощью функции Intel(R)
SST-TF, получите свойства turbo-частоты с включённым Intel(R) SST-TF и
сравните с базовой turbo-возможностью этой системы.

Получение базовой turbo-возможности
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы получить базовую turbo-возможность уровня производительности 0,
выполните::

 # intel-speed-select perf-profile info -l 0
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
      perf-profile-level-0
        ...
        ...
        turbo-ratio-limits-sse
          bucket-0
            core-count:2
            max-turbo-frequency(MHz):3200
          bucket-1
            core-count:4
            max-turbo-frequency(MHz):3100
          bucket-2
            core-count:6
            max-turbo-frequency(MHz):3100
          bucket-3
            core-count:8
            max-turbo-frequency(MHz):3100
          bucket-4
            core-count:10
            max-turbo-frequency(MHz):3100
          bucket-5
            core-count:12
            max-turbo-frequency(MHz):3100
          bucket-6
            core-count:14
            max-turbo-frequency(MHz):3100
          bucket-7
            core-count:16
            max-turbo-frequency(MHz):3100

На основе приведённых выше данных, когда все CPU заняты, может быть достигнута
макс. частота 3100 МГц. Если есть некоторая нагружающая рабочая нагрузка на
cpu 0 - 11 (например, stress), а на CPU 12 и 13 выполняется рабочая нагрузка
"hackbench pipe"::

 # taskset -c 12,13 perf bench -r 100 sched pipe
 # Running 'sched/pipe' benchmark:
 # Executed 1000000 pipe operations between two processes
     Total time: 5.705 [sec]
       5.705488 usecs/op
         175269 ops/sec

Вывод turbostat::

 #turbostat -c 0-13 --show Package,Core,CPU,Bzy_MHz -i 1
 Package	Core	CPU	Bzy_MHz
 0		0	0	3000
 0		1	1	3000
 0		2	2	3000
 0		3	3	3000
 0		4	4	3000
 0		5	5	3100
 0		6	6	3100
 0		7	7	3000
 0		8	8	3100
 0		9	9	3000
 0		10	10	3000
 0		11	11	3000
 0		12	12	3100
 0		13	13	3100

На основе вывода turbostat производительность ограничена потолком частоты 3100
МГц. Чтобы проверить, можно ли улучшить производительность hackbench для CPU 12
и CPU 13, сначала проверьте возможность функции Intel(R) SST-TF для этого уровня
производительности.

Получение возможности Intel(R) SST-TF
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы получить возможность, можно использовать команду "turbo-freq info"::

 # intel-speed-select turbo-freq info -l 0
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-0
      speed-select-turbo-freq
          bucket-0
            high-priority-cores-count:2
            high-priority-max-frequency(MHz):3200
            high-priority-max-avx2-frequency(MHz):3200
            high-priority-max-avx512-frequency(MHz):3100
          bucket-1
            high-priority-cores-count:4
            high-priority-max-frequency(MHz):3100
            high-priority-max-avx2-frequency(MHz):3000
            high-priority-max-avx512-frequency(MHz):2900
          bucket-2
            high-priority-cores-count:6
            high-priority-max-frequency(MHz):3100
            high-priority-max-avx2-frequency(MHz):3000
            high-priority-max-avx512-frequency(MHz):2900
          speed-select-turbo-freq-clip-frequencies
            low-priority-max-frequency(MHz):2600
            low-priority-max-avx2-frequency(MHz):2400
            low-priority-max-avx512-frequency(MHz):2100

На основе приведённого выше вывода есть Intel(R) SST-TF bucket, для которого
есть два высокоприоритетных ядра. Если установлено только два высокоприоритетных
ядра, то макс. turbo-частоту на этих ядрах можно увеличить до 3200 МГц. Это на
100 МГц больше, чем базовая turbo-возможность для всех ядер.

В свою очередь, для рабочей нагрузки hackbench два CPU можно установить как
высокоприоритетные, а остальные — как низкоприоритетные. Один из побочных
эффектов состоит в том, что после включения низкоприоритетные ядра будут
урезаны (clipped) до более низкой частоты 2600 МГц.

Включение Intel(R) SST-TF
~~~~~~~~~~~~~~~~~~~~~~~~~~

Чтобы включить Intel(R) SST-TF, выполните::

 # intel-speed-select -c 12,13 turbo-freq enable -a
 Intel(R) Speed Select Technology
 Executing on CPU model: X
 package-0
  die-0
    cpu-12
      turbo-freq
        enable:success
 package-0
  die-0
    cpu-13
      turbo-freq
        enable:success
 package--1
  die-0
    cpu-63
      turbo-freq --auto
        enable:success

В этом случае опция "-a" необязательна. Если установлена, она включает функцию
Intel(R) SST-TF, а также устанавливает CPU в высокий и низкий приоритет,
используя функции Intel Speed Select Technology Core Power (Intel(R) SST-CP).
Номера CPU, переданные с аргументами "-c", помечаются как высокоприоритетные,
включая их родственные (sibling).

Если опция -a не используется, то перед включением Intel(R) SST-TF требуются
следующие шаги:

- Обнаружить Intel(R) SST-TF и отметить buckets высокоприоритетных ядер и максимальную частоту

- Включить CLOS, используя набор функций core-power - Настроить параметры CLOS

- Подписать желаемые CPU на группы CLOS, убедившись, что высокоприоритетные ядра установлены на максимальную частоту

Если исполняется та же рабочая нагрузка hackbench, запланируйте потоки
hackbench на высокоприоритетных CPU::

 #taskset -c 12,13 perf bench -r 100 sched pipe
 # Running 'sched/pipe' benchmark:
 # Executed 1000000 pipe operations between two processes
     Total time: 5.510 [sec]
       5.510165 usecs/op
         180826 ops/sec

Это улучшило производительность примерно на 3.3% на занятой системе. Здесь
вывод turbostat покажет, что CPU 12 и CPU 13 получают прирост в 100 МГц. Вывод
turbostat::

 #turbostat -c 0-13 --show Package,Core,CPU,Bzy_MHz -i 1
 Package	Core	CPU	Bzy_MHz
 ...
 0		12	12	3200
 0		13	13	3200
