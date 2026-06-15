.. SPDX-License-Identifier: GPL-2.0

==============
Начало работы
==============

Эта страница содержит обзор kunit_tool и фреймворка KUnit, рассказывает,
как запускать существующие тесты, а затем как написать простой тест-кейс,
а также охватывает типичные проблемы, с которыми сталкиваются пользователи
при первом использовании KUnit.

Установка зависимостей
======================
У KUnit те же зависимости, что и у ядра Linux. Если вы можете собрать
ядро, то можете запускать и KUnit.

Запуск тестов с помощью kunit_tool
==================================
kunit_tool — это Python-скрипт, который конфигурирует и собирает ядро,
запускает тесты и форматирует их результаты. Из репозитория ядра вы
можете запустить kunit_tool:

.. code-block:: bash

	./tools/testing/kunit/kunit.py run

.. note ::
	Вы можете увидеть следующую ошибку:
	"The source tree is not clean, please run 'make ARCH=um mrproper'"

	Это происходит потому, что внутри kunit.py указывает ``.kunit``
	(вариант по умолчанию) в качестве каталога сборки в команде ``make O=output/dir``
	через аргумент ``--build_dir``.  Поэтому перед началом сборки вне
	дерева исходников дерево исходников должно быть чистым.

	Здесь же действует то предостережение, что упомянуто в разделе "Build
	directory for the kernel" документа :doc:`admin-guide </admin-guide/README>`,
	а именно: если вы используете каталог сборки, его необходимо использовать
	для всех вызовов ``make``.
	Хорошая новость в том, что это действительно решается запуском
	``make ARCH=um mrproper``, только учтите, что это удалит
	текущую конфигурацию и все сгенерированные файлы.

Если всё прошло правильно, вы должны увидеть следующее:

.. code-block::

	Configuring KUnit Kernel ...
	Building KUnit Kernel ...
	Starting KUnit Kernel ...

Тесты будут пройдены или провалены.

.. note ::
   Поскольку при первом запуске собирается множество исходников,
   шаг ``Building KUnit Kernel`` может занять некоторое время.

Подробную информацию об этой обёртке смотрите в:
Documentation/dev-tools/kunit/run_wrapper.rst.

Выбор тестов для запуска
------------------------

По умолчанию kunit_tool запускает все тесты, достижимые при минимальной
конфигурации, то есть со значениями по умолчанию для большинства
kconfig-опций.  Однако вы можете выбрать, какие тесты запускать, с помощью:

- `Настройка Kconfig`_, используемой для компиляции ядра, или
- `Фильтрация тестов по имени`_, чтобы выбрать конкретно, какие из скомпилированных тестов запускать.

Настройка Kconfig
~~~~~~~~~~~~~~~~~~
Хорошей отправной точкой для ``.kunitconfig`` является стандартная
конфигурация KUnit. Если вы ещё не запускали ``kunit.py run``, вы можете
сгенерировать её, выполнив:

.. code-block:: bash

	cd $PATH_TO_LINUX_REPO
	tools/testing/kunit/kunit.py config
	cat .kunit/.kunitconfig

.. note ::
   ``.kunitconfig`` находится в каталоге ``--build_dir``, используемом kunit.py, которым
   по умолчанию является ``.kunit``.

Перед запуском тестов kunit_tool убеждается, что все опции конфигурации,
заданные в ``.kunitconfig``, установлены в ``.config`` ядра. Он предупредит
вас, если вы не включили зависимости для используемых опций.

Существует множество способов настроить конфигурации:

a. Отредактируйте ``.kunit/.kunitconfig``. Файл должен содержать список kconfig-опций,
   необходимых для запуска нужных тестов, включая их зависимости.
   Возможно, вы захотите удалить CONFIG_KUNIT_ALL_TESTS из ``.kunitconfig``,
   так как он включит ряд дополнительных тестов, которые вам могут быть не нужны.
   Если вам нужно запустить на архитектуре, отличной от UML, смотрите :ref:`kunit-on-qemu`.

