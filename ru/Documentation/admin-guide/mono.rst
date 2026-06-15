Поддержка двоичных файлов Mono(tm) в ядре Linux
-----------------------------------------------

Чтобы настроить Linux на автоматическое выполнение основанных на Mono
двоичных файлов .NET (в виде файлов .exe) без необходимости использовать
обёртку Mono CLR, можно воспользоваться поддержкой BINFMT_MISC в ядре.

Это позволит вам запускать основанные на Mono двоичные файлы .NET так же,
как и любую другую программу, после выполнения следующих действий:

1) Вы ДОЛЖНЫ СНАЧАЛА установить поддержку Mono CLR, либо загрузив
   двоичный пакет или архив с исходным кодом (source tarball), либо
   установив её из Git. Двоичные пакеты для нескольких дистрибутивов
   можно найти по адресу:

	https://www.mono-project.com/download/

   Инструкции по компиляции Mono можно найти по адресу:

	https://www.mono-project.com/docs/compiling-mono/linux/

   После того как поддержка Mono CLR установлена, просто проверьте, что
   ``/usr/bin/mono`` (он может располагаться в другом месте, например
   ``/usr/local/bin/mono``) работает.

2) Вам нужно скомпилировать BINFMT_MISC либо как модуль, либо встроенным
   в ядро (``CONFIG_BINFMT_MISC``) и правильно его настроить.
   Если вы решите скомпилировать его как модуль, вам придётся
   вставлять его вручную с помощью modprobe/insmod, поскольку kmod
   не может быть легко задействован с binfmt_misc.
   Прочитайте файл ``binfmt_misc.txt`` в этом каталоге, чтобы узнать
   больше о процессе настройки.

3) Добавьте следующие записи в ``/etc/rc.local`` или аналогичный скрипт,
   запускаемый при старте системы:

   .. code-block:: sh

    # Insert BINFMT_MISC module into the kernel
    if [ ! -e /proc/sys/fs/binfmt_misc/register ]; then
        /sbin/modprobe binfmt_misc
	# Some distributions, like Fedora Core, perform
	# the following command automatically when the
	# binfmt_misc module is loaded into the kernel
	# or during normal boot up (systemd-based systems).
	# Thus, it is possible that the following line
	# is not needed at all.
	mount -t binfmt_misc none /proc/sys/fs/binfmt_misc
    fi

    # Register support for .NET CLR binaries
    if [ -e /proc/sys/fs/binfmt_misc/register ]; then
	# Replace /usr/bin/mono with the correct pathname to
	# the Mono CLR runtime (usually /usr/local/bin/mono
	# when compiling from sources or CVS).
        echo ':CLR:M::MZ::/usr/bin/mono:' > /proc/sys/fs/binfmt_misc/register
    else
        echo "No binfmt_misc support"
        exit 1
    fi

4) Проверьте, что двоичные файлы ``.exe`` можно запускать без помощи
   скрипта-обёртки, просто запустив файл ``.exe`` напрямую
   из командной строки, например::

	/usr/bin/xsd.exe

   .. note::

      Если это завершается ошибкой отказа в доступе (permission denied),
      проверьте, что у файла ``.exe`` есть права на выполнение.
