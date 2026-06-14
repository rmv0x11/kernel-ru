.. SPDX-License-Identifier: GPL-2.0

Руководство по дереву tip
=========================

Что такое дерево tip?
---------------------

Дерево tip — это собрание нескольких подсистем и направлений разработки.
Дерево tip является одновременно деревом непосредственной разработки и
агрегирующим деревом для нескольких деревьев суб-сопровождающих. URL gitweb
дерева tip: https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

Дерево tip содержит следующие подсистемы:

   - **Архитектура x86**

     Разработка архитектуры x86 ведётся в дереве tip, за исключением
     специфичных для x86 частей KVM и XEN, которые сопровождаются в
     соответствующих подсистемах и направляются в mainline напрямую
     оттуда. Тем не менее, хорошей практикой остаётся ставить
     сопровождающих x86 в Cc для специфичных для x86 патчей KVM и XEN.

     Некоторые подсистемы x86 имеют собственных сопровождающих в
     дополнение к общим сопровождающим x86. Пожалуйста, ставьте общих
     сопровождающих x86 в Cc для патчей, затрагивающих файлы в arch/x86,
     даже если они не указаны в файле MAINTAINER.

     Обратите внимание, что ``x86@kernel.org`` не является списком рассылки.
     Это всего лишь почтовый псевдоним, который распределяет письма команде
     сопровождающих x86 верхнего уровня. Пожалуйста, всегда ставьте в Cc
     список рассылки Linux Kernel (LKML) ``linux-kernel@vger.kernel.org``,
     иначе ваше письмо окажется только в личных почтовых ящиках
     сопровождающих.

   - **Планировщик**

     Разработка планировщика ведётся в дереве -tip, в ветке sched/core —
     с периодическим выделением суб-тематических деревьев для наборов
     патчей в работе.

   - **Блокировки и атомарные операции**

     Разработка блокировок (включая атомарные операции и другие примитивы
     синхронизации, связанные с блокировками) ведётся в дереве -tip, в
     ветке locking/core — с периодическим выделением суб-тематических
     деревьев для наборов патчей в работе.

   - **Обобщённая подсистема прерываний и драйверы микросхем прерываний**:

     - разработка ядра прерываний происходит в ветке irq/core

     - разработка драйверов микросхем прерываний также происходит в ветке
       irq/core, но патчи обычно применяются в отдельном дереве
       сопровождающего и затем агрегируются в irq/core

   - **Время, таймеры, отсчёт времени, NOHZ и связанные драйверы микросхем**:

     - разработка отсчёта времени (timekeeping), ядра clocksource, NTP и
       alarmtimer происходит в ветке timers/core, но патчи обычно
       применяются в отдельном дереве сопровождающего и затем агрегируются
       в timers/core

     - разработка драйверов clocksource/event происходит в ветке
       timers/core, но патчи в основном применяются в отдельном дереве
       сопровождающего и затем агрегируются в timers/core

   - **Ядро счётчиков производительности, поддержка архитектур и инструментарий**:

     - разработка ядра perf и поддержки архитектур происходит в ветке
       perf/core

     - разработка инструментария perf происходит в дереве сопровождающего
       инструментов perf и агрегируется в дерево tip.

   - **Ядро горячего подключения CPU (CPU hotplug)**

   - **Ядро RAS**

     Преимущественно специфичные для x86 патчи RAS собираются в ветке
     ras/core дерева tip.

   - **Ядро EFI**

     Разработка EFI ведётся в git-дереве efi. Собранные патчи агрегируются
     в ветке efi/core дерева tip.

   - **RCU**

     Разработка RCU происходит в дереве linux-rcu. Полученные изменения
     агрегируются в ветке core/rcu дерева tip.

   - **Различные компоненты основного кода**:

       - debugobjects

       - objtool

       - разрозненные мелочи


Замечания по отправке патчей
----------------------------

Выбор дерева/ветки
^^^^^^^^^^^^^^^^^^

В общем случае разработка относительно вершины ветки master дерева tip
вполне приемлема, но для подсистем, которые сопровождаются отдельно, имеют
собственное git-дерево и лишь агрегируются в дерево tip, разработку следует
вести относительно соответствующего дерева или ветки подсистемы.

