.. SPDX-License-Identifier: GPL-2.0

Написание тестов
================

Тестовые случаи
---------------

Фундаментальной единицей в KUnit является тестовый случай (test case). Тестовый
случай — это функция с сигнатурой ``void (*)(struct kunit *test)``. Она вызывает
тестируемую функцию, а затем задаёт *ожидания* (expectations) относительно того,
что должно произойти. Например:

.. code-block:: c

	void example_test_success(struct kunit *test)
	{
	}

	void example_test_failure(struct kunit *test)
	{
		KUNIT_FAIL(test, "This test never passes.");
	}

В приведённом выше примере ``example_test_success`` всегда проходит, потому что
ничего не делает: ожидания не задаются, и поэтому все ожидания выполняются.
С другой стороны, ``example_test_failure`` всегда завершается неудачей, потому
что вызывает ``KUNIT_FAIL`` — особое ожидание, которое записывает сообщение в
журнал и приводит к провалу тестового случая.

Ожидания
~~~~~~~~
*Ожидание* (expectation) указывает, что мы ожидаем от участка кода определённого
поведения в тесте. Ожидание вызывается подобно функции. Тест строится путём
задания ожиданий относительно поведения тестируемого участка кода. Когда одно
или несколько ожиданий не выполняются, тестовый случай проваливается, и
информация о неудаче записывается в журнал. Например:

.. code-block:: c

	void add_test_basic(struct kunit *test)
	{
		KUNIT_EXPECT_EQ(test, 1, add(1, 0));
		KUNIT_EXPECT_EQ(test, 2, add(1, 1));
	}

В приведённом выше примере ``add_test_basic`` делает несколько утверждений о
поведении функции с именем ``add``. Первый параметр всегда имеет тип
``struct kunit *``, который содержит информацию о текущем контексте теста. Второй
параметр в данном случае — это значение, которое ожидается. Последнее значение —
это то, чем значение является на самом деле. Если ``add`` удовлетворяет всем этим
ожиданиям, тестовый случай ``add_test_basic`` будет пройден; если какое-либо из
этих ожиданий не выполнится, тестовый случай провалится.

Тестовый случай *проваливается*, когда нарушается любое ожидание; однако тест
продолжит выполняться и попытается проверить другие ожидания, пока тестовый
случай не завершится или не будет прерван иным образом. Это противоположно
*утверждениям* (assertions), которые обсуждаются далее.

Чтобы узнать больше об ожиданиях KUnit, см. Documentation/dev-tools/kunit/api/test.rst.

.. note::
   Отдельный тестовый случай должен быть коротким, понятным и сосредоточенным на
   одном поведении.

Например, если мы хотим тщательно протестировать описанную выше функцию ``add``,
создайте дополнительные тестовые случаи, которые проверяли бы каждое свойство,
которым должна обладать функция ``add``, как показано ниже:

.. code-block:: c

	void add_test_basic(struct kunit *test)
	{
		KUNIT_EXPECT_EQ(test, 1, add(1, 0));
		KUNIT_EXPECT_EQ(test, 2, add(1, 1));
	}

	void add_test_negative(struct kunit *test)
	{
		KUNIT_EXPECT_EQ(test, 0, add(-1, 1));
	}

	void add_test_max(struct kunit *test)
	{
		KUNIT_EXPECT_EQ(test, INT_MAX, add(0, INT_MAX));
		KUNIT_EXPECT_EQ(test, -1, add(INT_MAX, INT_MIN));
	}

	void add_test_overflow(struct kunit *test)
	{
		KUNIT_EXPECT_EQ(test, INT_MIN, add(INT_MAX, 1));
	}

Утверждения
~~~~~~~~~~~

Утверждение (assertion) похоже на ожидание, за исключением того, что утверждение
немедленно прекращает тестовый случай, если условие не выполнено. Например:

.. code-block:: c

	static void test_sort(struct kunit *test)
	{
		int *a, i, r = 1;
		a = kunit_kmalloc_array(test, TEST_LEN, sizeof(*a), GFP_KERNEL);
		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, a);
		for (i = 0; i < TEST_LEN; i++) {
			r = (r * 725861) % 6599;
			a[i] = r;
		}
		sort(a, TEST_LEN, sizeof(*a), cmpint, NULL);
		for (i = 0; i < TEST_LEN-1; i++)
			KUNIT_EXPECT_LE(test, a[i], a[i + 1]);
	}

В этом примере нам нужна возможность выделить массив для тестирования функции
``sort()``. Поэтому мы используем ``KUNIT_ASSERT_NOT_ERR_OR_NULL()``, чтобы
прервать тест, если произошла ошибка выделения памяти.

.. note::
   В других тестовых фреймворках макросы ``ASSERT`` часто реализуются вызовом
   ``return``, поэтому они работают только из тестовой функции. В KUnit мы
   останавливаем текущий kthread при неудаче, так что вы можете вызывать их
   откуда угодно.

.. note::
   Предупреждение: из приведённого выше правила есть исключение. Вам не следует
   использовать утверждения в функции exit() набора (suite) или в функции
   освобождения для ресурса. Они выполняются, когда тест завершает работу, и
   утверждение здесь не даст выполниться остальному коду очистки, что
   потенциально может привести к утечке памяти.

Настройка сообщений об ошибках
------------------------------

Каждый из макросов ``KUNIT_EXPECT`` и ``KUNIT_ASSERT`` имеет вариант ``_MSG``.
Они принимают строку формата и аргументы, чтобы предоставить дополнительный
контекст к автоматически генерируемым сообщениям об ошибках.

.. code-block:: c

	char some_str[41];
	generate_sha1_hex_string(some_str);

	/* Before. Not easy to tell why the test failed. */
	KUNIT_EXPECT_EQ(test, strlen(some_str), 40);

	/* After. Now we see the offending string. */
	KUNIT_EXPECT_EQ_MSG(test, strlen(some_str), 40, "some_str='%s'", some_str);

Кроме того, можно полностью взять под контроль сообщение об ошибке с помощью
``KUNIT_FAIL()``, например:

.. code-block:: c

	/* Before */
	KUNIT_EXPECT_EQ(test, some_setup_function(), 0);

	/* After: full control over the failure message. */
	if (some_setup_function())
		KUNIT_FAIL(test, "Failed to setup thing for testing");


Наборы тестов
~~~~~~~~~~~~~

Нам нужно много тестовых случаев, охватывающих все варианты поведения единицы
кода. Часто бывает много похожих тестов. Чтобы уменьшить дублирование в этих
тесно связанных тестах, большинство фреймворков модульного тестирования (включая
KUnit) предоставляют понятие *набора тестов* (test suite). Набор тестов — это
коллекция тестовых случаев для единицы кода с необязательными функциями
подготовки (setup) и завершения (teardown), которые выполняются до/после всего
набора и/или каждого тестового случая.

.. note::
   Тестовый случай будет выполнен только в том случае, если он связан с набором
   тестов.

Например:

.. code-block:: c

	static struct kunit_case example_test_cases[] = {
		KUNIT_CASE(example_test_foo),
		KUNIT_CASE(example_test_bar),
		KUNIT_CASE(example_test_baz),
		{}
	};

	static struct kunit_suite example_test_suite = {
		.name = "example",
		.init = example_test_init,
		.exit = example_test_exit,
		.suite_init = example_suite_init,
		.suite_exit = example_suite_exit,
		.test_cases = example_test_cases,
	};
	kunit_test_suite(example_test_suite);

В приведённом выше примере набор тестов ``example_test_suite`` сначала выполнит
``example_suite_init``, затем выполнит тестовые случаи ``example_test_foo``,
``example_test_bar`` и ``example_test_baz``. Перед каждым из них непосредственно
будет вызвана ``example_test_init``, а сразу после — ``example_test_exit``.
Наконец, после всего остального будет вызвана ``example_suite_exit``.
``kunit_test_suite(example_test_suite)`` регистрирует набор тестов во фреймворке
тестирования KUnit.

.. note::
   Функции ``exit`` и ``suite_exit`` будут выполнены, даже если ``init`` или
   ``suite_init`` завершатся неудачей. Убедитесь, что они способны справиться с
   любым несогласованным состоянием, которое может возникнуть, если ``init`` или
   ``suite_init`` столкнутся с ошибками или завершатся досрочно.

``kunit_test_suite(...)`` — это макрос, который сообщает компоновщику разместить
указанный набор тестов в специальной секции компоновщика, чтобы он мог быть
запущен KUnit либо после ``late_init``, либо при загрузке тестового модуля (если
тест был собран как модуль).

Дополнительную информацию см. в Documentation/dev-tools/kunit/api/test.rst.

.. _kunit-on-non-uml:

Написание тестов для других архитектур
--------------------------------------

Лучше писать тесты, которые выполняются на UML, чем тесты, которые выполняются
только под определённой архитектурой. Лучше писать тесты, которые выполняются под
QEMU или другой легко доступной (и бесплатной с точки зрения денег) программной
средой, чем для конкретного оборудования.

Тем не менее, существуют по-прежнему веские причины писать тест, специфичный для
архитектуры или оборудования. Например, нам может понадобиться протестировать
код, который действительно относится к ``arch/some-arch/*``. Даже в этом случае
старайтесь писать тест так, чтобы он не зависел от физического оборудования.
Некоторым из наших тестовых случаев оборудование может не понадобиться, и лишь
немногим тестам действительно требуется оборудование для проверки. Когда
оборудование недоступно, вместо отключения тестов мы можем их пропускать.

Теперь, когда мы точно определили, какие части специфичны для оборудования,
фактическая процедура написания и запуска тестов такая же, как и при написании
обычных тестов KUnit.

.. important::
   Нам может потребоваться сбросить состояние оборудования. Если это невозможно,
   мы, возможно, сможем запускать только один тестовый случай за один вызов.

.. TODO(brendanhiggins@google.com): Add an actual example of an architecture-
   dependent KUnit test.

Распространённые шаблоны
========================

Изоляция поведения
------------------

Модульное тестирование ограничивает объём тестируемого кода одной единицей. Оно
управляет тем, какой код выполняется, когда тестируемая единица вызывает функцию.
Это работает там, где функция выставлена наружу как часть API таким образом, что
определение этой функции может быть изменено без влияния на остальную часть кодовой
базы. В ядре это достигается за счёт двух конструкций: классов, которые являются
структурами, содержащими указатели на функции, предоставленные реализующей
стороной, и специфичных для архитектуры функций, определения которых выбираются на
этапе компиляции.

Классы
~~~~~~

Классы не являются конструкцией, встроенной в язык программирования C; однако это
легко выводимое понятие. Соответственно, в большинстве случаев каждый проект,
который не использует стандартизированную библиотеку объектно-ориентированного
программирования (вроде GObject из GNOME), имеет свой собственный, немного
отличающийся способ объектно-ориентированного программирования; ядро Linux не
исключение.

Центральным понятием в объектно-ориентированном программировании ядра является
класс. В ядре *класс* — это структура, содержащая указатели на функции. Это
создаёт контракт между *реализующими* (implementers) и *пользователями* (users),
поскольку вынуждает их использовать одну и ту же сигнатуру функции, не вызывая
функцию напрямую. Чтобы быть классом, указатели на функции должны указывать, что
одним из параметров является указатель на класс, известный как *дескриптор
класса* (class handle). Таким образом, функции-члены (также известные как *методы*)
имеют доступ к переменным-членам (также известным как *поля*), что позволяет одной
и той же реализации иметь несколько *экземпляров* (instances).

Класс может быть *переопределён* (overridden) *дочерними классами* (child classes)
путём встраивания *родительского класса* (parent class) в дочерний класс. Тогда
при вызове *метода* дочернего класса реализация для дочернего класса знает, что
переданный ей указатель относится к родителю, содержащемуся внутри дочернего
класса. Таким образом, дочерний класс может вычислить указатель на самого себя,
поскольку указатель на родителя всегда смещён на фиксированную величину
относительно указателя на дочерний класс. Это смещение является смещением
родителя, содержащегося в структуре дочернего класса. Например:

.. code-block:: c

	struct shape {
		int (*area)(struct shape *this);
	};

	struct rectangle {
		struct shape parent;
		int length;
		int width;
	};

	int rectangle_area(struct shape *this)
	{
		struct rectangle *self = container_of(this, struct rectangle, parent);

		return self->length * self->width;
	};

	void rectangle_new(struct rectangle *self, int length, int width)
	{
		self->parent.area = rectangle_area;
		self->length = length;
		self->width = width;
	}

В этом примере вычисление указателя на дочерний класс из указателя на родителя
выполняется с помощью ``container_of``.

Имитация классов
~~~~~~~~~~~~~~~~

Чтобы провести модульное тестирование участка кода, который вызывает метод
класса, поведение метода должно быть управляемым, иначе тест перестаёт быть
модульным и становится интеграционным.

Имитация (fake) класса реализует участок кода, который отличается от того, что
выполняется в реальном (production) экземпляре, но ведёт себя идентично с точки
зрения вызывающих сторон. Это делается для замены зависимости, с которой сложно
иметь дело или которая работает медленно. Например, реализация имитации EEPROM,
хранящей «содержимое» во внутреннем буфере. Предположим, у нас есть класс,
представляющий EEPROM:

.. code-block:: c

	struct eeprom {
		ssize_t (*read)(struct eeprom *this, size_t offset, char *buffer, size_t count);
		ssize_t (*write)(struct eeprom *this, size_t offset, const char *buffer, size_t count);
	};

И мы хотим протестировать код, буферизующий записи в EEPROM:

.. code-block:: c

	struct eeprom_buffer {
		ssize_t (*write)(struct eeprom_buffer *this, const char *buffer, size_t count);
		int flush(struct eeprom_buffer *this);
		size_t flush_count; /* Flushes when buffer exceeds flush_count. */
	};

	struct eeprom_buffer *new_eeprom_buffer(struct eeprom *eeprom);
	void destroy_eeprom_buffer(struct eeprom *eeprom);

