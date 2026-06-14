.. title:: Kernel-doc comments

=================================
Написание комментариев kernel-doc
=================================

Файлы исходного кода ядра Linux могут содержать структурированные
комментарии документации в формате kernel-doc для описания функций, типов
и устройства кода. Документацию проще поддерживать в актуальном состоянии,
когда она встроена в файлы исходного кода.

.. note:: Формат kernel-doc обманчиво похож на javadoc,
   gtk-doc или Doxygen, но при этом заметно от них отличается по
   историческим причинам. Исходный код ядра содержит десятки тысяч
   комментариев kernel-doc. Пожалуйста, придерживайтесь описанного здесь стиля.

.. note:: kernel-doc не охватывает код на Rust: вместо этого см.
   Documentation/rust/general-information.rst.

Структура kernel-doc извлекается из комментариев, и на их основе
генерируются корректные описания функций и типов `Sphinx C Domain`_ с
якорями. Описания фильтруются для обработки специальных выделений kernel-doc
и перекрёстных ссылок. Подробности см. ниже.

.. _Sphinx C Domain: http://www.sphinx-doc.org/en/stable/domains.html

Каждая функция, экспортируемая в загружаемые модули с помощью
``EXPORT_SYMBOL`` или ``EXPORT_SYMBOL_GPL``, должна иметь комментарий
kernel-doc. Функции и структуры данных в заголовочных файлах, предназначенные
для использования модулями, также должны иметь комментарии kernel-doc.

Хорошей практикой является также предоставление документации в формате
kernel-doc для функций, видимых снаружи другим файлам ядра (не помеченных
``static``). Мы также рекомендуем предоставлять документацию в формате
kernel-doc для приватных (файловых ``static``) подпрограмм — ради
единообразия оформления исходного кода ядра. Это имеет меньший приоритет и
остаётся на усмотрение сопровождающего (maintainer) данного файла исходного
кода ядра.

Как оформлять комментарии kernel-doc
------------------------------------

Открывающая метка комментария ``/**`` используется для комментариев kernel-doc.
Инструмент ``kernel-doc`` извлекает комментарии, помеченные таким образом.
Остальная часть комментария оформляется как обычный многострочный комментарий
со столбцом звёздочек по левому краю и закрывается ``*/`` на отдельной строке.

Комментарии kernel-doc для функций и типов следует размещать непосредственно
перед описываемой функцией или типом, чтобы максимально повысить вероятность
того, что человек, изменяющий код, также изменит и документацию. Обзорные
комментарии kernel-doc можно размещать где угодно на верхнем уровне отступа.

Запуск инструмента ``kernel-doc`` с повышенной детализацией и без фактической
генерации вывода может использоваться для проверки правильности оформления
комментариев документации. Например::

	tools/docs/kernel-doc -v -none drivers/foo/bar.c

Формат документации файлов ``.c`` также проверяется при сборке ядра, когда
запрашивается выполнение дополнительных проверок gcc::

	make W=n

Однако приведённая выше команда не проверяет заголовочные файлы. Их следует
проверять отдельно с помощью ``kernel-doc``.

Документирование функций
------------------------

Общий формат комментария kernel-doc для функции и функциеподобного макроса::

  /**
   * function_name() - Brief description of function.
   * @arg1: Describe the first argument.
   * @arg2: Describe the second argument.
   *        One can provide multiple line descriptions
   *        for arguments.
   *
   * A longer description, with more discussion of the function function_name()
   * that might be useful to those using or modifying it. Begins with an
   * empty comment line, and may include additional embedded empty
   * comment lines.
   *
   * The longer description may have multiple paragraphs.
   *
   * Context: Describes whether the function can sleep, what locks it takes,
   *          releases, or expects to be held. It can extend over multiple
   *          lines.
   * Return: Describe the return value of function_name.
   *
   * The return value description can also have multiple paragraphs, and should
   * be placed at the end of the comment block.
   */

Краткое описание, следующее за именем функции, может занимать несколько строк
и заканчивается описанием аргумента, пустой строкой комментария или концом
блока комментария.

Параметры функции
~~~~~~~~~~~~~~~~~~