Исправления ошибок, нацеленные на mainline, всегда должны быть применимы к
дереву ядра mainline. Потенциальные конфликты с изменениями, которые уже
поставлены в очередь в дереве tip, разрешаются сопровождающими.

Тема патча
^^^^^^^^^^

Предпочтительный для дерева tip формат префиксов в теме патча —
'subsys/component:', например 'x86/apic:', 'x86/mm/fault:', 'sched/fair:',
'genirq/core:'. Пожалуйста, не используйте имена файлов или полные пути к
файлам в качестве префикса. 'git log path/to/file' в большинстве случаев
даст вам разумную подсказку.

Краткое описание патча в строке темы должно начинаться с заглавной буквы и
должно быть написано в повелительном тоне.


Журнал изменений (changelog)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Применяются общие правила о журналах изменений из :ref:`руководства по
отправке патчей <describe_changes>`.

Сопровождающие дерева tip придают значение следованию этим правилам,
особенно требованию писать журналы изменений в повелительном наклонении и
не олицетворять код или его выполнение. Это не просто прихоть
сопровождающих. Журналы изменений, написанные абстрактными словами, более
точны и обычно вызывают меньше путаницы, чем написанные в форме романов.

Также полезно структурировать журнал изменений на несколько абзацев, а не
сваливать всё в один. Хорошая структура — изложить контекст, проблему и
решение в отдельных абзацах и именно в таком порядке.

Примеры для иллюстрации:

  Пример 1::

    x86/intel_rdt/mbm: Fix MBM overflow handler during hot cpu

    When a CPU is dying, we cancel the worker and schedule a new worker on a
    different CPU on the same domain. But if the timer is already about to
    expire (say 0.99s) then we essentially double the interval.

    We modify the hot cpu handling to cancel the delayed work on the dying
    cpu and run the worker immediately on a different cpu in same domain. We
    do not flush the worker because the MBM overflow worker reschedules the
    worker on same CPU and scans the domain->cpu_mask to get the domain
    pointer.

  Улучшенная версия::

    x86/intel_rdt/mbm: Fix MBM overflow handler during CPU hotplug

    When a CPU is dying, the overflow worker is canceled and rescheduled on a
    different CPU in the same domain. But if the timer is already about to
    expire this essentially doubles the interval which might result in a non
    detected overflow.

    Cancel the overflow worker and reschedule it immediately on a different CPU
    in the same domain. The work could be flushed as well, but that would
    reschedule it on the same CPU.

  Пример 2::

    time: POSIX CPU timers: Ensure that variable is initialized

    If cpu_timer_sample_group returns -EINVAL, it will not have written into
    *sample. Checking for cpu_timer_sample_group's return value precludes the
    potential use of an uninitialized value of now in the following block.
    Given an invalid clock_idx, the previous code could otherwise overwrite
    *oldval in an undefined manner. This is now prevented. We also exploit
    short-circuiting of && to sample the timer only if the result will
    actually be used to update *oldval.

  Улучшенная версия::

    posix-cpu-timers: Make set_process_cpu_timer() more robust

    Because the return value of cpu_timer_sample_group() is not checked,
    compilers and static checkers can legitimately warn about a potential use
    of the uninitialized variable 'now'. This is not a runtime issue as all
    call sites hand in valid clock ids.

    Also cpu_timer_sample_group() is invoked unconditionally even when the
    result is not used because *oldval is NULL.

    Make the invocation conditional and check the return value.

  Пример 3::

    The entity can also be used for other purposes.

    Let's rename it to be more generic.

  Улучшенная версия::

    The entity can also be used for other purposes.

    Rename it to be more generic.


Для сложных сценариев, особенно для состояний гонки (race condition) и
проблем упорядочивания обращений к памяти, полезно изобразить сценарий
таблицей, показывающей параллелизм и временной порядок событий. Вот
пример::

    CPU0                            CPU1
    free_irq(X)                     interrupt X
                                    spin_lock(desc->lock)
                                    wake irq thread()
                                    spin_unlock(desc->lock)
    spin_lock(desc->lock)
    remove action()
    shutdown_irq()
    release_resources()             thread_handler()
    spin_unlock(desc->lock)           access released resources.
                                      ^^^^^^^^^^^^^^^^^^^^^^^^^
    synchronize_irq()

