Динамическая отладка (dynamic debug)
++++++++++++++++++++++++++++++++++++


Введение
========

Динамическая отладка (dynamic debug) позволяет динамически включать и
отключать код отладочной печати ядра для получения дополнительной
информации о ядре.

Если файл ``/proc/dynamic_debug/control`` существует, значит, в вашем ядре
есть динамическая отладка. Для её использования потребуется доступ root
(sudo su).

Динамическая отладка предоставляет:

 * Каталог всех *prdbgs* в вашем ядре.
   Чтобы увидеть их, выполните ``cat /proc/dynamic_debug/control``.

 * Простой язык запросов/команд для изменения *prdbgs* путём отбора по
   любой комбинации из 0 или 1 из следующего:

   - имя исходного файла
   - имя функции
   - номер строки (включая диапазоны номеров строк)
   - имя модуля
   - строка формата
   - имя класса (как оно известно/объявлено каждым модулем)

ПРИМЕЧАНИЕ: Чтобы действительно получить вывод отладочной печати на консоль,
вам может потребоваться скорректировать ``loglevel=`` ядра или использовать
``ignore_loglevel``. Об этих параметрах ядра читайте в
Documentation/admin-guide/kernel-parameters.rst.

Просмотр поведения динамической отладки
=======================================

Текущее настроенное поведение можно просмотреть в каталоге *prdbg*::

  :#> head -n7 /proc/dynamic_debug/control
  # filename:lineno [module]function flags format
  init/main.c:1179 [main]initcall_blacklist =_ "blacklisting initcall %s\012
  init/main.c:1218 [main]initcall_blacklisted =_ "initcall %s blacklisted\012"
  init/main.c:1424 [main]run_init_process =_ "  with arguments:\012"
  init/main.c:1426 [main]run_init_process =_ "    %s\012"
  init/main.c:1427 [main]run_init_process =_ "  with environment:\012"
  init/main.c:1429 [main]run_init_process =_ "    %s\012"

3-й столбец, разделённый пробелами, показывает текущие флаги, предварённые
символом ``=`` для удобства использования с grep/cut. ``=p`` показывает
включённые места вызова (callsites).

Управление поведением динамической отладки
==========================================

Поведение мест *prdbg* управляется записью запросов/команд в управляющий файл.
Пример::

  # grease the interface
  :#> alias ddcmd='echo $* > /proc/dynamic_debug/control'

  :#> ddcmd '-p; module main func run* +p'
  :#> grep =p /proc/dynamic_debug/control
  init/main.c:1424 [main]run_init_process =p "  with arguments:\012"
  init/main.c:1426 [main]run_init_process =p "    %s\012"
  init/main.c:1427 [main]run_init_process =p "  with environment:\012"
  init/main.c:1429 [main]run_init_process =p "    %s\012"

Сообщения об ошибках направляются на консоль/в syslog::

  :#> ddcmd mode foo +p
  dyndbg: unknown keyword "mode"
  dyndbg: query parse failed
  bash: echo: write error: Invalid argument

Если debugfs также включена и смонтирована, ``dynamic_debug/control`` доступен
и в каталоге монтирования, обычно ``/sys/kernel/debug/``.

Справочник по языку команд
==========================

На базовом лексическом уровне команда — это последовательность слов,
разделённых пробелами или табуляциями. Поэтому все приведённые ниже записи
эквивалентны::

  :#> ddcmd file svcsock.c line 1603 +p
  :#> ddcmd "file svcsock.c line 1603 +p"
  :#> ddcmd '  file   svcsock.c     line  1603 +p  '

Отправка команд ограничена одним системным вызовом write(). Несколько команд
можно записать вместе, разделяя их символом ``;`` или ``\n``::

  :#> ddcmd "func pnpacpi_get_resources +p; func pnp_assign_mem +p"
  :#> ddcmd <<"EOC"
  func pnpacpi_get_resources +p
  func pnp_assign_mem +p
  EOC
  :#> cat query-batch-file > /proc/dynamic_debug/control

