.. include:: <isonum.txt>

========================================================
Поддержка выбора видеорежима (Video Mode Selection) 2.13
========================================================

:Copyright: |copy| 1995--1999 Martin Mares, <mj@ucw.cz>

Введение
~~~~~~~~

Этот небольшой документ описывает функцию «Выбор видеорежима» (Video Mode
Selection), которая позволяет использовать различные специальные видеорежимы,
поддерживаемые видео-BIOS. Из-за использования BIOS выбор ограничен временем
загрузки (до начала распаковки ядра) и работает только на машинах 80X86,
которые загружаются через прошивку BIOS (в отличие от загрузки через UEFI,
kexec и т. п.).

.. note::

   Краткое введение для нетерпеливых: для начала просто используйте vga=ask,
   введите ``scan`` в приглашении выбора видеорежима, выберите режим, который
   хотите использовать, запомните его идентификатор режима (четырёхзначное
   шестнадцатеричное число), а затем установите параметр vga равным этому числу
   (предварительно переведя его в десятичную систему).

Используемый видеорежим выбирается параметром ядра, который можно задать в
Makefile ядра (строка SVGA_MODE=...), либо через опцию «vga=...» загрузчика LILO
(или другого используемого вами загрузчика), либо с помощью утилиты «xrandr»
(входящей в стандартные пакеты утилит Linux). Можно использовать следующие
значения этого параметра::

   NORMAL_VGA - Standard 80x25 mode available on all display adapters.

   EXTENDED_VGA	- Standard 8-pixel font mode: 80x43 on EGA, 80x50 on VGA.

   ASK_VGA - Display a video mode menu upon startup (see below).

   0..35 - Menu item number (when you have used the menu to view the list of
      modes available on your adapter, you can specify the menu item you want
      to use). 0..9 correspond to "0".."9", 10..35 to "a".."z". Warning: the
      mode list displayed may vary as the kernel version changes, because the
      modes are listed in a "first detected -- first displayed" manner. It's
      better to use absolute mode numbers instead.

   0x.... - Hexadecimal video mode ID (also displayed on the menu, see below
      for exact meaning of the ID). Warning: LILO doesn't support
      hexadecimal numbers -- you have to convert it to decimal manually.

Меню
~~~~

Режим ASK_VGA заставляет ядро при загрузке предлагать меню видеорежимов. Оно
отображает сообщение «Press <RETURN> to see video modes available, <SPACE>
to continue or wait 30 secs». Если вы нажмёте <RETURN>, вы попадёте в меню;
если нажмёте <SPACE> или подождёте 30 секунд, ядро загрузится в стандартном
режиме 80x25.

Меню выглядит так::

	Video adapter: <name-of-detected-video-adapter>
	Mode:    COLSxROWS:
	0  0F00  80x25
	1  0F01  80x50
	2  0F02  80x43
	3  0F03  80x26
	....
	Enter mode number or ``scan``: <flashing-cursor-here>

<name-of-detected-video-adapter> сообщает, какой видеоадаптер обнаружил Linux —
это либо обобщённое имя адаптера (MDA, CGA, HGC, EGA, VGA, VESA VGA [VGA с
VESA-совместимым BIOS]), либо имя набора микросхем (например, Trident). Прямое
определение наборов микросхем по умолчанию отключено, поскольку оно изначально
ненадёжно из-за совершенно безумной архитектуры PC.

«0  0F00  80x25» означает, что первый пункт меню (пункты меню нумеруются от «0»
до «9» и от «a» до «z») — это режим 80x25 с ID=0x0f00 (описание идентификаторов
режимов см. в следующем разделе).

<flashing-cursor-here> предлагает вам ввести номер пункта или идентификатор
режима, который вы хотите установить, и нажать <RETURN>. Если компьютер
выдаёт что-то про «Unknown mode ID», он пытается сказать вам, что установить
такой режим невозможно. Можно также нажать только <RETURN>, что оставит текущий
режим.

Список режимов обычно содержит несколько базовых режимов и некоторые режимы
VESA. Если ваш набор микросхем был обнаружен, отображаются также некоторые
режимы, специфичные для него (часть из них может отсутствовать или быть
непригодной к использованию на вашей машине, поскольку с одной и той же картой
часто поставляются разные BIOS, а номера режимов зависят исключительно от
VGA BIOS).

Режимы, отображаемые в меню, частично отсортированы: список начинается со
стандартных режимов (80x25 и 80x50), за которыми следуют «специальные» режимы
(80x28 и 80x43), локальные режимы (если включена функция локальных режимов),
режимы VESA и, наконец, режимы SVGA для автоматически обнаруженного адаптера.

