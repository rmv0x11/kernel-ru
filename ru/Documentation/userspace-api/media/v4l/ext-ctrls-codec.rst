.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: V4L

.. _codec-controls:

***********************************************
Справочник по элементам управления кодеками
***********************************************

Ниже описаны все элементы управления класса Codec. Сначала описаны общие
элементы управления, затем элементы управления, специфичные для определённого
оборудования.

.. note::

   Эти элементы управления применимы ко всем кодекам, а не только к MPEG.
   Определения снабжены префиксом V4L2_CID_MPEG/V4L2_MPEG, поскольку эти
   элементы управления изначально создавались для MPEG-кодеков и позднее были
   расширены для охвата всех форматов кодирования.


Общие элементы управления кодеками
==================================


.. _mpeg-control-id:

Идентификаторы элементов управления кодеком
-------------------------------------------

``V4L2_CID_CODEC_CLASS (class)``
    Дескриптор класса Codec. Вызов
    :ref:`VIDIOC_QUERYCTRL` для этого элемента управления
    вернёт описание данного класса элементов управления. Это описание может
    быть использовано, например, в качестве заголовка вкладки в графическом
    интерфейсе.

.. _v4l2-mpeg-stream-type:

``V4L2_CID_MPEG_STREAM_TYPE``
    (enum)

enum v4l2_mpeg_stream_type -
    Тип выходного потока MPEG-1, -2 или -4. Здесь ничего нельзя предполагать
    заранее. Каждый аппаратный MPEG-кодер обычно поддерживает разные
    подмножества доступных типов MPEG-потоков. Этот элемент управления
    специфичен для мультиплексированных MPEG-потоков. На данный момент
    определены следующие типы потоков:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_STREAM_TYPE_MPEG2_PS``
      - Программный поток MPEG-2 (program stream)
    * - ``V4L2_MPEG_STREAM_TYPE_MPEG2_TS``
      - Транспортный поток MPEG-2 (transport stream)
    * - ``V4L2_MPEG_STREAM_TYPE_MPEG1_SS``
      - Системный поток MPEG-1 (system stream)
    * - ``V4L2_MPEG_STREAM_TYPE_MPEG2_DVD``
      - DVD-совместимый поток MPEG-2
    * - ``V4L2_MPEG_STREAM_TYPE_MPEG1_VCD``
      - VCD-совместимый поток MPEG-1
    * - ``V4L2_MPEG_STREAM_TYPE_MPEG2_SVCD``
      - SVCD-совместимый поток MPEG-2



``V4L2_CID_MPEG_STREAM_PID_PMT (integer)``
    Идентификатор пакета Program Map Table для транспортного MPEG-потока (по
    умолчанию 16)

``V4L2_CID_MPEG_STREAM_PID_AUDIO (integer)``
    Идентификатор аудиопакета для транспортного MPEG-потока (по умолчанию 256)

``V4L2_CID_MPEG_STREAM_PID_VIDEO (integer)``
    Идентификатор видеопакета для транспортного MPEG-потока (по умолчанию 260)

``V4L2_CID_MPEG_STREAM_PID_PCR (integer)``
    Идентификатор пакета транспортного MPEG-потока, несущего поля PCR (по
    умолчанию 259)

``V4L2_CID_MPEG_STREAM_PES_ID_AUDIO (integer)``
    Идентификатор аудио для MPEG PES

``V4L2_CID_MPEG_STREAM_PES_ID_VIDEO (integer)``
    Идентификатор видео для MPEG PES

.. _v4l2-mpeg-stream-vbi-fmt:

``V4L2_CID_MPEG_STREAM_VBI_FMT``
    (enum)

enum v4l2_mpeg_stream_vbi_fmt -
    Некоторые карты могут встраивать данные VBI (например, Closed Caption,
    Teletext) в MPEG-поток. Этот элемент управления выбирает, следует ли
    встраивать данные VBI, и если да, то какой метод встраивания должен
    использоваться. Список возможных форматов VBI зависит от драйвера. На
    данный момент определены следующие типы форматов VBI:



