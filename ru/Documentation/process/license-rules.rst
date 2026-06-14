.. SPDX-License-Identifier: GPL-2.0

.. _kernel_licensing:

Правила лицензирования ядра Linux
=================================

Ядро Linux распространяется на условиях GNU General Public License версии 2
только (GPL-2.0), как указано в LICENSES/preferred/GPL-2.0, с явным
исключением для системных вызовов, описанным в
LICENSES/exceptions/Linux-syscall-note, как описано в файле COPYING.

Этот документ описывает, как каждый исходный файл должен быть аннотирован,
чтобы его лицензия была ясной и однозначной.
Он не заменяет лицензию ядра.

Лицензия, описанная в файле COPYING, применяется к исходному коду ядра в
целом, однако отдельные исходные файлы могут иметь другую лицензию, которая
обязана быть совместимой с GPL-2.0::

    GPL-1.0+  :  GNU General Public License v1.0 or later
    GPL-2.0+  :  GNU General Public License v2.0 or later
    LGPL-2.0  :  GNU Library General Public License v2 only
    LGPL-2.0+ :  GNU Library General Public License v2 or later
    LGPL-2.1  :  GNU Lesser General Public License v2.1 only
    LGPL-2.1+ :  GNU Lesser General Public License v2.1 or later

Помимо этого, отдельные файлы могут распространяться под двойной лицензией,
например под одним из совместимых вариантов GPL и в качестве альтернативы под
разрешительной лицензией вроде BSD, MIT и т.п.

Заголовочные файлы пользовательского API (UAPI), которые описывают интерфейс
программ пространства пользователя к ядру, представляют собой особый случай.
Согласно примечанию в файле COPYING ядра, интерфейс системных вызовов является
чёткой границей, которая не распространяет требования GPL на любое программное
обеспечение, использующее его для взаимодействия с ядром. Поскольку
заголовочные файлы UAPI должны быть включаемы в любые исходные файлы, создающие
исполняемый файл, работающий на ядре Linux, это исключение должно быть
задокументировано специальным лицензионным выражением.

Обычный способ выразить лицензию исходного файла — добавить соответствующий
шаблонный текст в верхний комментарий файла. Из-за форматирования, опечаток и
т.п. эти «шаблоны» сложно проверять инструментам, используемым в контексте
соответствия лицензиям.

Альтернативой шаблонному тексту является использование идентификаторов лицензий
Software Package Data Exchange (SPDX) в каждом исходном файле. Идентификаторы
лицензий SPDX — это машиночитаемые и точные краткие обозначения лицензии, под
которой предоставляется содержимое файла. Идентификаторы лицензий SPDX
управляются рабочей группой SPDX в Linux Foundation и были согласованы
партнёрами из всей отрасли, поставщиками инструментов и юридическими отделами.
Подробнее см. https://spdx.org/

Ядро Linux требует точный идентификатор SPDX во всех исходных файлах.
Допустимые идентификаторы, используемые в ядре, объяснены в разделе
`License identifiers`_ и были взяты из официального списка лицензий SPDX по
адресу https://spdx.org/licenses/ вместе с текстами лицензий.

Синтаксис идентификаторов лицензий
----------------------------------

1. Размещение:

   Идентификатор лицензии SPDX в файлах ядра должен добавляться в первую
   возможную строку файла, которая может содержать комментарий. Для большинства
   файлов это первая строка, за исключением скриптов, которым требуется
   '#!PATH_TO_INTERPRETER' в первой строке. Для таких скриптов идентификатор
   SPDX помещается во вторую строку.

|

2. Стиль:

   Идентификатор лицензии SPDX добавляется в виде комментария. Стиль комментария
   зависит от типа файла::

      C source:	// SPDX-License-Identifier: <SPDX License Expression>
      C header:	/* SPDX-License-Identifier: <SPDX License Expression> */
      ASM:	/* SPDX-License-Identifier: <SPDX License Expression> */
      scripts:	# SPDX-License-Identifier: <SPDX License Expression>
      .rst:	.. SPDX-License-Identifier: <SPDX License Expression>
      .dts{i}:	// SPDX-License-Identifier: <SPDX License Expression>

   Если конкретный инструмент не может обработать стандартный стиль комментария,
   следует использовать подходящий механизм комментирования, который этот
   инструмент принимает. Именно по этой причине в заголовочных файлах C
   используется комментарий стиля "/\* \*/". Наблюдалась поломка сборки с
   генерируемыми файлами .lds, где 'ld' не мог разобрать комментарий в стиле
   C++. К настоящему моменту это исправлено, но всё ещё существуют более старые
   ассемблерные инструменты, которые не могут обрабатывать комментарии в стиле
   C++.

|

