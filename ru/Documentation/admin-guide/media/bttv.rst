.. SPDX-License-Identifier: GPL-2.0

================
Драйвер bttv
================

Замечания к выпуску bttv
------------------------

Для bttv вам понадобятся как минимум следующие параметры конфигурации::

    ./scripts/config -e PCI
    ./scripts/config -m I2C
    ./scripts/config -m INPUT
    ./scripts/config -m MEDIA_SUPPORT
    ./scripts/config -e MEDIA_PCI_SUPPORT
    ./scripts/config -e MEDIA_ANALOG_TV_SUPPORT
    ./scripts/config -e MEDIA_DIGITAL_TV_SUPPORT
    ./scripts/config -e MEDIA_RADIO_SUPPORT
    ./scripts/config -e RC_CORE
    ./scripts/config -m VIDEO_BT848

Если на вашей плате есть цифровое ТВ, вам также понадобится::

    ./scripts/config -m DVB_BT8XX

В этом случае дополнительные замечания см. в
Documentation/admin-guide/media/bt8xx.rst.

Как заставить bttv работать с вашей картой
------------------------------------------

Если bttv скомпилирован и установлен, то для попытки его зондирования
обычно достаточно просто загрузить ядро. Однако, в зависимости от
модели, ядру может потребоваться дополнительная информация об
оборудовании, так как устройство может быть не в состоянии предоставить
такие сведения ядру напрямую.

Если этого не происходит, то, вероятно, bttv не смог автоматически
определить вашу карту, и ему нужны некоторые параметры insmod. Самый
важный параметр insmod для bttv — это «card=n» для выбора правильного
типа карты. Если у вас есть видео, но нет звука, то, скорее всего, вы
указали неверный тип карты (или не указали его вовсе). Список
поддерживаемых карт находится в
Documentation/admin-guide/media/bttv-cardlist.rst.

Если bttv загружается очень долго (иногда так бывает с дешёвыми картами
без тюнера), попробуйте добавить следующее в файл конфигурации модулей
(обычно это либо ``/etc/modules.conf``, либо некоторый файл в
``/etc/modules-load.d/``, но фактическое расположение зависит от вашего
дистрибутива)::

	options i2c-algo-bit bit_test=1

Некоторым картам для работы может потребоваться дополнительный файл
прошивки. Например, для WinTV/PVR нужен один файл прошивки с компакт-диска
с драйверами, называемый ``hcwamc.rbf``. Он находится внутри
самораспаковывающегося zip-файла ``pvr45xxx.exe``. Достаточно поместить
его в каталог ``/etc/firmware``, чтобы он автоматически загружался во
время зондирования драйвера (например, при загрузке ядра или при ручной
загрузке драйвера командой ``modprobe``).

Если вашей карты нет в списке
Documentation/admin-guide/media/bttv-cardlist.rst или если у вас возникают
проблемы с работой звука, прочитайте :ref:`still_doesnt_work`.


Автоматическое определение карт
-------------------------------

bttv использует PCI Subsystem ID для автоматического определения типа
карты. lspci выводит Subsystem ID во второй строке, это выглядит так:

.. code-block:: none

	00:0a.0 Multimedia video controller: Brooktree Corporation Bt878 (rev 02)
		Subsystem: Hauppauge computer works Inc. WinTV/GO
		Flags: bus master, medium devsel, latency 32, IRQ 5
		Memory at e2000000 (32-bit, prefetchable) [size=4K]

только карты на базе bt878 могут иметь subsystem ID (что не означает, что
он действительно есть у каждой карты). Карты bt848 не могут иметь
Subsystem ID и поэтому не могут быть определены автоматически. Список
идентификаторов находится в
Documentation/admin-guide/media/bttv-cardlist.rst
(на случай, если вам это интересно или вы хотите прислать патчи с
обновлениями).


.. _still_doesnt_work:

Всё равно не работает?
----------------------

У меня дома НЕТ лаборатории с 30+ различными платами захвата и генератором
тестового сигнала PAL/NTSC/SECAM, поэтому я часто не могу воспроизвести
ваши проблемы. Это сильно затрудняет для меня отладку.

Если у вас есть некоторые знания и свободное время, пожалуйста,
попробуйте исправить это самостоятельно (патчи, конечно же, очень
приветствуются...) Знаете ли: лозунг linux — «Сделай сам».

Существует список рассылки по адресу
http://vger.kernel.org/vger-lists.html#linux-media

Если у вас возникли проблемы с какой-то конкретной ТВ-картой,
попробуйте спросить там, а не писать мне напрямую. Шанс, что там есть
кто-то с такой же картой, гораздо выше...

По поводу проблем со звуком: во всём мире для ТВ-звука используется
множество различных систем. Кроме того, существуют разные микросхемы,
декодирующие звуковой сигнал. Отчёты о проблемах со звуком («стерео не
работает») практически бесполезны, если вы не включаете в них некоторые
подробности о вашем оборудовании и о схеме ТВ-звука, используемой в вашей
стране (или, по крайней мере, в стране, в которой вы живёте).

Параметры modprobe
------------------

.. note::


   Следующий список аргументов может быть устаревшим, так как мы можем
   добавлять новые параметры по мере необходимости. В случае сомнений,
   пожалуйста, проверьте через ``modinfo <module>``.

   Эта команда выводит различную информацию о модуле ядра, в том числе
   полный и актуальный список параметров insmod.



bttv
	Драйвер bt848/878 (микросхема захвата)

    аргументы insmod::

	    card=n		тип карты, список см. в CARDLIST.
	    tuner=n		тип тюнера, список см. в CARDLIST.
	    radio=0/1	карта поддерживает радио
	    pll=0/1/2	настройки pll

				    0: не использовать PLL
				    1: установлен кварц 28 МГц
				    2: установлен кварц 35 МГц

	    triton1=0/1     совместимость с Triton1 (+другими)
	    vsfx=0/1	ещё один бит совместимости с ошибкой чипсета
				    подробности об этих двух см. в README.quirks.

	    bigendian=n	Задаёт порядок байтов в gfx-фреймбуфере.
				    По умолчанию используется собственный порядок байтов.
	    fieldnr=0/1	Считать поля. Некоторому ПО для дескремблирования ТВ
				    это нужно, для остального это лишь генерирует
				    50 бесполезных IRQ/сек. По умолчанию 0 (выкл).
	    autoload=0/1	автозагрузка вспомогательных модулей (tuner, audio).
				    по умолчанию 1 (вкл).
	    bttv_verbose=0/1/2  уровень подробности (во время insmod, при
				    осмотре оборудования). по умолчанию 1.
	    bttv_debug=0/1	отладочные сообщения (для захвата).
				    по умолчанию 0 (выкл).
	    irq_debug=0/1	отладочные сообщения обработчика прерываний.
				    по умолчанию 0 (выкл).
	    gbuffers=2-32	количество буферов захвата для захвата через mmap.
				    по умолчанию 4.
	    gbufsize=	размер буферов захвата. значение по умолчанию и
				    максимальное значение — 0x208000 (~2 МБ)
	    no_overlay=0	Включить наложение (overlay) на неисправном
				    оборудовании. Есть некоторые чипсеты
				    (например, SIS), о которых известно, что
				    у них есть проблемы с проталкиванием PCI DMA,
				    используемым bttv. По умолчанию bttv отключает
				    наложение на таком оборудовании во избежание
				    сбоев. С помощью этого параметра insmod вы
				    можете это переопределить.
	    no_overlay=1	Отключить наложение. Его следует использовать на
				    неисправном оборудовании, которое не поддерживает
				    прямые передачи PCI2PCI.
	    automute=0/1	Автоматически отключает звук, если ТВ-сигнала нет;
				    по умолчанию включено. Вы можете попробовать
				    отключить это, если у вас плохое качество
				    входного сигнала, приводящее к нежелательным
				    пропаданиям звука.
	    chroma_agc=0/1	AGC сигнала цветности, по умолчанию выключено.
	    adc_crush=0/1	Luminance ADC crush, по умолчанию включено.
	    i2c_udelay=     Позволяет снизить скорость I2C. По умолчанию 5 мкс
				    (что соответствует 66,67 Кбит/с). Это
				    максимальная скорость, поддерживаемая
				    алгоритмом bitbang ядра. Вы можете использовать
				    меньшие значения, если сообщения I2C теряются
				    (известно, что значение 16 работает на всех
				    поддерживаемых картах).

	    bttv_gpio=0/1
	    gpiomask=
	    audioall=
	    audiomux=
				    Подробное описание см. в Sound-FAQ.

	remap, card, radio и pll принимают до четырёх аргументов через запятую
	(для нескольких плат).