Каждый аргумент функции следует описывать по порядку, сразу после краткого
описания функции.  Не оставляйте пустую строку между описанием функции и
аргументами, а также между аргументами.

Каждое описание ``@argument:`` может занимать несколько строк.

.. note::

   Если описание ``@argument`` состоит из нескольких строк, продолжение
   описания должно начинаться с той же позиции (столбца), что и предыдущая
   строка::

      * @argument: some long description
      *            that continues on next lines

   или::

      * @argument:
      *		some long description
      *		that continues on next lines

Если функция имеет переменное число аргументов, её описание следует записывать
в нотации kernel-doc так::

      * @...: description

Контекст функции
~~~~~~~~~~~~~~~~~

Контекст, в котором может быть вызвана функция, следует описывать в секции
с именем ``Context``. Сюда должно входить указание на то, может ли функция
засыпать (sleep) или быть вызвана из контекста прерывания, а также какие
блокировки она захватывает, освобождает и какие ожидает удерживаемыми
вызывающей стороной.

Примеры::

  * Context: Any context.
  * Context: Any context. Takes and releases the RCU lock.
  * Context: Any context. Expects <lock> to be held by caller.
  * Context: Process context. May sleep if @gfp flags permit.
  * Context: Process context. Takes and releases <mutex>.
  * Context: Softirq or process context. Takes and releases <lock>, BH-safe.
  * Context: Interrupt context.

Возвращаемые значения
~~~~~~~~~~~~~~~~~~~~~~

Возвращаемое значение, если оно есть, следует описывать в выделенной секции
с именем ``Return`` (или ``Returns``).

.. note::

  #) Предоставляемый вами многострочный описательный текст *не* распознаёт
     переносы строк, поэтому, если вы попытаетесь красиво отформатировать
     некоторый текст, как здесь::

	* Return:
	* %0 - OK
	* %-EINVAL - invalid argument
	* %-ENOMEM - out of memory

     всё это сольётся воедино и даст в результате::

	Return: 0 - OK -EINVAL - invalid argument -ENOMEM - out of memory

     Поэтому, чтобы получить нужные переносы строк, необходимо использовать
     список ReST, например::

      * Return:
      * * %0		- OK to runtime suspend the device
      * * %-EBUSY	- Device should not be runtime suspended

  #) Если в предоставляемом вами описательном тексте есть строки, которые
     начинаются с некоторой фразы, за которой следует двоеточие, каждая из
     этих фраз будет воспринята как новый заголовок секции, что, вероятно,
     не даст желаемого эффекта.

Документирование структур, объединений и перечислений
-----------------------------------------------------

Общий формат комментария kernel-doc для ``struct``, ``union`` и ``enum``::

  /**
   * struct struct_name - Brief description.
   * @member1: Description of member1.
   * @member2: Description of member2.
   *           One can provide multiple line descriptions
   *           for members.
   *
   * Description of the structure.
   */

В приведённом выше примере ``struct`` можно заменить на ``union`` или
``enum``  для описания объединений или перечислений. ``member`` используется
для обозначения имён членов ``struct`` и ``union``, а также элементов
перечисления в ``enum``.

Краткое описание, следующее за именем структуры, может занимать несколько
строк и заканчивается описанием члена, пустой строкой комментария или концом
блока комментария.

Члены
~~~~~

Члены структур, объединений и перечислений следует документировать так же,
как параметры функций; они идут сразу за кратким описанием и могут быть
многострочными.

Внутри описания ``struct`` или ``union`` можно использовать теги комментариев
``private:`` и ``public:``. Поля структуры, находящиеся в области ``private:``,
не отображаются в сгенерированной выходной документации.

Теги ``private:`` и ``public:`` должны начинаться сразу после метки
комментария ``/*``. По желанию они могут включать комментарии между ``:`` и
завершающей меткой ``*/``.

Пример::

  /**
   * struct my_struct - short description
   * @a: first member
   * @b: second member
   * @d: fourth member
   *
   * Longer description
   */
  struct my_struct {
      int a;
      int b;
  /* private: internal use only */
      int c;
  /* public: the next one is public */
      int d;
  };