Мы можем протестировать этот код, *имитировав* (faking out) нижележащий EEPROM:

.. code-block:: c

	struct fake_eeprom {
		struct eeprom parent;
		char contents[FAKE_EEPROM_CONTENTS_SIZE];
	};

	ssize_t fake_eeprom_read(struct eeprom *parent, size_t offset, char *buffer, size_t count)
	{
		struct fake_eeprom *this = container_of(parent, struct fake_eeprom, parent);

		count = min(count, FAKE_EEPROM_CONTENTS_SIZE - offset);
		memcpy(buffer, this->contents + offset, count);

		return count;
	}

	ssize_t fake_eeprom_write(struct eeprom *parent, size_t offset, const char *buffer, size_t count)
	{
		struct fake_eeprom *this = container_of(parent, struct fake_eeprom, parent);

		count = min(count, FAKE_EEPROM_CONTENTS_SIZE - offset);
		memcpy(this->contents + offset, buffer, count);

		return count;
	}

	void fake_eeprom_init(struct fake_eeprom *this)
	{
		this->parent.read = fake_eeprom_read;
		this->parent.write = fake_eeprom_write;
		memset(this->contents, 0, FAKE_EEPROM_CONTENTS_SIZE);
	}

Теперь мы можем использовать её для тестирования ``struct eeprom_buffer``:

.. code-block:: c

	struct eeprom_buffer_test {
		struct fake_eeprom *fake_eeprom;
		struct eeprom_buffer *eeprom_buffer;
	};

	static void eeprom_buffer_test_does_not_write_until_flush(struct kunit *test)
	{
		struct eeprom_buffer_test *ctx = test->priv;
		struct eeprom_buffer *eeprom_buffer = ctx->eeprom_buffer;
		struct fake_eeprom *fake_eeprom = ctx->fake_eeprom;
		char buffer[] = {0xff};

		eeprom_buffer->flush_count = SIZE_MAX;

		eeprom_buffer->write(eeprom_buffer, buffer, 1);
		KUNIT_EXPECT_EQ(test, fake_eeprom->contents[0], 0);

		eeprom_buffer->write(eeprom_buffer, buffer, 1);
		KUNIT_EXPECT_EQ(test, fake_eeprom->contents[1], 0);

		eeprom_buffer->flush(eeprom_buffer);
		KUNIT_EXPECT_EQ(test, fake_eeprom->contents[0], 0xff);
		KUNIT_EXPECT_EQ(test, fake_eeprom->contents[1], 0xff);
	}

	static void eeprom_buffer_test_flushes_after_flush_count_met(struct kunit *test)
	{
		struct eeprom_buffer_test *ctx = test->priv;
		struct eeprom_buffer *eeprom_buffer = ctx->eeprom_buffer;
		struct fake_eeprom *fake_eeprom = ctx->fake_eeprom;
		char buffer[] = {0xff};

		eeprom_buffer->flush_count = 2;

		eeprom_buffer->write(eeprom_buffer, buffer, 1);
		KUNIT_EXPECT_EQ(test, fake_eeprom->contents[0], 0);

		eeprom_buffer->write(eeprom_buffer, buffer, 1);
		KUNIT_EXPECT_EQ(test, fake_eeprom->contents[0], 0xff);
		KUNIT_EXPECT_EQ(test, fake_eeprom->contents[1], 0xff);
	}

	static void eeprom_buffer_test_flushes_increments_of_flush_count(struct kunit *test)
	{
		struct eeprom_buffer_test *ctx = test->priv;
		struct eeprom_buffer *eeprom_buffer = ctx->eeprom_buffer;
		struct fake_eeprom *fake_eeprom = ctx->fake_eeprom;
		char buffer[] = {0xff, 0xff};

		eeprom_buffer->flush_count = 2;

		eeprom_buffer->write(eeprom_buffer, buffer, 1);
		KUNIT_EXPECT_EQ(test, fake_eeprom->contents[0], 0);

		eeprom_buffer->write(eeprom_buffer, buffer, 2);
		KUNIT_EXPECT_EQ(test, fake_eeprom->contents[0], 0xff);
		KUNIT_EXPECT_EQ(test, fake_eeprom->contents[1], 0xff);
		/* Should have only flushed the first two bytes. */
		KUNIT_EXPECT_EQ(test, fake_eeprom->contents[2], 0);
	}

	static int eeprom_buffer_test_init(struct kunit *test)
	{
		struct eeprom_buffer_test *ctx;

		ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);

		ctx->fake_eeprom = kunit_kzalloc(test, sizeof(*ctx->fake_eeprom), GFP_KERNEL);
		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->fake_eeprom);
		fake_eeprom_init(ctx->fake_eeprom);

		ctx->eeprom_buffer = new_eeprom_buffer(&ctx->fake_eeprom->parent);
		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->eeprom_buffer);

		test->priv = ctx;

		return 0;
	}

	static void eeprom_buffer_test_exit(struct kunit *test)
	{
		struct eeprom_buffer_test *ctx = test->priv;

		destroy_eeprom_buffer(ctx->eeprom_buffer);
	}

