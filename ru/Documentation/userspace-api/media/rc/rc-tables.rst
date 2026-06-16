.. SPDX-License-Identifier: GPL-2.0 OR GFDL-1.1-no-invariants-or-later

.. _Remote_controllers_tables:

*****************************************
Таблицы пультов дистанционного управления
*****************************************

К сожалению, на протяжении нескольких лет не предпринималось попыток создать
единообразные IR-коды клавиш для различных устройств. Из-за этого одно и то же
имя IR-клавиши отображалось совершенно по-разному на различных IR-устройствах.
В результате одно и то же имя IR-клавиши отображалось совершенно по-разному на
различных IR-устройствах. Поэтому V4L2 API теперь задаёт стандарт отображения
мультимедийных клавиш на IR.

Этот стандарт должен использоваться как драйверами V4L/DVB, так и приложениями
пространства пользователя.

Модули регистрируют пульт как клавиатуру в подсистеме ввода Linux. Это означает,
что нажатия IR-клавиш будут выглядеть как обычные нажатия клавиш клавиатуры
(если включён CONFIG_INPUT_KEYBOARD). Используя устройства событий
(CONFIG_INPUT_EVDEV), приложения могут обращаться к пульту через устройства
/dev/input/event.


.. _rc_standard_keymap:

.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.5cm}|