.. tabularcolumns:: |p{6.6 cm}|p{10.9cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_STREAM_VBI_FMT_NONE``
      - Нет VBI в MPEG-потоке
    * - ``V4L2_MPEG_STREAM_VBI_FMT_IVTV``
      - VBI в приватных пакетах, формат IVTV (описан в исходных кодах ядра в
	файле
	``Documentation/userspace-api/media/drivers/cx2341x-uapi.rst``)



.. _v4l2-mpeg-audio-sampling-freq:

``V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ``
    (enum)

enum v4l2_mpeg_audio_sampling_freq -
    Частота дискретизации MPEG Audio. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_AUDIO_SAMPLING_FREQ_44100``
      - 44,1 кГц
    * - ``V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000``
      - 48 кГц
    * - ``V4L2_MPEG_AUDIO_SAMPLING_FREQ_32000``
      - 32 кГц



.. _v4l2-mpeg-audio-encoding:

``V4L2_CID_MPEG_AUDIO_ENCODING``
    (enum)

enum v4l2_mpeg_audio_encoding -
    Кодирование MPEG Audio. Этот элемент управления специфичен для
    мультиплексированных MPEG-потоков. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_AUDIO_ENCODING_LAYER_1``
      - Кодирование MPEG-1/2 Layer I
    * - ``V4L2_MPEG_AUDIO_ENCODING_LAYER_2``
      - Кодирование MPEG-1/2 Layer II
    * - ``V4L2_MPEG_AUDIO_ENCODING_LAYER_3``
      - Кодирование MPEG-1/2 Layer III
    * - ``V4L2_MPEG_AUDIO_ENCODING_AAC``
      - MPEG-2/4 AAC (Advanced Audio Coding)
    * - ``V4L2_MPEG_AUDIO_ENCODING_AC3``
      - Кодирование AC-3, также известное как ATSC A/52



.. _v4l2-mpeg-audio-l1-bitrate:

``V4L2_CID_MPEG_AUDIO_L1_BITRATE``
    (enum)

enum v4l2_mpeg_audio_l1_bitrate -
    Битрейт MPEG-1/2 Layer I. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_32K``
      - 32 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_64K``
      - 64 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_96K``
      - 96 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_128K``
      - 128 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_160K``
      - 160 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_192K``
      - 192 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_224K``
      - 224 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_256K``
      - 256 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_288K``
      - 288 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_320K``
      - 320 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_352K``
      - 352 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_384K``
      - 384 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_416K``
      - 416 кбит/с
    * - ``V4L2_MPEG_AUDIO_L1_BITRATE_448K``
      - 448 кбит/с



.. _v4l2-mpeg-audio-l2-bitrate:

``V4L2_CID_MPEG_AUDIO_L2_BITRATE``
    (enum)

enum v4l2_mpeg_audio_l2_bitrate -
    Битрейт MPEG-1/2 Layer II. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_32K``
      - 32 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_48K``
      - 48 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_56K``
      - 56 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_64K``
      - 64 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_80K``
      - 80 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_96K``
      - 96 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_112K``
      - 112 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_128K``
      - 128 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_160K``
      - 160 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_192K``
      - 192 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_224K``
      - 224 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_256K``
      - 256 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_320K``
      - 320 кбит/с
    * - ``V4L2_MPEG_AUDIO_L2_BITRATE_384K``
      - 384 кбит/с



.. _v4l2-mpeg-audio-l3-bitrate:

``V4L2_CID_MPEG_AUDIO_L3_BITRATE``
    (enum)

enum v4l2_mpeg_audio_l3_bitrate -
    Битрейт MPEG-1/2 Layer III. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_32K``
      - 32 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_40K``
      - 40 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_48K``
      - 48 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_56K``
      - 56 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_64K``
      - 64 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_80K``
      - 80 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_96K``
      - 96 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_112K``
      - 112 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_128K``
      - 128 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_160K``
      - 160 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_192K``
      - 192 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_224K``
      - 224 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_256K``
      - 256 кбит/с
    * - ``V4L2_MPEG_AUDIO_L3_BITRATE_320K``
      - 320 кбит/с



``V4L2_CID_MPEG_AUDIO_AAC_BITRATE (integer)``
    Битрейт AAC в битах в секунду.

.. _v4l2-mpeg-audio-ac3-bitrate:

``V4L2_CID_MPEG_AUDIO_AC3_BITRATE``
    (enum)

enum v4l2_mpeg_audio_ac3_bitrate -
    Битрейт AC-3. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_32K``
      - 32 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_40K``
      - 40 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_48K``
      - 48 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_56K``
      - 56 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_64K``
      - 64 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_80K``
      - 80 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_96K``
      - 96 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_112K``
      - 112 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_128K``
      - 128 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_160K``
      - 160 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_192K``
      - 192 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_224K``
      - 224 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_256K``
      - 256 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_320K``
      - 320 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_384K``
      - 384 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_448K``
      - 448 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_512K``
      - 512 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_576K``
      - 576 кбит/с
    * - ``V4L2_MPEG_AUDIO_AC3_BITRATE_640K``
      - 640 кбит/с



.. _v4l2-mpeg-audio-mode:

``V4L2_CID_MPEG_AUDIO_MODE``
    (enum)

enum v4l2_mpeg_audio_mode -
    Режим MPEG Audio. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_AUDIO_MODE_STEREO``
      - Стерео
    * - ``V4L2_MPEG_AUDIO_MODE_JOINT_STEREO``
      - Joint Stereo
    * - ``V4L2_MPEG_AUDIO_MODE_DUAL``
      - Двуязычный
    * - ``V4L2_MPEG_AUDIO_MODE_MONO``
      - Моно



.. _v4l2-mpeg-audio-mode-extension:

``V4L2_CID_MPEG_AUDIO_MODE_EXTENSION``
    (enum)

enum v4l2_mpeg_audio_mode_extension -
    Расширение аудиорежима Joint Stereo. В Layer I и II оно указывает, какие
    поддиапазоны находятся в intensity stereo. Все остальные поддиапазоны
    кодируются в стерео. Layer III (пока) не поддерживается. Возможные
    значения:

.. tabularcolumns:: |p{9.1cm}|p{8.4cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_AUDIO_MODE_EXTENSION_BOUND_4``
      - Поддиапазоны 4-31 в intensity stereo
    * - ``V4L2_MPEG_AUDIO_MODE_EXTENSION_BOUND_8``
      - Поддиапазоны 8-31 в intensity stereo
    * - ``V4L2_MPEG_AUDIO_MODE_EXTENSION_BOUND_12``
      - Поддиапазоны 12-31 в intensity stereo
    * - ``V4L2_MPEG_AUDIO_MODE_EXTENSION_BOUND_16``
      - Поддиапазоны 16-31 в intensity stereo



.. _v4l2-mpeg-audio-emphasis:

``V4L2_CID_MPEG_AUDIO_EMPHASIS``
    (enum)

enum v4l2_mpeg_audio_emphasis -
    Аудиоэмфазис. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_AUDIO_EMPHASIS_NONE``
      - Нет
    * - ``V4L2_MPEG_AUDIO_EMPHASIS_50_DIV_15_uS``
      - Эмфазис 50/15 микросекунд
    * - ``V4L2_MPEG_AUDIO_EMPHASIS_CCITT_J17``
      - CCITT J.17



.. _v4l2-mpeg-audio-crc:

``V4L2_CID_MPEG_AUDIO_CRC``
    (enum)

enum v4l2_mpeg_audio_crc -
    Метод CRC. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_AUDIO_CRC_NONE``
      - Нет
    * - ``V4L2_MPEG_AUDIO_CRC_CRC16``
      - 16-битная проверка чётности



``V4L2_CID_MPEG_AUDIO_MUTE (boolean)``
    Отключает звук при захвате. Это делается не за счёт отключения звукового
    оборудования, которое всё равно может издавать лёгкое шипение, а в самом
    кодере, что гарантирует фиксированный и воспроизводимый аудиопоток. 0 =
    звук включён, 1 = звук отключён.

.. _v4l2-mpeg-audio-dec-playback:

``V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK``
    (enum)

enum v4l2_mpeg_audio_dec_playback -
    Определяет, как должно воспроизводиться одноязычное аудио. Возможные
    значения:



.. tabularcolumns:: |p{9.8cm}|p{7.7cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_AUDIO_DEC_PLAYBACK_AUTO``
      - Автоматически определяет наилучший режим воспроизведения.
    * - ``V4L2_MPEG_AUDIO_DEC_PLAYBACK_STEREO``
      - Стереовоспроизведение.
    * - ``V4L2_MPEG_AUDIO_DEC_PLAYBACK_LEFT``
      - Воспроизведение левого канала.
    * - ``V4L2_MPEG_AUDIO_DEC_PLAYBACK_RIGHT``
      - Воспроизведение правого канала.
    * - ``V4L2_MPEG_AUDIO_DEC_PLAYBACK_MONO``
      - Моновоспроизведение.
    * - ``V4L2_MPEG_AUDIO_DEC_PLAYBACK_SWAPPED_STEREO``
      - Стереовоспроизведение с поменянными местами левым и правым каналами.



.. _v4l2-mpeg-audio-dec-multilingual-playback:

``V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK``
    (enum)

enum v4l2_mpeg_audio_dec_playback -
    Определяет, как должно воспроизводиться многоязычное аудио.

.. _v4l2-mpeg-video-encoding:

``V4L2_CID_MPEG_VIDEO_ENCODING``
    (enum)

enum v4l2_mpeg_video_encoding -
    Метод кодирования MPEG Video. Этот элемент управления специфичен для
    мультиплексированных MPEG-потоков. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_ENCODING_MPEG_1``
      - Кодирование MPEG-1 Video
    * - ``V4L2_MPEG_VIDEO_ENCODING_MPEG_2``
      - Кодирование MPEG-2 Video
    * - ``V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC``
      - Кодирование MPEG-4 AVC (H.264) Video



.. _v4l2-mpeg-video-aspect:

``V4L2_CID_MPEG_VIDEO_ASPECT``
    (enum)

enum v4l2_mpeg_video_aspect -
    Соотношение сторон видео. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_ASPECT_1x1``
    * - ``V4L2_MPEG_VIDEO_ASPECT_4x3``
    * - ``V4L2_MPEG_VIDEO_ASPECT_16x9``
    * - ``V4L2_MPEG_VIDEO_ASPECT_221x100``



``V4L2_CID_MPEG_VIDEO_B_FRAMES (integer)``
    Количество B-кадров (по умолчанию 2)

``V4L2_CID_MPEG_VIDEO_GOP_SIZE (integer)``
    Размер GOP (по умолчанию 12)

``V4L2_CID_MPEG_VIDEO_GOP_CLOSURE (boolean)``
    Замкнутость GOP (по умолчанию 1)

``V4L2_CID_MPEG_VIDEO_PULLDOWN (boolean)``
    Включить 3:2 pulldown (по умолчанию 0)

.. _v4l2-mpeg-video-bitrate-mode:

``V4L2_CID_MPEG_VIDEO_BITRATE_MODE``
    (enum)

enum v4l2_mpeg_video_bitrate_mode -
    Режим битрейта видео. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_BITRATE_MODE_VBR``
      - Переменный битрейт
    * - ``V4L2_MPEG_VIDEO_BITRATE_MODE_CBR``
      - Постоянный битрейт
    * - ``V4L2_MPEG_VIDEO_BITRATE_MODE_CQ``
      - Постоянное качество



``V4L2_CID_MPEG_VIDEO_BITRATE (integer)``
    Средний битрейт видео в битах в секунду.

``V4L2_CID_MPEG_VIDEO_BITRATE_PEAK (integer)``
    Пиковый битрейт видео в битах в секунду. Должен быть больше или равен
    среднему битрейту видео. Игнорируется, если режим битрейта видео
    установлен в постоянный битрейт.

``V4L2_CID_MPEG_VIDEO_CONSTANT_QUALITY (integer)``
    Управление уровнем постоянного качества. Этот элемент управления
    применим, когда значение ``V4L2_CID_MPEG_VIDEO_BITRATE_MODE`` равно
    ``V4L2_MPEG_VIDEO_BITRATE_MODE_CQ``. Допустимый диапазон — от 1 до 100,
    где 1 означает наименьшее качество, а 100 — наивысшее качество. Кодер сам
    выберет подходящий параметр квантования и битрейт для достижения
    запрошенного качества кадра.


``V4L2_CID_MPEG_VIDEO_FRAME_SKIP_MODE (enum)``

enum v4l2_mpeg_video_frame_skip_mode -
    Указывает, в каких условиях кодер должен пропускать кадры. Если
    кодирование кадра приведёт к тому, что закодированный поток станет больше
    выбранного ограничения на объём данных, то кадр будет пропущен. Возможные
    значения:


.. tabularcolumns:: |p{8.2cm}|p{9.3cm}|

.. raw:: latex

    \small

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_FRAME_SKIP_MODE_DISABLED``
      - Режим пропуска кадров отключён.
    * - ``V4L2_MPEG_VIDEO_FRAME_SKIP_MODE_LEVEL_LIMIT``
      - Режим пропуска кадров включён, а ограничение буфера задаётся выбранным
        уровнем и определяется стандартом.
    * - ``V4L2_MPEG_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT``
      - Режим пропуска кадров включён, а ограничение буфера задаётся элементом
        управления :ref:`VBV (MPEG1/2/4) <v4l2-mpeg-video-vbv-size>` или
        :ref:`размером буфера CPB (H264) <v4l2-mpeg-video-h264-cpb-size>`.

.. raw:: latex

    \normalsize

``V4L2_CID_MPEG_VIDEO_TEMPORAL_DECIMATION (integer)``
    Для каждого захваченного кадра пропускать указанное число последующих
    кадров (по умолчанию 0).

``V4L2_CID_MPEG_VIDEO_MUTE (boolean)``
    «Заглушает» видео фиксированным цветом при захвате. Это полезно для
    тестирования, чтобы получить фиксированный видеопоток. 0 = не заглушено, 1
    = заглушено.

``V4L2_CID_MPEG_VIDEO_MUTE_YUV (integer)``
    Задаёт цвет «заглушки» видео. Переданное 32-битное целое интерпретируется
    следующим образом (бит 0 = младший значащий бит):



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - Биты 0:7
      - Информация о цветности V
    * - Биты 8:15
      - Информация о цветности U
    * - Биты 16:23
      - Информация о яркости Y
    * - Биты 24:31
      - Должно быть нулём.



.. _v4l2-mpeg-video-dec-pts:

``V4L2_CID_MPEG_VIDEO_DEC_PTS (integer64)``
    Этот доступный только для чтения элемент управления возвращает 33-битную
    видеометку времени представления (Presentation Time Stamp), как определено
    в ITU T-REC-H.222.0 и ISO/IEC 13818-1, для текущего отображаемого кадра.
    Это та же PTS, что используется в
    :ref:`VIDIOC_DECODER_CMD`.

.. _v4l2-mpeg-video-dec-frame:

``V4L2_CID_MPEG_VIDEO_DEC_FRAME (integer64)``
    Этот доступный только для чтения элемент управления возвращает счётчик
    кадров для кадра, который в данный момент отображается (декодируется). Это
    значение сбрасывается в 0 при каждом запуске декодера.

``V4L2_CID_MPEG_VIDEO_DEC_CONCEAL_COLOR (integer64)``
    Этот элемент управления задаёт цвет сокрытия в цветовом пространстве YUV.
    Он описывает предпочтение клиента относительно цвета сокрытия ошибки в
    случае ошибки, когда опорный кадр отсутствует. Декодер должен заполнить
    опорный буфер предпочтительным цветом и использовать его для последующего
    декодирования. Этот элемент управления использует 16 бит на канал.
    Применим к декодерам.

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * -
      - 8-битный формат
      - 10-битный формат
      - 12-битный формат
    * - Яркость Y
      - Биты 0:7
      - Биты 0:9
      - Биты 0:11
    * - Цветность Cb
      - Биты 16:23
      - Биты 16:25
      - Биты 16:27
    * - Цветность Cr
      - Биты 32:39
      - Биты 32:41
      - Биты 32:43
    * - Должно быть нулём
      - Биты 48:63
      - Биты 48:63
      - Биты 48:63

``V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE (boolean)``
    Если включено, декодер ожидает получения одного слайса на буфер, в
    противном случае декодер ожидает один кадр на буфер. Применим к декодеру,
    все кодеки.

``V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY_ENABLE (boolean)``
    Если задержка отображения включена, то декодер вынужден возвращать буфер
    CAPTURE (декодированный кадр) после обработки определённого числа буферов
    OUTPUT. Задержку можно задать через
    ``V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY``. Эта возможность может
    использоваться, например, для генерации миниатюр видео. Применим к
    декодеру.

``V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY (integer)``
    Значение задержки отображения для декодера. Декодер вынужден возвращать
    декодированный кадр после установленного числа кадров «задержки
    отображения». Если это число мало, то это может привести к возврату
    кадров не в порядке отображения; кроме того, оборудование может всё ещё
    использовать возвращённый буфер в качестве опорного изображения для
    последующих кадров.

``V4L2_CID_MPEG_VIDEO_AU_DELIMITER (boolean)``
    Если включено, будут генерироваться NALU типа AUD (Access Unit
    Delimiter). Это может быть полезно для нахождения начала кадра без
    необходимости полного разбора каждого NALU. Применим к кодерам H264 и
    HEVC.

``V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE (boolean)``
    Включить запись соотношения сторон сэмпла в Video Usability Information.
    Применим к кодеру H264.

.. _v4l2-mpeg-video-h264-vui-sar-idc:

``V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC``
    (enum)

enum v4l2_mpeg_video_h264_vui_sar_idc -
    Индикатор соотношения сторон сэмпла VUI для кодирования H.264. Значение
    определено в таблице E-1 стандарта. Применим к кодеру H264.



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_UNSPECIFIED``
      - Не указано
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_1x1``
      - 1x1
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_12x11``
      - 12x11
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_10x11``
      - 10x11
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_16x11``
      - 16x11
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_40x33``
      - 40x33
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_24x11``
      - 24x11
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_20x11``
      - 20x11
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_32x11``
      - 32x11
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_80x33``
      - 80x33
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_18x11``
      - 18x11
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_15x11``
      - 15x11
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_64x33``
      - 64x33
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_160x99``
      - 160x99
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_4x3``
      - 4x3
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_3x2``
      - 3x2
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_2x1``
      - 2x1
    * - ``V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED``
      - Расширенный SAR



``V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_WIDTH (integer)``
    Расширенная ширина соотношения сторон сэмпла для кодирования H.264 VUI.
    Применим к кодеру H264.

``V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_HEIGHT (integer)``
    Расширенная высота соотношения сторон сэмпла для кодирования H.264 VUI.
    Применим к кодеру H264.

.. _v4l2-mpeg-video-h264-level:

``V4L2_CID_MPEG_VIDEO_H264_LEVEL``
    (enum)

enum v4l2_mpeg_video_h264_level -
    Информация об уровне для элементарного видеопотока H264. Применим к кодеру
    H264. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_1_0``
      - Level 1.0
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_1B``
      - Level 1B
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_1_1``
      - Level 1.1
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_1_2``
      - Level 1.2
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_1_3``
      - Level 1.3
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_2_0``
      - Level 2.0
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_2_1``
      - Level 2.1
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_2_2``
      - Level 2.2
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_3_0``
      - Level 3.0
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_3_1``
      - Level 3.1
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_3_2``
      - Level 3.2
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_4_0``
      - Level 4.0
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_4_1``
      - Level 4.1
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_4_2``
      - Level 4.2
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_5_0``
      - Level 5.0
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_5_1``
      - Level 5.1
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_5_2``
      - Level 5.2
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_6_0``
      - Level 6.0
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_6_1``
      - Level 6.1
    * - ``V4L2_MPEG_VIDEO_H264_LEVEL_6_2``
      - Level 6.2



.. _v4l2-mpeg-video-mpeg2-level:

``V4L2_CID_MPEG_VIDEO_MPEG2_LEVEL``
    (enum)

enum v4l2_mpeg_video_mpeg2_level -
    Информация об уровне для элементарного потока MPEG2. Применим к
    MPEG2-кодекам. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_MPEG2_LEVEL_LOW``
      - Low Level (LL)
    * - ``V4L2_MPEG_VIDEO_MPEG2_LEVEL_MAIN``
      - Main Level (ML)
    * - ``V4L2_MPEG_VIDEO_MPEG2_LEVEL_HIGH_1440``
      - High-1440 Level (H-14)
    * - ``V4L2_MPEG_VIDEO_MPEG2_LEVEL_HIGH``
      - High Level (HL)



.. _v4l2-mpeg-video-mpeg4-level:

``V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL``
    (enum)

enum v4l2_mpeg_video_mpeg4_level -
    Информация об уровне для элементарного потока MPEG4. Применим к кодеру
    MPEG4. Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_0``
      - Level 0
    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_0B``
      - Level 0b
    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_1``
      - Level 1
    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_2``
      - Level 2
    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_3``
      - Level 3
    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_3B``
      - Level 3b
    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_4``
      - Level 4
    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_5``
      - Level 5



.. _v4l2-mpeg-video-h264-profile:

``V4L2_CID_MPEG_VIDEO_H264_PROFILE``
    (enum)

enum v4l2_mpeg_video_h264_profile -
    Информация о профиле для H264. Применим к кодеру H264. Возможные значения:

.. raw:: latex

    \small

.. tabularcolumns:: |p{10.2cm}|p{7.3cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE``
      - Профиль Baseline
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE``
      - Профиль Constrained Baseline
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_MAIN``
      - Профиль Main
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_EXTENDED``
      - Профиль Extended
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_HIGH``
      - Профиль High
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_10``
      - Профиль High 10
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_422``
      - Профиль High 422
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_444_PREDICTIVE``
      - Профиль High 444 Predictive
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_10_INTRA``
      - Профиль High 10 Intra
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_422_INTRA``
      - Профиль High 422 Intra
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_444_INTRA``
      - Профиль High 444 Intra
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_CAVLC_444_INTRA``
      - Профиль CAVLC 444 Intra
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_BASELINE``
      - Профиль Scalable Baseline
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_HIGH``
      - Профиль Scalable High
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_HIGH_INTRA``
      - Профиль Scalable High Intra
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_STEREO_HIGH``
      - Профиль Stereo High
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH``
      - Профиль Multiview High
    * - ``V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_HIGH``
      - Профиль Constrained High

.. raw:: latex

    \normalsize

.. _v4l2-mpeg-video-mpeg2-profile:

``V4L2_CID_MPEG_VIDEO_MPEG2_PROFILE``
    (enum)

enum v4l2_mpeg_video_mpeg2_profile -
    Информация о профиле для MPEG2. Применим к MPEG2-кодекам. Возможные
    значения:

.. raw:: latex

    \small

.. tabularcolumns:: |p{10.2cm}|p{7.3cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_MPEG2_PROFILE_SIMPLE``
      - Профиль Simple (SP)
    * - ``V4L2_MPEG_VIDEO_MPEG2_PROFILE_MAIN``
      - Профиль Main (MP)
    * - ``V4L2_MPEG_VIDEO_MPEG2_PROFILE_SNR_SCALABLE``
      - Профиль SNR Scalable (SNR)
    * - ``V4L2_MPEG_VIDEO_MPEG2_PROFILE_SPATIALLY_SCALABLE``
      - Профиль Spatially Scalable (Spt)
    * - ``V4L2_MPEG_VIDEO_MPEG2_PROFILE_HIGH``
      - Профиль High (HP)
    * - ``V4L2_MPEG_VIDEO_MPEG2_PROFILE_MULTIVIEW``
      - Профиль Multi-view (MVP)


.. raw:: latex

    \normalsize

.. _v4l2-mpeg-video-mpeg4-profile:

``V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE``
    (enum)

enum v4l2_mpeg_video_mpeg4_profile -
    Информация о профиле для MPEG4. Применим к кодеру MPEG4. Возможные
    значения:

.. raw:: latex

    \small

.. tabularcolumns:: |p{11.8cm}|p{5.7cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE``
      - Профиль Simple
    * - ``V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_SIMPLE``
      - Профиль Advanced Simple
    * - ``V4L2_MPEG_VIDEO_MPEG4_PROFILE_CORE``
      - Профиль Core
    * - ``V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE_SCALABLE``
      - Профиль Simple Scalable
    * - ``V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_CODING_EFFICIENCY``
      - Профиль Advanced Coding Efficiency

.. raw:: latex

    \normalsize

``V4L2_CID_MPEG_VIDEO_MAX_REF_PIC (integer)``
    Максимальное число опорных изображений, используемых для кодирования.
    Применим к кодеру.

.. _v4l2-mpeg-video-multi-slice-mode:

``V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE``
    (enum)

enum v4l2_mpeg_video_multi_slice_mode -
    Определяет, как кодер должен обрабатывать разделение кадра на слайсы.
    Применим к кодеру. Возможные значения:



.. tabularcolumns:: |p{9.6cm}|p{7.9cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE``
      - Один слайс на кадр.
    * - ``V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_MB``
      - Несколько слайсов с заданным максимальным числом макроблоков на слайс.
    * - ``V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES``
      - Несколько слайсов с заданным максимальным размером в байтах на слайс.



``V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB (integer)``
    Максимальное число макроблоков в слайсе. Используется, когда
    ``V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE`` установлен в
    ``V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_MB``. Применим к кодеру.

``V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES (integer)``
    Максимальный размер слайса в байтах. Используется, когда
    ``V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE`` установлен в
    ``V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES``. Применим к кодеру.

.. _v4l2-mpeg-video-h264-loop-filter-mode:

``V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE``
    (enum)

enum v4l2_mpeg_video_h264_loop_filter_mode -
    Режим петлевого фильтра для кодера H264. Возможные значения:

.. raw:: latex

    \small

.. tabularcolumns:: |p{13.5cm}|p{4.0cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED``
      - Петлевой фильтр включён.
    * - ``V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED``
      - Петлевой фильтр отключён.
    * - ``V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY``
      - Петлевой фильтр отключён на границе слайса.

.. raw:: latex

    \normalsize


``V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA (integer)``
    Коэффициент alpha петлевого фильтра, определённый в стандарте H264. Это
    значение соответствует полю slice_alpha_c0_offset_div2 заголовка слайса и
    должно находиться в диапазоне от -6 до +6 включительно. Фактическое
    смещение alpha FilterOffsetA вдвое больше этого значения. Применим к кодеру
    H264.

``V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA (integer)``
    Коэффициент beta петлевого фильтра, определённый в стандарте H264. Он
    соответствует полю slice_beta_offset_div2 заголовка слайса и должен
    находиться в диапазоне от -6 до +6 включительно. Фактическое смещение beta
    FilterOffsetB вдвое больше этого значения. Применим к кодеру H264.

.. _v4l2-mpeg-video-h264-entropy-mode:

``V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE``
    (enum)

enum v4l2_mpeg_video_h264_entropy_mode -
    Режим энтропийного кодирования для H264 - CABAC/CAVALC. Применим к кодеру
    H264. Возможные значения:


.. tabularcolumns:: |p{9.0cm}|p{8.5cm}|


.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CAVLC``
      - Использовать энтропийное кодирование CAVLC.
    * - ``V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC``
      - Использовать энтропийное кодирование CABAC.



``V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM (boolean)``
    Включить преобразование 8X8 для H264. Применим к кодеру H264.

``V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION (boolean)``
    Включить ограниченное внутреннее предсказание для H264. Применим к кодеру
    H264.

``V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET (integer)``
    Задать смещение, которое следует добавить к параметру квантования яркости
    для определения параметра квантования цветности. Применим к кодеру H264.

``V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB (integer)``
    Циклическое внутреннее обновление макроблоков. Это число непрерывных
    макроблоков, обновляемых в каждом кадре. В каждом кадре обновляется
    последовательный набор макроблоков, пока цикл не завершится и не начнётся
    заново с верхней части кадра. Установка этого элемента управления в ноль
    означает, что макроблоки не будут обновляться. Обратите внимание, что этот
    элемент управления не действует, когда элемент управления
    ``V4L2_CID_MPEG_VIDEO_INTRA_REFRESH_PERIOD`` установлен в ненулевое
    значение. Применим к кодерам H264, H263 и MPEG4.

``V4L2_CID_MPEG_VIDEO_INTRA_REFRESH_PERIOD_TYPE (enum)``

enum v4l2_mpeg_video_intra_refresh_period_type -
    Задаёт тип внутреннего обновления. Период обновления всего кадра задаётся
    через V4L2_CID_MPEG_VIDEO_INTRA_REFRESH_PERIOD. Обратите внимание, что
    если этот элемент управления отсутствует, то не определено, какой тип
    обновления используется, и это остаётся на усмотрение драйвера. Применим к
    кодерам H264 и HEVC. Возможные значения:

.. tabularcolumns:: |p{9.6cm}|p{7.9cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_INTRA_REFRESH_PERIOD_TYPE_RANDOM``
      - Весь кадр полностью обновляется случайным образом по истечении
        заданного периода.
    * - ``V4L2_MPEG_VIDEO_INTRA_REFRESH_PERIOD_TYPE_CYCLIC``
      - Макроблоки всего кадра полностью обновляются в циклическом порядке по
        истечении заданного периода.

``V4L2_CID_MPEG_VIDEO_INTRA_REFRESH_PERIOD (integer)``
    Период внутреннего обновления макроблоков. Это задаёт период обновления
    всего кадра. Другими словами, это определяет число кадров, в течение
    которых весь кадр будет внутренне обновлён. Пример: установка периода в 1
    означает, что весь кадр будет обновлён; установка периода в 2 означает, что
    половина макроблоков будет внутренне обновлена в frameX, а другая половина
    макроблоков будет обновлена в frameX + 1 и так далее. Установка периода в
    ноль означает, что период не задан. Обратите внимание, что если клиент
    устанавливает этот элемент управления в ненулевое значение, то элемент
    управления ``V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB`` должен
    игнорироваться. Применим к кодерам H264 и HEVC.

``V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE (boolean)``
    Включение управления скоростью на уровне кадра. Если этот элемент
    управления отключён, то параметр квантования для каждого типа кадра
    является постоянным и устанавливается соответствующими элементами
    управления (например, ``V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP``). Если
    управление скоростью кадра включено, то параметр квантования
    подстраивается под выбранный битрейт. Минимальное и максимальное значения
    параметра квантования можно задать соответствующими элементами управления
    (например, ``V4L2_CID_MPEG_VIDEO_H263_MIN_QP``). Применим к кодерам.

``V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE (boolean)``
    Включение управления скоростью на уровне макроблоков. Применим к кодерам
    MPEG4 и H264.

``V4L2_CID_MPEG_VIDEO_MPEG4_QPEL (boolean)``
    Оценка движения с точностью до четверти пикселя для MPEG4. Применим к
    кодеру MPEG4.

``V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP (integer)``
    Параметр квантования для I-кадра для H263. Допустимый диапазон: от 1 до
    31.

``V4L2_CID_MPEG_VIDEO_H263_MIN_QP (integer)``
    Минимальный параметр квантования для H263. Допустимый диапазон: от 1 до
    31.

``V4L2_CID_MPEG_VIDEO_H263_MAX_QP (integer)``
    Максимальный параметр квантования для H263. Допустимый диапазон: от 1 до
    31.

``V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP (integer)``
    Параметр квантования для P-кадра для H263. Допустимый диапазон: от 1 до
    31.

``V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP (integer)``
    Параметр квантования для B-кадра для H263. Допустимый диапазон: от 1 до
    31.

``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP (integer)``
    Параметр квантования для I-кадра для H264. Допустимый диапазон: от 0 до
    51.

``V4L2_CID_MPEG_VIDEO_H264_MIN_QP (integer)``
    Минимальный параметр квантования для H264. Допустимый диапазон: от 0 до 51.

``V4L2_CID_MPEG_VIDEO_H264_MAX_QP (integer)``
    Максимальный параметр квантования для H264. Допустимый диапазон: от 0 до 51.

``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP (integer)``
    Параметр квантования для P-кадра для H264. Допустимый диапазон: от 0 до
    51.

``V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP (integer)``
    Параметр квантования для B-кадра для H264. Допустимый диапазон: от 0 до
    51.

``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP (integer)``
    Минимальный параметр квантования для I-кадра H264 для ограничения качества
    I-кадра определённым диапазоном. Допустимый диапазон: от 0 до 51. Если
    V4L2_CID_MPEG_VIDEO_H264_MIN_QP также установлен, параметр квантования
    должен быть выбран так, чтобы удовлетворять обоим требованиям.

``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP (integer)``
    Максимальный параметр квантования для I-кадра H264 для ограничения
    качества I-кадра определённым диапазоном. Допустимый диапазон: от 0 до 51.
    Если V4L2_CID_MPEG_VIDEO_H264_MAX_QP также установлен, параметр
    квантования должен быть выбран так, чтобы удовлетворять обоим требованиям.

``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP (integer)``
    Минимальный параметр квантования для P-кадра H264 для ограничения качества
    P-кадра определённым диапазоном. Допустимый диапазон: от 0 до 51. Если
    V4L2_CID_MPEG_VIDEO_H264_MIN_QP также установлен, параметр квантования
    должен быть выбран так, чтобы удовлетворять обоим требованиям.

``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP (integer)``
    Максимальный параметр квантования для P-кадра H264 для ограничения
    качества P-кадра определённым диапазоном. Допустимый диапазон: от 0 до 51.
    Если V4L2_CID_MPEG_VIDEO_H264_MAX_QP также установлен, параметр
    квантования должен быть выбран так, чтобы удовлетворять обоим требованиям.

``V4L2_CID_MPEG_VIDEO_H264_B_FRAME_MIN_QP (integer)``
    Минимальный параметр квантования для B-кадра H264 для ограничения качества
    B-кадра определённым диапазоном. Допустимый диапазон: от 0 до 51. Если
    V4L2_CID_MPEG_VIDEO_H264_MIN_QP также установлен, параметр квантования
    должен быть выбран так, чтобы удовлетворять обоим требованиям.

``V4L2_CID_MPEG_VIDEO_H264_B_FRAME_MAX_QP (integer)``
    Максимальный параметр квантования для B-кадра H264 для ограничения
    качества B-кадра определённым диапазоном. Допустимый диапазон: от 0 до 51.
    Если V4L2_CID_MPEG_VIDEO_H264_MAX_QP также установлен, параметр
    квантования должен быть выбран так, чтобы удовлетворять обоим требованиям.

``V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP (integer)``
    Параметр квантования для I-кадра для MPEG4. Допустимый диапазон: от 1 до
    31.

``V4L2_CID_MPEG_VIDEO_MPEG4_MIN_QP (integer)``
    Минимальный параметр квантования для MPEG4. Допустимый диапазон: от 1 до 31.

``V4L2_CID_MPEG_VIDEO_MPEG4_MAX_QP (integer)``
    Максимальный параметр квантования для MPEG4. Допустимый диапазон: от 1 до 31.

``V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP (integer)``
    Параметр квантования для P-кадра для MPEG4. Допустимый диапазон: от 1 до
    31.

``V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP (integer)``
    Параметр квантования для B-кадра для MPEG4. Допустимый диапазон: от 1 до
    31.

.. _v4l2-mpeg-video-vbv-size:

``V4L2_CID_MPEG_VIDEO_VBV_SIZE (integer)``
    Размер Video Buffer Verifier в килобайтах, используется как ограничение
    пропуска кадров. VBV определён в стандарте как средство проверки того, что
    произведённый поток будет успешно декодирован. Стандарт описывает его как
    «Часть гипотетического декодера, которая концептуально подключена к выходу
    кодера. Его назначение — обеспечить ограничение на изменчивость скорости
    передачи данных, которую может производить кодер или процесс
    редактирования.». Применим к кодерам MPEG1, MPEG2, MPEG4.

.. _v4l2-mpeg-video-vbv-delay:

``V4L2_CID_MPEG_VIDEO_VBV_DELAY (integer)``
    Задаёт начальную задержку в миллисекундах для управления буфером VBV.

.. _v4l2-mpeg-video-hor-search-range:

``V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE (integer)``
    Горизонтальный диапазон поиска определяет максимальную горизонтальную
    область поиска в пикселях для поиска и сопоставления текущего макроблока
    (MB) в опорном изображении. Этот макрос элемента управления V4L2
    используется для задания горизонтального диапазона поиска для модуля
    оценки движения в видеокодере.

.. _v4l2-mpeg-video-vert-search-range:

``V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE (integer)``
    Вертикальный диапазон поиска определяет максимальную вертикальную область
    поиска в пикселях для поиска и сопоставления текущего макроблока (MB) в
    опорном изображении. Этот макрос элемента управления V4L2 используется для
    задания вертикального диапазона поиска для модуля оценки движения в
    видеокодере.

.. _v4l2-mpeg-video-force-key-frame:

``V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME (button)``
    Принудительно установить ключевой кадр для следующего буфера в очереди.
    Применим к кодерам. Это общий, не зависящий от кодека элемент управления
    ключевыми кадрами.

.. _v4l2-mpeg-video-h264-cpb-size:

``V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE (integer)``
    Размер Coded Picture Buffer в килобайтах, используется как ограничение
    пропуска кадров. CPB определён в стандарте H264 как средство проверки
    того, что произведённый поток будет успешно декодирован. Применим к кодеру
    H264.

``V4L2_CID_MPEG_VIDEO_H264_I_PERIOD (integer)``
    Период между I-кадрами в открытом GOP для H264. В случае открытого GOP это
    период между двумя I-кадрами. Период между IDR-кадрами (Instantaneous
    Decoding Refresh) берётся из элемента управления GOP_SIZE. IDR-кадр, что
    означает Instantaneous Decoding Refresh, — это I-кадр, после которого не
    делается ссылок на предшествующие кадры. Это означает, что поток может быть
    перезапущен с IDR-кадра без необходимости хранить или декодировать любые
    предыдущие кадры. Применим к кодеру H264.

.. _v4l2-mpeg-video-header-mode:

``V4L2_CID_MPEG_VIDEO_HEADER_MODE``
    (enum)

enum v4l2_mpeg_video_header_mode -
    Определяет, возвращается ли заголовок в качестве первого буфера или он
    возвращается вместе с первым кадром. Применим к кодерам. Возможные
    значения:

.. raw:: latex

    \small

.. tabularcolumns:: |p{10.3cm}|p{7.2cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE``
      - Заголовок потока возвращается отдельно в первом буфере.
    * - ``V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME``
      - Заголовок потока возвращается вместе с первым закодированным
	кадром.

.. raw:: latex

    \normalsize


``V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER (boolean)``
    Повторять заголовки видеопоследовательности. Повторение этих заголовков
    упрощает произвольный доступ к видеопотоку. Применим к кодеру MPEG1, 2 и 4.

``V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER (boolean)``
    Включить фильтр деблокинга постобработки для декодера MPEG4. Применим к
    декодеру MPEG4.

``V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_RES (integer)``
    Значение vop_time_increment_resolution для MPEG4. Применим к кодеру MPEG4.

``V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_INC (integer)``
    Значение vop_time_increment для MPEG4. Применим к кодеру MPEG4.

``V4L2_CID_MPEG_VIDEO_H264_SEI_FRAME_PACKING (boolean)``
    Включить генерацию дополнительной информации улучшения (supplemental
    enhancement information) об упаковке кадров в закодированном битовом
    потоке. SEI-сообщение об упаковке кадров содержит расположение L- и
    R-плоскостей для трёхмерного просмотра. Применим к кодеру H264.

``V4L2_CID_MPEG_VIDEO_H264_SEI_FP_CURRENT_FRAME_0 (boolean)``
    Устанавливает текущий кадр как frame0 в SEI упаковки кадров. Применим к
    кодеру H264.

.. _v4l2-mpeg-video-h264-sei-fp-arrangement-type:

``V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE``
    (enum)

enum v4l2_mpeg_video_h264_sei_fp_arrangement_type -
    Тип расположения упаковки кадров для H264 SEI. Применим к кодеру H264.
    Возможные значения:

.. raw:: latex

    \small

.. tabularcolumns:: |p{12cm}|p{5.5cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_CHEKERBOARD``
      - Пиксели поочерёдно берутся из L и R.
    * - ``V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_COLUMN``
      - L и R чередуются по столбцам.
    * - ``V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_ROW``
      - L и R чередуются по строкам.
    * - ``V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_SIDE_BY_SIDE``
      - L находится слева, R справа.
    * - ``V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_TOP_BOTTOM``
      - L находится сверху, R снизу.
    * - ``V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_TEMPORAL``
      - Один вид на кадр.

.. raw:: latex

    \normalsize



``V4L2_CID_MPEG_VIDEO_H264_FMO (boolean)``
    Включает гибкое упорядочение макроблоков (flexible macroblock ordering) в
    закодированном битовом потоке. Это техника, используемая для
    реструктуризации порядка макроблоков в изображениях. Применим к кодеру
    H264.

.. _v4l2-mpeg-video-h264-fmo-map-type:

``V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE``
   (enum)

enum v4l2_mpeg_video_h264_fmo_map_type -
    При использовании FMO тип карты разделяет изображение на различные шаблоны
    сканирования макроблоков. Применим к кодеру H264. Возможные значения:

.. raw:: latex

    \small

.. tabularcolumns:: |p{12.5cm}|p{5.0cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES``
      - Слайсы чередуются один за другим с макроблоками в порядке длин серий
	(run length).
    * - ``V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_SCATTERED_SLICES``
      - Рассеивает макроблоки на основе математической функции, известной как
	кодеру, так и декодеру.
    * - ``V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_FOREGROUND_WITH_LEFT_OVER``
      - Макроблоки, расположенные в прямоугольных областях или областях
        интереса.
    * - ``V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_BOX_OUT``
      - Группы слайсов растут циклически от центра к краям.
    * - ``V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_RASTER_SCAN``
      - Группы слайсов растут в шаблоне растрового сканирования слева направо.
    * - ``V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_WIPE_SCAN``
      - Группы слайсов растут в шаблоне сканирования стиранием сверху вниз.
    * - ``V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_EXPLICIT``
      - Определяемый пользователем тип карты.

.. raw:: latex

    \normalsize



``V4L2_CID_MPEG_VIDEO_H264_FMO_SLICE_GROUP (integer)``
    Число групп слайсов в FMO. Применим к кодеру H264.

.. _v4l2-mpeg-video-h264-fmo-change-direction:

``V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_DIRECTION``
    (enum)

enum v4l2_mpeg_video_h264_fmo_change_dir -
    Указывает направление изменения группы слайсов для растровых карт и карт
    стирания. Применим к кодеру H264. Возможные значения:

.. tabularcolumns:: |p{9.6cm}|p{7.9cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_RIGHT``
      - Растровое сканирование или стирание вправо.
    * - ``V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_LEFT``
      - Обратное растровое сканирование или стирание влево.



``V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_RATE (integer)``
    Указывает размер первой группы слайсов для растровой карты и карты
    стирания. Применим к кодеру H264.

``V4L2_CID_MPEG_VIDEO_H264_FMO_RUN_LENGTH (integer)``
    Указывает число последовательных макроблоков для карты с чередованием.
    Применим к кодеру H264.

``V4L2_CID_MPEG_VIDEO_H264_ASO (boolean)``
    Включает произвольное упорядочение слайсов (arbitrary slice ordering) в
    закодированном битовом потоке. Применим к кодеру H264.

``V4L2_CID_MPEG_VIDEO_H264_ASO_SLICE_ORDER (integer)``
    Указывает порядок слайсов в ASO. Применим к кодеру H264. Переданное
    32-битное целое интерпретируется следующим образом (бит 0 = младший
    значащий бит):



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - Биты 0:15
      - Идентификатор слайса
    * - Биты 16:32
      - Позиция или порядок слайса



``V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING (boolean)``
    Включает иерархическое кодирование H264. Применим к кодеру H264.

.. _v4l2-mpeg-video-h264-hierarchical-coding-type:

``V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE``
    (enum)

enum v4l2_mpeg_video_h264_hierarchical_coding_type -
    Указывает тип иерархического кодирования. Применим к кодеру H264.
    Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_B``
      - Иерархическое B-кодирование.
    * - ``V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_P``
      - Иерархическое P-кодирование.



``V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER (integer)``
    Указывает число слоёв иерархического кодирования. Применим к кодеру H264.

``V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP (integer)``
    Указывает определяемый пользователем QP для каждого слоя. Применим к
    кодеру H264. Переданное 32-битное целое интерпретируется следующим образом
    (бит 0 = младший значащий бит):



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - Биты 0:15
      - Значение QP
    * - Биты 16:32
      - Номер слоя

``V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L0_BR (integer)``
    Указывает битрейт (бит/с) для слоя 0 иерархического кодирования для кодера H264.

``V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L1_BR (integer)``
    Указывает битрейт (бит/с) для слоя 1 иерархического кодирования для кодера H264.

``V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L2_BR (integer)``
    Указывает битрейт (бит/с) для слоя 2 иерархического кодирования для кодера H264.

``V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L3_BR (integer)``
    Указывает битрейт (бит/с) для слоя 3 иерархического кодирования для кодера H264.

``V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L4_BR (integer)``
    Указывает битрейт (бит/с) для слоя 4 иерархического кодирования для кодера H264.

``V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L5_BR (integer)``
    Указывает битрейт (бит/с) для слоя 5 иерархического кодирования для кодера H264.

``V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L6_BR (integer)``
    Указывает битрейт (бит/с) для слоя 6 иерархического кодирования для кодера H264.

``V4L2_CID_FWHT_I_FRAME_QP (integer)``
    Параметр квантования для I-кадра для FWHT. Допустимый диапазон: от 1 до
    31.

``V4L2_CID_FWHT_P_FRAME_QP (integer)``
    Параметр квантования для P-кадра для FWHT. Допустимый диапазон: от 1 до
    31.

``V4L2_CID_MPEG_VIDEO_AVERAGE_QP (integer)``
    Этот доступный только для чтения элемент управления возвращает среднее
    значение QP текущего закодированного кадра. Значение применяется к
    последнему извлечённому из очереди буферу захвата (VIDIOC_DQBUF). Его
    допустимый диапазон зависит от формата и параметров кодирования.
    Для H264 его допустимый диапазон — от 0 до 51.
    Для HEVC его допустимый диапазон — от 0 до 51 для 8 бит и
    от 0 до 63 для 10 бит.
    Для H263 и MPEG4 его допустимый диапазон — от 1 до 31.
    Для VP8 его допустимый диапазон — от 0 до 127.
    Для VP9 его допустимый диапазон — от 0 до 255.
    Если для кодека заданы MIN_QP и MAX_QP, то QP будет удовлетворять обоим требованиям.
    Кодеки должны всегда использовать указанный диапазон, а не аппаратный пользовательский диапазон.
    Применим к кодерам

.. raw:: latex

    \normalsize


Элементы управления MFC 5.1 MPEG
================================

Следующие элементы управления класса MPEG относятся к настройкам
декодирования и кодирования MPEG, специфичным для устройства Multi Format
Codec 5.1, присутствующего в семействе SoC S5P от Samsung.


.. _mfc51-control-id:

Идентификаторы элементов управления MFC 5.1
-------------------------------------------

``V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE (boolean)``
    Если задержка отображения включена, то декодер вынужден возвращать буфер
    CAPTURE (декодированный кадр) после обработки определённого числа буферов
    OUTPUT. Задержку можно задать через
    ``V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY``. Эта возможность
    может использоваться, например, для генерации миниатюр видео. Применим к
    декодеру H264.

    .. note::

       Этот элемент управления устарел. Используйте вместо него стандартный
       элемент управления ``V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY_ENABLE``.

``V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY (integer)``
    Значение задержки отображения для декодера H264. Декодер вынужден
    возвращать декодированный кадр после установленного числа кадров «задержки
    отображения». Если это число мало, то это может привести к возврату кадров
    не в порядке отображения; кроме того, оборудование может всё ещё
    использовать возвращённый буфер в качестве опорного изображения для
    последующих кадров.

    .. note::

       Этот элемент управления устарел. Используйте вместо него стандартный
       элемент управления ``V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY``.

``V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P (integer)``
    Число опорных изображений, используемых для кодирования P-изображения.
    Применим к кодеру H264.

``V4L2_CID_MPEG_MFC51_VIDEO_PADDING (boolean)``
    Включение заполнения (padding) в кодере — использовать цвет вместо
    повторения граничных пикселей. Применим к кодерам.

``V4L2_CID_MPEG_MFC51_VIDEO_PADDING_YUV (integer)``
    Цвет заполнения в кодере. Применим к кодерам. Переданное 32-битное целое
    интерпретируется следующим образом (бит 0 = младший значащий бит):



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - Биты 0:7
      - Информация о цветности V
    * - Биты 8:15
      - Информация о цветности U
    * - Биты 16:23
      - Информация о яркости Y
    * - Биты 24:31
      - Должно быть нулём.



``V4L2_CID_MPEG_MFC51_VIDEO_RC_REACTION_COEFF (integer)``
    Коэффициент реакции для управления скоростью MFC. Применим к кодерам.

    .. note::

       #. Действует только при включённом управлении скоростью на уровне кадра.

       #. Для жёсткого CBR это поле должно быть малым (например, 2 ~ 10). Для
	  VBR это поле должно быть большим (например, 100 ~ 1000).

       #. Не рекомендуется использовать число большее, чем
	  FRAME_RATE * (10^9 / BIT_RATE).

``V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK (boolean)``
    Адаптивное управление скоростью для тёмной области. Действует только при
    включённом H.264 и управлении скоростью на уровне макроблоков
    (``V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE``). Применим к кодеру H264.

``V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_SMOOTH (boolean)``
    Адаптивное управление скоростью для гладкой области. Действует только при
    включённом H.264 и управлении скоростью на уровне макроблоков
    (``V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE``). Применим к кодеру H264.

``V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC (boolean)``
    Адаптивное управление скоростью для статической области. Действует только
    при включённом H.264 и управлении скоростью на уровне макроблоков
    (``V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE``). Применим к кодеру H264.

``V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_ACTIVITY (boolean)``
    Адаптивное управление скоростью для области активности. Действует только
    при включённом H.264 и управлении скоростью на уровне макроблоков
    (``V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE``). Применим к кодеру H264.

.. _v4l2-mpeg-mfc51-video-frame-skip-mode:

``V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE``
    (enum)

    .. note::

       Этот элемент управления устарел. Используйте вместо него стандартный
       элемент управления ``V4L2_CID_MPEG_VIDEO_FRAME_SKIP_MODE``.

enum v4l2_mpeg_mfc51_video_frame_skip_mode -
    Указывает, в каких условиях кодер должен пропускать кадры. Если
    кодирование кадра приведёт к тому, что закодированный поток станет больше
    выбранного ограничения на объём данных, то кадр будет пропущен. Возможные
    значения:


.. tabularcolumns:: |p{9.4cm}|p{8.1cm}|

.. raw:: latex

    \small

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_DISABLED``
      - Режим пропуска кадров отключён.
    * - ``V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_LEVEL_LIMIT``
      - Режим пропуска кадров включён, а ограничение буфера задаётся выбранным
	уровнем и определяется стандартом.
    * - ``V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT``
      - Режим пропуска кадров включён, а ограничение буфера задаётся элементом
	управления размером буфера VBV (MPEG1/2/4) или CPB (H264).

.. raw:: latex

    \normalsize

``V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT (integer)``
    Включить управление скоростью с фиксированным целевым числом бит. Если эта
    настройка включена, то логика управления скоростью кодера будет вычислять
    средний битрейт для GOP и удерживать его ниже или равным заданному
    целевому битрейту. В противном случае логика управления скоростью вычисляет
    общий средний битрейт для потока и удерживает его ниже или равным
    заданному битрейту. В первом случае средний битрейт для всего потока будет
    меньше заданного битрейта. Это вызвано тем, что среднее вычисляется для
    меньшего числа кадров; с другой стороны, включение этой настройки
    гарантирует, что поток будет удовлетворять жёстким ограничениям на полосу
    пропускания. Применим к кодерам.

.. _v4l2-mpeg-mfc51-video-force-frame-type:

``V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE``
    (enum)

enum v4l2_mpeg_mfc51_video_force_frame_type -
    Принудительно установить тип кадра для следующего буфера в очереди.
    Применим к кодерам. Возможные значения:

.. tabularcolumns:: |p{9.9cm}|p{7.6cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_DISABLED``
      - Принудительная установка определённого типа кадра отключена.
    * - ``V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_I_FRAME``
      - Принудительно установить I-кадр.
    * - ``V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_NOT_CODED``
      - Принудительно установить некодированный кадр.


Элементы управления CX2341x MPEG
================================

Следующие элементы управления класса MPEG относятся к настройкам кодирования
MPEG, специфичным для чипов кодирования MPEG Conexant CX23415 и CX23416.


.. _cx2341x-control-id:

Идентификаторы элементов управления CX2341x
-------------------------------------------

.. _v4l2-mpeg-cx2341x-video-spatial-filter-mode:

``V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE``
    (enum)

enum v4l2_mpeg_cx2341x_video_spatial_filter_mode -
    Задаёт режим Spatial Filter (по умолчанию ``MANUAL``). Возможные значения:


.. tabularcolumns:: |p{11.5cm}|p{6.0cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE_MANUAL``
      - Выбирать фильтр вручную
    * - ``V4L2_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE_AUTO``
      - Выбирать фильтр автоматически



``V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER (integer (0-15))``
    Настройка для Spatial Filter. 0 = выключено, 15 = максимум. (По умолчанию
    0.)

.. _luma-spatial-filter-type:

``V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE``
    (enum)

enum v4l2_mpeg_cx2341x_video_luma_spatial_filter_type -
    Выбрать алгоритм, используемый для Luma Spatial Filter (по умолчанию
    ``1D_HOR``). Возможные значения:

.. tabularcolumns:: |p{13.1cm}|p{4.4cm}|

.. raw:: latex

    \footnotesize

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_OFF``
      - Без фильтра
    * - ``V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_1D_HOR``
      - Одномерный горизонтальный
    * - ``V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_1D_VERT``
      - Одномерный вертикальный
    * - ``V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_2D_HV_SEPARABLE``
      - Двумерный разделимый
    * - ``V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_2D_SYM_NON_SEPARABLE``
      - Двумерный симметричный неразделимый

.. raw:: latex

    \normalsize

.. _chroma-spatial-filter-type:

``V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE``
    (enum)

enum v4l2_mpeg_cx2341x_video_chroma_spatial_filter_type -
    Выбрать алгоритм для Chroma Spatial Filter (по умолчанию ``1D_HOR``).
    Возможные значения:

.. raw:: latex

    \footnotesize

.. tabularcolumns:: |p{11.0cm}|p{6.5cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE_OFF``
      - Без фильтра
    * - ``V4L2_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE_1D_HOR``
      - Одномерный горизонтальный

.. raw:: latex

    \normalsize

.. _v4l2-mpeg-cx2341x-video-temporal-filter-mode:

``V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE``
    (enum)

enum v4l2_mpeg_cx2341x_video_temporal_filter_mode -
    Задаёт режим Temporal Filter (по умолчанию ``MANUAL``). Возможные значения:

.. raw:: latex

    \footnotesize

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE_MANUAL``
      - Выбирать фильтр вручную
    * - ``V4L2_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE_AUTO``
      - Выбирать фильтр автоматически

.. raw:: latex

    \normalsize

``V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER (integer (0-31))``
    Настройка для Temporal Filter. 0 = выключено, 31 = максимум. (По умолчанию
    8 для полномасштабного захвата и 0 для масштабированного захвата.)

.. _v4l2-mpeg-cx2341x-video-median-filter-type:

``V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE``
    (enum)

enum v4l2_mpeg_cx2341x_video_median_filter_type -
    Тип Median Filter (по умолчанию ``OFF``). Возможные значения:


.. raw:: latex

    \small

.. tabularcolumns:: |p{11.0cm}|p{6.5cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_OFF``
      - Без фильтра
    * - ``V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_HOR``
      - Горизонтальный фильтр
    * - ``V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_VERT``
      - Вертикальный фильтр
    * - ``V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_HOR_VERT``
      - Горизонтальный и вертикальный фильтр
    * - ``V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_DIAG``
      - Диагональный фильтр

.. raw:: latex

    \normalsize

``V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_BOTTOM (integer (0-255))``
    Порог, выше которого включается медианный фильтр яркости (по умолчанию 0)

``V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_TOP (integer (0-255))``
    Порог, ниже которого включается медианный фильтр яркости (по умолчанию
    255)

``V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_BOTTOM (integer (0-255))``
    Порог, выше которого включается медианный фильтр цветности (по умолчанию
    0)

``V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP (integer (0-255))``
    Порог, ниже которого включается медианный фильтр цветности (по умолчанию
    255)

``V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS (boolean)``
    MPEG-кодер CX2341X может вставлять один пустой пакет MPEG-2 PES в поток
    между каждыми четырьмя видеокадрами. Размер пакета составляет 2048 байт,
    включая поля packet_start_code_prefix и stream_id. Поле stream_id равно
    0xBF (private stream 2). Полезная нагрузка состоит из байтов 0x00, которые
    должны быть заполнены приложением. 0 = не вставлять, 1 = вставлять пакеты.


Справочник по элементам управления VPX
=======================================

Элементы управления VPX включают элементы управления параметрами кодирования
видеокодека VPx.


.. _vpx-control-id:

Идентификаторы элементов управления VPX
---------------------------------------

.. _v4l2-vpx-num-partitions:

``V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS``
    (enum)

enum v4l2_vp8_num_partitions -
    Число token-разделов (token partitions), используемых в кодере VP8.
    Возможные значения:



.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_CID_MPEG_VIDEO_VPX_1_PARTITION``
      - 1 раздел коэффициентов
    * - ``V4L2_CID_MPEG_VIDEO_VPX_2_PARTITIONS``
      - 2 раздела коэффициентов
    * - ``V4L2_CID_MPEG_VIDEO_VPX_4_PARTITIONS``
      - 4 раздела коэффициентов
    * - ``V4L2_CID_MPEG_VIDEO_VPX_8_PARTITIONS``
      - 8 разделов коэффициентов



``V4L2_CID_MPEG_VIDEO_VPX_IMD_DISABLE_4X4 (boolean)``
    Установка этого предотвращает режим intra 4x4 при принятии решения о
    внутреннем режиме.

.. _v4l2-vpx-num-ref-frames:

``V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES``
    (enum)

enum v4l2_vp8_num_ref_frames -
    Число опорных изображений для кодирования P-кадров. Возможные значения:

.. tabularcolumns:: |p{7.5cm}|p{7.5cm}|

.. raw:: latex

    \small

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_CID_MPEG_VIDEO_VPX_1_REF_FRAME``
      - Будет производиться поиск по последнему закодированному кадру
    * - ``V4L2_CID_MPEG_VIDEO_VPX_2_REF_FRAME``
      - Поиск будет производиться по двум кадрам среди последнего
	закодированного кадра, golden-кадра и альтернативного опорного (altref)
	кадра. Реализация кодера сама решит, какие два будут выбраны.
    * - ``V4L2_CID_MPEG_VIDEO_VPX_3_REF_FRAME``
      - Поиск будет производиться по последнему закодированному кадру,
	golden-кадру и altref-кадру.

.. raw:: latex

    \normalsize



``V4L2_CID_MPEG_VIDEO_VPX_FILTER_LEVEL (integer)``
    Указывает уровень петлевого фильтра. Регулировка уровня петлевого фильтра
    производится через значение дельты относительно базового значения
    петлевого фильтра.

``V4L2_CID_MPEG_VIDEO_VPX_FILTER_SHARPNESS (integer)``
    Этот параметр влияет на петлевой фильтр. Любое значение выше нуля ослабляет
    эффект деблокинга петлевого фильтра.

``V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD (integer)``
    Задаёт период обновления для golden-кадра. Период определяется в числе
    кадров. Для значения «n» каждый n-й кадр, начиная с первого ключевого
    кадра, будет браться в качестве golden-кадра. Например, для
    последовательности кодирования 0, 1, 2, 3, 4, 5, 6, 7, где период
    обновления golden-кадра задан равным 4, кадры 0, 4, 8 и т. д. будут браться
    в качестве golden-кадров, поскольку кадр 0 всегда является ключевым кадром.

.. _v4l2-vpx-golden-frame-sel:

``V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL``
    (enum)

enum v4l2_vp8_golden_frame_sel -
    Выбирает golden-кадр для кодирования. Возможные значения:

.. raw:: latex

    \scriptsize

.. tabularcolumns:: |p{8.6cm}|p{8.9cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_PREV``
      - Использовать (n-2)-й кадр в качестве golden-кадра, где индекс текущего
	кадра равен «n».
    * - ``V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_REF_PERIOD``
      - Использовать предыдущий конкретный кадр, указанный через
	``V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD``, в качестве
	golden-кадра.

.. raw:: latex

    \normalsize


``V4L2_CID_MPEG_VIDEO_VPX_MIN_QP (integer)``
    Минимальный параметр квантования для VP8.

``V4L2_CID_MPEG_VIDEO_VPX_MAX_QP (integer)``
    Максимальный параметр квантования для VP8.

``V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP (integer)``
    Параметр квантования для I-кадра для VP8.

``V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP (integer)``
    Параметр квантования для P-кадра для VP8.

.. _v4l2-mpeg-video-vp8-profile:

``V4L2_CID_MPEG_VIDEO_VP8_PROFILE``
    (enum)

enum v4l2_mpeg_video_vp8_profile -
    Этот элемент управления позволяет выбрать профиль для кодера VP8. Он также
    используется для перечисления поддерживаемых профилей кодером или
    декодером VP8. Возможные значения:

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_0``
      - Профиль 0
    * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_1``
      - Профиль 1
    * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_2``
      - Профиль 2
    * - ``V4L2_MPEG_VIDEO_VP8_PROFILE_3``
      - Профиль 3

.. _v4l2-mpeg-video-vp9-profile:

``V4L2_CID_MPEG_VIDEO_VP9_PROFILE``
    (enum)

enum v4l2_mpeg_video_vp9_profile -
    Этот элемент управления позволяет выбрать профиль для кодера VP9. Он также
    используется для перечисления поддерживаемых профилей кодером или
    декодером VP9. Возможные значения:

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_VP9_PROFILE_0``
      - Профиль 0
    * - ``V4L2_MPEG_VIDEO_VP9_PROFILE_1``
      - Профиль 1
    * - ``V4L2_MPEG_VIDEO_VP9_PROFILE_2``
      - Профиль 2
    * - ``V4L2_MPEG_VIDEO_VP9_PROFILE_3``
      - Профиль 3

.. _v4l2-mpeg-video-vp9-level:

``V4L2_CID_MPEG_VIDEO_VP9_LEVEL (enum)``

enum v4l2_mpeg_video_vp9_level -
    Этот элемент управления позволяет выбрать уровень для кодера VP9. Он также
    используется для перечисления поддерживаемых уровней кодером или декодером
    VP9. Дополнительную информацию можно найти на
    `webmproject <https://www.webmproject.org/vp9/levels/>`__. Возможные значения:

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_1_0``
      - Level 1
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_1_1``
      - Level 1.1
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_2_0``
      - Level 2
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_2_1``
      - Level 2.1
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_3_0``
      - Level 3
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_3_1``
      - Level 3.1
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_4_0``
      - Level 4
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_4_1``
      - Level 4.1
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_5_0``
      - Level 5
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_5_1``
      - Level 5.1
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_5_2``
      - Level 5.2
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_6_0``
      - Level 6
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_6_1``
      - Level 6.1
    * - ``V4L2_MPEG_VIDEO_VP9_LEVEL_6_2``
      - Level 6.2


Справочник по элементам управления High Efficiency Video Coding (HEVC/H.265)
============================================================================

Элементы управления HEVC/H.265 включают элементы управления параметрами
кодирования видеокодека HEVC/H.265.


.. _hevc-control-id:

Идентификаторы элементов управления HEVC/H.265
----------------------------------------------

``V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP (integer)``
    Минимальный параметр квантования для HEVC.
    Допустимый диапазон: от 0 до 51 для 8 бит и от 0 до 63 для 10 бит.

``V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP (integer)``
    Максимальный параметр квантования для HEVC.
    Допустимый диапазон: от 0 до 51 для 8 бит и от 0 до 63 для 10 бит.

``V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP (integer)``
    Параметр квантования для I-кадра для HEVC.
    Допустимый диапазон: [V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
    V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP].

``V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP (integer)``
    Параметр квантования для P-кадра для HEVC.
    Допустимый диапазон: [V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
    V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP].

``V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP (integer)``
    Параметр квантования для B-кадра для HEVC.
    Допустимый диапазон: [V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
    V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP].

``V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_MIN_QP (integer)``
    Минимальный параметр квантования для I-кадра HEVC для ограничения качества
    I-кадра определённым диапазоном. Допустимый диапазон: от 0 до 51 для 8 бит и от 0 до 63 для 10 бит.
    Если V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP также установлен, параметр квантования
    должен быть выбран так, чтобы удовлетворять обоим требованиям.

``V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_MAX_QP (integer)``
    Максимальный параметр квантования для I-кадра HEVC для ограничения качества
    I-кадра определённым диапазоном. Допустимый диапазон: от 0 до 51 для 8 бит и от 0 до 63 для 10 бит.
    Если V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP также установлен, параметр квантования
    должен быть выбран так, чтобы удовлетворять обоим требованиям.

``V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_MIN_QP (integer)``
    Минимальный параметр квантования для P-кадра HEVC для ограничения качества
    P-кадра определённым диапазоном. Допустимый диапазон: от 0 до 51 для 8 бит и от 0 до 63 для 10 бит.
    Если V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP также установлен, параметр квантования
    должен быть выбран так, чтобы удовлетворять обоим требованиям.

``V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_MAX_QP (integer)``
    Максимальный параметр квантования для P-кадра HEVC для ограничения качества
    P-кадра определённым диапазоном. Допустимый диапазон: от 0 до 51 для 8 бит и от 0 до 63 для 10 бит.
    Если V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP также установлен, параметр квантования
    должен быть выбран так, чтобы удовлетворять обоим требованиям.

``V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_MIN_QP (integer)``
    Минимальный параметр квантования для B-кадра HEVC для ограничения качества
    B-кадра определённым диапазоном. Допустимый диапазон: от 0 до 51 для 8 бит и от 0 до 63 для 10 бит.
    Если V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP также установлен, параметр квантования
    должен быть выбран так, чтобы удовлетворять обоим требованиям.

``V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_MAX_QP (integer)``
    Максимальный параметр квантования для B-кадра HEVC для ограничения качества
    B-кадра определённым диапазоном. Допустимый диапазон: от 0 до 51 для 8 бит и от 0 до 63 для 10 бит.
    Если V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP также установлен, параметр квантования
    должен быть выбран так, чтобы удовлетворять обоим требованиям.

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_QP (boolean)``
    HIERARCHICAL_QP позволяет хосту задавать значения параметра квантования
    для каждого временного слоя через HIERARCHICAL_QP_LAYER. Это действует
    только если HIERARCHICAL_CODING_LAYER больше 1. Установка значения этого
    элемента управления в 1 включает задание значений QP для слоёв.

.. _v4l2-hevc-hier-coding-type:

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_TYPE``
    (enum)

enum v4l2_mpeg_video_hevc_hier_coding_type -
    Выбирает тип иерархического кодирования для кодирования. Возможные значения:

.. raw:: latex

    \footnotesize

.. tabularcolumns:: |p{8.2cm}|p{9.3cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_B``
      - Использовать B-кадр для иерархического кодирования.
    * - ``V4L2_MPEG_VIDEO_HEVC_HIERARCHICAL_CODING_P``
      - Использовать P-кадр для иерархического кодирования.

.. raw:: latex

    \normalsize


``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER (integer)``
    Выбирает слой иерархического кодирования. При обычном кодировании
    (неиерархическое кодирование) он должен быть равен нулю. Возможные значения
    [0, 6]. 0 указывает HIERARCHICAL CODING LAYER 0, 1 указывает HIERARCHICAL
    CODING LAYER 1 и так далее.

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP (integer)``
    Указывает параметр квантования для слоя 0 иерархического кодирования.
    Допустимый диапазон: [V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
    V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP].

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP (integer)``
    Указывает параметр квантования для слоя 1 иерархического кодирования.
    Допустимый диапазон: [V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
    V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP].

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP (integer)``
    Указывает параметр квантования для слоя 2 иерархического кодирования.
    Допустимый диапазон: [V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
    V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP].

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP (integer)``
    Указывает параметр квантования для слоя 3 иерархического кодирования.
    Допустимый диапазон: [V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
    V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP].

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP (integer)``
    Указывает параметр квантования для слоя 4 иерархического кодирования.
    Допустимый диапазон: [V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
    V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP].

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP (integer)``
    Указывает параметр квантования для слоя 5 иерархического кодирования.
    Допустимый диапазон: [V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
    V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP].

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP (integer)``
    Указывает параметр квантования для слоя 6 иерархического кодирования.
    Допустимый диапазон: [V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP,
    V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP].

.. _v4l2-hevc-profile:

``V4L2_CID_MPEG_VIDEO_HEVC_PROFILE``
    (enum)

enum v4l2_mpeg_video_hevc_profile -
    Выбрать желаемый профиль для кодера HEVC.

.. raw:: latex

    \footnotesize

.. tabularcolumns:: |p{9.0cm}|p{8.5cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN``
      - Профиль Main.
    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_STILL_PICTURE``
      - Профиль Main still picture.
    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_10``
      - Профиль Main 10.

.. raw:: latex

    \normalsize


.. _v4l2-hevc-level:

``V4L2_CID_MPEG_VIDEO_HEVC_LEVEL``
    (enum)

enum v4l2_mpeg_video_hevc_level -
    Выбирает желаемый уровень для кодера HEVC.

==================================	=========
``V4L2_MPEG_VIDEO_HEVC_LEVEL_1``	Level 1.0
``V4L2_MPEG_VIDEO_HEVC_LEVEL_2``	Level 2.0
``V4L2_MPEG_VIDEO_HEVC_LEVEL_2_1``	Level 2.1
``V4L2_MPEG_VIDEO_HEVC_LEVEL_3``	Level 3.0
``V4L2_MPEG_VIDEO_HEVC_LEVEL_3_1``	Level 3.1
``V4L2_MPEG_VIDEO_HEVC_LEVEL_4``	Level 4.0
``V4L2_MPEG_VIDEO_HEVC_LEVEL_4_1``	Level 4.1
``V4L2_MPEG_VIDEO_HEVC_LEVEL_5``	Level 5.0
``V4L2_MPEG_VIDEO_HEVC_LEVEL_5_1``	Level 5.1
``V4L2_MPEG_VIDEO_HEVC_LEVEL_5_2``	Level 5.2
``V4L2_MPEG_VIDEO_HEVC_LEVEL_6``	Level 6.0
``V4L2_MPEG_VIDEO_HEVC_LEVEL_6_1``	Level 6.1
``V4L2_MPEG_VIDEO_HEVC_LEVEL_6_2``	Level 6.2
==================================	=========

``V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION (integer)``
    Указывает число равномерно распределённых подынтервалов, называемых
    тиками (ticks), в пределах одной секунды. Это 16-битное беззнаковое целое,
    имеющее максимальное значение до 0xffff и минимальное значение 1.

.. _v4l2-hevc-tier:

``V4L2_CID_MPEG_VIDEO_HEVC_TIER``
    (enum)

enum v4l2_mpeg_video_hevc_tier -
    TIER_FLAG указывает информацию об уровнях (tier) закодированного
    HEVC-изображения. Уровни были созданы для работы с приложениями, которые
    различаются по максимальному битрейту. Установка флага в 0 выбирает уровень
    HEVC как Main tier, а установка этого флага в 1 указывает High tier. High
    tier предназначен для приложений, требующих высоких битрейтов.

==================================	==========
``V4L2_MPEG_VIDEO_HEVC_TIER_MAIN``	Main tier.
``V4L2_MPEG_VIDEO_HEVC_TIER_HIGH``	High tier.
==================================	==========


``V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH (integer)``
    Выбирает максимальную глубину единицы кодирования HEVC.

.. _v4l2-hevc-loop-filter-mode:

``V4L2_CID_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE``
    (enum)

enum v4l2_mpeg_video_hevc_loop_filter_mode -
    Режим петлевого фильтра для кодера HEVC. Возможные значения:

.. raw:: latex

    \footnotesize

.. tabularcolumns:: |p{12.1cm}|p{5.4cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_DISABLED``
      - Петлевой фильтр отключён.
    * - ``V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_ENABLED``
      - Петлевой фильтр включён.
    * - ``V4L2_MPEG_VIDEO_HEVC_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY``
      - Петлевой фильтр отключён на границе слайса.

.. raw:: latex

    \normalsize


``V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2 (integer)``
    Выбирает смещение beta петлевого фильтра HEVC. Допустимый диапазон [-6, +6].

``V4L2_CID_MPEG_VIDEO_HEVC_LF_TC_OFFSET_DIV2 (integer)``
    Выбирает смещение tc петлевого фильтра HEVC. Допустимый диапазон [-6, +6].

.. _v4l2-hevc-refresh-type:

``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_TYPE``
    (enum)

enum v4l2_mpeg_video_hevc_hier_refresh_type -
    Выбирает тип обновления для кодера HEVC.
    Хост должен указать период в
    V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD.

.. raw:: latex

    \footnotesize

.. tabularcolumns:: |p{6.2cm}|p{11.3cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_NONE``
      - Использовать B-кадр для иерархического кодирования.
    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_CRA``
      - Использовать кодирование изображения CRA (Clean Random Access Unit).
    * - ``V4L2_MPEG_VIDEO_HEVC_REFRESH_IDR``
      - Использовать кодирование изображения IDR (Instantaneous Decoding Refresh).

.. raw:: latex

    \normalsize


``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD (integer)``
    Выбирает период обновления для кодера HEVC.
    Это указывает число I-изображений между двумя CRA/IDR-изображениями.
    Это действует только если REFRESH_TYPE не равен 0.

``V4L2_CID_MPEG_VIDEO_HEVC_LOSSLESS_CU (boolean)``
    Указывает кодирование HEVC без потерь. Установка в 0 отключает кодирование
    без потерь. Установка в 1 включает кодирование без потерь.

``V4L2_CID_MPEG_VIDEO_HEVC_CONST_INTRA_PRED (boolean)``
    Указывает постоянное внутреннее предсказание для кодера HEVC. Задаёт
    ограниченное внутреннее предсказание, при котором внутреннее предсказание
    самой большой единицы кодирования (largest coding unit, LCU) выполняется с
    использованием только остаточных данных и декодированных сэмплов соседних
    внутренних LCU. Установка значения в 1 включает постоянное внутреннее
    предсказание, а установка значения в 0 отключает постоянное внутреннее
    предсказание.

``V4L2_CID_MPEG_VIDEO_HEVC_WAVEFRONT (boolean)``
    Указывает волновую параллельную обработку (wavefront parallel processing)
    для кодера HEVC. Установка в 0 отключает эту возможность, а установка в 1
    включает волновую параллельную обработку.

``V4L2_CID_MPEG_VIDEO_HEVC_GENERAL_PB (boolean)``
    Установка значения в 1 включает комбинацию P- и B-кадров для кодера HEVC.

``V4L2_CID_MPEG_VIDEO_HEVC_TEMPORAL_ID (boolean)``
    Указывает временной идентификатор для кодера HEVC, который включается
    установкой значения в 1.

``V4L2_CID_MPEG_VIDEO_HEVC_STRONG_SMOOTHING (boolean)``
    Указывает, что билинейная интерполяция условно используется в процессе
    фильтрации внутреннего предсказания в CVS, когда установлено в 1.
    Указывает, что билинейная интерполяция не используется в CVS, когда
    установлено в 0.

``V4L2_CID_MPEG_VIDEO_HEVC_MAX_NUM_MERGE_MV_MINUS1 (integer)``
    Указывает максимальное число объединяемых кандидатных векторов движения.
    Значения от 0 до 4.

``V4L2_CID_MPEG_VIDEO_HEVC_TMV_PREDICTION (boolean)``
    Указывает предсказание временных векторов движения для кодера HEVC.
    Установка в 1 включает предсказание. Установка в 0 отключает предсказание.

``V4L2_CID_MPEG_VIDEO_HEVC_WITHOUT_STARTCODE (boolean)``
    Указывает, генерирует ли HEVC поток с размером поля длины вместо шаблона
    стартового кода. Размер поля длины настраивается через элемент управления
    V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD. Установка значения в 0
    отключает кодирование без шаблона стартового кода. Установка значения в 1
    включает кодирование без шаблона стартового кода.

.. _v4l2-hevc-size-of-length-field:

``V4L2_CID_MPEG_VIDEO_HEVC_SIZE_OF_LENGTH_FIELD``
(enum)

enum v4l2_mpeg_video_hevc_size_of_length_field -
    Указывает размер поля длины.
    Это действует, когда включено кодирование WITHOUT_STARTCODE_ENABLE.

.. raw:: latex

    \footnotesize

.. tabularcolumns:: |p{5.5cm}|p{12.0cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0

    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_0``
      - Генерировать шаблон стартового кода (Normal).
    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_1``
      - Генерировать размер поля длины вместо шаблона стартового кода, длина равна 1.
    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_2``
      - Генерировать размер поля длины вместо шаблона стартового кода, длина равна 2.
    * - ``V4L2_MPEG_VIDEO_HEVC_SIZE_4``
      - Генерировать размер поля длины вместо шаблона стартового кода, длина равна 4.

.. raw:: latex

    \normalsize

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR (integer)``
    Указывает битрейт для слоя 0 иерархического кодирования для кодера HEVC.

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_BR (integer)``
    Указывает битрейт для слоя 1 иерархического кодирования для кодера HEVC.

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_BR (integer)``
    Указывает битрейт для слоя 2 иерархического кодирования для кодера HEVC.

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_BR (integer)``
    Указывает битрейт для слоя 3 иерархического кодирования для кодера HEVC.

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_BR (integer)``
    Указывает битрейт для слоя 4 иерархического кодирования для кодера HEVC.

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_BR (integer)``
    Указывает битрейт для слоя 5 иерархического кодирования для кодера HEVC.

``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_BR (integer)``
    Указывает битрейт для слоя 6 иерархического кодирования для кодера HEVC.

``V4L2_CID_MPEG_VIDEO_REF_NUMBER_FOR_PFRAMES (integer)``
    Выбирает число P-опорных изображений, требуемых для кодера HEVC.
    P-кадр может использовать 1 или 2 кадра для ссылки.

``V4L2_CID_MPEG_VIDEO_PREPEND_SPSPPS_TO_IDR (integer)``
    Указывает, следует ли генерировать SPS и PPS при каждом IDR. Установка в 0
    отключает генерацию SPS и PPS при каждом IDR. Установка в единицу включает
    генерацию SPS и PPS при каждом IDR.
