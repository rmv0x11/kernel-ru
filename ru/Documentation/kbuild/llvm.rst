.. _kbuild_llvm:

=================================
Сборка Linux с помощью Clang/LLVM
=================================

Этот документ описывает, как собрать ядро Linux с помощью Clang и утилит
LLVM.

О документе
-----------

Ядро Linux традиционно всегда компилировалось с помощью тулчейнов GNU,
таких как GCC и binutils. Ведущаяся работа позволила использовать `Clang
<https://clang.llvm.org/>`_ и утилиты `LLVM <https://llvm.org/>`_ в качестве
пригодной замены. Дистрибутивы, такие как `Android
<https://www.android.com/>`_, `ChromeOS
<https://www.chromium.org/chromium-os>`_, `OpenMandriva
<https://www.openmandriva.org/>`_ и `Chimera Linux
<https://chimera-linux.org/>`_, используют ядра, собранные Clang. Парки серверов
дата-центров Google и Meta также работают на ядрах, собранных с помощью Clang.

`LLVM — это набор компонентов тулчейна, реализованных в виде объектов C++
<https://www.aosabook.org/en/llvm.html>`_. Clang — это фронтенд к LLVM,
который поддерживает C и расширения GNU C, необходимые ядру, и произносится
«клэнг» («klang»), а не «си-лэнг» («see-lang»).

Сборка с помощью LLVM
---------------------

Вызовите ``make`` через::

	make LLVM=1

чтобы выполнить компиляцию для целевой системы хоста. Для кросс-компиляции::

	make LLVM=1 ARCH=arm64

Аргумент LLVM=
--------------

В LLVM есть замены для утилит GNU binutils. Их можно включать по отдельности.
Полный список поддерживаемых переменных make::

	make CC=clang LD=ld.lld AR=llvm-ar NM=llvm-nm STRIP=llvm-strip \
	  OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump READELF=llvm-readelf \
	  HOSTCC=clang HOSTCXX=clang++ HOSTAR=llvm-ar HOSTLD=ld.lld

``LLVM=1`` разворачивается в приведённое выше.

Если ваши инструменты LLVM недоступны в вашем PATH, вы можете указать их
расположение с помощью переменной LLVM, добавив завершающий слеш::

	make LLVM=/path/to/llvm/

что приведёт к использованию ``/path/to/llvm/clang``, ``/path/to/llvm/ld.lld``
и т.д. Также можно использовать следующее::

	PATH=/path/to/llvm:$PATH make LLVM=1

Если ваши инструменты LLVM имеют суффикс версии и вы хотите протестировать
именно эту явную версию, а не исполняемые файлы без суффикса, как при ``LLVM=1``,
вы можете передать суффикс с помощью переменной ``LLVM``::

	make LLVM=-14

что приведёт к использованию ``clang-14``, ``ld.lld-14`` и т.д.

Для поддержки сочетаний путей вне дерева исходников с суффиксами версий мы
рекомендуем::

	PATH=/path/to/llvm/:$PATH make LLVM=-14

``LLVM=0`` не то же самое, что полное отсутствие ``LLVM``: он будет вести себя
как ``LLVM=1``. Если вы хотите использовать только определённые утилиты LLVM,
используйте их соответствующие переменные make.

То же значение, что используется для ``LLVM=``, должно задаваться при каждом
вызове ``make``, если настройка и сборка выполняются отдельными командами.
``LLVM=`` также следует задавать как переменную окружения при запуске скриптов,
которые в итоге будут запускать ``make``.

Кросс-компиляция
----------------

Один двоичный файл компилятора Clang (и соответствующие утилиты LLVM), как
правило, содержит все поддерживаемые бэкенды, что может помочь упростить
кросс-компиляцию, особенно когда используется ``LLVM=1``. Если вы используете
только инструменты LLVM, ``CROSS_COMPILE`` или префиксы целевых триплетов
становятся ненужными. Пример::

	make LLVM=1 ARCH=arm64

В качестве примера смешивания утилит LLVM и GNU: для такой целевой архитектуры,
как ``ARCH=s390``, которая пока не имеет поддержки ``ld.lld`` или ``llvm-objcopy``,
вы можете вызвать ``make`` через::

	make LLVM=1 ARCH=s390 LD=s390x-linux-gnu-ld.bfd \
	  OBJCOPY=s390x-linux-gnu-objcopy

В этом примере в качестве компоновщика будет вызван ``s390x-linux-gnu-ld.bfd``,
а также ``s390x-linux-gnu-objcopy``, поэтому убедитесь, что они доступны в вашем
``$PATH``.

``CROSS_COMPILE`` не используется в качестве префикса двоичного файла компилятора
Clang (или соответствующих утилит LLVM), как это происходит с утилитами GNU,
когда ``LLVM=1`` не задано.

Аргумент LLVM_IAS=
------------------