tuner
	Драйвер тюнера. Он нужен, если только вы не хотите использовать
	карту лишь с камерой или плата не обеспечивает аналоговую ТВ-настройку.

	аргументы insmod::

		debug=1		выводить некоторую отладочную информацию в syslog
		type=n		тип микросхемы тюнера. n следующим образом:
				полный список см. в CARDLIST.
		pal=[bdgil]	выбор варианта PAL (используется только для
				некоторых тюнеров, важно для звуковой несущей).

tvaudio
	Предоставляет единый драйвер для всех простых микросхем управления
	звуком i2c (tda/tea*).

	аргументы insmod::

		tda8425  = 1	включить/отключить поддержку
		tda9840  = 1	различных микросхем.
		tda9850  = 1	tea6300 не может быть определён автоматически и
		tda9855  = 1	поэтому по умолчанию выключен; если он есть
		tda9873  = 1	на вашей карте (STB используют такие)
		tda9874a = 1	вам придётся включить его явно.
		tea6300  = 0	Две микросхемы tda985x используют один и тот же
		tea6420  = 1	адрес i2c, и их нельзя отличить друг
		pic16c54 = 1	от друга, возможно, вам придётся отключить
				неправильную из них.
		debug = 1	выводить отладочные сообщения

msp3400
	Драйвер микросхем звукового процессора msp34xx. Если у вас
	стереокарта, вы, вероятно, захотите загрузить именно этот модуль через insmod.

	аргументы insmod::

		debug=1/2	выводить некоторую отладочную информацию в syslog,
				2 — более подробно.
		simple=1	Использовать метод «короткого программирования».
				Более новые версии msp34xx поддерживают это.
				Это нужно для стерео dbx. По умолчанию включено,
				если поддерживается микросхемой.
		once=1		Не проверять режим звука ТВ-станций каждые
				несколько секунд, а только один раз после
				переключения каналов.
		amsound=1	Звуковая несущая — AM/NICAM на 6.5 МГц. Это
				должно улучшить ситуацию для французов,
				автосканирование несущей, по-видимому, работает
				только с FM...

Если ящик намертво зависает с bttv
----------------------------------

Это может быть ошибка драйвера bttv. Это также может быть неисправное
оборудование. Это также может быть что-то ещё...

Простое письмо мне с текстом «bttv зависает» вряд ли сильно поможет. В
этом README есть несколько подсказок о том, как вы можете помочь
локализовать проблему.


Ошибки bttv
~~~~~~~~~~~

Если одна версия работает, а другая нет, то, скорее всего, это ошибка
драйвера. Очень полезно, если вы можете сказать, где именно она появилась
(т. е. последняя работающая и первая неработающая версия).

При жёстком зависании вы, вероятно, ничего не найдёте в файлах журналов.
Единственный способ захватить какие-либо сообщения ядра — это подключить
последовательную консоль и позволить какому-нибудь терминальному
приложению вести журнал сообщений. /me использует screen. Подробности о
настройке последовательной консоли см. в
Documentation/admin-guide/serial-console.rst.

Прочитайте Documentation/admin-guide/bug-hunting.rst, чтобы узнать, как
извлечь какую-либо полезную информацию из дампа регистров+стека, выводимого
ядром при ошибках защиты (так называемых «kernel oops»).

Если вы столкнулись с какой-либо взаимоблокировкой (deadlock), вы можете
попробовать сделать дамп трассировки вызовов для каждого процесса с помощью
sysrq-t (см. Documentation/admin-guide/sysrq.rst). Так можно выяснить, где
*именно* застрял какой-то процесс в состоянии «D».

Я видел отчёты о том, что bttv 0.7.x падает, тогда как 0.8.x у некоторых
людей работает железобетонно. Так что, вероятно, где-то в bttv 0.7.x
осталась небольшая ошибочка. Понятия не имею, где именно; у меня и у
множества других людей она работает стабильно. Но в случае, если у вас
есть проблемы с версиями 0.7.x, вы можете попробовать 0.8.x...


Аппаратные ошибки
~~~~~~~~~~~~~~~~~

Некоторое оборудование не может работать с передачами PCI-PCI (т. е.
grabber => vga). Иногда проблемы с bttv возникают просто из-за высокой
нагрузки на шину PCI. У микросхем bt848/878 есть несколько обходных
решений для известных несовместимостей, см. README.quirks.

Некоторые сообщают, что увеличение задержки pci тоже помогает, хотя я не
уверен, действительно ли это устраняет проблемы или лишь снижает
вероятность их возникновения. И у bttv, и у btaudio есть параметр insmod
для установки задержки PCI устройства.

У некоторых системных плат есть проблемы с корректной работой нескольких
устройств, выполняющих DMA одновременно. bttv + ide, похоже, иногда это
вызывает; если это ваш случай, то вы, вероятно, наблюдаете зависания
только при одновременном видео и доступе к жёсткому диску. Обновление
драйвера IDE для получения новейших и наилучших обходных решений
аппаратных ошибок может устранить эти проблемы.


Прочее
~~~~~~

Если вы используете какой-нибудь закрытый хлам (вроде модуля nvidia),
попробуйте воспроизвести проблему без него.

Известно, что разделение IRQ в некоторых случаях вызывает проблемы. В
теории и во многих конфигурациях оно прекрасно работает. Тем не менее,
возможно, стоит попробовать переставить карты PCI местами, чтобы дать bttv
другой IRQ или заставить его разделять IRQ с каким-то другим оборудованием.
Разделение IRQ с VGA-картами, похоже, иногда вызывает неполадки. Я также
видел забавные эффекты, когда bttv разделял IRQ с мостом ACPI (и
apci-включённым ядром).

Особенности bttv
----------------

Ниже приведено то, что говорится в технической документации bt878 о
режимах совместимости с ошибкой PCI микросхемы bt878.

Параметр insmod triton1 устанавливает бит EN_TBFX в регистре управления.
Параметр insmod vsfx делает то же самое для бита EN_VSFX. Если у вас
проблемы со стабильностью, вы можете попробовать, заставит ли один из этих
параметров ваш ящик работать стабильно.

drivers/pci/quirks.c знает об этих проблемах, благодаря чему эти биты
включаются автоматически для известных неисправных чипсетов (посмотрите на
сообщения ядра, bttv вам сообщит).

Обычный режим PCI
~~~~~~~~~~~~~~~~~

Сигнал PCI REQ представляет собой логическое ИЛИ входящих запросов функций.
Внутренние сигналы GNT[0:1] асинхронно стробируются по GNT и
демультиплексируются сигналом запроса аудио. Таким образом, при включении
питания арбитр по умолчанию выбирает видеофункцию и «паркуется» на ней во
время отсутствия запросов на доступ к шине. Это желательно, поскольку видео
будет запрашивать шину чаще. Однако аудио будет иметь наивысший приоритет
доступа к шине. Таким образом, аудио получит первый доступ к шине, даже если
выдаст запрос после видеозапроса, но до того, как внешний арбитр PCI
предоставит доступ к Bt879. Ни одна из функций не может вытеснить другую,
оказавшись на шине. Длительность опорожнения всего видео-FIFO PCI на шину PCI
очень мала по сравнению с задержкой доступа к шине, которую может допустить
аудио-FIFO PCI.


Режим совместимости 430FX
~~~~~~~~~~~~~~~~~~~~~~~~~~

При использовании 430FX PCI следующие правила обеспечат совместимость:

 (1) Снимайте REQ одновременно с установкой FRAME.
 (2) Не устанавливайте REQ повторно для запроса другой транзакции шины до
     завершения предыдущей транзакции.