3. Синтаксис:

   <SPDX License Expression> — это либо краткий идентификатор лицензии SPDX из
   списка лицензий SPDX, либо комбинация двух кратких идентификаторов лицензий
   SPDX, разделённых словом "WITH", когда применяется исключение из лицензии.
   Когда применяется несколько лицензий, выражение состоит из ключевых слов
   "AND", "OR", разделяющих подвыражения и заключённых в "(", ")" .

   Идентификаторы лицензий для лицензий вроде [L]GPL с опцией 'or later'
   строятся с использованием "+" для указания опции 'or later'.::

      // SPDX-License-Identifier: GPL-2.0+
      // SPDX-License-Identifier: LGPL-2.1+

   WITH следует использовать, когда необходим модификатор к лицензии.
   Например, файлы UAPI ядра Linux используют выражение::

      // SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
      // SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note

   Другие примеры использования исключений WITH, встречающиеся в ядре::

      // SPDX-License-Identifier: GPL-2.0 WITH mif-exception
      // SPDX-License-Identifier: GPL-2.0+ WITH GCC-exception-2.0

   Исключения могут использоваться только с конкретными идентификаторами
   лицензий. Допустимые идентификаторы лицензий перечислены в тегах файла с
   текстом исключения. Подробнее см. пункт `Exceptions`_ в главе `License
   identifiers`_.

   OR следует использовать, если файл имеет двойную лицензию и должна быть
   выбрана только одна лицензия. Например, некоторые файлы dtsi доступны под
   двойными лицензиями::

      // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause

   Примеры из ядра для лицензионных выражений в файлах с двойной лицензией::

      // SPDX-License-Identifier: GPL-2.0 OR MIT
      // SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
      // SPDX-License-Identifier: GPL-2.0 OR Apache-2.0
      // SPDX-License-Identifier: GPL-2.0 OR MPL-1.1
      // SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT
      // SPDX-License-Identifier: GPL-1.0+ OR BSD-3-Clause OR OpenSSL

   AND следует использовать, если файл имеет несколько лицензий, условия всех
   которых применяются к использованию файла. Например, если код унаследован из
   другого проекта и было дано разрешение поместить его в ядро, но исходные
   условия лицензии должны оставаться в силе::

      // SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) AND MIT

   Ещё один пример, где необходимо соблюдать оба набора условий лицензии::

      // SPDX-License-Identifier: GPL-1.0+ AND LGPL-2.1+

License identifiers
-------------------

Используемые в настоящее время лицензии, а также лицензии для кода,
добавляемого в ядро, можно разделить на:

1. _`Preferred licenses`:

   По возможности следует использовать эти лицензии, так как известно, что они
   полностью совместимы и широко используются. Эти лицензии доступны в
   каталоге::

      LICENSES/preferred/

   в дереве исходного кода ядра.

   Файлы в этом каталоге содержат полный текст лицензии и `Metatags`_. Имена
   файлов идентичны идентификатору лицензии SPDX, который должен использоваться
   для этой лицензии в исходных файлах.

   Примеры::

      LICENSES/preferred/GPL-2.0

   Содержит текст лицензии GPL версии 2 и необходимые метатеги::

      LICENSES/preferred/MIT

   Содержит текст лицензии MIT и необходимые метатеги

   _`Metatags`:

   В файле лицензии должны присутствовать следующие метатеги:

   - Valid-License-Identifier:

     Одна или несколько строк, которые объявляют, какие идентификаторы лицензий
     допустимы внутри проекта для ссылки на этот конкретный текст лицензии.
     Обычно это один допустимый идентификатор, но, например, для лицензий с
     опцией 'or later' допустимы два идентификатора.

   - SPDX-URL:

     URL страницы SPDX, которая содержит дополнительную информацию, относящуюся
     к лицензии.

   - Usage-Guidance:

     Текст свободной формы с рекомендациями по использованию. Текст должен
     включать корректные примеры идентификаторов лицензий SPDX в том виде, в
     каком они должны помещаться в исходные файлы согласно рекомендациям
     `Синтаксис идентификаторов лицензий`_.

   - License-Text:

     Весь текст после этого тега рассматривается как оригинальный текст лицензии

   Примеры формата файла::

      Valid-License-Identifier: GPL-2.0
      Valid-License-Identifier: GPL-2.0+
      SPDX-URL: https://spdx.org/licenses/GPL-2.0.html
      Usage-Guide:
        To use this license in source code, put one of the following SPDX
	tag/value pairs into a comment according to the placement
	guidelines in the licensing rules documentation.
	For 'GNU General Public License (GPL) version 2 only' use:
	  SPDX-License-Identifier: GPL-2.0
	For 'GNU General Public License (GPL) version 2 or any later version' use:
	  SPDX-License-Identifier: GPL-2.0+
      License-Text:
        Full license text

   ::

      SPDX-License-Identifier: MIT
      SPDX-URL: https://spdx.org/licenses/MIT.html
      Usage-Guide:
	To use this license in source code, put the following SPDX
	tag/value pair into a comment according to the placement
	guidelines in the licensing rules documentation.
	  SPDX-License-Identifier: MIT
      License-Text:
        Full license text