Lockdep выдаёт похожий полезный вывод для изображения возможного сценария
взаимоблокировки (deadlock)::

    CPU0                                    CPU1
    rtmutex_lock(&rcu->rt_mutex)
      spin_lock(&rcu->rt_mutex.wait_lock)
                                            local_irq_disable()
                                            spin_lock(&timer->it_lock)
                                            spin_lock(&rcu->mutex.wait_lock)
    --> Interrupt
        spin_lock(&timer->it_lock)


Ссылки на функции в журналах изменений
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Когда в журнале изменений упоминается функция — будь то в тексте или в
строке темы — пожалуйста, используйте формат 'function_name()'. Опускание
скобок после имени функции может быть неоднозначным::

  Subject: subsys/component: Make reservation_count static

  reservation_count is only used in reservation_stats. Make it static.

Вариант со скобками более точен::

  Subject: subsys/component: Make reservation_count() static

  reservation_count() is only called from reservation_stats(). Make it
  static.


Трассировки стека (backtrace) в журналах изменений
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

См. :ref:`backtraces`.

Порядок тегов коммита
^^^^^^^^^^^^^^^^^^^^^

Чтобы иметь единообразное представление тегов коммита, сопровождающие tip
используют следующую схему упорядочивания тегов:

 - Fixes: 12+char-SHA1 ("sub/sys: Original subject line")

   Тег Fixes следует добавлять даже для изменений, которые не нуждаются в
   бэкпорте в стабильные ядра, то есть когда устраняется недавно
   возникшая проблема, затрагивающая только tip или текущую вершину
   mainline. Эти теги помогают идентифицировать исходный коммит и гораздо
   ценнее, чем заметное упоминание коммита, который внёс проблему, в самом
   тексте журнала изменений, поскольку их можно извлекать автоматически.

   Следующий пример иллюстрирует разницу::

     Commit

       abcdef012345678 ("x86/xxx: Replace foo with bar")

     left an unused instance of variable foo around. Remove it.

     Signed-off-by: J.Dev <j.dev@mail>

   Пожалуйста, напишите вместо этого::

     The recent replacement of foo with bar left an unused instance of
     variable foo around. Remove it.

     Fixes: abcdef012345678 ("x86/xxx: Replace foo with bar")
     Signed-off-by: J.Dev <j.dev@mail>

   Последний вариант помещает в фокус информацию о патче и дополняет её
   ссылкой на коммит, который внёс проблему, вместо того чтобы изначально
   ставить в фокус исходный коммит.

 - Reported-by: ``Reporter <reporter@mail>``

 - Closes: ``URL or Message-ID of the bug report this is fixing``

 - Originally-by: ``Original author <original-author@mail>``

 - Suggested-by: ``Suggester <suggester@mail>``

 - Co-developed-by: ``Co-author <co-author@mail>``

   Signed-off-by: ``Co-author <co-author@mail>``

   Обратите внимание, что Co-developed-by и Signed-off-by соавтора(ов)
   должны идти парами.

 - Signed-off-by: ``Author <author@mail>``

   Первый Signed-off-by (SOB) после последней пары Co-developed-by/SOB — это
   SOB автора, то есть человека, отмеченного автором в git.

 - Signed-off-by: ``Patch handler <handler@mail>``

   SOB после SOB автора принадлежат людям, обрабатывающим и
   транспортирующим патч, но не участвовавшим в разработке. Цепочки SOB
   должны отражать **реальный** путь, который патч прошёл при доставке к
   нам, причём первая запись SOB сигнализирует об основном авторстве
   единственного автора. Подтверждения (acks) следует давать строками
   Acked-by, а одобрения по результатам рецензирования — строками
   Reviewed-by.

   Если обработчик внёс изменения в патч или журнал изменений, то это
   следует упомянуть **после** текста журнала изменений и **над** всеми
   тегами коммита в следующем формате::

     ... changelog text ends.

     [ handler: Replaced foo by bar and updated changelog ]

     First-tag: .....

   Обратите внимание на две пустые новые строки, которые отделяют текст
   журнала изменений и теги коммита от этой пометки.

   Если патч отправляется в список рассылки обработчиком, то автор должен
   быть указан в первой строке журнала изменений с помощью::

     From: Author <author@mail>

     Changelog text starts here....

   чтобы авторство сохранилось. За строкой 'From:' должна следовать
   пустая новая строка. Если эта строка 'From:' отсутствует, то патч будет
   приписан человеку, который его отправил (транспортировал, обработал).
   Строка 'From:' автоматически удаляется при применении патча и не
   появляется в итоговом журнале изменений git. Она лишь влияет на
   информацию об авторстве итогового коммита Git.

 - Tested-by: ``Tester <tester@mail>``

 - Reviewed-by: ``Reviewer <reviewer@mail>``

 - Acked-by: ``Acker <acker@mail>``

 - Cc: ``cc-ed-person <person@mail>``

   Если патч следует бэкпортировать в стабильные ядра, то, пожалуйста,
   добавьте тег '``Cc: stable@vger.kernel.org``', но не ставьте stable в Cc
   при отправке вашего письма.

 - Link: ``https://link/to/information``

   Для ссылки на письмо, опубликованное в списках рассылки ядра,
   пожалуйста, используйте URL-перенаправитель lore.kernel.org::

     Link: https://lore.kernel.org/email-message-id@here

   Этот URL следует использовать при ссылке на относящиеся к делу темы
   списка рассылки, связанные наборы патчей или другие примечательные
   обсуждения. Удобный способ связать трейлеры ``Link:`` с сообщением
   коммита — использовать markdown-подобную нотацию в квадратных скобках,
   например::

     A similar approach was attempted before as part of a different
     effort [1], but the initial implementation caused too many
     regressions [2], so it was backed out and reimplemented.

     Link: https://lore.kernel.org/some-msgid@here # [1]
     Link: https://bugzilla.example.org/bug/12345  # [2]

   Вы также можете использовать трейлеры ``Link:`` для указания
   происхождения патча при применении его в ваше git-дерево. В этом случае,
   пожалуйста, используйте выделенный домен ``patch.msgid.link`` вместо
   ``lore.kernel.org``. Эта практика позволяет автоматизированным
   инструментам определять, какую ссылку использовать для получения
   исходной отправки патча. Например::

     Link: https://patch.msgid.link/patch-source-message-id@here

