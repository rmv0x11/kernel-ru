.. SPDX-License-Identifier: GPL-2.0

==================================================
Использование фреймворка цифрового телевидения
==================================================

Введение
~~~~~~~~

Одно существенное различие между цифровым и аналоговым телевидением, которое
следует учитывать неосторожному читателю (как я сам), состоит в том, что хотя
структура компонентов карт DVB-T в значительной мере схожа со структурой карт
аналогового телевидения, работают они существенно по-разному.

Назначение аналогового телевизора — принимать и отображать аналоговый
телевизионный сигнал. Аналоговый телевизионный сигнал (иначе известный как
композитное видео) представляет собой аналоговое кодирование последовательности
кадров изображения (25 кадров в секунду в Европе), растеризованных с
использованием технологии чересстрочной развёртки. Чересстрочная развёртка
использует два поля для представления одного кадра. Поэтому карта аналогового
телевидения для ПК имеет следующее назначение:

* Настроить приёмник на приём вещательного сигнала
* демодулировать вещательный сигнал
* демультиплексировать аналоговый видеосигнал и аналоговый аудиосигнал.

  .. note::

     в некоторых странах применяется цифровой аудиосигнал,
     встроенный в модулированный композитный аналоговый сигнал —
     с использованием сигнализации NICAM.)

* оцифровать аналоговый видеосигнал и сделать получившийся поток данных
  доступным для шины данных.

Цифровой поток данных с карты аналогового телевидения генерируется схемами
на самой карте и часто представляется в несжатом виде. Для телевизионного
сигнала PAL, закодированного с разрешением 768x576 24-битных цветных пикселей
со скоростью 25 кадров в секунду, генерируется довольно большой объём данных,
который должен быть обработан ПК, прежде чем он сможет быть отображён на экране
видеомонитора. Некоторые карты аналогового телевидения для ПК имеют встроенные
кодеры MPEG2, которые позволяют представить ПК необработанный цифровой поток
данных в закодированном и сжатом виде — аналогично тому виду, который
используется в цифровом телевидении.

Назначение простой бюджетной карты цифрового телевидения (DVB-T, C или S)
состоит лишь в том, чтобы:

* Настроить приёмник на приём вещательного сигнала. * Извлечь закодированный
  цифровой поток данных из вещательного сигнала.
* Сделать закодированный цифровой поток данных (MPEG2) доступным для шины данных.

Существенное различие между ними заключается в том, что тюнер на карте
аналогового телевидения выдаёт аналоговый сигнал, тогда как тюнер на карте
цифрового телевидения выдаёт сжатый закодированный цифровой поток данных.
Поскольку сигнал уже оцифрован, передать этот поток данных на шину данных ПК
с минимальной дополнительной обработкой тривиально, а затем извлечь цифровые
потоки видео и аудио данных, передав их соответствующему программному или
аппаратному обеспечению для декодирования и просмотра.

Запуск карты в работу
~~~~~~~~~~~~~~~~~~~~~~~

Device Driver API для DVB под Linux будет предоставлять следующие
узлы устройств через файловую систему devfs:

* /dev/dvb/adapter0/demux0
* /dev/dvb/adapter0/dvr0
* /dev/dvb/adapter0/frontend0

Узел устройства ``/dev/dvb/adapter0/dvr0`` используется для чтения потока
данных MPEG2, а узел устройства ``/dev/dvb/adapter0/frontend0`` используется
для настройки модуля фронтенд-тюнера. Узел ``/dev/dvb/adapter0/demux0``
используется для управления тем, какие программы будут приниматься.

В зависимости от набора возможностей карты Device Driver API может также
предоставлять и другие узлы устройств:

* /dev/dvb/adapter0/ca0
* /dev/dvb/adapter0/audio0
* /dev/dvb/adapter0/net0
* /dev/dvb/adapter0/osd0
* /dev/dvb/adapter0/video0

Узел ``/dev/dvb/adapter0/ca0`` используется для декодирования зашифрованных
каналов. Остальные узлы устройств встречаются только на устройствах,
использующих драйвер av7110, который теперь устарел вместе с дополнительным
API, который такие устройства используют.

Приём канала цифрового телевидения
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

В этом разделе делается попытка объяснить, как это работает и как это влияет
на настройку карты цифрового телевидения.

В этом примере мы рассматриваем настройку на каналы DVB-T в Австралии,
в регионе Мельбурна.

Частоты, которые в настоящее время транслируются передатчиками
на горе Дандинонг:

Таблица 1. Частоты транспондеров, Mount Dandenong, Vic, Aus.