В каждом термине запроса также можно использовать подстановочные символы
(wildcards). Правило сопоставления поддерживает ``*`` (соответствует нулю или
более символам) и ``?`` (соответствует ровно одному символу). Например, можно
сопоставить все драйверы usb::

  :#> ddcmd file "drivers/usb/*" +p	# "" to suppress shell expansion

Синтаксически команда — это пары «ключевое слово — значение», за которыми
следует изменение или установка флагов::

  command ::= match-spec* flags-spec

Спецификации match-spec отбирают *prdbgs* из каталога, к которым затем
применяется спецификация flags-spec; все ограничения объединяются по И (AND).
Отсутствующее ключевое слово эквивалентно ключевому слову "*".


Спецификация сопоставления — это ключевое слово, которое выбирает сравниваемый
атрибут места вызова, и значение для сравнения. Возможные ключевые слова:::

  match-spec ::= 'func' string |
		 'file' string |
		 'module' string |
		 'format' string |
		 'class' string |
		 'line' line-range

  line-range ::= lineno |
		 '-'lineno |
		 lineno'-' |
		 lineno'-'lineno

  lineno ::= unsigned-int

.. note::

  ``line-range`` не может содержать пробел, например
  "1-30" — допустимый диапазон, а "1 - 30" — нет.


Значения каждого ключевого слова:

func
    Заданная строка сравнивается с именем функции каждого места вызова.
    Пример::

	func svc_tcp_accept
	func *recv*		# in rfcomm, bluetooth, ping, tcp