Тестирование на множестве входных данных
----------------------------------------

Тестирования всего нескольких входных значений недостаточно, чтобы убедиться, что
код работает правильно, например: тестирование хеш-функции.

Мы можем написать вспомогательный макрос или функцию. Функция вызывается для
каждого входного значения. Например, чтобы протестировать ``sha1sum(1)``, мы можем
написать:

.. code-block:: c

	#define TEST_SHA1(in, want) \
		sha1sum(in, out); \
		KUNIT_EXPECT_STREQ_MSG(test, out, want, "sha1sum(%s)", in);

	char out[40];
	TEST_SHA1("hello world",  "2aae6c35c94fcfb415dbe95f408b9ce91ee846ed");
	TEST_SHA1("hello world!", "430ce34d020724ed75a196dfc2ad67c77772d169");

Обратите внимание на использование версии ``_MSG`` макроса ``KUNIT_EXPECT_STREQ``
для вывода более подробной ошибки и для того, чтобы сделать утверждения внутри
вспомогательных макросов более понятными.

Варианты ``_MSG`` полезны, когда одно и то же ожидание вызывается несколько раз
(в цикле или вспомогательной функции) и поэтому номера строки недостаточно для
определения того, что именно не прошло, как показано ниже.

В сложных случаях мы рекомендуем использовать *табличный тест* (table-driven test)
вместо варианта со вспомогательным макросом, например:

.. code-block:: c

	int i;
	char out[40];

	struct sha1_test_case {
		const char *str;
		const char *sha1;
	};

	struct sha1_test_case cases[] = {
		{
			.str = "hello world",
			.sha1 = "2aae6c35c94fcfb415dbe95f408b9ce91ee846ed",
		},
		{
			.str = "hello world!",
			.sha1 = "430ce34d020724ed75a196dfc2ad67c77772d169",
		},
	};
	for (i = 0; i < ARRAY_SIZE(cases); ++i) {
		sha1sum(cases[i].str, out);
		KUNIT_EXPECT_STREQ_MSG(test, out, cases[i].sha1,
		                      "sha1sum(%s)", cases[i].str);
	}


Здесь больше шаблонного (boilerplate) кода, но он может:

* быть более читаемым, когда имеется несколько входов/выходов (благодаря именам
  полей).

  * Например, см. ``fs/ext4/inode-test.c``.

* уменьшать дублирование, если тестовые случаи разделяются между несколькими
  тестами.

  * Например: если мы хотим протестировать ``sha256sum``, мы могли бы добавить
    поле ``sha256`` и переиспользовать ``cases``.

* быть преобразован в «параметризованный тест».

Параметризованное тестирование
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Для запуска тестового случая на множестве входных данных KUnit предоставляет
фреймворк параметризованного тестирования. Эта возможность формализует и
расширяет понятие табличных тестов, обсуждавшееся ранее.

Тест KUnit считается параметризованным, если при регистрации тестового случая
предоставляется функция-генератор параметров. Пользователь теста может либо
написать собственную функцию-генератор, либо использовать одну из тех, что
предоставляются KUnit. Функция-генератор хранится в
``kunit_case->generate_params`` и может быть задана с помощью макросов, описанных
в разделе ниже.

Чтобы установить терминологию: «параметризованный тест» — это тест, который
выполняется несколько раз (по одному разу на «параметр», или «прогон параметра»).
Каждый прогон параметра имеет как собственную независимую ``struct kunit``
(«контекст прогона параметра»), так и доступ к общей родительской ``struct kunit``
(«контекст параметризованного теста»).

Передача параметров в тест
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Существует три способа предоставить параметры тесту:

Макросы для массива параметров:

   KUnit предоставляет специальную поддержку для распространённого шаблона
   табличного тестирования. Применив либо ``KUNIT_ARRAY_PARAM``, либо
   ``KUNIT_ARRAY_PARAM_DESC`` к массиву ``cases`` из предыдущего раздела, мы можем
   создать параметризованный тест, как показано ниже:

.. code-block:: c

	// This is copy-pasted from above.
	struct sha1_test_case {
		const char *str;
		const char *sha1;
	};
	static const struct sha1_test_case cases[] = {
		{
			.str = "hello world",
			.sha1 = "2aae6c35c94fcfb415dbe95f408b9ce91ee846ed",
		},
		{
			.str = "hello world!",
			.sha1 = "430ce34d020724ed75a196dfc2ad67c77772d169",
		},
	};

	// Creates `sha1_gen_params()` to iterate over `cases` while using
	// the struct member `str` for the case description.
	KUNIT_ARRAY_PARAM_DESC(sha1, cases, str);

	// Looks no different from a normal test.
	static void sha1_test(struct kunit *test)
	{
		// This function can just contain the body of the for-loop.
		// The former `cases[i]` is accessible under test->param_value.
		char out[40];
		struct sha1_test_case *test_param = (struct sha1_test_case *)(test->param_value);

		sha1sum(test_param->str, out);
		KUNIT_EXPECT_STREQ_MSG(test, out, test_param->sha1,
				      "sha1sum(%s)", test_param->str);
	}

	// Instead of KUNIT_CASE, we use KUNIT_CASE_PARAM and pass in the
	// function declared by KUNIT_ARRAY_PARAM or KUNIT_ARRAY_PARAM_DESC.
	static struct kunit_case sha1_test_cases[] = {
		KUNIT_CASE_PARAM(sha1_test, sha1_gen_params),
		{}
	};