===========	===========
Broadcaster	Frequency
===========	===========
Seven		177.500 Mhz
SBS		184.500 Mhz
Nine		191.625 Mhz
Ten		219.500 Mhz
ABC		226.500 Mhz
Channel 31	557.625 Mhz
===========	===========

Утилиты сканирования цифрового телевидения (такие как dvbv5-scan) используют
набор вкомпилированных значений по умолчанию для различных стран и регионов.
В настоящее время они предоставляются в виде отдельного пакета под названием
dtv-scan-tables. Его git-дерево расположено на LinuxTV.org:

    https://git.linuxtv.org/dtv-scan-tables.git/

Если ни одна из имеющихся там таблиц не подходит, можно указать в командной
строке файл данных, содержащий частоты транспондеров. Вот пример файла для
транспондеров каналов, перечисленных выше, в старом формате «channel»::

	# Data file for DVB scan program
	#
	# C Frequency SymbolRate FEC QAM
	# S Frequency Polarisation SymbolRate FEC
	# T Frequency Bandwidth FEC FEC2 QAM Mode Guard Hier

	T 177500000 7MHz AUTO AUTO QAM64 8k 1/16 NONE
	T 184500000 7MHz AUTO AUTO QAM64 8k 1/8 NONE
	T 191625000 7MHz AUTO AUTO QAM64 8k 1/16 NONE
	T 219500000 7MHz AUTO AUTO QAM64 8k 1/16 NONE
	T 226500000 7MHz AUTO AUTO QAM64 8k 1/16 NONE
	T 557625000 7MHz AUTO AUTO QPSK 8k 1/16 NONE

В наши дни мы предпочитаем использовать более новый формат, который более
подробен и проще для понимания. В новом формате данные транспондера канала
«Seven» представлены так::

	[Seven]
		DELIVERY_SYSTEM = DVBT
		FREQUENCY = 177500000
		BANDWIDTH_HZ = 7000000
		CODE_RATE_HP = AUTO
		CODE_RATE_LP = AUTO
		MODULATION = QAM/64
		TRANSMISSION_MODE = 8K
		GUARD_INTERVAL = 1/16
		HIERARCHY = NONE
		INVERSION = AUTO

Обновлённую версию полной таблицы см. по адресу:

    https://git.linuxtv.org/dtv-scan-tables.git/tree/dvb-t/au-Melbourne

Когда утилита сканирования цифрового телевидения запускается, она выводит
файл, содержащий информацию обо всех аудио- и видеопрограммах, которые
существуют в транспондерах каждого канала, на который может захватиться
фронтенд карты (т. е. о любых, чей сигнал достаточно силён на вашей антенне).