Пожалуйста, не используйте объединённые теги, например
``Reported-and-tested-by``, так как они лишь усложняют автоматическое
извлечение тегов.


Ссылки на документацию
^^^^^^^^^^^^^^^^^^^^^^

Предоставление ссылок на документацию в журнале изменений — большое
подспорье для последующей отладки и анализа. К сожалению, URL-адреса часто
очень быстро ломаются, потому что компании часто реструктурируют свои
веб-сайты. К «нелетучим» исключениям относятся Intel SDM и AMD APM.

Поэтому для «летучих» документов, пожалуйста, создайте запись в bugzilla
ядра https://bugzilla.kernel.org и приложите копию этих документов к
записи bugzilla. Наконец, укажите URL записи bugzilla в журнале изменений.

Повторная отправка патча или напоминания
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

См. :ref:`resend_reminders`.

Окно слияния (merge window)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Пожалуйста, не ожидайте, что патчи будут рецензированы или слиты
сопровождающими tip незадолго до окна слияния или во время него. В это
время деревья закрыты для всего, кроме срочных исправлений. Они снова
открываются, как только окно слияния закрывается и выпускается новое ядро
-rc1.

Большие серии следует отправлять в пригодном для слияния состоянии *по*
*меньшей* мере за неделю до открытия окна слияния. Исключения делаются для
исправлений ошибок и *иногда* для небольших самостоятельных драйверов для
нового оборудования или минимально инвазивных патчей для введения
оборудования в строй.

Во время окна слияния сопровождающие вместо этого сосредотачиваются на
отслеживании изменений в upstream, исправлении последствий окна слияния,
сборе исправлений ошибок и небольшой передышке. Пожалуйста, отнеситесь к
этому с уважением.

Так называемые ветки _urgent_ сливаются в mainline во время фазы
стабилизации каждого релиза.


Git
^^^

Сопровождающие tip принимают git-запросы на включение (pull requests) от
сопровождающих, предоставляющих изменения подсистем для агрегации в дерево
tip.