|

2. Устаревшие лицензии:

   Эти лицензии следует использовать только для существующего кода или для
   импорта кода из другого проекта. Эти лицензии доступны в каталоге::

      LICENSES/deprecated/

   в дереве исходного кода ядра.

   Файлы в этом каталоге содержат полный текст лицензии и `Metatags`_. Имена
   файлов идентичны идентификатору лицензии SPDX, который должен использоваться
   для этой лицензии в исходных файлах.

   Примеры::

      LICENSES/deprecated/ISC

   Содержит текст лицензии Internet Systems Consortium и необходимые
   метатеги::

      LICENSES/deprecated/GPL-1.0

   Содержит текст лицензии GPL версии 1 и необходимые метатеги.

   Metatags:

   Требования к метатегам для 'других' лицензий идентичны требованиям
   `Preferred licenses`_.

   Пример формата файла::

      Valid-License-Identifier: ISC
      SPDX-URL: https://spdx.org/licenses/ISC.html
      Usage-Guide:
        Usage of this license in the kernel for new code is discouraged
	and it should solely be used for importing code from an already
	existing project.
        To use this license in source code, put the following SPDX
	tag/value pair into a comment according to the placement
	guidelines in the licensing rules documentation.
	  SPDX-License-Identifier: ISC
      License-Text:
        Full license text

|

3. Только двойное лицензирование

   Эти лицензии следует использовать только для двойного лицензирования кода с
   другой лицензией в дополнение к предпочтительной лицензии. Эти лицензии
   доступны в каталоге::

      LICENSES/dual/

   в дереве исходного кода ядра.

   Файлы в этом каталоге содержат полный текст лицензии и `Metatags`_. Имена
   файлов идентичны идентификатору лицензии SPDX, который должен использоваться
   для этой лицензии в исходных файлах.

   Примеры::

      LICENSES/dual/MPL-1.1

   Содержит текст лицензии Mozilla Public License версии 1.1 и необходимые
   метатеги::

      LICENSES/dual/Apache-2.0

   Содержит текст лицензии Apache License версии 2.0 и необходимые
   метатеги.

   Metatags:

   Требования к метатегам для 'других' лицензий идентичны требованиям
   `Preferred licenses`_.

   Пример формата файла::

      Valid-License-Identifier: MPL-1.1
      SPDX-URL: https://spdx.org/licenses/MPL-1.1.html
      Usage-Guide:
        Do NOT use. The MPL-1.1 is not GPL2 compatible. It may only be used for
        dual-licensed files where the other license is GPL2 compatible.
        If you end up using this it MUST be used together with a GPL2 compatible
        license using "OR".
        To use the Mozilla Public License version 1.1 put the following SPDX
        tag/value pair into a comment according to the placement guidelines in
        the licensing rules documentation:
      SPDX-License-Identifier: MPL-1.1
      License-Text:
        Full license text

|