Если вас не устраивает предлагаемый список режимов (например, если вы считаете,
что ваша карта способна на большее), вы можете ввести «scan» вместо номера
пункта / идентификатора режима. Программа попытается запросить у BIOS все
возможные номера видеорежимов и проверить, что произойдёт. Экран, вероятно,
будет некоторое время дико мигать, из монитора будут слышны странные звуки и
т. п., а затем появятся действительно все согласованные видеорежимы,
поддерживаемые вашим BIOS (плюс, возможно, какие-то ``ghost modes``). Если вы
опасаетесь, что это может повредить ваш монитор, не используйте эту функцию.

После сканирования порядок режимов несколько отличается: автоматически
обнаруженные режимы SVGA не отображаются вообще, а режимы, выявленные с помощью
``scan``, показываются перед всеми режимами VESA.

Идентификаторы режимов
~~~~~~~~~~~~~~~~~~~~~~~

Из-за сложности всего, что связано с видео, используемые здесь идентификаторы
видеорежимов также несколько сложны. Идентификатор видеорежима — это 16-битное
число, обычно выражаемое в шестнадцатеричной записи (начинающейся с «0x»). Вы
можете установить режим, введя его напрямую, если знаете его, даже если он не
показан в меню.

Номера идентификаторов можно разделить на следующие диапазоны::

   0x0000 to 0x00ff - menu item references. 0x0000 is the first item. Don't use
	outside the menu as this can change from boot to boot (especially if you
	have used the ``scan`` feature).

   0x0100 to 0x017f - standard BIOS modes. The ID is a BIOS video mode number
	(as presented to INT 10, function 00) increased by 0x0100.

   0x0200 to 0x08ff - VESA BIOS modes. The ID is a VESA mode ID increased by
	0x0100. All VESA modes should be autodetected and shown on the menu.

   0x0900 to 0x09ff - Video7 special modes. Set by calling INT 0x10, AX=0x6f05.
	(Usually 940=80x43, 941=132x25, 942=132x44, 943=80x60, 944=100x60,
	945=132x28 for the standard Video7 BIOS)

   0x0f00 to 0x0fff - special modes (they are set by various tricks -- usually
	by modifying one of the standard modes). Currently available:
	0x0f00	standard 80x25, don't reset mode if already set (=FFFF)
	0x0f01	standard with 8-point font: 80x43 on EGA, 80x50 on VGA
	0x0f02	VGA 80x43 (VGA switched to 350 scanlines with a 8-point font)
	0x0f03	VGA 80x28 (standard VGA scans, but 14-point font)
	0x0f04	leave current video mode
	0x0f05	VGA 80x30 (480 scans, 16-point font)
	0x0f06	VGA 80x34 (480 scans, 14-point font)
	0x0f07	VGA 80x60 (480 scans, 8-point font)
	0x0f08	Graphics hack (see the VIDEO_GFX_HACK paragraph below)

   0x1000 to 0x7fff - modes specified by resolution. The code has a "0xRRCC"
	form where RR is a number of rows and CC is a number of columns.
	E.g., 0x1950 corresponds to a 80x25 mode, 0x2b84 to 132x43 etc.
	This is the only fully portable way to refer to a non-standard mode,
	but it relies on the mode being found and displayed on the menu
	(remember that mode scanning is not done automatically).

   0xff00 to 0xffff - aliases for backward compatibility:
	0xffff	equivalent to 0x0f00 (standard 80x25)
	0xfffe	equivalent to 0x0f01 (EGA 80x43 or VGA 80x50)

Если вы добавите 0x8000 к идентификатору режима, программа попытается пересчитать
вертикальные тайминги отображения в соответствии с параметрами режима, что можно
использовать для устранения некоторых надоедливых ошибок отдельных VGA BIOS
(обычно тех, что используются для карт с наборами микросхем S3 и старых BIOS
Cirrus Logic) — в основном лишних строк в конце экрана.

Опции
~~~~~