Запросы на включение для новых отправок патчей обычно не принимаются и не
заменяют надлежащую отправку патчей в список рассылки. Основная причина
этого в том, что рабочий процесс рецензирования основан на электронной
почте.

Если вы отправляете большую серию патчей, полезно предоставить git-ветку в
приватном репозитории, что позволяет заинтересованным людям легко получить
серию для тестирования. Обычный способ предложить это — указать git-URL в
сопроводительном письме (cover letter) серии патчей.

Тестирование
^^^^^^^^^^^^

Код следует тестировать перед отправкой сопровождающим tip. Всё, кроме
незначительных изменений, должно быть собрано, загружено и протестировано с
включёнными всеобъемлющими (и тяжеловесными) опциями отладки ядра.

Эти опции отладки можно найти в kernel/configs/x86_debug.config, и их можно
добавить к существующей конфигурации ядра, выполнив:

	make x86_debug.config

Некоторые из этих опций специфичны для x86 и могут быть опущены при
тестировании на других архитектурах.

.. _maintainer-tip-coding-style:

Замечания по стилю кода
-----------------------

Стиль комментариев
^^^^^^^^^^^^^^^^^^

Предложения в комментариях начинаются с заглавной буквы.

Однострочные комментарии::

	/* This is a single line comment */

Многострочные комментарии::

	/*
	 * This is a properly formatted
	 * multi-line comment.
	 *
	 * Larger multi-line comments should be split into paragraphs.
	 */

Без хвостовых комментариев (см. ниже):

  Пожалуйста, воздержитесь от использования хвостовых комментариев.
  Хвостовые комментарии нарушают плавность чтения почти во всех контекстах,
  но особенно в коде::

	if (somecondition_is_true) /* Don't put a comment here */
		dostuff(); /* Neither here */

	seed = MAGIC_CONSTANT; /* Nor here */

  Вместо этого используйте отдельно стоящие комментарии::

	/* This condition is not obvious without a comment */
	if (somecondition_is_true) {
		/* This really needs to be documented */
		dostuff();
	}

	/* This magic initialization needs a comment. Maybe not? */
	seed = MAGIC_CONSTANT;

  При документировании структур в заголовочных файлах используйте хвостовые
  комментарии в стиле C++ для достижения более компактного расположения и
  лучшей читаемости::

        // eax
        u32     x2apic_shift    :  5, // Number of bits to shift APIC ID right
                                      // for the topology ID at the next level
                                : 27; // Reserved
        // ebx
        u32     num_processors  : 16, // Number of processors at current level
                                : 16; // Reserved

  в противовес::

	/* eax */
	        /*
	         * Number of bits to shift APIC ID right for the topology ID
	         * at the next level
	         */
         u32     x2apic_shift    :  5,
		 /* Reserved */
				 : 27;

	/* ebx */
		/* Number of processors at current level */
	u32     num_processors  : 16,
		/* Reserved */
				: 16;

Комментируйте важные вещи:

  Комментарии следует добавлять там, где операция неочевидна.
  Документирование очевидного — лишь отвлечение::

	/* Decrement refcount and check for zero */
	if (refcount_dec_and_test(&p->refcnt)) {
		do;
		lots;
		of;
		magic;
		things;
	}

  Вместо этого комментарии должны объяснять неочевидные детали и
  документировать ограничения::

	if (refcount_dec_and_test(&p->refcnt)) {
		/*
		 * Really good explanation why the magic things below
		 * need to be done, ordering and locking constraints,
		 * etc..
		 */
		do;
		lots;
		of;
		magic;
		/* Needs to be the last operation because ... */
		things;
	}

Комментарии-документация функций:

  Для документирования функций и их аргументов, пожалуйста, используйте
  формат kernel-doc, а не свободные комментарии::

	/**
	 * magic_function - Do lots of magic stuff
	 * @magic:	Pointer to the magic data to operate on
	 * @offset:	Offset in the data array of @magic
	 *
	 * Deep explanation of mysterious things done with @magic along
         * with documentation of the return values.
	 *
	 * Note, that the argument descriptors above are arranged
	 * in a tabular fashion.
	 */

  Это особенно касается глобально видимых функций и inline-функций в
  публичных заголовочных файлах. Использование формата kernel-doc для каждой
  (статической) функции, нуждающейся в крошечном пояснении, может быть
  избыточным. Использование описательных имён функций часто заменяет эти
  крошечные комментарии. Как всегда, руководствуйтесь здравым смыслом.