b. Включите дополнительные kconfig-опции поверх ``.kunit/.kunitconfig``.
   Например, чтобы добавить тест связного списка ядра, вы можете выполнить::

	./tools/testing/kunit/kunit.py run \
		--kconfig_add CONFIG_LIST_KUNIT_TEST=y

c. Укажите путь к одному или нескольким файлам .kunitconfig из дерева.
   Например, чтобы запустить только тесты ``FAT_FS`` и ``EXT4``, вы можете выполнить::

	./tools/testing/kunit/kunit.py run \
		--kunitconfig ./fs/fat/.kunitconfig \
		--kunitconfig ./fs/ext4/.kunitconfig

d. Если вы измените ``.kunitconfig``, kunit.py инициирует пересборку файла
   ``.config``. Но вы можете редактировать файл ``.config`` напрямую или с помощью
   инструментов вроде ``make menuconfig O=.kunit``. Пока он является надмножеством
   ``.kunitconfig``, kunit.py не перезапишет ваши изменения.


.. note ::

	Чтобы сохранить .kunitconfig после того, как вы нашли подходящую конфигурацию::

		make savedefconfig O=.kunit
		cp .kunit/defconfig .kunit/.kunitconfig

Фильтрация тестов по имени
~~~~~~~~~~~~~~~~~~~~~~~~~~~
Если вам нужно больше конкретики, чем может дать Kconfig, можно также
выбрать, какие тесты выполнять во время загрузки, передав glob-фильтр
(инструкции по шаблону читайте в man-странице :manpage:`glob(7)`).
Если в фильтре есть ``"."`` (точка), она будет интерпретирована как
разделитель между именем набора тестов и тест-кейсом,
иначе она будет интерпретирована как имя набора тестов.
Например, предположим, что мы используем конфигурацию по умолчанию:

a. укажите имя набора тестов, например ``"kunit_executor_test"``,
   чтобы запустить каждый содержащийся в нём тест-кейс::

	./tools/testing/kunit/kunit.py run "kunit_executor_test"

b. укажите имя тест-кейса с префиксом из его набора тестов,
   например ``"example.example_simple_test"``, чтобы запустить именно этот тест-кейс::

	./tools/testing/kunit/kunit.py run "example.example_simple_test"