.. flat-table:: Стандартное отображение IR-клавиш
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2


    -  .. row 1

       -  Код клавиши

       -  Значение

       -  Примеры клавиш на IR

    -  .. row 2

       -  **Цифровые клавиши**

    -  .. row 3

       -  ``KEY_NUMERIC_0``

       -  Цифра 0 на клавиатуре

       -  0

    -  .. row 4

       -  ``KEY_NUMERIC_1``

       -  Цифра 1 на клавиатуре

       -  1

    -  .. row 5

       -  ``KEY_NUMERIC_2``

       -  Цифра 2 на клавиатуре

       -  2

    -  .. row 6

       -  ``KEY_NUMERIC_3``

       -  Цифра 3 на клавиатуре

       -  3

    -  .. row 7

       -  ``KEY_NUMERIC_4``

       -  Цифра 4 на клавиатуре

       -  4

    -  .. row 8

       -  ``KEY_NUMERIC_5``

       -  Цифра 5 на клавиатуре

       -  5

    -  .. row 9

       -  ``KEY_NUMERIC_6``

       -  Цифра 6 на клавиатуре

       -  6

    -  .. row 10

       -  ``KEY_NUMERIC_7``

       -  Цифра 7 на клавиатуре

       -  7

    -  .. row 11

       -  ``KEY_NUMERIC_8``

       -  Цифра 8 на клавиатуре

       -  8

    -  .. row 12

       -  ``KEY_NUMERIC_9``

       -  Цифра 9 на клавиатуре

       -  9

    -  .. row 13

       -  **Управление воспроизведением видео**

    -  .. row 14

       -  ``KEY_FORWARD``

       -  Мгновенная перемотка вперёд по времени

       -  >> / FORWARD

    -  .. row 15

       -  ``KEY_BACK``

       -  Мгновенная перемотка назад по времени

       -  <<< / BACK

    -  .. row 16

       -  ``KEY_FASTFORWARD``

       -  Ускоренное воспроизведение видео

       -  >>> / FORWARD

    -  .. row 17

       -  ``KEY_REWIND``

       -  Воспроизведение видео в обратную сторону

       -  REWIND / BACKWARD

    -  .. row 18

       -  ``KEY_NEXT``

       -  Выбор следующей главы / подглавы / интервала

       -  NEXT / SKIP

    -  .. row 19

       -  ``KEY_PREVIOUS``

       -  Выбор предыдущей главы / подглавы / интервала

       -  << / PREV / PREVIOUS

    -  .. row 20

       -  ``KEY_AGAIN``

       -  Повтор видео или интервала видео

       -  REPEAT / LOOP / RECALL

    -  .. row 21

       -  ``KEY_PAUSE``

       -  Приостановка потока

       -  PAUSE / FREEZE

    -  .. row 22

       -  ``KEY_PLAY``

       -  Воспроизведение видео с обычным сдвигом по времени

       -  NORMAL TIMESHIFT / LIVE / >

    -  .. row 23

       -  ``KEY_PLAYPAUSE``

       -  Переключение между воспроизведением и паузой

       -  PLAY / PAUSE

    -  .. row 24

       -  ``KEY_STOP``

       -  Остановка потока

       -  STOP

    -  .. row 25

       -  ``KEY_RECORD``

       -  Запуск/остановка записи потока

       -  CAPTURE / REC / RECORD/PAUSE

    -  .. row 26

       -  ``KEY_CAMERA``

       -  Снимок изображения

       -  CAMERA ICON / CAPTURE / SNAPSHOT

    -  .. row 27

       -  ``KEY_SHUFFLE``

       -  Включение режима случайного воспроизведения

       -  SHUFFLE

    -  .. row 28

       -  ``KEY_TIME``

       -  Активация режима сдвига по времени

       -  TIME SHIFT

    -  .. row 29

       -  ``KEY_TITLE``

       -  Разрешение смены главы

       -  CHAPTER

    -  .. row 30

       -  ``KEY_SUBTITLE``

       -  Разрешение смены субтитров

       -  SUBTITLE

    -  .. row 31

       -  **Управление изображением**

    -  .. row 32

       -  ``KEY_BRIGHTNESSDOWN``

       -  Уменьшение яркости

       -  BRIGHTNESS DECREASE

    -  .. row 33

       -  ``KEY_BRIGHTNESSUP``

       -  Увеличение яркости

       -  BRIGHTNESS INCREASE

    -  .. row 34

       -  ``KEY_ANGLE``

       -  Переключение угла обзора видеокамеры (для видео, в которых сохранено
	  более одного угла)

       -  ANGLE / SWAP

    -  .. row 35

       -  ``KEY_EPG``

       -  Открытие электронного телегида (EPG)

       -  EPG / GUIDE

    -  .. row 36

       -  ``KEY_TEXT``

       -  Активация/смена режима скрытых субтитров

       -  CLOSED CAPTION/TELETEXT / DVD TEXT / TELETEXT / TTX

    -  .. row 37

       -  **Управление звуком**

    -  .. row 38

       -  ``KEY_AUDIO``

       -  Смена источника звука

       -  AUDIO SOURCE / AUDIO / MUSIC

    -  .. row 39

       -  ``KEY_MUTE``

       -  Отключение/включение звука

       -  MUTE / DEMUTE / UNMUTE

    -  .. row 40

       -  ``KEY_VOLUMEDOWN``

       -  Уменьшение громкости

       -  VOLUME- / VOLUME DOWN

    -  .. row 41

       -  ``KEY_VOLUMEUP``

       -  Увеличение громкости

       -  VOLUME+ / VOLUME UP

    -  .. row 42

       -  ``KEY_MODE``

       -  Смена звукового режима

       -  MONO/STEREO

    -  .. row 43

       -  ``KEY_LANGUAGE``

       -  Выбор языка

       -  1ST / 2ND LANGUAGE / DVD LANG / MTS/SAP / MTS SEL

    -  .. row 44

       -  **Управление каналами**

    -  .. row 45

       -  ``KEY_CHANNEL``

       -  Переход к следующему избранному каналу

       -  ALT / CHANNEL / CH SURFING / SURF / FAV

    -  .. row 46

       -  ``KEY_CHANNELDOWN``

       -  Последовательное уменьшение номера канала

       -  CHANNEL - / CHANNEL DOWN / DOWN

    -  .. row 47

       -  ``KEY_CHANNELUP``

       -  Последовательное увеличение номера канала

       -  CHANNEL + / CHANNEL UP / UP

    -  .. row 48

       -  ``KEY_DIGITS``

       -  Использование более одной цифры для канала

       -  PLUS / 100/ 1xx / xxx / -/-- / Single Double Triple Digit

    -  .. row 49

       -  ``KEY_SEARCH``

       -  Запуск автопоиска каналов

       -  SCAN / AUTOSCAN

    -  .. row 50

       -  **Цветные клавиши**

    -  .. row 51

       -  ``KEY_BLUE``

       -  Синяя клавиша IR

       -  BLUE

    -  .. row 52

       -  ``KEY_GREEN``

       -  Зелёная клавиша IR

       -  GREEN

    -  .. row 53

       -  ``KEY_RED``

       -  Красная клавиша IR

       -  RED

    -  .. row 54

       -  ``KEY_YELLOW``

       -  Жёлтая клавиша IR

       -  YELLOW

    -  .. row 55

       -  **Выбор источника мультимедиа**

    -  .. row 56

       -  ``KEY_CD``

       -  Смена источника входного сигнала на Compact Disc

       -  CD

    -  .. row 57

       -  ``KEY_DVD``

       -  Смена входного сигнала на DVD

       -  DVD / DVD MENU

    -  .. row 58

       -  ``KEY_EJECTCLOSECD``

       -  Открытие/закрытие проигрывателя CD/DVD

       -  -> ) / CLOSE / OPEN

    -  .. row 59

       -  ``KEY_MEDIA``

       -  Включение/выключение мультимедийного приложения

       -  PC/TV / TURN ON/OFF APP

    -  .. row 60

       -  ``KEY_PC``

       -  Переключение с TV на PC

       -  PC

    -  .. row 61

       -  ``KEY_RADIO``

       -  Перевод в режим радио AM/FM

       -  RADIO / TV/FM / TV/RADIO / FM / FM/RADIO

    -  .. row 62

       -  ``KEY_TV``

       -  Выбор режима TV

       -  TV / LIVE TV

    -  .. row 63

       -  ``KEY_TV2``

       -  Выбор кабельного режима

       -  AIR/CBL

    -  .. row 64

       -  ``KEY_VCR``

       -  Выбор режима VCR

       -  VCR MODE / DTR

    -  .. row 65

       -  ``KEY_VIDEO``

       -  Переключение между входными режимами

       -  SOURCE / SELECT / DISPLAY / SWITCH INPUTS / VIDEO

    -  .. row 66

       -  **Управление питанием**

    -  .. row 67

       -  ``KEY_POWER``

       -  Включение/выключение компьютера

       -  SYSTEM POWER / COMPUTER POWER

    -  .. row 68

       -  ``KEY_POWER2``

       -  Включение/выключение приложения

       -  TV ON/OFF / POWER

    -  .. row 69

       -  ``KEY_SLEEP``

       -  Активация таймера сна

       -  SLEEP / SLEEP TIMER

    -  .. row 70

       -  ``KEY_SUSPEND``

       -  Перевод компьютера в режим ожидания

       -  STANDBY / SUSPEND

    -  .. row 71

       -  **Управление окнами**

    -  .. row 72

       -  ``KEY_CLEAR``

       -  Остановка потока и возврат к входному видео/аудио по умолчанию

       -  CLEAR / RESET / BOSS KEY

    -  .. row 73

       -  ``KEY_CYCLEWINDOWS``

       -  Сворачивание окон и переход к следующему

       -  ALT-TAB / MINIMIZE / DESKTOP

    -  .. row 74

       -  ``KEY_FAVORITES``

       -  Открытие окна избранного потока

       -  TV WALL / Favorites

    -  .. row 75

       -  ``KEY_MENU``

       -  Вызов меню приложения

       -  2ND CONTROLS (USA: MENU) / DVD/MENU / SHOW/HIDE CTRL

    -  .. row 76

       -  ``KEY_NEW``

       -  Открытие/закрытие режима «картинка в картинке»

       -  PIP

    -  .. row 77

       -  ``KEY_OK``

       -  Отправка кода подтверждения приложению

       -  OK / ENTER / RETURN

    -  .. row 78

       -  ``KEY_ASPECT_RATIO``

       -  Выбор соотношения сторон экрана

       -  4:3 16:9 SELECT

    -  .. row 79

       -  ``KEY_FULL_SCREEN``

       -  Перевод устройства в режим масштабирования/полноэкранный режим

       -  ZOOM / FULL SCREEN / ZOOM+ / HIDE PANEL / SWITCH

    -  .. row 80

       -  **Клавиши навигации**

    -  .. row 81

       -  ``KEY_ESC``

       -  Отмена текущей операции

       -  CANCEL / BACK

    -  .. row 82

       -  ``KEY_HELP``

       -  Открытие окна справки

       -  HELP

    -  .. row 83

       -  ``KEY_HOMEPAGE``

       -  Переход на домашнюю страницу

       -  HOME

    -  .. row 84

       -  ``KEY_INFO``

       -  Открытие экранного меню (OSD)

       -  DISPLAY INFORMATION / OSD

    -  .. row 85

       -  ``KEY_WWW``

       -  Открытие браузера по умолчанию

       -  WEB

    -  .. row 86

       -  ``KEY_UP``

       -  Клавиша «вверх»

       -  UP

    -  .. row 87

       -  ``KEY_DOWN``

       -  Клавиша «вниз»

       -  DOWN

    -  .. row 88

       -  ``KEY_LEFT``

       -  Клавиша «влево»

       -  LEFT

    -  .. row 89

       -  ``KEY_RIGHT``

       -  Клавиша «вправо»

       -  RIGHT

    -  .. row 90

       -  **Прочие клавиши**

    -  .. row 91

       -  ``KEY_DOT``

       -  Возврат точки

       -  .

    -  .. row 92

       -  ``KEY_FN``

       -  Выбор функции

       -  FUNCTION


Следует отметить, что иногда на некоторых более дешёвых IR-устройствах
отсутствуют некоторые основные клавиши. Поэтому рекомендуется следующее:


.. _rc_keymap_notes:

.. flat-table:: Примечания
    :header-rows:  0
    :stub-columns: 0


    -  .. row 1

       -  На более простых IR-устройствах без отдельных клавиш каналов нужно
	  отображать UP как ``KEY_CHANNELUP``

    -  .. row 2

       -  На более простых IR-устройствах без отдельных клавиш каналов нужно
	  отображать DOWN как ``KEY_CHANNELDOWN``

    -  .. row 3

       -  На более простых IR-устройствах без отдельных клавиш громкости нужно
	  отображать LEFT как ``KEY_VOLUMEDOWN``

    -  .. row 4

       -  На более простых IR-устройствах без отдельных клавиш громкости нужно
	  отображать RIGHT как ``KEY_VOLUMEUP``