Вложенные структуры/объединения
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Вложенные структуры и объединения тоже можно документировать, например::

      /**
       * struct nested_foobar - a struct with nested unions and structs
       * @memb1: first member of anonymous union/anonymous struct
       * @memb2: second member of anonymous union/anonymous struct
       * @memb3: third member of anonymous union/anonymous struct
       * @memb4: fourth member of anonymous union/anonymous struct
       * @bar: non-anonymous union
       * @bar.st1: struct st1 inside @bar
       * @bar.st2: struct st2 inside @bar
       * @bar.st1.memb1: first member of struct st1 on union bar
       * @bar.st1.memb2: second member of struct st1 on union bar
       * @bar.st2.memb1: first member of struct st2 on union bar
       * @bar.st2.memb2: second member of struct st2 on union bar
       */
      struct nested_foobar {
        /* Anonymous union/struct*/
        union {
          struct {
            int memb1;
            int memb2;
          };
          struct {
            void *memb3;
            int memb4;
          };
        };
        union {
          struct {
            int memb1;
            int memb2;
          } st1;
          struct {
            void *memb1;
            int memb2;
          } st2;
        } bar;
      };

.. note::

   #) При документировании вложенных структур или объединений, если
      ``struct``/``union`` ``foo`` имеет имя, член ``bar`` внутри неё/него
      должен документироваться как ``@foo.bar:``
   #) Когда вложенная ``struct``/``union`` анонимна, член ``bar`` в ней
      должен документироваться как ``@bar:``

Встроенные (in-line) комментарии документации членов
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Члены структуры также можно документировать встроенно прямо внутри
определения. Есть два стиля: однострочные комментарии, где открывающая ``/**``
и закрывающая ``*/`` метки находятся на одной строке, и многострочные
комментарии, где каждая из них находится на отдельной строке, как и все
прочие комментарии kernel-doc::

  /**
   * struct foo - Brief description.
   * @foo: The Foo member.
   */
  struct foo {
        int foo;
        /**
         * @bar: The Bar member.
         */
        int bar;
        /**
         * @baz: The Baz member.
         *
         * Here, the member description may contain several paragraphs.
         */
        int baz;
        union {
                /** @foobar: Single line description. */
                int foobar;
        };
        /** @bar2: Description for struct @bar2 inside @foo */
        struct {
                /**
                 * @bar2.barbar: Description for @barbar inside @foo.bar2
                 */
                int barbar;
        } bar2;
  };

Документирование typedef
------------------------

Общий формат комментария kernel-doc для ``typedef``::

  /**
   * typedef type_name - Brief description.
   *
   * Description of the type.
   */

Также можно документировать typedef с прототипами функций::

  /**
   * typedef type_name - Brief description.
   * @arg1: description of arg1
   * @arg2: description of arg2
   *
   * Description of the type.
   *
   * Context: Locking context.
   * Returns: Meaning of the return value.
   */
   typedef void (*type_name)(struct v4l2_ctrl *arg1, void *arg2);

Документирование переменных
---------------------------

Общий формат комментария kernel-doc для переменной::

  /**
   * var var_name - Brief description.
   *
   * Description of the var_name variable.
   */
   extern int var_name;

Документирование объектоподобных макросов
-----------------------------------------

Объектоподобные макросы отличаются от функциеподобных макросов. Они
различаются по тому, следует ли сразу за именем макроса левая круглая скобка
('(') — для функциеподобных макросов — или нет — для объектоподобных макросов.

Функциеподобные макросы обрабатываются инструментом ``tools/docs/kernel-doc``
как функции. У них может быть список параметров. У объектоподобных макросов
списка параметров нет.

Общий формат комментария kernel-doc для объектоподобного макроса::

  /**
   * define object_name - Brief description.
   *
   * Description of the object.
   */

Пример::

  /**
   * define MAX_ERRNO - maximum errno value that is supported
   *
   * Kernel pointers have redundant information, so we can use a
   * scheme where we can return either an error code or a normal
   * pointer with the same return value.
   */
  #define MAX_ERRNO	4095