Поскольку отдельные ведущие устройства шины не имеют прямого управления REQ,
простое логическое ИЛИ видео- и аудиозапросов нарушило бы эти правила.
Поэтому и арбитр, и инициатор содержат логику режима совместимости 430FX.
Чтобы включить режим 430FX, установите бит EN_TBFX, как указано в Device
Control Register на странице 104.

Когда EN_TBFX включён, арбитр гарантирует выполнение обоих правил
совместимости. До того как PCI-арбитр установит GNT, этот внутренний арбитр
всё ещё может выполнять логическое ИЛИ двух запросов. Однако, как только
выдан GNT, этот арбитр должен зафиксировать своё решение и теперь
направлять на вывод REQ только предоставленный запрос. Фиксация решения
арбитра происходит независимо от состояния FRAME, поскольку он не знает,
когда будет установлен FRAME (обычно — каждый инициатор устанавливает FRAME
на цикле, следующем за GNT). Когда FRAME установлен, в обязанности
инициатора входит снять свой запрос в то же время. В обязанности арбитра
входит позволить этому запросу пройти к REQ и не позволить другому запросу
удерживать REQ установленным. Фиксация решения может быть снята в конце
транзакции: например, когда шина простаивает (FRAME и IRDY). Затем решение
арбитра может продолжаться асинхронно до тех пор, пока GNT снова не будет
установлен.


Сопряжение с базовой логикой, не соответствующей PCI 2.1
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Небольшой процент устройств базовой логики может начать транзакцию шины во
время того же цикла, в котором снимается GNT. Это не соответствует PCI 2.1.
Чтобы обеспечить совместимость при использовании ПК с этими PCI-контроллерами,
необходимо включить бит EN_VSFX (см. Device Control Register на странице 104).
В этом режиме арбитр не передаёт GNT внутренним функциям, если не установлен
REQ. Это предотвращает начало транзакции шины в том же цикле, когда снимается
GNT. Это также имеет побочный эффект невозможности воспользоваться
преимуществами парковки шины, что снижает производительность арбитража.
Драйверы Bt879 должны опрашивать эти несоответствующие устройства и
устанавливать бит EN_VSFX, только если это требуется.


Другие элементы массива tvcards
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Если вы пытаетесь заставить работать новую карту, вам может быть полезно
узнать, для чего предназначены остальные элементы массива tvcards::

	video_inputs    - кол-во видеовходов у карты
	audio_inputs    - историческое наследие, больше не используется.
	tuner           - какой вход является тюнером
	svhs            - какой вход является svhs (все остальные помечены как composite)
	muxsel          - видеомультиплексор, отображение input->registervalue
	pll             - то же, что параметр insmod pll=
	tuner_type      - то же, что параметр insmod tuner=
	*_modulename    - подсказка, нужно ли какой-то карте загрузить тот или иной
			аудиомодуль для корректной работы.
	has_radio	- есть ли у этой ТВ-карты радиотюнер.
	no_msp34xx	- «1» отключает загрузку модуля msp3400.o
	no_tda9875	- «1» отключает загрузку модуля tda9875.o
	needs_tvaudio	- установите в «1» для загрузки модуля tvaudio.o

Если некоторый элемент конфигурации задан и в массиве tvcards, и как
параметр insmod, приоритет имеет параметр insmod.

Карты
-----

.. note::

   Более обновлённый список см. на
   https://linuxtv.org/wiki/index.php/Hardware_Device_Information

Поддерживаемые карты: карты Bt848/Bt848a/Bt849/Bt878/Bt879
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Поддерживаются все карты с Bt848/Bt848a/Bt849/Bt878/Bt879 и обычными
входами Composite/S-VHS. Поддержка телетекста и Intercast (только PAL)
для ВСЕХ карт через программное декодирование сэмплов VBI.

Некоторые карты с дополнительным мультиплексированием входов или другими
дополнительными «навороченными» микросхемами поддерживаются лишь частично
(если только не предоставлены спецификации производителем карты). Если
карта указана здесь, это не обязательно означает, что она полностью
поддерживается.

Все остальные карты отличаются лишь дополнительными компонентами, такими
как тюнеры, звуковые декодеры, EEPROM, декодеры телетекста...


MATRIX Vision
~~~~~~~~~~~~~

MV-Delta
- Bt848A
- 4 входа Composite, 1 вход S-VHS (общий с 4-м composite)
- EEPROM

http://www.matrix-vision.de/

У этой карты нет тюнера, но она поддерживает все 4 composite (1 общий с
входом S-VHS) у Bt848A.
Очень хорошая карта, если у вас есть только спутниковое ТВ, но к карте
через composite подключено несколько тюнеров.

Большое спасибо Matrix-Vision за то, что бесплатно предоставили нам 2
карты, что сделало возможной поддержку работы Bt848a/Bt849 с одним кварцем!!!



Miro/Pinnacle PCTV
~~~~~~~~~~~~~~~~~~

- Bt848
  некоторые (все??) поставляются с 2 кварцами для PAL/SECAM и NTSC
- ТВ-тюнер PAL, SECAM или NTSC (Philips или TEMIC)
- звуковой декодер MSP34xx на дополнительной плате
  декодер поддерживается, но, насколько я знаю, пока не работает
  (нужна другая настройка звукового MUX в порту GPIO??? кто-нибудь это исправил???)
- 1 тюнер, 1 вход composite и 1 вход S-VHS
- тип тюнера определяется автоматически

http://www.miro.de/
http://www.miro.com/


Большое спасибо за бесплатную карту, которая сделала возможной первую
поддержку NTSC ещё в 1997 году!


Hauppauge Win/TV pci
~~~~~~~~~~~~~~~~~~~~

Существует множество различных версий карт Hauppauge с разными тюнерами
(ТВ+Радио...), декодерами телетекста.
Обратите внимание, что даже карты с одинаковыми номерами моделей имеют (в
зависимости от ревизии) разные микросхемы.

- Bt848 (и другие, но всегда в режиме работы с 2 кварцами???)
  более новые карты имеют Bt878

- PAL, SECAM, NTSC или тюнер с поддержкой Радио или без неё

например:

- PAL:

  - TDA5737: VHF, hyperband and UHF mixer/oscillator for TV and VCR 3-band tuners
  - TSA5522: 1.4 GHz I2C-bus controlled synthesizer, I2C 0xc2-0xc3

- NTSC:

  - TDA5731: VHF, hyperband and UHF mixer/oscillator for TV and VCR 3-band tuners
  - TSA5518: техническая документация недоступна на сайте Philips

- Микросхема декодера телетекста Philips SAA5246 или SAA5284 (либо нет)
  с буферной памятью RAM (например, Winbond W24257AS-35: 32Kx8 CMOS static RAM)
  SAA5246 (I2C 0x22) поддерживается

- 256-байтовый EEPROM: Microchip 24LC02B или Philips 8582E2Y
  с информацией о конфигурации
  адрес I2C 0xa0 (24LC02B также отвечает на 0xa2-0xaf)

- 1 тюнер, 1 вход composite и (в зависимости от модели) 1 вход S-VHS

- 14052B: мультиплексор для выбора источника звука

- звуковой декодер: TDA9800, MSP34xx (стереокарты)


Askey CPH-Series
~~~~~~~~~~~~~~~~
Разработано TelSignal(?), OEM-поставки многими вендорами (Typhoon, Anubis, Dynalink)

- Серия карт:
  - CPH01x: BT848 только захват
  - CPH03x: BT848
  - CPH05x: BT878 с FM
  - CPH06x: BT878 (без FM)
  - CPH07x: BT878 только захват

- ТВ-стандарты:
  - CPH0x0: NTSC-M/M
  - CPH0x1: PAL-B/G
  - CPH0x2: PAL-I/I
  - CPH0x3: PAL-D/K
  - CPH0x4: SECAM-L/L
  - CPH0x5: SECAM-B/G
  - CPH0x6: SECAM-D/K
  - CPH0x7: PAL-N/N
  - CPH0x8: PAL-B/H
  - CPH0x9: PAL-M/M

- CPH03x часто продавалась как «TV capturer».