Документирование требований к блокировкам
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  Документирование требований к блокировкам — хорошее дело, но комментарии
  не обязательно лучший выбор. Вместо того чтобы писать::

	/* Caller must hold foo->lock */
	void func(struct foo *foo)
	{
		...
	}

  Пожалуйста, используйте::

	void func(struct foo *foo)
	{
		lockdep_assert_held(&foo->lock);
		...
	}

  В ядрах с PROVE_LOCKING функция lockdep_assert_held() выдаёт
  предупреждение, если вызывающая сторона не держит блокировку. Комментарии
  на такое не способны.

Правила скобок
^^^^^^^^^^^^^^

Скобки следует опускать только если оператор, следующий за 'if', 'for',
'while' и т. п., действительно является единственной строкой::

	if (foo)
		do_something();

Следующее не считается оператором в одну строку, даже несмотря на то, что C
не требует скобок::

	for (i = 0; i < end; i++)
		if (foo[i])
			do_something(foo[i]);

Добавление скобок вокруг внешнего цикла улучшает плавность чтения::

	for (i = 0; i < end; i++) {
		if (foo[i])
			do_something(foo[i]);
	}


Объявления переменных
^^^^^^^^^^^^^^^^^^^^^

Предпочтительный порядок объявлений переменных в начале функции — порядок
перевёрнутой ёлки::

	struct long_struct_name *descriptive_name;
	unsigned long foo, bar;
	unsigned int tmp;
	int ret;

Приведённое выше разбирается быстрее, чем обратный порядок::

	int ret;
	unsigned int tmp;
	unsigned long foo, bar;
	struct long_struct_name *descriptive_name;

И тем более быстрее, чем случайный порядок::

	unsigned long foo, bar;
	int ret;
	struct long_struct_name *descriptive_name;
	unsigned int tmp;

Также, пожалуйста, старайтесь объединять переменные одного типа в одну
строку. Нет смысла тратить место на экране::

	unsigned long a;
	unsigned long b;
	unsigned long c;
	unsigned long d;

Вполне достаточно написать::

	unsigned long a, b, c, d;

Пожалуйста, также воздержитесь от введения разрывов строк в объявлениях
переменных::

	struct long_struct_name *descriptive_name = container_of(bar,
						      struct long_struct_name,
	                                              member);
	struct foobar foo;

Гораздо лучше перенести инициализацию в отдельную строку после объявлений::

	struct long_struct_name *descriptive_name;
	struct foobar foo;

	descriptive_name = container_of(bar, struct long_struct_name, member);


Типы переменных
^^^^^^^^^^^^^^^

Пожалуйста, используйте надлежащие типы u8, u16, u32, u64 для переменных,
которые предназначены для описания оборудования или используются в качестве
аргументов функций, обращающихся к оборудованию. Эти типы чётко определяют
разрядность и позволяют избежать усечения, расширения и путаницы 32/64 бит.

u64 также рекомендуется в коде, который стал бы неоднозначным для 32-битных
ядер при использовании вместо него 'unsigned long'. Хотя в таких ситуациях
можно было бы использовать и 'unsigned long long', u64 короче и к тому же
ясно показывает, что операция должна быть шириной 64 бита независимо от
целевого CPU.

Пожалуйста, используйте 'unsigned int' вместо 'unsigned'.


Константы
^^^^^^^^^

Пожалуйста, не используйте в коде или инициализаторах литеральные
(шестнадцатеричные) десятичные числа. Либо используйте надлежащие
определения с описательными именами, либо рассмотрите использование enum.


Объявления структур и инициализаторы
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Объявления структур должны выравнивать имена членов структуры в табличной
форме::

	struct bar_order {
		unsigned int	guest_id;
		int		ordered_item;
		struct menu	*menu;
	};

Пожалуйста, избегайте документирования членов структуры внутри объявления,
потому что это часто приводит к странно отформатированным комментариям, а
члены структуры становятся менее различимыми::

	struct bar_order {
		unsigned int	guest_id; /* Unique guest id */
		int		ordered_item;
		/* Pointer to a menu instance which contains all the drinks */
		struct menu	*menu;
	};