Вот вывод инструментов dvbv5 после сканирования каналов, выполненного
в Мельбурне::

    [ABC HDTV]
	    SERVICE_ID = 560
	    VIDEO_PID = 2307
	    AUDIO_PID = 0
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 226500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 3/4
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [ABC TV Melbourne]
	    SERVICE_ID = 561
	    VIDEO_PID = 512
	    AUDIO_PID = 650
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 226500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 3/4
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [ABC TV 2]
	    SERVICE_ID = 562
	    VIDEO_PID = 512
	    AUDIO_PID = 650
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 226500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 3/4
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [ABC TV 3]
	    SERVICE_ID = 563
	    VIDEO_PID = 512
	    AUDIO_PID = 650
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 226500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 3/4
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [ABC TV 4]
	    SERVICE_ID = 564
	    VIDEO_PID = 512
	    AUDIO_PID = 650
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 226500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 3/4
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [ABC DiG Radio]
	    SERVICE_ID = 566
	    VIDEO_PID = 0
	    AUDIO_PID = 2311
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 226500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 3/4
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [TEN Digital]
	    SERVICE_ID = 1585
	    VIDEO_PID = 512
	    AUDIO_PID = 650
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 219500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 1/2
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [TEN Digital 1]
	    SERVICE_ID = 1586
	    VIDEO_PID = 512
	    AUDIO_PID = 650
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 219500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 1/2
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [TEN Digital 2]
	    SERVICE_ID = 1587
	    VIDEO_PID = 512
	    AUDIO_PID = 650
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 219500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 1/2
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [TEN Digital 3]
	    SERVICE_ID = 1588
	    VIDEO_PID = 512
	    AUDIO_PID = 650
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 219500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 1/2
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [TEN Digital]
	    SERVICE_ID = 1589
	    VIDEO_PID = 512
	    AUDIO_PID = 650
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 219500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 1/2
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [TEN Digital 4]
	    SERVICE_ID = 1590
	    VIDEO_PID = 512
	    AUDIO_PID = 650
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 219500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 1/2
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [TEN Digital]
	    SERVICE_ID = 1591
	    VIDEO_PID = 512
	    AUDIO_PID = 650
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 219500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 1/2
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [TEN HD]
	    SERVICE_ID = 1592
	    VIDEO_PID = 514
	    AUDIO_PID = 0
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 219500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 1/2
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [TEN Digital]
	    SERVICE_ID = 1593
	    VIDEO_PID = 512
	    AUDIO_PID = 650
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 219500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 1/2
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [Nine Digital]
	    SERVICE_ID = 1072
	    VIDEO_PID = 513
	    AUDIO_PID = 660
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 191625000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 1/2
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [Nine Digital HD]
	    SERVICE_ID = 1073
	    VIDEO_PID = 512
	    AUDIO_PID = 0
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 191625000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 1/2
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [Nine Guide]
	    SERVICE_ID = 1074
	    VIDEO_PID = 514
	    AUDIO_PID = 670
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 191625000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 3/4
	    CODE_RATE_LP = 1/2
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/16
	    HIERARCHY = NONE

    [7 Digital]
	    SERVICE_ID = 1328
	    VIDEO_PID = 769
	    AUDIO_PID = 770
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 177500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 2/3
	    CODE_RATE_LP = 2/3
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/8
	    HIERARCHY = NONE

    [7 Digital 1]
	    SERVICE_ID = 1329
	    VIDEO_PID = 769
	    AUDIO_PID = 770
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 177500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 2/3
	    CODE_RATE_LP = 2/3
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/8
	    HIERARCHY = NONE

    [7 Digital 2]
	    SERVICE_ID = 1330
	    VIDEO_PID = 769
	    AUDIO_PID = 770
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 177500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 2/3
	    CODE_RATE_LP = 2/3
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/8
	    HIERARCHY = NONE

    [7 Digital 3]
	    SERVICE_ID = 1331
	    VIDEO_PID = 769
	    AUDIO_PID = 770
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 177500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 2/3
	    CODE_RATE_LP = 2/3
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/8
	    HIERARCHY = NONE

    [7 HD Digital]
	    SERVICE_ID = 1332
	    VIDEO_PID = 833
	    AUDIO_PID = 834
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 177500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 2/3
	    CODE_RATE_LP = 2/3
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/8
	    HIERARCHY = NONE

    [7 Program Guide]
	    SERVICE_ID = 1334
	    VIDEO_PID = 865
	    AUDIO_PID = 866
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 177500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 2/3
	    CODE_RATE_LP = 2/3
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/8
	    HIERARCHY = NONE

    [SBS HD]
	    SERVICE_ID = 784
	    VIDEO_PID = 102
	    AUDIO_PID = 103
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 536500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 2/3
	    CODE_RATE_LP = 2/3
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/8
	    HIERARCHY = NONE

    [SBS DIGITAL 1]
	    SERVICE_ID = 785
	    VIDEO_PID = 161
	    AUDIO_PID = 81
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 536500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 2/3
	    CODE_RATE_LP = 2/3
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/8
	    HIERARCHY = NONE

    [SBS DIGITAL 2]
	    SERVICE_ID = 786
	    VIDEO_PID = 162
	    AUDIO_PID = 83
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 536500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 2/3
	    CODE_RATE_LP = 2/3
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/8
	    HIERARCHY = NONE

    [SBS EPG]
	    SERVICE_ID = 787
	    VIDEO_PID = 163
	    AUDIO_PID = 85
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 536500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 2/3
	    CODE_RATE_LP = 2/3
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/8
	    HIERARCHY = NONE

    [SBS RADIO 1]
	    SERVICE_ID = 798
	    VIDEO_PID = 0
	    AUDIO_PID = 201
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 536500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 2/3
	    CODE_RATE_LP = 2/3
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/8
	    HIERARCHY = NONE

    [SBS RADIO 2]
	    SERVICE_ID = 799
	    VIDEO_PID = 0
	    AUDIO_PID = 202
	    DELIVERY_SYSTEM = DVBT
	    FREQUENCY = 536500000
	    INVERSION = OFF
	    BANDWIDTH_HZ = 7000000
	    CODE_RATE_HP = 2/3
	    CODE_RATE_LP = 2/3
	    MODULATION = QAM/64
	    TRANSMISSION_MODE = 8K
	    GUARD_INTERVAL = 1/8
	    HIERARCHY = NONE