Идентификация:

  #) Карты 878 можно идентифицировать по PCI Subsystem-ID:
     - 144f:3000 = CPH06x
     - 144F:3002 = CPH05x w/ FM
     - 144F:3005 = CPH06x_LC (без пульта дистанционного управления)
  #) На карты сзади наклеена наклейка с моделью «CPH».
  #) На этих картах есть номер, напечатанный на печатной плате прямо над металлической коробкой тюнера:
     - "80-CP2000300-x" = CPH03X
     - "80-CP2000500-x" = CPH05X
     - "80-CP2000600-x" = CPH06X / CPH06x_LC

  Askey продаёт эти карты как «Magic TView series», бренд «MagicXpress».
  Другие OEM часто называют их «Tview», «TView99» или иначе.

Lifeview Flyvideo Series:
~~~~~~~~~~~~~~~~~~~~~~~~~

Наименование этих серий различается во времени и пространстве.

Идентификация:
  #) Некоторые модели можно идентифицировать по PCI subsystem ID:

     - 1852:1852 = Flyvideo 98 FM
     - 1851:1850 = Flyvideo 98
     - 1851:1851 = Flyvideo 98 EZ (только захват)

  #) На печатной плате есть надпись:

     - LR25       = Flyvideo (Zoran ZR36120, SAA7110A)
     - LR26 Rev.N = Flyvideo II (Bt848)
     - LR26 Rev.O = Flyvideo II (Bt878)
     - LR37 Rev.C = Flyvideo EZ (Capture only, ZR36120 + SAA7110)
     - LR38 Rev.A1= Flyvideo II EZ (Bt848 capture only)
     - LR50 Rev.Q = Flyvideo 98 (w/eeprom and PCI subsystem ID)
     - LR50 Rev.W = Flyvideo 98 (no eeprom)
     - LR51 Rev.E = Flyvideo 98 EZ (capture only)
     - LR90       = Flyvideo 2000 (Bt878)
     - LR90 Flyvideo 2000S (Bt878) w/Stereo TV (Package incl. LR91 daughterboard)
     - LR91       = Stereo daughter card for LR90
     - LR97       = Flyvideo DVBS
     - LR99 Rev.E = Low profile card for OEM integration (only internal audio!) bt878
     - LR136	 = Flyvideo 2100/3100 (Low profile, SAA7130/SAA7134)
     - LR137      = Flyvideo DV2000/DV3000 (SAA7130/SAA7134 + IEEE1394)
     - LR138 Rev.C= Flyvideo 2000 (SAA7130)
     - LR138 Flyvideo 3000 (SAA7134) w/Stereo TV

	- Они существуют в вариациях w/FM и w/Remote, иногда обозначаемых
	  суффиксами «FM» и «R».

  #) У вас ноутбук (карта miniPCI):

      - Product    = FlyTV Platinum Mini
      - Model/Chip = LR212/saa7135

      - Lifeview.com.tw утверждает (февр. 2002):
        "The FlyVideo2000 and FlyVideo2000s product name have renamed to FlyVideo98."
        Их карты Bt8x8 указаны как снятые с производства.
      - Flyvideo 2000S, вероятно, продавалась как Flyvideo 3000 в некоторых странах (Европа?).
        Новые Flyvideo 2000/3000 основаны на SAA7130/SAA7134.

«Flyvideo II» было названием карт 848, в настоящее время (в Германии)
это название повторно используется для LR50 Rev.W.

Веб-сайт Lifeview в какой-то момент упоминал Flyvideo III, но такой карты
пока не встречалось (возможно, это было немецкое название LR90 [стерео]).
Эти карты также продаются многими OEM.

FlyVideo A2 (Elta 8680)= LR90 Rev.F (w/Remote, w/o FM, stereo TV by tda9821) {Germany}

Lifeview 3000 (Elta 8681), продаваемая Plus (апрель 2002), Германия = LR138 w/ saa7134