Пользовательская функция-генератор параметров:

   Функция-генератор отвечает за генерацию параметров один за другим и имеет
   следующую сигнатуру:
   ``const void* (*)(struct kunit *test, const void *prev, char *desc)``.
   Вы можете передать функцию-генератор макросам ``KUNIT_CASE_PARAM``
   или ``KUNIT_CASE_PARAM_WITH_INIT``.

   Функция получает ранее сгенерированный параметр в качестве аргумента ``prev``
   (который равен ``NULL`` при первом вызове), а также может обращаться к контексту
   параметризованного теста, передаваемому в качестве аргумента ``test``. KUnit
   вызывает эту функцию многократно, пока она не вернёт ``NULL``, что означает
   завершение параметризованного теста.

   Ниже приведён пример того, как это работает:

.. code-block:: c

	#define MAX_TEST_BUFFER_SIZE 8

	// Example generator function. It produces a sequence of buffer sizes that
	// are powers of two, starting at 1 (e.g., 1, 2, 4, 8).
	static const void *buffer_size_gen_params(struct kunit *test, const void *prev, char *desc)
	{
		long prev_buffer_size = (long)prev;
		long next_buffer_size = 1; // Start with an initial size of 1.

		// Stop generating parameters if the limit is reached or exceeded.
		if (prev_buffer_size >= MAX_TEST_BUFFER_SIZE)
			return NULL;

		// For subsequent calls, calculate the next size by doubling the previous one.
		if (prev)
			next_buffer_size = prev_buffer_size << 1;

		return (void *)next_buffer_size;
	}

	// Simple test to validate that kunit_kzalloc provides zeroed memory.
	static void buffer_zero_test(struct kunit *test)
	{
		long buffer_size = (long)test->param_value;
		// Use kunit_kzalloc to allocate a zero-initialized buffer. This makes the
		// memory "parameter run managed," meaning it's automatically cleaned up at
		// the end of each parameter run.
		int *buf = kunit_kzalloc(test, buffer_size * sizeof(int), GFP_KERNEL);

		// Ensure the allocation was successful.
		KUNIT_ASSERT_NOT_NULL(test, buf);

		// Loop through the buffer and confirm every element is zero.
		for (int i = 0; i < buffer_size; i++)
			KUNIT_EXPECT_EQ(test, buf[i], 0);
	}

	static struct kunit_case buffer_test_cases[] = {
		KUNIT_CASE_PARAM(buffer_zero_test, buffer_size_gen_params),
		{}
	};

Регистрация массива параметров во время выполнения в функции инициализации:

   Для сценариев, где вам может потребоваться инициализировать параметризованный
   тест, вы можете напрямую зарегистрировать массив параметров в контексте
   параметризованного теста.

   Чтобы сделать это, вы должны передать контекст параметризованного теста, сам
   массив, размер массива и функцию ``get_description()`` макросу
   ``kunit_register_params_array()``. Этот макрос заполняет
   ``struct kunit_params`` внутри контекста параметризованного теста, фактически
   сохраняя объект массива параметров. Функция ``get_description()`` будет
   использоваться для заполнения описаний параметров и имеет следующую сигнатуру:
   ``void (*)(struct kunit *test, const void *param, char *desc)``. Обратите
   внимание, что она также имеет доступ к контексту параметризованного теста.

      .. important::
         При использовании этого способа регистрации массива параметров вам нужно
         будет вручную передать ``kunit_array_gen_params()`` в качестве
         функции-генератора в ``KUNIT_CASE_PARAM_WITH_INIT``.
         ``kunit_array_gen_params()`` — это вспомогательная функция KUnit, которая
         будет использовать зарегистрированный массив для генерации параметров.

	 При необходимости, вместо передачи вспомогательной функции KUnit, вы также
	 можете передать собственную пользовательскую функцию-генератор, которая
	 использует массив параметров. Чтобы обратиться к массиву параметров изнутри
	 функции-генератора параметров, используйте ``test->params_array.params``.

   Макрос ``kunit_register_params_array()`` следует вызывать внутри функции
   ``param_init()``, которая инициализирует параметризованный тест и имеет
   следующую сигнатуру ``int (*)(struct kunit *test)``. Подробное объяснение этого
   механизма см. в разделе «Добавление общих ресурсов», который следует за этим.
   Этот метод поддерживает регистрацию как динамически построенных, так и
   статических массивов параметров.

   Фрагмент кода ниже демонстрирует тест ``example_param_init_dynamic_arr``,
   который использует ``make_fibonacci_params()`` для создания динамического
   массива, который затем регистрируется с помощью
   ``kunit_register_params_array()``. Чтобы увидеть полный код, обратитесь к
   lib/kunit/kunit-example-test.c.

.. code-block:: c

	/*
	* Example of a parameterized test param_init() function that registers a dynamic
	* array of parameters.
	*/
	static int example_param_init_dynamic_arr(struct kunit *test)
	{
		size_t seq_size;
		int *fibonacci_params;

		kunit_info(test, "initializing parameterized test\n");

		seq_size = 6;
		fibonacci_params = make_fibonacci_params(test, seq_size);
		if (!fibonacci_params)
			return -ENOMEM;
		/*
		* Passes the dynamic parameter array information to the parameterized test
		* context struct kunit. The array and its metadata will be stored in
		* test->parent->params_array. The array itself will be located in
		* params_data.params.
		*/
		kunit_register_params_array(test, fibonacci_params, seq_size,
					example_param_dynamic_arr_get_desc);
		return 0;
	}

	static struct kunit_case example_test_cases[] = {
		/*
		 * Note how we pass kunit_array_gen_params() to use the array we
		 * registered in example_param_init_dynamic_arr() to generate
		 * parameters.
		 */
		KUNIT_CASE_PARAM_WITH_INIT(example_params_test_with_init_dynamic_arr,
					   kunit_array_gen_params,
					   example_param_init_dynamic_arr,
					   example_param_exit_dynamic_arr),
		{}
	};