Вместо этого, пожалуйста, рассмотрите использование формата kernel-doc в
комментарии, предшествующем объявлению структуры, что легче читать и имеет
дополнительное преимущество включения информации в документацию ядра,
например, следующим образом::


	/**
	 * struct bar_order - Description of a bar order
	 * @guest_id:		Unique guest id
	 * @ordered_item:	The item number from the menu
	 * @menu:		Pointer to the menu from which the item
	 *  			was ordered
	 *
	 * Supplementary information for using the struct.
	 *
	 * Note, that the struct member descriptors above are arranged
	 * in a tabular fashion.
	 */
	struct bar_order {
		unsigned int	guest_id;
		int		ordered_item;
		struct menu	*menu;
	};

Статические инициализаторы структур должны использовать инициализаторы C99
и также должны быть выровнены в табличной форме::

	static struct foo statfoo = {
		.a		= 0,
		.plain_integer	= CONSTANT_DEFINE_OR_ENUM,
		.bar		= &statbar,
	};

Обратите внимание, что хотя синтаксис C99 допускает опускание последней
запятой, мы рекомендуем использовать запятую на последней строке, потому
что это упрощает переупорядочивание и добавление новых строк, а также
немного облегчает чтение таких будущих патчей.

Разрывы строк
^^^^^^^^^^^^^

Ограничение длины строки 80 символами делает код с глубокими отступами
трудночитаемым. Рассмотрите вынос кода в вспомогательные функции, чтобы
избежать чрезмерных разрывов строк.

Правило 80 символов не является строгим правилом, поэтому, пожалуйста,
руководствуйтесь здравым смыслом при разбиении строк. В частности, строки
формата никогда не следует разбивать.

При разбиении объявлений функций или вызовов функций, пожалуйста,
выравнивайте первый аргумент во второй строке с первым аргументом в первой
строке::

  static int long_function_name(struct foobar *barfoo, unsigned int id,
				unsigned int offset)
  {

	if (!id) {
		ret = longer_function_name(barfoo, DEFAULT_BARFOO_ID,
					   offset);
	...

Пространства имён
^^^^^^^^^^^^^^^^^

Пространства имён функций/переменных улучшают читаемость и упрощают поиск
через grep. Эти пространства имён представляют собой строковые префиксы для
глобально видимых имён функций и переменных, включая inline. Эти префиксы
должны объединять имя подсистемы и компонента, например 'x86_comp\_',
'sched\_', 'irq\_' и 'mutex\_'.

Это касается также статических функций файловой области видимости, которые
непосредственно помещаются в глобально видимые шаблоны драйверов — для таких
символов также полезно нести хороший префикс, ради читаемости трассировок
стека.

Префиксы пространств имён можно опускать для локальных статических функций и
переменных. Действительно локальные функции, вызываемые только другими
локальными функциями, могут иметь более короткие описательные имена — наша
основная забота — это удобство поиска через grep и читаемость трассировок
стека.

Пожалуйста, обратите внимание, что префиксы 'xxx_vendor\_' и 'vendor_xxx_`
бесполезны для статических функций в специфичных для вендора файлах. В конце
концов, и так уже ясно, что код специфичен для вендора. Кроме того, имена
вендоров следует использовать только для действительно специфичной для
вендора функциональности.

Как всегда, руководствуйтесь здравым смыслом и стремитесь к
последовательности и читаемости.


Уведомления о коммитах
----------------------

Дерево tip отслеживается ботом на предмет новых коммитов. Бот отправляет
письмо для каждого нового коммита в выделенный список рассылки
(``linux-tip-commits@vger.kernel.org``) и ставит в Cc всех людей, которые
упомянуты в одном из тегов коммита. Он использует email message ID из тега
Link в конце списка тегов для установки заголовка письма In-Reply-To, так
что сообщение корректно объединяется в цепочку с письмом отправки патча.

Сопровождающие tip и суб-сопровождающие стараются ответить отправителю при
слиянии патча, но иногда они забывают или это не вписывается в рабочий
процесс текущего момента. Хотя сообщение бота сугубо механическое, оно также
подразумевает «Спасибо! Применено.».