кодирование конфигурации lifeview на выводах gpio 0-9
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- LR50 rev. Q ("PARTS: 7031505116), Tuner wurde als Nr. 5 erkannt, Eingänge
  SVideo, TV, Composite, Audio, Remote:

 - CP9..1=100001001 (1: 0-Ohm-Widerstand gegen GND unbestückt; 0: bestückt)


Typhoon TV card series:
~~~~~~~~~~~~~~~~~~~~~~~

Это могут быть серии CPH, Flyvideo, Pixelview или KNC1.

Typhoon — это бренд Anubis.

Модель 50680 использовалась повторно, у некоторых номеров моделей со
временем менялось содержимое.

Модели:

  - 50680 "TV Tuner PCI Pal BG"(old,red package)=can be CPH03x(bt848) or CPH06x(bt878)
  - 50680 "TV Tuner Pal BG" (blue package)= Pixelview PV-BT878P+ (Rev 9B)
  - 50681 "TV Tuner PCI Pal I" (variant of 50680)
  - 50682 "TView TV/FM Tuner Pal BG"       = Flyvideo 98FM (LR50 Rev.Q)

  .. note::

	 На упаковке изображён CPH05x (который был бы настоящим TView)

  - 50683 "TV Tuner PCI SECAM" (variant of 50680)
  - 50684 "TV Tuner Pal BG"                = Pixelview 878TV(Rev.3D)
  - 50686 "TV Tuner"                       = KNC1 TV Station
  - 50687 "TV Tuner stereo"                = KNC1 TV Station pro
  - 50688 "TV Tuner RDS" (black package)   = KNC1 TV Station RDS
  - 50689  TV SAT DVB-S CARD CI PCI (SAA7146AH, SU1278?) = "KNC1 TV Station DVB-S"
  - 50692 "TV/FM Tuner" (small PCB)
  - 50694  TV TUNER CARD RDS (PHILIPS CHIPSET SAA7134HL)
  - 50696  TV TUNER STEREO (PHILIPS CHIPSET SAA7134HL, MK3ME Tuner)
  - 50804  PC-SAT TV/Audio Karte = Techni-PC-Sat (ZORAN 36120PQC, Tuner:Alps)
  - 50866  TVIEW SAT RECEIVER+ADR
  - 50868 "TV/FM Tuner Pal I" (variant of 50682)
  - 50999 "TV/FM Tuner Secam" (variant of 50682)

Guillemot
~~~~~~~~~

Модели:

- Maxi-TV PCI (ZR36120)
- Maxi TV Video 2 = LR50 Rev.Q (FI1216MF, PAL BG+SECAM)
- Maxi TV Video 3 = CPH064 (PAL BG + SECAM)

Mentor
~~~~~~

Mentor TV card ("55-878TV-U1") = Pixelview 878TV(Rev.3F) (w/FM w/Remote)

Prolink
~~~~~~~

- ТВ-карты:

  - PixelView Play TV pro - (Model: PV-BT878P+ REV 8E)
  - PixelView Play TV pro - (Model: PV-BT878P+ REV 9D)
  - PixelView Play TV pro - (Model: PV-BT878P+ REV 4C / 8D / 10A )
  - PixelView Play TV - (Model: PV-BT848P+)
  - 878TV - (Model: PV-BT878TV)

- Мультимедийные ТВ-комплекты (карта + пакет ПО):

  - PixelView Play TV Theater - (Model: PV-M4200) =  PixelView Play TV pro + Software
  - PixelView Play TV PAK -     (Model: PV-BT878P+ REV 4E)
  - PixelView Play TV/VCR -     (Model: PV-M3200 REV 4C / 8D / 10A )
  - PixelView Studio PAK -      (Model:    M2200 REV 4C / 8D / 10A )
  - PixelView PowerStudio PAK - (Model: PV-M3600 REV 4E)
  - PixelView DigitalVCR PAK -  (Model: PV-M2400 REV 4C / 8D / 10A )
  - PixelView PlayTV PAK II (TV/FM card + usb camera)  PV-M3800
  - PixelView PlayTV XP PV-M4700,PV-M4700(w/FM)
  - PixelView PlayTV DVR PV-M4600  package contents:PixelView PlayTV pro, windvr & videoMail s/w

- Прочие карты:

  - PV-BT878P+rev.9B (Play TV Pro, opt. w/FM w/NICAM)
  - PV-BT878P+rev.2F
  - PV-BT878P Rev.1D (bt878, capture only)

  - XCapture PV-CX881P (cx23881)
  - PlayTV HD PV-CX881PL+, PV-CX881PL+(w/FM) (cx23881)

  - DTV3000 PV-DTV3000P+ DVB-S CI = Twinhan VP-1030
  - DTV2000 DVB-S = Twinhan VP-1020

- Видеоконференцсвязь:

  - PixelView Meeting PAK - (Model: PV-BT878P)
  - PixelView Meeting PAK Lite - (Model: PV-BT878P)
  - PixelView Meeting PAK plus - (Model: PV-BT878P+rev 4C/8D/10A)
  - PixelView Capture - (Model: PV-BT848P)
  - PixelView PlayTV USB pro
  - Model No. PV-NT1004+, PV-NT1004+ (w/FM) = NT1004 USB decoder chip + SAA7113 video decoder chip

Dynalink
~~~~~~~~

Это серия CPH.

Phoebemicro
~~~~~~~~~~~

- TV Master    = CPH030 or CPH060
- TV Master FM = CPH050

Genius/Kye
~~~~~~~~~~

- Video Wonder/Genius Internet Video Kit = LR37 Rev.C
- Video Wonder Pro II (848 or 878) = LR26

Tekram
~~~~~~

- VideoCap C205 (Bt848)
- VideoCap C210 (zr36120 +Philips)
- CaptureTV M200 (ISA)
- CaptureTV M205 (Bt848)

Lucky Star
~~~~~~~~~~

- Image World Conference TV = LR50 Rev. Q

Leadtek
~~~~~~~

- WinView 601 (Bt848)
- WinView 610 (Zoran)
- WinFast2000
- WinFast2000 XP

Поддержка Leadtek WinView 601 TV/FM
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Автор этого раздела: Jon Tombs <jon@gte.esi.us.es>

Эта карта в основном такая же, как и все остальные (Bt484A, тюнер Philips),
главное отличие в том, что к 3 линиям GPIO подключён программируемый
аттенюатор, чтобы обеспечить некоторое управление громкостью. Они также
встроили на плату ИК-пульт дистанционного управления с декодированием; я
добавлю поддержку этого, когда у меня будет время (он просто генерирует
прерывание на каждое нажатие клавиши, при этом код клавиши помещается в
порт GPIO).

У меня пока нет ни одного приложения для тестирования поддержки радио.
Установка частоты тюнера должна работать, но возможно, что звуковой
мультиплексор задан неверно. Если это не работает, пришлите мне письмо.


- Никакого спасибо Leadtek — они отказались отвечать на любые вопросы об их
  оборудовании. Драйвер был написан путём визуального осмотра карты. Если вы
  используете этот драйвер, отправьте им оскорбительное письмо и скажите им,
  что вы не продолжите покупать их оборудование, пока они не начнут
  поддерживать Linux.

- Небольшое спасибо Princeton Technology Corp (http://www.princeton.com.tw),
  которая делает звуковой аттенюатор. Их общедоступная техническая документация,
  имеющаяся на их веб-сайте, не содержит информации о программировании
  микросхемы! Спрятанные на их сервере, есть полные технические документации,
  но не спрашивайте, как я их нашёл.

Чтобы использовать драйвер, я применяю следующие параметры, настройки
тюнера и pll в вашей стране могут отличаться. Вы можете задать их
принудительно через параметры modprobe. Например::

    modprobe bttv  tuner=1 pll=28 radio=1 card=17

Задаёт тип тюнера 1 (Philips PAL_I), PLL с кварцем 28 МГц, включает
FM-радио и выбирает bttv card ID 17 (Leadtek WinView 601).


KNC One
~~~~~~~

- TV-Station
- TV-Station SE (+Software Bundle)
- TV-Station pro (+TV stereo)
- TV-Station FM (+Radio)
- TV-Station RDS (+RDS)
- TV Station SAT (analog satellite)
- TV-Station DVB-S

.. note:: более новые карты имеют saa7134, но название модели осталось прежним?

Provideo
~~~~~~~~

-  PV951 или PV-951, теперь называется PV-951T
   (также продаётся как:
   Boeder TV-FM Video Capture Card,
   Titanmedia Supervision TV-2400,
   Provideo PV951 TF,
   3DeMon PV951,
   MediaForte TV-Vision PV951,
   Yoko PV951,
   Vivanco Tuner Card PCI Art.-Nr.: 68404
   )

- Серия видеонаблюдения:

 - PV-141
 - PV-143
 - PV-147
 - PV-148 (только захват)
 - PV-150
 - PV-151

- Серия тюнеров TV-FM:

 - PV-951TDV (tv tuner + 1394)
 - PV-951T/TF
 - PV-951PT/TF
 - PV-956T/TF Low Profile
 - PV-911

Highscreen
~~~~~~~~~~

Модели:

- TV Karte = LR50 Rev.S
- TV-Boostar = Terratec Terra TV+ Version 1.0 (Bt848, tda9821) "ceb105.pcb"

Zoltrix
~~~~~~~

Модели:

- Face to Face Capture (Bt848 capture only) (PCB "VP-2848")
- Face To Face TV MAX (Bt848) (PCB "VP-8482 Rev1.3")
- Genie TV (Bt878) (PCB "VP-8790 Rev 2.1")
- Genie Wonder Pro

AVerMedia
~~~~~~~~~

- AVer FunTV Lite (ISA, AV3001 chipset)  "M101.C"
- AVerTV
- AVerTV Stereo
- AVerTV Studio (w/FM)
- AVerMedia TV98 with Remote
- AVerMedia TV/FM98 Stereo
- AVerMedia TVCAM98
- TVCapture (Bt848)
- TVPhone (Bt848)
- TVCapture98 (="AVerMedia TV98" in USA) (Bt878)
- TVPhone98 (Bt878, w/FM)

======== =========== =============== ======= ====== ======== =======================
PCB      PCI-ID      Model-Name      Eeprom  Tuner  Sound    Country
======== =========== =============== ======= ====== ======== =======================
M101.C   ISA !
M108-B      Bt848                     --     FR1236		 US   [#f2]_, [#f3]_
M1A8-A      Bt848    AVer TV-Phone           FM1216  --
M168-T   1461:0003   AVerTV Studio   48:17   FM1216 TDA9840T  D    [#f1]_ w/FM w/Remote
M168-U   1461:0004   TVCapture98     40:11   FI1216   --      D    w/Remote
M168II-B 1461:0003   Medion MD9592   48:16   FM1216 TDA9873H  D    w/FM
======== =========== =============== ======= ====== ======== =======================

.. [#f1] Дочерняя плата MB68-A с TDA9820T и TDA9840T
.. [#f2] Sony NE41S распаяна (стереозвук?)
.. [#f3] Дочерняя плата M118-A с pic 16c54 и кварцем 4 МГц

- На сайте для США есть другие драйверы для (по состоянию на 09/2002):

  - EZ Capture/InterCam PCI (BT-848 chip)
  - EZ Capture/InterCam PCI (BT-878 chip)
  - TV-Phone (BT-848 chip)
  - TV98 (BT-848 chip)
  - TV98 With Remote (BT-848 chip)
  - TV98 (BT-878 chip)
  - TV98 With Remote (BT-878)
  - TV/FM98 (BT-878 chip)
  - AVerTV
  - AverTV Stereo
  - AVerTV Studio

DE hat diverse Treiber fuer diese Modelle (Stand 09/2002):

  - TVPhone (848) mit Philips tuner FR12X6 (w/ FM radio)
  - TVPhone (848) mit Philips tuner FM12X6 (w/ FM radio)
  - TVCapture (848) w/Philips tuner FI12X6
  - TVCapture (848) non-Philips tuner
  - TVCapture98 (Bt878)
  - TVPhone98 (Bt878)
  - AVerTV und TVCapture98 w/VCR (Bt 878)
  - AVerTVStudio und TVPhone98 w/VCR (Bt878)
  - AVerTV GO Series (Kein SVideo Input)
  - AVerTV98 (BT-878 chip)
  - AVerTV98 mit Fernbedienung (BT-878 chip)
  - AVerTV/FM98 (BT-878 chip)

  - VDOmate (www.averm.com.cn) = M168U ?

Aimslab
~~~~~~~

Модели:

- Video Highway or "Video Highway TR200" (ISA)
- Video Highway Xtreme (aka "VHX") (Bt848, FM w/ TEA5757)

IXMicro (former: IMS=Integrated Micro Solutions)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- IXTV BT848 (=TurboTV)
- IXTV BT878
- IMS TurboTV (Bt848)

Lifetec/Medion/Tevion/Aldi
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- LT9306/MD9306 = CPH061
- LT9415/MD9415 = LR90 Rev.F or Rev.G
- MD9592 = Avermedia TVphone98 (PCI_ID=1461:0003), PCB-Rev=M168II-B (w/TDA9873H)
- MD9717 = KNC One (Rev D4, saa7134, FM1216 MK2 tuner)
- MD5044 = KNC One (Rev D4, saa7134, FM1216ME MK3 tuner)

Modular Technologies (www.modulartech.com) UK
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- MM100 PCTV (Bt848)
- MM201 PCTV (Bt878, Bt832) w/ Quartzsight camera
- MM202 PCTV (Bt878, Bt832, tda9874)
- MM205 PCTV (Bt878)
- MM210 PCTV (Bt878) (Galaxy TV, Galaxymedia ?)

Terratec
~~~~~~~~

Модели:

- Terra TV+ Version 1.0 (Bt848), "ceb105.PCB" printed on the PCB, TDA9821
- Terra TV+ Version 1.1 (Bt878), "LR74 Rev.E" printed on the PCB, TDA9821
- Terra TValueRadio,             "LR102 Rev.C" printed on the PCB
- Terra TV/Radio+ Version 1.0,   "80-CP2830100-0" TTTV3 printed on the PCB,
  "CPH010-E83" on the back, SAA6588T, TDA9873H
- Terra TValue Version BT878,    "80-CP2830110-0 TTTV4" printed on the PCB,
  "CPH011-D83" on back
- Terra TValue Version 1.0       "ceb105.PCB" (really identical to Terra TV+ Version 1.0)
- Terra TValue New Revision	  "LR102 Rec.C"
- Terra Active Radio Upgrade (tea5757h, saa6588t)

- LR74 — это более новая ревизия печатной платы ceb105 (обе вкл. разъём для Active Radio Upgrade)

- Cinergy 400 (saa7134), "E877 11(S)", "PM820092D" printed on PCB
- Cinergy 600 (saa7134)

Technisat
~~~~~~~~~

Модели:

- Discos ADR PC-Karte ISA (no TV!)
- Discos ADR PC-Karte PCI (probably no TV?)
- Techni-PC-Sat (Sat. analog)
  Rev 1.2 (zr36120, vpx3220, stv0030, saa5246, BSJE3-494A)
- Mediafocus I (zr36120/zr36125, drp3510, Sat. analog + ADR Radio)
- Mediafocus II (saa7146, Sat. analog)
- SatADR Rev 2.1 (saa7146a, saa7113h, stv0056a, msp3400c, drp3510a, BSKE3-307A)
- SkyStar 1 DVB  (AV7110) = Technotrend Premium
- SkyStar 2 DVB  (B2C2) (=Sky2PC)

Siemens
~~~~~~~

Multimedia eXtension Board (MXB) (SAA7146, SAA7111)

Powercolor
~~~~~~~~~~

Модели:

- MTV878
       Упаковка поставляется с разным содержимым:

           a) pcb "MTV878" (CARD=75)
           b) Pixelview Rev. 4\_

- MTV878R w/Remote Control
- MTV878F w/Remote Control w/FM radio

Pinnacle
~~~~~~~~

Модели PCTV:

- Mirovideo PCTV (Bt848)
- Mirovideo PCTV SE (Bt848)
- Mirovideo PCTV Pro (Bt848 + Daughterboard for TV Stereo and FM)
- Studio PCTV Rave (Bt848 Version = Mirovideo PCTV)
- Studio PCTV Rave (Bt878 package w/o infrared)
- Studio PCTV      (Bt878)
- Studio PCTV Pro  (Bt878 stereo w/ FM)
- Pinnacle PCTV    (Bt878, MT2032)
- Pinnacle PCTV Pro (Bt878, MT2032)
- Pinncale PCTV Sat (bt878a, HM1821/1221) ["Conexant CX24110 with CX24108 tuner, aka HM1221/HM1811"]
- Pinnacle PCTV Sat XE

Модели захвата и воспроизведения M(J)PEG:

- DC1+ (ISA)
- DC10  (zr36057,     zr36060,      saa7110, adv7176)
- DC10+ (zr36067,     zr36060,      saa7110, adv7176)
- DC20  (ql16x24b,zr36050, zr36016, saa7110, saa7187 ...)
- DC30  (zr36057, zr36050, zr36016, vpx3220, adv7176, ad1843, tea6415, miro FST97A1)
- DC30+ (zr36067, zr36050, zr36016, vpx3220, adv7176)
- DC50  (zr36067, zr36050, zr36016, saa7112, adv7176 (2 pcs.?), ad1843, miro FST97A1, Lattice ???)

Lenco
~~~~~

Модели:

- MXR-9565 (=Technisat Mediafocus?)
- MXR-9571 (Bt848) (=CPH031?)
- MXR-9575
- MXR-9577 (Bt878) (=Prolink 878TV Rev.3x)
- MXTV-9578CP (Bt878) (= Prolink PV-BT878P+4E)

Iomega
~~~~~~

Buz (zr36067, zr36060, saa7111, saa7185)

LML
~~~
   LML33 (zr36067, zr36060, bt819, bt856)

Grandtec
~~~~~~~~

Модели:

- Grand Video Capture (Bt848)
- Multi Capture Card  (Bt878)

Koutech
~~~~~~~

Модели:

- KW-606 (Bt848)
- KW-607 (Bt848 capture only)
- KW-606RSF
- KW-607A (capture only)
- KW-608 (Zoran capture only)

IODATA (jp)
~~~~~~~~~~~

Модели:

- GV-BCTV/PCI
- GV-BCTV2/PCI
- GV-BCTV3/PCI
- GV-BCTV4/PCI
- GV-VCP/PCI (capture only)
- GV-VCP2/PCI (capture only)

Canopus (jp)
~~~~~~~~~~~~

WinDVR	= Kworld "KW-TVL878RF"

www.sigmacom.co.kr
~~~~~~~~~~~~~~~~~~

Sigma Cyber TV II

www.sasem.co.kr
~~~~~~~~~~~~~~~

Litte OnAir TV

hama
~~~~

TV/Radio-Tuner Card, PCI (Model 44677) = CPH051

Sigma Designs
~~~~~~~~~~~~~

Hollywood plus (em8300, em9010, adv7175), (PCB "M340-10") MPEG DVD decoder

Formac
~~~~~~

Модели:

- iProTV (Card for iMac Mezzanine slot, Bt848+SCSI)
- ProTV (Bt848)
- ProTV II = ProTV Stereo (Bt878) ["stereo" means FM stereo, tv is still mono]

ATI
~~~

Модели:

- TV-Wonder
- TV-Wonder VE

Diamond Multimedia
~~~~~~~~~~~~~~~~~~

DTV2000 (Bt848, tda9875)

Aopen
~~~~~

- VA1000 Plus (w/ Stereo)
- VA1000 Lite
- VA1000 (=LR90)

Intel
~~~~~

Модели:

- Smart Video Recorder (ISA full-length)
- Smart Video Recorder pro (ISA half-length)
- Smart Video Recorder III (Bt848)

STB
~~~

Модели:

- STB Gateway 6000704 (bt878)
- STB Gateway 6000699 (bt848)
- STB Gateway 6000402 (bt848)
- STB TV130 PCI

Videologic
~~~~~~~~~~

Модели:

- Captivator Pro/TV (ISA?)
- Captivator PCI/VC (Bt848 bundled with camera) (capture only)

Technotrend
~~~~~~~~~~~~

Модели:

- TT-SAT PCI (PCB "Sat-PCI Rev.:1.3.1"; zr36125, vpx3225d, stc0056a, Tuner:BSKE6-155A
- TT-DVB-Sat
   - revisions 1.1, 1.3, 1.5, 1.6 and 2.1
   - Эта карта продаётся как OEM от:

	- Siemens DVB-s Card
	- Hauppauge WinTV DVB-S
	- Technisat SkyStar 1 DVB
	- Galaxis DVB Sat

   - Теперь эта карта называется TT-PCline Premium Family
   - TT-Budget (saa7146, bsru6-701a)
     Эта карта продаётся как OEM от:

	- Hauppauge WinTV Nova
	- Satelco Standard PCI (DVB-S)
   - TT-DVB-C PCI

Teles
~~~~~

 DVB-s (Rev. 2.2, BSRV2-301A, data only?)

Remote Vision
~~~~~~~~~~~~~

MX RV605 (Bt848 capture only)

Boeder
~~~~~~

Модели:

- PC ChatCam (Model 68252) (Bt848 capture only)
- Tv/Fm Capture Card  (Model 68404) = PV951

Media-Surfer  (esc-kathrein.de)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- Sat-Surfer (ISA)
- Sat-Surfer PCI = Techni-PC-Sat
- Cable-Surfer 1
- Cable-Surfer 2
- Cable-Surfer PCI (zr36120)
- Audio-Surfer (ISA Radio card)

Jetway (www.jetway.com.tw)
~~~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- JW-TV 878M
- JW-TV 878  = KWorld KW-TV878RF

Galaxis
~~~~~~~

Модели:

- Galaxis DVB Card S CI
- Galaxis DVB Card C CI
- Galaxis DVB Card S
- Galaxis DVB Card C
- Galaxis plug.in S [neuer Name: Galaxis DVB Card S CI

Hauppauge
~~~~~~~~~

Модели:

- множество-множество моделей WinTV...
- WinTV DVBs = Technotrend Premium 1.3
- WinTV NOVA = Technotrend Budget 1.1 "S-DVB DATA"
- WinTV NOVA-CI "SDVBACI"
- WinTV Nova USB (=Technotrend USB 1.0)
- WinTV-Nexus-s (=Technotrend Premium 2.1 or 2.2)
- WinTV PVR
- WinTV PVR 250
- WinTV PVR 450

Модели для США

-990 WinTV-PVR-350 (249USD) (iTVC15 chipset + radio)
-980 WinTV-PVR-250 (149USD) (iTVC15 chipset)
-880 WinTV-PVR-PCI (199USD) (KFIR chipset + bt878)
-881 WinTV-PVR-USB
-190 WinTV-GO
-191 WinTV-GO-FM
-404 WinTV
-401 WinTV-radio
-495 WinTV-Theater
-602 WinTV-USB
-621 WinTV-USB-FM
-600 USB-Live
-698 WinTV-HD
-697 WinTV-D
-564 WinTV-Nexus-S

Deutsche Modelle:

-603 WinTV GO
-719 WinTV Primio-FM
-718 WinTV PCI-FM
-497 WinTV Theater
-569 WinTV USB
-568 WinTV USB-FM
-882 WinTV PVR
-981 WinTV PVR 250
-891 WinTV-PVR-USB
-541 WinTV Nova
-488 WinTV Nova-Ci
-564 WinTV-Nexus-s
-727 WinTV-DVB-c
-545 Common Interface
-898 WinTV-Nova-USB

Модели для Великобритании:

-607 WinTV Go
-693,793 WinTV Primio FM
-647,747 WinTV PCI FM
-498 WinTV Theater
-883 WinTV PVR
-893 WinTV PVR USB  (Duplicate entry)
-566 WinTV USB (UK)
-573 WinTV USB FM
-429 Impact VCB (bt848)
-600 USB Live (Video-In 1x Comp, 1xSVHS)
-542 WinTV Nova
-717 WinTV DVB-S
-909 Nova-t PCI
-893 Nova-t USB   (Duplicate entry)
-802 MyTV
-804 MyView
-809 MyVideo
-872 MyTV2Go FM
-546 WinTV Nova-S CI
-543 WinTV Nova
-907 Nova-S USB
-908 Nova-T USB
-717 WinTV Nexus-S
-157 DEC3000-s Standalone + USB

Испания:

-685 WinTV-Go
-690 WinTV-PrimioFM
-416 WinTV-PCI Nicam Estereo
-677 WinTV-PCI-FM
-699 WinTV-Theater
-683 WinTV-USB
-678 WinTV-USB-FM
-983 WinTV-PVR-250
-883 WinTV-PVR-PCI
-993 WinTV-PVR-350
-893 WinTV-PVR-USB
-728 WinTV-DVB-C PCI
-832 MyTV2Go
-869 MyTV2Go-FM
-805 MyVideo (USB)


Matrix-Vision
~~~~~~~~~~~~~

Модели:

- MATRIX-Vision MV-Delta
- MATRIX-Vision MV-Delta 2
- MVsigma-SLC (Bt848)

Conceptronic (.net)
~~~~~~~~~~~~~~~~~~~

Модели:

- TVCON FM,  TV card w/ FM = CPH05x
- TVCON = CPH06x

BestData
~~~~~~~~

Модели:

- HCC100 = VCC100rev1 + camera
- VCC100 rev1 (bt848)
- VCC100 rev2 (bt878)

Gallant  (www.gallantcom.com) www.minton.com.tw
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- Intervision IV-510 (capture only bt8x8)
- Intervision IV-550 (bt8x8)
- Intervision IV-100 (zoran)
- Intervision IV-1000 (bt8x8)

Asonic (www.asonic.com.cn) (website down)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SkyEye tv 878

Hoontech
~~~~~~~~

878TV/FM

Teppro (www.itcteppro.com.tw)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- ITC PCITV (Card Ver 1.0) "Teppro TV1/TVFM1 Card"
- ITC PCITV (Card Ver 2.0)
- ITC PCITV (Card Ver 3.0) = "PV-BT878P+ (REV.9D)"
- ITC PCITV (Card Ver 4.0)
- TEPPRO IV-550 (For BT848 Main Chip)
- ITC DSTTV (bt878, satellite)
- ITC VideoMaker (saa7146, StreamMachine sm2110, tvtuner) "PV-SM2210P+ (REV:1C)"

Kworld (www.kworld.com.tw)
~~~~~~~~~~~~~~~~~~~~~~~~~~

PC TV Station:

- KWORLD KW-TV878R  TV (no radio)
- KWORLD KW-TV878RF TV (w/ radio)
- KWORLD KW-TVL878RF (low profile)
- KWORLD KW-TV713XRF (saa7134)


 MPEG TV Station (те же карты, что и выше, плюс ПО WinDVR — MPEG-кодер/декодер)

- KWORLD KW-TV878R -Pro   TV (no Radio)
- KWORLD KW-TV878RF-Pro   TV (w/ Radio)
- KWORLD KW-TV878R -Ultra TV (no Radio)
- KWORLD KW-TV878RF-Ultra TV (w/ Radio)

JTT/ Justy Corp.(http://www.jtt.ne.jp/)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

JTT-02 (JTT TV) "TV watchmate pro" (bt848)

ADS www.adstech.com
~~~~~~~~~~~~~~~~~~~

Модели:

- Channel Surfer TV ( CHX-950 )
- Channel Surfer TV+FM ( CHX-960FM )

AVEC www.prochips.com
~~~~~~~~~~~~~~~~~~~~~

AVEC Intercapture (bt848, tea6320)

NoBrand
~~~~~~~

TV Excel = Australian Name for "PV-BT878P+ 8E" or "878TV Rev.3\_"

Mach www.machspeed.com
~~~~~~~~~~~~~~~~~~~~~~

Mach TV 878

Eline www.eline-net.com/
~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- Eline Vision TVMaster / TVMaster FM (ELV-TVM/ ELV-TVM-FM) = LR26  (bt878)
- Eline Vision TVMaster-2000 (ELV-TVM-2000, ELV-TVM-2000-FM)= LR138 (saa713x)

Spirit
~~~~~~

- Spirit TV Tuner/Video Capture Card (bt848)

Boser www.boser.com.tw
~~~~~~~~~~~~~~~~~~~~~~

Модели:

- HS-878 Mini PCI Capture Add-on Card
- HS-879 Mini PCI 3D Audio and Capture Add-on Card (w/ ES1938 Solo-1)

Satelco www.citycom-gmbh.de, www.satelco.de
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- TV-FM =KNC1 saa7134
- Standard PCI (DVB-S) = Technotrend Budget
- Standard PCI (DVB-S) w/ CI
- Satelco Highend PCI (DVB-S) = Technotrend Premium


Sensoray www.sensoray.com
~~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- Sensoray 311 (PC/104 bus)
- Sensoray 611 (PCI)

CEI (Chartered Electronics Industries Pte Ltd [CEI] [FCC ID HBY])
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- TV Tuner  -  HBY-33A-RAFFLES  Brooktree Bt848KPF + Philips
- TV Tuner MG9910  -  HBY33A-TVO  CEI + Philips SAA7110 + OKI M548262 + ST STV8438CV
- Primetime TV (ISA)

  - приобретена Singapore Technologies
  - теперь работает как Chartered Semiconductor Manufacturing
  - производитель видеокарт указан как:

    - Cogent Electronics Industries [CEI]

AITech
~~~~~~

Модели:

- Wavewatcher TV (ISA)
- AITech WaveWatcher TV-PCI = can be LR26 (Bt848) or LR50 (BT878)
- WaveWatcher TVR-202 TV/FM Radio Card (ISA)

MAXRON
~~~~~~

Maxron MaxTV/FM Radio (KW-TV878-FNT) = Kworld or JW-TV878-FBK

www.ids-imaging.de
~~~~~~~~~~~~~~~~~~

Модели:

- Falcon Series (capture only)

В США: http://www.theimagingsource.com/
- DFG/LC1

www.sknet-web.co.jp
~~~~~~~~~~~~~~~~~~~

SKnet Monster TV (saa7134)

A-Max www.amaxhk.com (Colormax, Amax, Napa)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

APAC Viewcomp 878

Cybertainment
~~~~~~~~~~~~~

Модели:

- CyberMail AV Video Email Kit w/ PCI Capture Card (capture only)
- CyberMail Xtreme

Это Flyvideo

VCR (http://www.vcrinc.com/)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Video Catcher 16

Twinhan
~~~~~~~

Модели:

- DST Card/DST-IP (bt878, twinhan asic) VP-1020
  - Продаётся как:

    - KWorld DVBS Satellite TV-Card
    - Powercolor DSTV Satellite Tuner Card
    - Prolink Pixelview DTV2000
    - Provideo PV-911 Digital Satellite TV Tuner Card With Common Interface ?

- DST-CI Card (DVB Satellite) VP-1030
- DCT Card (DVB cable)

MSI
~~~

Модели:

- MSI TV@nywhere Tuner Card (MS-8876) (CX23881/883) несовместима с Bt878.
- MS-8401 DVB-S

Focus www.focusinfo.com
~~~~~~~~~~~~~~~~~~~~~~~

InVideo PCI (bt878)

Sdisilk www.sdisilk.com/
~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- SDI Silk 100
- SDI Silk 200 SDI Input Card

www.euresys.com
~~~~~~~~~~~~~~~

PICOLO series

PMC/Pace
~~~~~~~~

www.pacecom.co.uk website closed

Mercury www.kobian.com (UK and FR)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Модели:

- LR50
- LR138RBG-Rx  == LR138

TEC sound
~~~~~~~~~

TV-Mate = Zoltrix VP-8482

Хотя «образованное» гугление нашло: www.techmakers.com

(на упаковке и в руководствах нет никакой другой информации о производителе) TecSound

Lorenzen www.lorenzen.de
~~~~~~~~~~~~~~~~~~~~~~~~

SL DVB-S PCI = Technotrend Budget PCI (su1278 or bsru version)

Origo (.uk) www.origo2000.com
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PC TV Card = LR50

I/O Magic www.iomagic.com
~~~~~~~~~~~~~~~~~~~~~~~~~

PC PVR - Desktop TV Personal Video Recorder DR-PCTV100 = Pinnacle ROB2D-51009464 4.0 + Cyberlink PowerVCR II

Arowana
~~~~~~~

TV-Karte / Poso Power TV (?) = Zoltrix VP-8482 (?)

iTVC15 boards
~~~~~~~~~~~~~

kuroutoshikou.com ITVC15
yuan.com MPG160 PCI TV (Internal PCI MPEG2 encoder card plus TV-tuner)

Asus www.asuscom.com
~~~~~~~~~~~~~~~~~~~~

Модели:

- Asus TV Tuner Card 880 NTSC (low profile, cx23880)
- Asus TV (saa7134)

Hoontech
~~~~~~~~

http://www.hoontech.de/

- HART Vision 848 (H-ART Vision 848)
- HART Vision 878 (H-Art Vision 878)



Микросхемы, используемые в устройствах bttv
-------------------------------------------

- все платы:

  - Brooktree Bt848/848A/849/878/879: микросхема видеозахвата

- Специфичные для платы

  - Miro PCTV:

    - тюнер Philips или Temic

  - Hauppauge Win/TV pci (version 405):

    - Microchip 24LC02B или Philips 8582E2Y:

       - 256-байтовый EEPROM с информацией о конфигурации
       - I2C 0xa0-0xa1, (24LC02B также отвечает на 0xa2-0xaf)

    - Philips SAA5246AGP/E: микросхема декодера видеотекста, I2C 0x22-0x23

    - TDA9800: звуковой декодер

    - Winbond W24257AS-35: 32Kx8 CMOS static RAM (буферная память видеотекста)

    - 14052B: аналоговый коммутатор для выбора источника звука

- PAL:

  - TDA5737: VHF, hyperband and UHF mixer/oscillator for TV and VCR 3-band tuners
  - TSA5522: 1.4 GHz I2C-bus controlled synthesizer, I2C 0xc2-0xc3

- NTSC:

  - TDA5731: VHF, hyperband and UHF mixer/oscillator for TV and VCR 3-band tuners
  - TSA5518: техническая документация недоступна на сайте Philips

- STB TV pci:

  - ???
  - если вы хотите лучшую поддержку карт STB, пришлите мне информацию!
    Посмотрите на плату! Какие микросхемы на ней?




Спецификации
------------

Philips		http://www.Semiconductors.COM/pip/

Conexant	http://www.conexant.com/

Micronas	http://www.micronas.com/en/home/index.html

Благодарности
-------------

Большое спасибо:

- Markus Schroeder <schroedm@uni-duesseldorf.de> за информацию о Bt848 и
  программировании тюнера и его управляющую программу xtvc.

- Martin Buck <martin-2.buck@student.uni-ulm.de> за его замечательный пакет
  Videotext.

- Gerd Hoffmann за поддержку MSP3400 и модульную поддержку I2C, тюнера, ...

- MATRIX Vision за бесплатное предоставление нам 2 карт, что сделало
  возможной поддержку работы с одним кварцем.

- MIRO за предоставление бесплатной карты PCTV и подробной информации о
  компонентах на их картах. (Например, как определяется тип тюнера.)
  Без их карты я не смог бы отладить режим NTSC.

- Hauppauge за рассказ о том, как выбирается звуковой вход и какие
  компоненты они используют и будут использовать на своих радиокартах.
  Также большое спасибо за то, что прислали мне факсом техническую
  документацию FM1216.

Участники
---------

Michael Chu <mmchu@pobox.com>
  Исправление AverMedia и более гибкое распознавание карт

Alan Cox <alan@lxorguk.ukuu.org.uk>
  Интерфейс Video4Linux и адаптация к ядру 2.1.x

Chris Kleitsch
  Аппаратный I2C

Gerd Hoffmann
  Радиокарта (звуковой процессор ITT)

bigfoot <bigfoot@net-way.net>

Ragnar Hojland Espinosa <ragnar@macula.net>
  Карта ConferenceTV


+ и многие другие (пожалуйста, напишите мне, если вас нет в этом списке и
		     вы хотели бы быть упомянутыми)