Добавление общих ресурсов
^^^^^^^^^^^^^^^^^^^^^^^^^
Все прогоны параметров в этом фреймворке удерживают ссылку на контекст
параметризованного теста, к которому можно обращаться, используя родительский
указатель ``struct kunit``. Контекст параметризованного теста сам по себе не
используется для выполнения какой-либо тестовой логики; вместо этого он служит
контейнером для общих ресурсов.

Можно добавить ресурсы для разделения между прогонами параметров в рамках
параметризованного теста, используя ``KUNIT_CASE_PARAM_WITH_INIT``, которому вы
передаёте пользовательские функции ``param_init()`` и ``param_exit()``. Эти
функции выполняются по одному разу до и после параметризованного теста
соответственно.

Функция ``param_init()`` с сигнатурой ``int (*)(struct kunit *test)`` может
использоваться для добавления ресурсов в поля ``resources`` или ``priv`` контекста
параметризованного теста, регистрации массива параметров и любой другой логики
инициализации.

Функция ``param_exit()`` с сигнатурой ``void (*)(struct kunit *test)`` может
использоваться для освобождения любых ресурсов, которые не управлялись
параметризованным тестом (то есть не очищались автоматически после завершения
параметризованного теста), а также для любой другой логики завершения.

Как ``param_init()``, так и ``param_exit()`` за кулисами получают контекст
параметризованного теста. Однако функция тестового случая получает контекст
прогона параметра. Поэтому, чтобы управлять общими ресурсами и обращаться к ним
изнутри функции тестового случая, вы должны использовать ``test->parent``.

Например, поиск общего ресурса, выделенного с помощью Resource API, требует
передачи ``test->parent`` в ``kunit_find_resource()``. Этот принцип
распространяется на все остальные API, которые могут использоваться в функции
тестового случая, включая ``kunit_kzalloc()``, ``kunit_kmalloc_array()`` и другие
(см. Documentation/dev-tools/kunit/api/test.rst и
Documentation/dev-tools/kunit/api/resource.rst).

.. note::
   Функция ``suite->init()``, которая выполняется перед каждым прогоном параметра,
   получает контекст прогона параметра. Поэтому любые ресурсы, настроенные в
   ``suite->init()``, очищаются после каждого прогона параметра.

Код ниже показывает, как можно добавить общие ресурсы. Обратите внимание, что этот
код использует Resource API, о котором вы можете прочитать подробнее здесь:
Documentation/dev-tools/kunit/api/resource.rst. Чтобы увидеть полную версию этого
кода, обратитесь к lib/kunit/kunit-example-test.c.

.. code-block:: c

	static int example_resource_init(struct kunit_resource *res, void *context)
	{
		... /* Code that allocates memory and stores context in res->data. */
	}

	/* This function deallocates memory for the kunit_resource->data field. */
	static void example_resource_free(struct kunit_resource *res)
	{
		kfree(res->data);
	}

	/* This match function locates a test resource based on defined criteria. */
	static bool example_resource_alloc_match(struct kunit *test, struct kunit_resource *res,
						 void *match_data)
	{
		return res->data && res->free == example_resource_free;
	}

	/* Function to initialize the parameterized test. */
	static int example_param_init(struct kunit *test)
	{
		int ctx = 3; /* Data to be stored. */
		void *data = kunit_alloc_resource(test, example_resource_init,
						  example_resource_free,
						  GFP_KERNEL, &ctx);
		if (!data)
			return -ENOMEM;
		kunit_register_params_array(test, example_params_array,
					    ARRAY_SIZE(example_params_array));
		return 0;
	}

	/* Example test that uses shared resources in test->resources. */
	static void example_params_test_with_init(struct kunit *test)
	{
		int threshold;
		const struct example_param *param = test->param_value;
		/*  Here we pass test->parent to access the parameterized test context. */
		struct kunit_resource *res = kunit_find_resource(test->parent,
								 example_resource_alloc_match,
								 NULL);

		threshold = *((int *)res->data);
		KUNIT_ASSERT_LE(test, param->value, threshold);
		kunit_put_resource(res);
	}

	static struct kunit_case example_test_cases[] = {
		KUNIT_CASE_PARAM_WITH_INIT(example_params_test_with_init, kunit_array_gen_params,
					   example_param_init, NULL),
		{}
	};

В качестве альтернативы использованию KUnit Resource API для разделения ресурсов
вы можете разместить их в ``test->parent->priv``. Это служит более лёгким методом
хранения ресурсов, лучше подходящим для сценариев, где не требуется сложное
управление ресурсами.

Как было сказано ранее, ``param_init()`` и ``param_exit()`` получают контекст
параметризованного теста. Поэтому вы можете напрямую использовать ``test->priv``
внутри ``param_init/exit`` для управления общими ресурсами. Однако изнутри функции
тестового случая вы должны подняться вверх к родительской ``struct kunit``, то
есть к контексту параметризованного теста. Поэтому для доступа к тем же ресурсам
вам нужно использовать ``test->parent->priv``.

Ресурсы, размещённые в ``test->parent->priv``, должны быть выделены в памяти,
чтобы сохраняться между прогонами параметров. Если память выделяется с помощью
API выделения памяти KUnit (более подробно описанных в разделе «Выделение памяти»
ниже), вам не нужно будет беспокоиться об освобождении. Эти API сделают память
«управляемой» параметризованным тестом, гарантируя, что она будет автоматически
очищена после завершения параметризованного теста.

Код ниже демонстрирует пример использования поля ``priv`` для общих ресурсов:

.. code-block:: c

	static const struct example_param {
		int value;
	} example_params_array[] = {
		{ .value = 3, },
		{ .value = 2, },
		{ .value = 1, },
		{ .value = 0, },
	};

	/* Initialize the parameterized test context. */
	static int example_param_init_priv(struct kunit *test)
	{
		int ctx = 3; /* Data to be stored. */
		int arr_size = ARRAY_SIZE(example_params_array);

		/*
		 * Allocate memory using kunit_kzalloc(). Since the `param_init`
		 * function receives the parameterized test context, this memory
		 * allocation will be scoped to the lifetime of the parameterized test.
		 */
		test->priv = kunit_kzalloc(test, sizeof(int), GFP_KERNEL);

		/* Assign the context value to test->priv.*/
		*((int *)test->priv) = ctx;

		/* Register the parameter array. */
		kunit_register_params_array(test, example_params_array, arr_size, NULL);
		return 0;
	}

	static void example_params_test_with_init_priv(struct kunit *test)
	{
		int threshold;
		const struct example_param *param = test->param_value;

		/* By design, test->parent will not be NULL. */
		KUNIT_ASSERT_NOT_NULL(test, test->parent);

		/* Here we use test->parent->priv to access the shared resource. */
		threshold = *(int *)test->parent->priv;

		KUNIT_ASSERT_LE(test, param->value, threshold);
	}

	static struct kunit_case example_tests[] = {
		KUNIT_CASE_PARAM_WITH_INIT(example_params_test_with_init_priv,
					   kunit_array_gen_params,
					   example_param_init_priv, NULL),
		{}
	};

Выделение памяти
----------------

Там, где вы могли бы использовать ``kzalloc``, вы можете вместо этого использовать
``kunit_kzalloc``, поскольку тогда KUnit обеспечит освобождение памяти после
завершения теста.

Это полезно, потому что позволяет нам использовать макросы ``KUNIT_ASSERT_EQ`` для
досрочного выхода из теста, не беспокоясь о том, чтобы не забыть вызвать ``kfree``.
Например:

.. code-block:: c

	void example_test_allocation(struct kunit *test)
	{
		char *buffer = kunit_kzalloc(test, 16, GFP_KERNEL);
		/* Ensure allocation succeeded. */
		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buffer);

		KUNIT_ASSERT_STREQ(test, buffer, "");
	}

Регистрация действий очистки
----------------------------

Если вам нужно выполнить некоторую очистку, выходящую за рамки простого
использования ``kunit_kzalloc``, вы можете зарегистрировать пользовательское
«отложенное действие» (deferred action) — функцию очистки, выполняемую при выходе
из теста (как при штатном завершении, так и через провалившееся утверждение).

Действия — это простые функции без возвращаемого значения и с единственным
аргументом-контекстом типа ``void*``, и они выполняют ту же роль, что и функции
«cleanup» в тестах на Python и Go, операторы «defer» в языках, которые их
поддерживают, и (в некоторых случаях) деструкторы в языках с RAII.

Они очень полезны для снятия регистрации чего-либо из глобальных списков, закрытия
файлов или других ресурсов либо освобождения ресурсов.

Например:

.. code-block:: C

	static void cleanup_device(void *ctx)
	{
		struct device *dev = (struct device *)ctx;

		device_unregister(dev);
	}

	void example_device_test(struct kunit *test)
	{
		struct my_device dev;

		device_register(&dev);

		kunit_add_action(test, &cleanup_device, &dev);
	}

Обратите внимание, что для функций вроде device_unregister, которые принимают лишь
единственный аргумент размером с указатель, можно автоматически сгенерировать
обёртку с помощью макроса ``KUNIT_DEFINE_ACTION_WRAPPER()``, например:

.. code-block:: C

	KUNIT_DEFINE_ACTION_WRAPPER(device_unregister, device_unregister_wrapper, struct device *);
	kunit_add_action(test, &device_unregister_wrapper, &dev);

Вам следует поступать так, а не приводить вручную к типу ``kunit_action_t``,
поскольку приведение указателей на функции нарушит Control Flow Integrity (CFI).

``kunit_add_action`` может завершиться неудачей, если, например, в системе
закончилась память. Вместо неё вы можете использовать
``kunit_add_action_or_reset``, которая немедленно выполняет действие, если его
нельзя отложить.

Если вам нужно больше контроля над тем, когда вызывается функция очистки, вы
можете запустить её досрочно с помощью ``kunit_release_action`` или отменить её
полностью с помощью ``kunit_remove_action``.


Тестирование статических функций
--------------------------------

Если вы хотите протестировать статические функции, не выставляя эти функции
наружу за пределы тестирования, один из вариантов — условно экспортировать символ.
Когда KUnit включён, символ выставляется наружу, но в противном случае остаётся
статическим. Чтобы использовать этот метод, следуйте приведённому ниже шаблону.

.. code-block:: c

	/* In the file containing functions to test "my_file.c" */

	#include <kunit/visibility.h>
	#include <my_file.h>
	...
	VISIBLE_IF_KUNIT int do_interesting_thing()
	{
	...
	}
	EXPORT_SYMBOL_IF_KUNIT(do_interesting_thing);

	/* In the header file "my_file.h" */

	#if IS_ENABLED(CONFIG_KUNIT)
		int do_interesting_thing(void);
	#endif

	/* In the KUnit test file "my_file_test.c" */

	#include <kunit/visibility.h>
	#include <my_file.h>
	...
	MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
	...
	// Use do_interesting_thing() in tests

Полный пример см. в этом `патче <https://lore.kernel.org/all/20221207014024.340230-3-rmoar@google.com/>`_,
где тест изменён так, чтобы условно выставлять статические функции наружу для
тестирования с помощью приведённых выше макросов.