file
    Заданная строка сравнивается либо с путём относительно корня исходных
    текстов (src-root), либо с базовым именем исходного файла каждого места
    вызова. Примеры::

	file svcsock.c
	file kernel/freezer.c	# ie column 1 of control file
	file drivers/usb/*	# all callsites under it
	file inode.c:start_*	# parse :tail as a func (above)
	file inode.c:1-100	# parse :tail as a line-range (above)

module
    Заданная строка сравнивается с именем модуля каждого места вызова.
    Имя модуля — это строка, как она видна в ``lsmod``, то есть без каталога
    и без суффикса ``.ko``, при этом ``-`` заменён на ``_``. Примеры::

	module sunrpc
	module nfsd
	module drm*	# both drm, drm_kms_helper

format
    Заданная строка ищется внутри строки формата динамической отладки.
    Обратите внимание, что строка не обязана совпадать со всем форматом
    целиком — достаточно совпадения с некоторой его частью. Пробельные
    символы и другие специальные символы можно экранировать с помощью
    нотации восьмеричного символьного экранирования C ``\ooo``, например,
    символ пробела — это ``\040``. Кроме того, строку можно заключить в
    двойные кавычки (``"``) или одинарные кавычки (``'``). Примеры::

	format svcrdma:         // many of the NFS/RDMA server pr_debugs
	format readahead        // some pr_debugs in the readahead cache
	format nfsd:\040SETATTR // one way to match a format with whitespace
	format "nfsd: SETATTR"  // a neater way to match a format with whitespace
	format 'nfsd: SETATTR'  // yet another way to match a format with whitespace

class
    Заданное class_name проверяется относительно каждого модуля, который мог
    объявить список известных class_names. Если class_name найдено для модуля,
    выполняются сопоставление и корректировка по месту вызова и классу.
    Примеры::

	class DRM_UT_KMS	# a DRM.debug category
	class JUNK		# silent non-match
	// class TLD_*		# NOTICE: no wildcard in class names

line
    Заданный номер строки или диапазон номеров строк сравнивается с номером
    строки каждого места вызова ``pr_debug()``. Одиночный номер строки
    совпадает с номером строки места вызова в точности. Диапазон номеров строк
    совпадает с любым местом вызова между первым и последним номером строки
    включительно. Пустой первый номер означает первую строку файла, пустой
    последний номер строки означает последний номер строки в файле. Примеры::

	line 1603           // exactly line 1603
	line 1600-1605      // the six lines from line 1600 to line 1605
	line -1605          // the 1605 lines from line 1 to line 1605
	line 1600-          // all lines from line 1600 to the end of the file

Спецификация флагов состоит из операции изменения, за которой следует один или
несколько символов флагов. Операция изменения — это один из символов::

  -    remove the given flags
  +    add the given flags
  =    set the flags to the given flags

Флаги таковы::

  p    enables the pr_debug() callsite.
  _    enables no flags.

  Decorator flags add to the message-prefix, in order:
  t    Include thread ID, or <intr>
  m    Include module name
  f    Include the function name
  s    Include the source file name
  l    Include line number
  d    Include call trace

Для ``print_hex_dump_debug()`` и ``print_hex_dump_bytes()`` имеет значение
только флаг ``p``, остальные флаги игнорируются.

Обратите внимание, что регулярное выражение ``^[-+=][fslmptd_]+$`` соответствует
спецификации флагов. Чтобы сбросить все флаги сразу, используйте ``=_`` или
``-fslmptd``.


Отладочные сообщения во время процесса загрузки
===============================================

Чтобы активировать отладочные сообщения для базового кода и встроенных модулей
во время процесса загрузки, ещё до того как появятся пространство пользователя
(userspace) и debugfs, используйте ``dyndbg="QUERY"`` или
``module.dyndbg="QUERY"``. QUERY следует синтаксису, описанному выше, но не
должна превышать 1023 символов. Ваш загрузчик может накладывать более жёсткие
ограничения.

Эти параметры ``dyndbg`` обрабатываются сразу после обработки таблиц ddebug,
в составе early_initcall. Таким образом, с помощью этого параметра загрузки вы
можете включить отладочные сообщения во всём коде, выполняемом после этого
early_initcall.

Например, на системе x86 включение ACPI — это subsys_initcall, и::

   dyndbg="file ec.c +p"

покажет ранние транзакции встроенного контроллера (Embedded Controller) во
время настройки ACPI, если ваша машина (обычно ноутбук) оснащена встроенным
контроллером. Инициализация PCI (или других устройств) также является
подходящим кандидатом для использования этого параметра загрузки в целях
отладки.

Если модуль ``foo`` не встроен, ``foo.dyndbg`` всё равно будет обработан во
время загрузки без эффекта, но будет обработан повторно при последующей загрузке
модуля. Голый ``dyndbg=`` обрабатывается только при загрузке.


Отладочные сообщения во время инициализации модуля
==================================================

Когда вызывается ``modprobe foo``, modprobe сканирует ``/proc/cmdline`` на
предмет ``foo.params``, отбрасывает ``foo.`` и передаёт их ядру вместе с
параметрами, заданными в аргументах modprobe или в файлах
``/etc/modprobe.d/*.conf``, в следующем порядке:

1. параметры, заданные через ``/etc/modprobe.d/*.conf``::

	options foo dyndbg=+pt
	options foo dyndbg # defaults to +p

2. ``foo.dyndbg``, как задано в аргументах загрузки; ``foo.`` отбрасывается и
   передаётся::

	foo.dyndbg=" func bar +p; func buz +mp"

3. аргументы для modprobe::

	modprobe foo dyndbg==pmf # override previous settings

Эти запросы ``dyndbg`` применяются по порядку, причём последний имеет решающее
слово. Это позволяет аргументам загрузки переопределять или изменять параметры
из ``/etc/modprobe.d`` (что разумно, поскольку 1 распространяется на всю
систему, а 2 специфичен для ядра или загрузки), а аргументам modprobe —
переопределять и то, и другое.

В форме ``foo.dyndbg="QUERY"`` запрос не должен содержать ``module foo``.
``foo`` извлекается из имени параметра и применяется к каждому запросу в
``QUERY``, причём допускается только 1 спецификация match-spec каждого типа.

Параметр ``dyndbg`` является «фиктивным» параметром модуля, что означает:

- модулям не нужно явно определять его
- каждый модуль получает его неявно, независимо от того, использует ли он
  pr_debug или нет
- он не появляется в ``/sys/module/$module/parameters/``.
  Чтобы увидеть его, выполните grep по управляющему файлу или просмотрите
  ``/proc/cmdline.``

Для ядер с ``CONFIG_DYNAMIC_DEBUG`` любые настройки, заданные во время загрузки
(или включённые флагом ``-DDEBUG`` при компиляции), можно отключить позже через
интерфейс debugfs, если отладочные сообщения больше не нужны::

   echo "module module_name -p" > /proc/dynamic_debug/control

Примеры
=======

::

  // enable the message at line 1603 of file svcsock.c
  :#> ddcmd 'file svcsock.c line 1603 +p'

  // enable all the messages in file svcsock.c
  :#> ddcmd 'file svcsock.c +p'

  // enable all the messages in the NFS server module
  :#> ddcmd 'module nfsd +p'

  // enable all 12 messages in the function svc_process()
  :#> ddcmd 'func svc_process +p'

  // disable all 12 messages in the function svc_process()
  :#> ddcmd 'func svc_process -p'

  // enable messages for NFS calls READ, READLINK, READDIR and READDIR+.
  :#> ddcmd 'format "nfsd: READ" +p'

  // enable messages in files of which the paths include string "usb"
  :#> ddcmd 'file *usb* +p'

  // enable all messages
  :#> ddcmd '+p'

  // add module, function to all enabled messages
  :#> ddcmd '+mf'

  // boot-args example, with newlines and comments for readability
  Kernel command line: ...
    // see what's going on in dyndbg=value processing
    dynamic_debug.verbose=3
    // enable pr_debugs in the btrfs module (can be builtin or loadable)
    btrfs.dyndbg="+p"
    // enable pr_debugs in all files under init/
    // and the function parse_one, #cmt is stripped
    dyndbg="file init/* +p #cmt ; func parse_one +p"
    // enable pr_debugs in 2 functions in a module loaded later
    pc87360.dyndbg="func pc87360_init_device +p; func pc87360_find +p"

Конфигурация ядра
=================

Динамическая отладка включается через элементы конфигурации ядра::

  CONFIG_DYNAMIC_DEBUG=y	# build catalog, enables CORE
  CONFIG_DYNAMIC_DEBUG_CORE=y	# enable mechanics only, skip catalog

Если вы не хотите включать динамическую отладку глобально (например, в некоторой
встраиваемой системе), вы можете задать ``CONFIG_DYNAMIC_DEBUG_CORE`` как
базовую поддержку динамической отладки и добавить
``ccflags := -DDYNAMIC_DEBUG_MODULE`` в Makefile любых модулей, которые вы
хотели бы позже отлаживать динамически.


API *prdbg* ядра
================

Следующие функции каталогизируются и поддаются управлению, когда динамическая
отладка включена::

  pr_debug()
  dev_dbg()
  print_hex_dump_debug()
  print_hex_dump_bytes()

В противном случае по умолчанию они отключены; ``ccflags += -DDEBUG`` или
``#define DEBUG`` в исходном файле включат их соответствующим образом.

Если ``CONFIG_DYNAMIC_DEBUG`` не установлен, ``print_hex_dump_debug()`` —
это просто сокращение для ``print_hex_dump(KERN_DEBUG)``.

Для ``print_hex_dump_debug()``/``print_hex_dump_bytes()`` строка формата — это
её аргумент ``prefix_str``, если он является константной строкой; либо
``hexdump`` в случае, когда ``prefix_str`` строится динамически.