Пример::

  /**
   * define DRM_GEM_VRAM_PLANE_HELPER_FUNCS - \
   *	Initializes struct drm_plane_helper_funcs for VRAM handling
   *
   * This macro initializes struct drm_plane_helper_funcs to use the
   * respective helper functions.
   */
  #define DRM_GEM_VRAM_PLANE_HELPER_FUNCS \
	.prepare_fb = drm_gem_vram_plane_helper_prepare_fb, \
	.cleanup_fb = drm_gem_vram_plane_helper_cleanup_fb


Выделения и перекрёстные ссылки
-------------------------------

В описательном тексте комментария kernel-doc распознаются следующие
специальные шаблоны, которые преобразуются в надлежащую разметку
reStructuredText и ссылки `Sphinx C Domain`_.

.. attention:: Перечисленное ниже распознаётся **только** внутри комментариев
	       kernel-doc, **но не** внутри обычных документов reStructuredText.

``funcname()``
  Ссылка на функцию.

``@parameter``
  Имя параметра функции. (Без перекрёстных ссылок, только форматирование.)

``%CONST``
  Имя константы. (Без перекрёстных ссылок, только форматирование.)

  Примеры::

    %0    %NULL    %-1    %-EFAULT    %-EINVAL    %-ENOMEM

````literal````
  Литеральный блок, который следует обрабатывать как есть. В выводе будет
  использован ``моноширинный шрифт``.

  Полезно, если требуется использовать специальные символы, которые иначе
  имели бы какое-либо значение либо для скрипта kernel-doc, либо для
  reStructuredText.

  Это особенно полезно, если внутри описания функции нужно использовать что-то
  вроде ``%ph``.

``$ENVVAR``
  Имя переменной окружения. (Без перекрёстных ссылок, только форматирование.)

``&struct name``
  Ссылка на структуру.

``&enum name``
  Ссылка на перечисление (enum).

``&typedef name``
  Ссылка на typedef.

``&struct_name->member`` или ``&struct_name.member``
  Ссылка на член ``struct`` или ``union``. Перекрёстная ссылка будет вести
  к определению ``struct`` или ``union``, а не непосредственно к члену.

``&name``
  Обобщённая ссылка на тип. Предпочтительнее использовать полную форму ссылки,
  описанную выше. Эта форма предназначена в основном для устаревших
  комментариев.

Перекрёстные ссылки из reStructuredText
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Для перекрёстных ссылок на функции и типы, определённые в комментариях
kernel-doc, из документов reStructuredText не требуется никакого
дополнительного синтаксиса.
Просто завершайте имена функций ``()`` и пишите ``struct``, ``union``,
``enum`` или ``typedef`` перед типами.
Например::

  See foo().
  See struct foo.
  See union bar.
  See enum baz.
  See typedef meh.

Однако, если требуется пользовательский текст в ссылке перекрёстной ссылки,
это можно сделать с помощью следующего синтаксиса::

  See :c:func:`my custom link text for function foo <foo>`.
  See :c:type:`my custom link text for struct bar <bar>`.

Дополнительные подробности см. в документации `Sphinx C Domain`_.

.. note::
   Переменные не подвергаются перекрёстному ссыланию автоматически. Для них
   нужно явно добавить перекрёстную ссылку C domain.

Обзорные комментарии документации
---------------------------------

Чтобы облегчить размещение исходного кода и комментариев рядом, вы можете
включать блоки документации kernel-doc, которые являются комментариями
свободной формы, а не kernel-doc для функций, структур, объединений,
перечислений, typedef или переменных. Это можно использовать, например, для
описания принципа работы (theory of operation) драйвера или библиотечного
кода.

Это делается с помощью ключевого слова секции ``DOC:`` с заголовком секции.

Общий формат обзорного или высокоуровневого комментария документации::

  /**
   * DOC: Theory of Operation
   *
   * The whizbang foobar is a dilly of a gizmo. It can do whatever you
   * want it to do, at any time. It reads your mind. Here's how it works.
   *
   * foo bar splat
   *
   * The only drawback to this gizmo is that is can sometimes damage
   * hardware, software, or its subject(s).
   */

Заголовок, следующий за ``DOC:``, выступает в роли заголовка внутри файла
исходного кода, а также как идентификатор для извлечения комментария
документации. Поэтому заголовок должен быть уникальным в пределах файла.