Параметры сборки для arch/x86/boot/* выбираются утилитой kconfig ядра и файлом
.config ядра.

VIDEO_GFX_HACK — включает специальный хак для установки графических режимов,
которые будут использоваться позже специальными драйверами. Позволяет
установить _любой_ режим BIOS, включая графические, и принудительно задать
конкретное разрешение текстового экрана вместо считывания его из переменных
BIOS. Не используйте, если не уверены, что понимаете, что делаете. Чтобы
активировать эту настройку, используйте номер режима 0x0f08 (см. раздел
«Идентификаторы режимов» выше).

Всё ещё не работает?
~~~~~~~~~~~~~~~~~~~~

Когда определение режима не работает (например, список режимов неверен или
машина зависает вместо отображения меню), попробуйте отключить некоторые из
параметров конфигурации, перечисленных в разделе «Опции». Если это не помогает,
вы всё ещё можете использовать своё ядро с видеорежимом, заданным напрямую через
параметр ядра.

В любом случае, пожалуйста, пришлите мне отчёт об ошибке, содержащий то, что
_именно_ происходит, и как переключатели конфигурации влияют на поведение
ошибки.

Если вы запускаете Linux из M$-DOS, вы также можете использовать некоторые
инструменты DOS для установки видеорежима. В этом случае вы должны указать Linux
режим 0x0f04 («оставить текущие настройки»), потому что если вы этого не сделаете
и будете использовать какой-либо нестандартный режим, Linux автоматически
переключится на 80x25.

Если вы установили какой-либо расширенный режим и внизу экрана есть одна или
несколько лишних строк, содержащих уже прокрученный текст, ваш VGA BIOS содержит
самую распространённую ошибку видео-BIOS под названием «incorrect vertical
display end setting». Добавление 0x8000 к идентификатору режима может устранить
проблему. К сожалению, это нужно делать вручную — механизмов автоопределения нет.

История
~~~~~~~

=============== ================================================================
1.0 (??-Nov-95)	First version supporting all adapters supported by the old
		setup.S + Cirrus Logic 54XX. Present in some 1.3.4? kernels
		and then removed due to instability on some machines.
2.0 (28-Jan-96)	Rewritten from scratch. Cirrus Logic 64XX support added, almost
		everything is configurable, the VESA support should be much more
		stable, explicit mode numbering allowed, "scan" implemented etc.
2.1 (30-Jan-96) VESA modes moved to 0x200-0x3ff. Mode selection by resolution
		supported. Few bugs fixed. VESA modes are listed prior to
		modes supplied by SVGA autodetection as they are more reliable.
		CLGD autodetect works better. Doesn't depend on 80x25 being
		active when started. Scanning fixed. 80x43 (any VGA) added.
		Code cleaned up.
2.2 (01-Feb-96)	EGA 80x43 fixed. VESA extended to 0x200-0x4ff (non-standard 02XX
		VESA modes work now). Display end bug workaround supported.
		Special modes renumbered to allow adding of the "recalculate"
		flag, 0xffff and 0xfffe became aliases instead of real IDs.
		Screen contents retained during mode changes.
2.3 (15-Mar-96)	Changed to work with 1.3.74 kernel.
2.4 (18-Mar-96)	Added patches by Hans Lermen fixing a memory overwrite problem
		with some boot loaders. Memory management rewritten to reflect
		these changes. Unfortunately, screen contents retaining works
		only with some loaders now.
		Added a Tseng 132x60 mode.
2.5 (19-Mar-96)	Fixed a VESA mode scanning bug introduced in 2.4.
2.6 (25-Mar-96)	Some VESA BIOS errors not reported -- it fixes error reports on
		several cards with broken VESA code (e.g., ATI VGA).
2.7 (09-Apr-96)	- Accepted all VESA modes in range 0x100 to 0x7ff, because some
		  cards use very strange mode numbers.
		- Added Realtek VGA modes (thanks to Gonzalo Tornaria).
		- Hardware testing order slightly changed, tests based on ROM
		  contents done as first.
		- Added support for special Video7 mode switching functions
		  (thanks to Tom Vander Aa).
		- Added 480-scanline modes (especially useful for notebooks,
		  original version written by hhanemaa@cs.ruu.nl, patched by
		  Jeff Chua, rewritten by me).
		- Screen store/restore fixed.
2.8 (14-Apr-96) - Previous release was not compilable without CONFIG_VIDEO_SVGA.
		- Better recognition of text modes during mode scan.
2.9 (12-May-96)	- Ignored VESA modes 0x80 - 0xff (more VESA BIOS bugs!)
2.10(11-Nov-96) - The whole thing made optional.
		- Added the CONFIG_VIDEO_400_HACK switch.
		- Added the CONFIG_VIDEO_GFX_HACK switch.
		- Code cleanup.
2.11(03-May-97) - Yet another cleanup, now including also the documentation.
		- Direct testing of SVGA adapters turned off by default, ``scan``
		  offered explicitly on the prompt line.
		- Removed the doc section describing adding of new probing
		  functions as I try to get rid of _all_ hardware probing here.
2.12(25-May-98) Added support for VESA frame buffer graphics.
2.13(14-May-99) Minor documentation fixes.
=============== ================================================================