c. используйте символы подстановки (``*?[``), чтобы запустить любой тест-кейс, соответствующий шаблону,
   например ``"*.*64*"``, чтобы запустить тест-кейсы, содержащие ``"64"`` в имени, в составе
   любого набора тестов::

	./tools/testing/kunit/kunit.py run "*.*64*"

Запуск тестов без обёртки KUnit
===============================
Если вы не хотите использовать обёртку KUnit (например: вы хотите, чтобы
тестируемый код интегрировался с другими системами, или использовать иную/
неподдерживаемую архитектуру или конфигурацию), KUnit можно включить в
любое ядро, а результаты считать и разобрать вручную.

.. note ::
   ``CONFIG_KUNIT`` не следует включать в производственной среде.
   Включение KUnit отключает рандомизацию размещения адресного пространства
   ядра (KASLR), и тесты могут влиять на состояние ядра способами, не
   подходящими для производственной эксплуатации.

Конфигурирование ядра
---------------------
Чтобы включить сам KUnit, необходимо включить Kconfig-опцию ``CONFIG_KUNIT``
(в разделе Kernel Hacking/Kernel Testing and Coverage в
``menuconfig``). Оттуда вы можете включить любые тесты KUnit. Обычно у них
есть опции конфигурации, заканчивающиеся на ``_KUNIT_TEST``.

KUnit и тесты KUnit можно компилировать как модули. Тесты в модуле
будут запускаться при загрузке модуля.

Запуск тестов (без обёртки KUnit)
---------------------------------
Соберите и запустите своё ядро. В журнале ядра вывод теста печатается
в формате TAP. По умолчанию это произойдёт только в том случае, если KUnit/тесты
встроены в ядро. В противном случае модуль потребуется загрузить.

.. note ::
   Некоторые строки и/или данные могут перемежаться в выводе TAP.

Написание вашего первого теста
==============================
В вашем репозитории ядра давайте добавим немного кода, который мы сможем протестировать.

1. Создайте файл ``drivers/misc/example.h``, который содержит:

.. code-block:: c

	int misc_example_add(int left, int right);

2. Создайте файл ``drivers/misc/example.c``, который содержит:

.. code-block:: c

	#include <linux/errno.h>

	#include "example.h"

	int misc_example_add(int left, int right)
	{
		return left + right;
	}

3. Добавьте следующие строки в ``drivers/misc/Kconfig``:

.. code-block:: kconfig

	config MISC_EXAMPLE
		bool "My example"

4. Добавьте следующие строки в ``drivers/misc/Makefile``:

.. code-block:: make

	obj-$(CONFIG_MISC_EXAMPLE) += example.o

Теперь мы готовы писать тест-кейсы.

1. Добавьте приведённый ниже тест-кейс в ``drivers/misc/example_test.c``:

.. code-block:: c

	#include <kunit/test.h>
	#include "example.h"

	/* Define the test cases. */

	static void misc_example_add_test_basic(struct kunit *test)
	{
		KUNIT_EXPECT_EQ(test, 1, misc_example_add(1, 0));
		KUNIT_EXPECT_EQ(test, 2, misc_example_add(1, 1));
		KUNIT_EXPECT_EQ(test, 0, misc_example_add(-1, 1));
		KUNIT_EXPECT_EQ(test, INT_MAX, misc_example_add(0, INT_MAX));
		KUNIT_EXPECT_EQ(test, -1, misc_example_add(INT_MAX, INT_MIN));
	}

	static void misc_example_test_failure(struct kunit *test)
	{
		KUNIT_FAIL(test, "This test never passes.");
	}

	static struct kunit_case misc_example_test_cases[] = {
		KUNIT_CASE(misc_example_add_test_basic),
		KUNIT_CASE(misc_example_test_failure),
		{}
	};

	static struct kunit_suite misc_example_test_suite = {
		.name = "misc-example",
		.test_cases = misc_example_test_cases,
	};
	kunit_test_suite(misc_example_test_suite);

	MODULE_LICENSE("GPL");

2. Добавьте следующие строки в ``drivers/misc/Kconfig``:

.. code-block:: kconfig

	config MISC_EXAMPLE_TEST
		tristate "Test for my example" if !KUNIT_ALL_TESTS
		depends on MISC_EXAMPLE && KUNIT
		default KUNIT_ALL_TESTS

Примечание: Если ваш тест не поддерживает сборку в виде загружаемого модуля (что
не рекомендуется), замените tristate на bool и используйте зависимость от KUNIT=y вместо KUNIT.

3. Добавьте следующие строки в ``drivers/misc/Makefile``:

.. code-block:: make

	obj-$(CONFIG_MISC_EXAMPLE_TEST) += example_test.o

4. Добавьте следующие строки в ``.kunit/.kunitconfig``:

.. code-block:: none

	CONFIG_MISC_EXAMPLE=y
	CONFIG_MISC_EXAMPLE_TEST=y

5. Запустите тест:

.. code-block:: bash

	./tools/testing/kunit/kunit.py run

Вы должны увидеть следующий сбой:

.. code-block:: none

	...
	[16:08:57] [PASSED] misc-example:misc_example_add_test_basic
	[16:08:57] [FAILED] misc-example:misc_example_test_failure
	[16:08:57] EXPECTATION FAILED at drivers/misc/example-test.c:17
	[16:08:57]      This test never passes.
	...

Поздравляем! Вы только что написали свой первый тест KUnit.

Дальнейшие шаги
===============

Если вам интересно использовать некоторые из более продвинутых возможностей kunit.py,
загляните в Documentation/dev-tools/kunit/run_wrapper.rst

Если вы хотите запускать тесты без использования kunit.py, ознакомьтесь с
Documentation/dev-tools/kunit/run_manual.rst

Дополнительную информацию о написании тестов KUnit (включая некоторые распространённые приёмы
тестирования различных вещей) смотрите в Documentation/dev-tools/kunit/usage.rst