=================================
Включение комментариев kernel-doc
=================================

Комментарии документации могут включаться в любые документы reStructuredText
с помощью специального расширения-директивы kernel-doc для Sphinx.

Директива kernel-doc имеет формат::

  .. kernel-doc:: source
     :option:

*source* — это путь к файлу исходного кода относительно дерева исходного кода
ядра. Поддерживаются следующие опции директивы:

export: *[source-pattern ...]*
  Включить документацию для всех функций в *source*, которые были
  экспортированы с помощью ``EXPORT_SYMBOL`` или ``EXPORT_SYMBOL_GPL`` либо
  в *source*, либо в любом из файлов, указанных шаблоном *source-pattern*.

  *source-pattern* полезен, когда комментарии kernel-doc размещены в
  заголовочных файлах, а ``EXPORT_SYMBOL`` и ``EXPORT_SYMBOL_GPL`` находятся
  рядом с определениями функций.

  Примеры::

    .. kernel-doc:: lib/bitmap.c
       :export:

    .. kernel-doc:: include/net/mac80211.h
       :export: net/mac80211/*.c

internal: *[source-pattern ...]*
  Включить документацию для всех функций и типов в *source*, которые
  **не** были экспортированы с помощью ``EXPORT_SYMBOL`` или
  ``EXPORT_SYMBOL_GPL`` либо в *source*, либо в любом из файлов, указанных
  шаблоном *source-pattern*.

  Пример::

    .. kernel-doc:: drivers/gpu/drm/i915/intel_audio.c
       :internal:

identifiers: *[ function/type ...]*
  Включить документацию для каждой *функции* и каждого *типа* в *source*.
  Если *функция* не указана, будет включена документация для всех функций
  и типов в *source*.
  *type* может быть идентификатором ``struct``, ``union``, ``enum``,
  ``typedef`` или ``var``.

  Примеры::

    .. kernel-doc:: lib/bitmap.c
       :identifiers: bitmap_parselist bitmap_parselist_user

    .. kernel-doc:: lib/idr.c
       :identifiers:

no-identifiers: *[ function/type ...]*
  Исключить документацию для каждой *функции* и каждого *типа* в *source*.

  Пример::

    .. kernel-doc:: lib/bitmap.c
       :no-identifiers: bitmap_parselist

functions: *[ function/type ...]*
  Это псевдоним директивы 'identifiers'; считается устаревшим.

doc: *title*
  Включить документацию для абзаца ``DOC:``, идентифицируемого по *title*
  в *source*. В *title* допускаются пробелы; не заключайте *title* в кавычки.
  *title* используется только как идентификатор абзаца и не включается в
  вывод. Пожалуйста, убедитесь, что в охватывающем документе reStructuredText
  есть подходящий заголовок.

  Пример::

    .. kernel-doc:: drivers/gpu/drm/i915/intel_audio.c
       :doc: High Definition Audio over HDMI and Display Port

Без опций директива kernel-doc включает все комментарии документации из файла
исходного кода.

Расширение kernel-doc включено в дерево исходного кода ядра, по пути
``Documentation/sphinx/kerneldoc.py``. Внутри оно использует скрипт
``tools/docs/kernel-doc`` для извлечения комментариев документации из
исходного кода.

.. _kernel_doc:

Как использовать kernel-doc для генерации man-страниц
-----------------------------------------------------

Чтобы сгенерировать man-страницы для всех файлов, содержащих разметку
kernel-doc, выполните::

  $ make mandocs

Или вызовите ``script-build-wrapper`` напрямую::

  $ ./tools/docs/sphinx-build-wrapper mandocs

Вывод будет находиться в каталоге ``/man`` внутри выходного каталога
(по умолчанию: ``Documentation/output``).

При желании можно сгенерировать частичный набор man-страниц с помощью
SPHINXDIRS:

  $ make SPHINXDIRS=driver-api/media mandocs

.. note::

   Когда используется SPHINXDIRS={subdir}, будут сгенерированы man-страницы
   только для файлов, явно находящихся внутри файла
   ``Documentation/{subdir}/.../*.rst``.