В качестве **альтернативы** описанному выше методу, вы можете условно подключить
(``#include``) тестовый файл в конце вашего файла .c. Это не рекомендуется, но
работает при необходимости. Например:

.. code-block:: c

	/* In "my_file.c" */

	static int do_interesting_thing();

	#ifdef CONFIG_MY_KUNIT_TEST
	#include "my_kunit_test.c"
	#endif

Внедрение кода только для тестов
--------------------------------

Подобно показанному выше, мы можем добавить логику, специфичную для тестов.
Например:

.. code-block:: c

	/* In my_file.h */

	#ifdef CONFIG_MY_KUNIT_TEST
	/* Defined in my_kunit_test.c */
	void test_only_hook(void);
	#else
	void test_only_hook(void) { }
	#endif

Этот код, предназначенный только для тестов, можно сделать более полезным, обращаясь
к текущему ``kunit_test``, как показано в следующем разделе: *Доступ к текущему
тесту*.

Доступ к текущему тесту
-----------------------

В некоторых случаях нам нужно вызвать код, предназначенный только для тестов, извне
тестового файла. Это полезно, например, при предоставлении имитации (fake)
реализации функции или для того, чтобы провалить любой текущий тест изнутри
обработчика ошибок.
Мы можем сделать это через поле ``kunit_test`` в ``task_struct``, к которому можем
обращаться с помощью функции ``kunit_get_current_test()`` из ``kunit/test-bug.h``.

``kunit_get_current_test()`` безопасно вызывать, даже если KUnit не включён. Если
KUnit не включён или если в текущей задаче не выполняется тест, она вернёт
``NULL``. Это компилируется либо в no-op, либо в проверку статического ключа
(static key), так что при отсутствии выполняющегося теста влияние на
производительность будет пренебрежимо малым.

В приведённом ниже примере это используется для реализации «мок»-реализации (mock)
функции ``foo``:

.. code-block:: c

	#include <kunit/test-bug.h> /* for kunit_get_current_test */

	struct test_data {
		int foo_result;
		int want_foo_called_with;
	};

	static int fake_foo(int arg)
	{
		struct kunit *test = kunit_get_current_test();
		struct test_data *test_data = test->priv;

		KUNIT_EXPECT_EQ(test, test_data->want_foo_called_with, arg);
		return test_data->foo_result;
	}

	static void example_simple_test(struct kunit *test)
	{
		/* Assume priv (private, a member used to pass test data from
		 * the init function) is allocated in the suite's .init */
		struct test_data *test_data = test->priv;

		test_data->foo_result = 42;
		test_data->want_foo_called_with = 1;

		/* In a real test, we'd probably pass a pointer to fake_foo somewhere
		 * like an ops struct, etc. instead of calling it directly. */
		KUNIT_EXPECT_EQ(test, fake_foo(1), 42);
	}

В этом примере мы используем член ``priv`` структуры ``struct kunit`` как способ
передачи данных в тест из функции инициализации. В общем случае ``priv`` — это
указатель, который может использоваться для любых пользовательских данных. Это
предпочтительнее статических переменных, так как позволяет избежать проблем
параллелизма (concurrency).

Если бы нам было нужно что-то более гибкое, мы могли бы использовать именованный
``kunit_resource``. Каждый тест может иметь несколько ресурсов, имеющих строковые
имена, что обеспечивает ту же гибкость, что и член ``priv``, но также, например,
позволяет вспомогательным функциям создавать ресурсы, не конфликтуя друг с другом.
Также можно определить функцию очистки для каждого ресурса, что упрощает
предотвращение утечек ресурсов. Дополнительную информацию см. в
Documentation/dev-tools/kunit/api/resource.rst.

Провал текущего теста
---------------------

Если мы хотим провалить текущий тест, мы можем использовать
``kunit_fail_current_test(fmt, args...)``, которая определена в
``<kunit/test-bug.h>`` и не требует подключения ``<kunit/test.h>``.
Например, у нас есть опция включить некоторые дополнительные отладочные проверки
для некоторых структур данных, как показано ниже:

.. code-block:: c

	#include <kunit/test-bug.h>

	#ifdef CONFIG_EXTRA_DEBUG_CHECKS
	static void validate_my_data(struct data *data)
	{
		if (is_valid(data))
			return;

		kunit_fail_current_test("data %p is invalid", data);

		/* Normal, non-KUnit, error reporting code here. */
	}
	#else
	static void my_debug_function(void) { }
	#endif

``kunit_fail_current_test()`` безопасно вызывать, даже если KUnit не включён. Если
KUnit не включён или если в текущей задаче не выполняется тест, она ничего не
сделает. Это компилируется либо в no-op, либо в проверку статического ключа (static
key), так что при отсутствии выполняющегося теста влияние на производительность
будет пренебрежимо малым.

Управление имитациями устройств и драйверов
-------------------------------------------

При тестировании драйверов или кода, взаимодействующего с драйверами, многим
функциям потребуется ``struct device`` или ``struct device_driver``. Во многих
случаях для тестирования любой заданной функции не требуется настройка реального
устройства, поэтому вместо него может использоваться имитация (fake) устройства.

KUnit предоставляет вспомогательные функции для создания этих имитаций устройств и
управления ими; внутренне они имеют тип ``struct kunit_device`` и присоединяются к
специальной шине ``kunit_bus``. Эти устройства поддерживают управляемые ресурсы
устройства (devres), как описано в
Documentation/driver-api/driver-model/devres.rst

Чтобы создать управляемый KUnit ``struct device_driver``, используйте
``kunit_driver_create()``, которая создаст драйвер с заданным именем на шине
``kunit_bus``. Этот драйвер будет автоматически уничтожен, когда соответствующий
тест завершится, но также может быть уничтожен вручную с помощью
``driver_unregister()``.

Чтобы создать имитацию устройства, используйте ``kunit_device_register()``,
которая создаст и зарегистрирует устройство, используя новый управляемый KUnit
драйвер, созданный с помощью ``kunit_driver_create()``. Чтобы предоставить
конкретный, не управляемый KUnit драйвер, используйте вместо неё
``kunit_device_register_with_driver()``. Как и в случае с управляемыми драйверами,
управляемые KUnit имитации устройств автоматически очищаются при завершении теста,
но могут быть очищены вручную досрочно с помощью ``kunit_device_unregister()``.

Устройства KUnit следует использовать предпочтительнее ``root_device_register()``,
а также вместо ``platform_device_register()`` в случаях, когда устройство не
является в остальном платформенным устройством (platform device).

Например:

.. code-block:: c

	#include <kunit/device.h>

	static void test_my_device(struct kunit *test)
	{
		struct device *fake_device;
		const char *dev_managed_string;

		// Create a fake device.
		fake_device = kunit_device_register(test, "my_device");
		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, fake_device)

		// Pass it to functions which need a device.
		dev_managed_string = devm_kstrdup(fake_device, "Hello, World!");

		// Everything is cleaned up automatically when the test ends.
	}