Clang может ассемблировать код на ассемблере. Вы можете передать ``LLVM_IAS=0``,
чтобы отключить это поведение и заставить Clang вместо этого вызывать
соответствующий неинтегрированный ассемблер. Пример::

	make LLVM=1 LLVM_IAS=0

``CROSS_COMPILE`` необходим при кросс-компиляции и использовании ``LLVM_IAS=0``,
чтобы задать ``--prefix=`` для компилятора с целью нахождения соответствующего
неинтегрированного ассемблера (как правило, вы не хотите использовать системный
ассемблер, когда целью является другая архитектура). Пример::

	make LLVM=1 ARCH=arm LLVM_IAS=0 CROSS_COMPILE=arm-linux-gnueabi-


Ccache
------

``ccache`` можно использовать вместе с ``clang`` для ускорения последующих
сборок (хотя KBUILD_BUILD_TIMESTAMP_ следует задавать детерминированным
значением между сборками, чтобы избежать 100% промахов кэша, подробнее см.
Reproducible_builds_)::

	KBUILD_BUILD_TIMESTAMP='' make LLVM=1 CC="ccache clang"

.. _KBUILD_BUILD_TIMESTAMP: kbuild.html#kbuild-build-timestamp
.. _Reproducible_builds: reproducible-builds.html#timestamps

Поддерживаемые архитектуры
--------------------------

LLVM поддерживает не все архитектуры, которые поддерживает Linux, и то, что
целевая архитектура поддерживается в LLVM, ещё не означает, что ядро соберётся
или будет работать без каких-либо проблем. Ниже приведена общая сводка
архитектур, которые в настоящее время работают с ``CC=clang`` или ``LLVM=1``.
Уровень поддержки соответствует значениям «S» в файлах MAINTAINERS. Если
архитектура отсутствует, это означает либо что LLVM её не поддерживает, либо что
есть известные проблемы. Использование последней стабильной версии LLVM или даже
дерева разработки, как правило, даёт наилучшие результаты. Обычно ожидается, что
``defconfig`` архитектуры работает хорошо, у определённых конфигураций могут быть
проблемы, которые ещё не были выявлены. Сообщения об ошибках всегда приветствуются
в трекере задач ниже!

.. list-table::
   :widths: 10 10 10
   :header-rows: 1

   * - Архитектура
     - Уровень поддержки
     - Команда ``make``
   * - arm
     - Supported
     - ``LLVM=1``
   * - arm64
     - Supported
     - ``LLVM=1``
   * - hexagon
     - Maintained
     - ``LLVM=1``
   * - loongarch
     - Maintained
     - ``LLVM=1``
   * - mips
     - Maintained
     - ``LLVM=1``
   * - powerpc
     - Maintained
     - ``LLVM=1``
   * - riscv
     - Supported
     - ``LLVM=1``
   * - s390
     - Maintained
     - ``LLVM=1`` (LLVM >= 18.1.0), ``CC=clang`` (LLVM < 18.1.0)
   * - sparc (sparc64 only)
     - Maintained
     - ``CC=clang LLVM_IAS=0`` (LLVM >= 20)
   * - um (User Mode)
     - Maintained
     - ``LLVM=1``
   * - x86
     - Supported
     - ``LLVM=1``

Где получить помощь
-------------------

- `Веб-сайт <https://clangbuiltlinux.github.io/>`_
- `Список рассылки <https://lore.kernel.org/llvm/>`_: <llvm@lists.linux.dev>
- `Архивы старого списка рассылки <https://groups.google.com/g/clang-built-linux>`_
- `Трекер задач <https://github.com/ClangBuiltLinux/linux/issues>`_
- IRC: #clangbuiltlinux на irc.libera.chat
- `Telegram <https://t.me/ClangBuiltLinux>`_: @ClangBuiltLinux
- `Wiki <https://github.com/ClangBuiltLinux/linux/wiki>`_
- `Задачи для начинающих <https://github.com/ClangBuiltLinux/linux/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22>`_

.. _getting_llvm:

Где получить LLVM
-----------------

Мы предоставляем готовые стабильные версии LLVM на `kernel.org
<https://kernel.org/pub/tools/llvm/>`_. Они оптимизированы с помощью данных
профилирования для сборки ядер Linux, что должно сократить время сборки ядра по
сравнению с другими дистрибутивами LLVM.

Ниже приведены ссылки, которые могут быть полезны для сборки LLVM из исходного
кода или его получения через пакетный менеджер дистрибутива.

- https://releases.llvm.org/download.html
- https://github.com/llvm/llvm-project
- https://llvm.org/docs/GettingStarted.html
- https://llvm.org/docs/CMake.html
- https://apt.llvm.org/
- https://www.archlinux.org/packages/extra/x86_64/llvm/
- https://github.com/ClangBuiltLinux/tc-build
- https://github.com/ClangBuiltLinux/linux/wiki/Building-Clang-from-source
- https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/