4. _`Exceptions`:

   Некоторые лицензии могут быть дополнены исключениями, которые предоставляют
   определённые права, не предоставляемые исходной лицензией. Эти исключения
   доступны в каталоге::

      LICENSES/exceptions/

   в дереве исходного кода ядра. Файлы в этом каталоге содержат полный текст
   исключения и необходимые `Exception Metatags`_.

   Примеры::

      LICENSES/exceptions/Linux-syscall-note

   Содержит исключение для системных вызовов Linux, как задокументировано в
   файле COPYING ядра Linux, которое используется для заголовочных файлов UAPI.
   например /\* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note \*/::

      LICENSES/exceptions/GCC-exception-2.0

   Содержит 'исключение для компоновки' GCC, которое позволяет компоновать любой
   двоичный файл независимо от его лицензии со скомпилированной версией файла,
   помеченного этим исключением. Это требуется для создания запускаемых
   исполняемых файлов из исходного кода, несовместимого с GPL.

   _`Exception Metatags`:

   В файле исключения должны присутствовать следующие метатеги:

   - SPDX-Exception-Identifier:

     Один идентификатор исключения, который может использоваться с
     идентификаторами лицензий SPDX.

   - SPDX-URL:

     URL страницы SPDX, которая содержит дополнительную информацию, относящуюся
     к исключению.

   - SPDX-Licenses:

     Разделённый запятыми список идентификаторов лицензий SPDX, для которых
     может использоваться это исключение.

   - Usage-Guidance:

     Текст свободной формы с рекомендациями по использованию. За текстом должны
     следовать корректные примеры идентификаторов лицензий SPDX в том виде, в
     каком они должны помещаться в исходные файлы согласно рекомендациям
     `Синтаксис идентификаторов лицензий`_.

   - Exception-Text:

     Весь текст после этого тега рассматривается как оригинальный текст
     исключения

   Примеры формата файла::

      SPDX-Exception-Identifier: Linux-syscall-note
      SPDX-URL: https://spdx.org/licenses/Linux-syscall-note.html
      SPDX-Licenses: GPL-2.0, GPL-2.0+, GPL-1.0+, LGPL-2.0, LGPL-2.0+, LGPL-2.1, LGPL-2.1+
      Usage-Guidance:
        This exception is used together with one of the above SPDX-Licenses
	to mark user-space API (uapi) header files so they can be included
	into non GPL compliant user-space application code.
        To use this exception add it with the keyword WITH to one of the
	identifiers in the SPDX-Licenses tag:
	  SPDX-License-Identifier: <SPDX-License> WITH Linux-syscall-note
      Exception-Text:
        Full exception text

   ::

      SPDX-Exception-Identifier: GCC-exception-2.0
      SPDX-URL: https://spdx.org/licenses/GCC-exception-2.0.html
      SPDX-Licenses: GPL-2.0, GPL-2.0+
      Usage-Guidance:
        The "GCC Runtime Library exception 2.0" is used together with one
	of the above SPDX-Licenses for code imported from the GCC runtime
	library.
        To use this exception add it with the keyword WITH to one of the
	identifiers in the SPDX-Licenses tag:
	  SPDX-License-Identifier: <SPDX-License> WITH GCC-exception-2.0
      Exception-Text:
        Full exception text


Все идентификаторы лицензий SPDX и исключения должны иметь соответствующий файл
в подкаталогах LICENSES. Это требуется, чтобы позволить проверку инструментами
(например, checkpatch.pl) и иметь лицензии готовыми для чтения и извлечения
прямо из исходного кода, что рекомендуется различными FOSS-организациями,
например `инициативой FSFE REUSE <https://reuse.software/>`_.

_`MODULE_LICENSE`
-----------------

   Загружаемым модулям ядра также требуется тег MODULE_LICENSE(). Этот тег не
   является ни заменой надлежащей информации о лицензии исходного кода
   (SPDX-License-Identifier), ни каким-либо образом значимым для выражения или
   определения точной лицензии, под которой предоставляется исходный код модуля.

   Единственное назначение этого тега — предоставить достаточную информацию о
   том, является ли модуль свободным программным обеспечением или
   проприетарным, для загрузчика модулей ядра и для инструментов пространства
   пользователя.

   Допустимые строки лицензий для MODULE_LICENSE():

    ============================= =============================================
    "GPL"			  Модуль лицензирован под GPL версии 2. Это
				  не выражает какого-либо различия между
				  GPL-2.0-only и GPL-2.0-or-later. Точную
				  информацию о лицензии можно определить только
				  через информацию о лицензии в
				  соответствующих исходных файлах.

    "GPL v2"			  То же, что и "GPL". Существует по
				  историческим причинам.

    "GPL and additional rights"   Историческая вариация выражения того, что
				  исходный код модуля имеет двойную лицензию под
				  вариантом GPL v2 и лицензией MIT. Пожалуйста,
				  не используйте в новом коде.

    "Dual MIT/GPL"		  Корректный способ выразить, что модуль имеет
				  двойную лицензию под вариантом GPL v2 или
				  лицензией MIT на выбор.

    "Dual BSD/GPL"		  Модуль имеет двойную лицензию под вариантом
				  GPL v2 или лицензией BSD на выбор. Точный
				  вариант лицензии BSD можно определить только
				  через информацию о лицензии
				  в соответствующих исходных файлах.

    "Dual MPL/GPL"		  Модуль имеет двойную лицензию под вариантом
				  GPL v2 или лицензией Mozilla Public License
				  (MPL) на выбор. Точный вариант лицензии MPL
				  можно определить только через информацию о
				  лицензии в соответствующих исходных
				  файлах.

    "Proprietary"		  Модуль под проприетарной лицензией.
				  "Proprietary" следует понимать только как
				  "Лицензия не совместима с GPLv2".
                                  Эта строка предназначена исключительно для
                                  несовместимых с GPL2 сторонних модулей и не
                                  может использоваться для модулей, исходный код
                                  которых находится в дереве ядра. Помеченные
                                  таким образом модули заражают (tainting) ядро
                                  флагом 'P' при загрузке, и загрузчик модулей
                                  ядра отказывается компоновать такие модули с
                                  символами, экспортированными через
                                  EXPORT_SYMBOL_GPL().
    ============================= =============================================
