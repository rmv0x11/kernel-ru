.. SPDX-License-Identifier: GPL-2.0

Драйвер виртуального декодера без состояния (visl)
==================================================

Виртуальное устройство декодера без состояния для целей разработки uAPI без
состояния (stateless).

Цель этого инструмента — помочь в разработке и тестировании приложений
пространства пользователя (userspace), использующих stateless-API V4L2 для
декодирования мультимедиа.

Реализация в пространстве пользователя может использовать visl для запуска
цикла декодирования даже тогда, когда оборудование недоступно или когда uAPI
ядра для кодека ещё не было принято в апстрим (upstream). Это позволяет выявить
ошибки на раннем этапе.

Этот драйвер также может трассировать содержимое элементов управления V4L2,
передаваемых ему. Кроме того, он может выводить содержимое буферов vb2 через
интерфейс debugfs. Во многих отношениях это похоже на инфраструктуру
трассировки, доступную для других популярных API кодирования/декодирования, и
может помочь в разработке приложения пространства пользователя, используя другое
(работающее) приложение в качестве эталона.

.. note::

        Фактическое декодирование видеокадров в visl не выполняется. Вместо этого
        для записи различной отладочной информации в буферы захвата используется
        генератор тестовых изображений V4L2.

Параметры модуля
----------------

- visl_debug: Активирует отладочную информацию, печатая различные отладочные
  сообщения через dprintk. Также управляет тем, отображается ли отладочная
  информация по каждому кадру. По умолчанию выключено. Обратите внимание, что
  включение этой возможности может привести к низкой производительности при
  выводе через последовательный порт.

- visl_transtime_ms: Имитируемое время обработки в миллисекундах. Замедление
  скорости декодирования может быть полезно для отладки.

- visl_dprintk_frame_start, visl_dprintk_frame_nframes: Задаёт диапазон кадров,
  на которых активируется dprintk. Это управляет трассировкой dprintk только в
  расчёте на отдельные кадры. Обратите внимание, что печать большого объёма
  данных может быть медленной при выводе через последовательный порт.

- keep_bitstream_buffers: Управляет тем, сохраняются ли буферы битового потока
  (т.е. OUTPUT) после сеанса декодирования. По умолчанию false, чтобы уменьшить
  объём беспорядка. keep_bitstream_buffers == false хорошо работает при
  отладке клиентской программы в реальном времени с помощью GDB.

- bitstream_trace_frame_start, bitstream_trace_nframes: Аналогично
  visl_dprintk_frame_start, visl_dprintk_nframes, но вместо этого управляет
  выводом данных буфера через debugfs.

- tpg_verbose: Записывает дополнительную информацию в каждый выходной кадр для
  облегчения отладки API. Если задано значение true, выходные кадры для заданного
  входа не являются стабильными, так как к ним добавляется некоторая информация,
  например указатели или состояние очереди.

Каков сценарий использования этого драйвера по умолчанию?
---------------------------------------------------------

Этот драйвер можно использовать как способ сравнения различных реализаций в
пространстве пользователя. При этом предполагается, что рабочий клиент
запускается против visl, а данные ftrace и буфера OUTPUT затем используются для
отладки реализации, находящейся в процессе разработки.

Несмотря на то что фактическое декодирование видео не выполняется, выходные
кадры можно сравнивать с эталоном для заданного входа, за исключением случая,
когда tpg_verbose установлен в true.

В зависимости от значения параметра tpg_verbose, информацию об опорных кадрах,
их временных метках, состоянии очередей OUTPUT и CAPTURE и многом другом можно
прочитать непосредственно из буферов CAPTURE.

Поддерживаемые кодеки
---------------------

Поддерживаются следующие кодеки:

- FWHT
- MPEG2
- VP8
- VP9
- H.264
- HEVC
- AV1

События трассировки visl
------------------------
События трассировки определяются для каждого кодека, например:

.. code-block:: bash

        $ ls /sys/kernel/tracing/events/ | grep visl
        visl_av1_controls
        visl_fwht_controls
        visl_h264_controls
        visl_hevc_controls
        visl_mpeg2_controls
        visl_vp8_controls
        visl_vp9_controls

Например, чтобы вывести данные HEVC SPS:

.. code-block:: bash

        $ echo 1 >  /sys/kernel/tracing/events/visl_hevc_controls/v4l2_ctrl_hevc_sps/enable

Данные SPS будут выведены в буфер трассировки, т.е.:

.. code-block:: bash

        $ cat /sys/kernel/tracing/trace
        video_parameter_set_id 0
        seq_parameter_set_id 0
        pic_width_in_luma_samples 1920
        pic_height_in_luma_samples 1080
        bit_depth_luma_minus8 0
        bit_depth_chroma_minus8 0
        log2_max_pic_order_cnt_lsb_minus4 4
        sps_max_dec_pic_buffering_minus1 6
        sps_max_num_reorder_pics 2
        sps_max_latency_increase_plus1 0
        log2_min_luma_coding_block_size_minus3 0
        log2_diff_max_min_luma_coding_block_size 3
        log2_min_luma_transform_block_size_minus2 0
        log2_diff_max_min_luma_transform_block_size 3
        max_transform_hierarchy_depth_inter 2
        max_transform_hierarchy_depth_intra 2
        pcm_sample_bit_depth_luma_minus1 0
        pcm_sample_bit_depth_chroma_minus1 0
        log2_min_pcm_luma_coding_block_size_minus3 0
        log2_diff_max_min_pcm_luma_coding_block_size 0
        num_short_term_ref_pic_sets 0
        num_long_term_ref_pics_sps 0
        chroma_format_idc 1
        sps_max_sub_layers_minus1 0
        flags AMP_ENABLED|SAMPLE_ADAPTIVE_OFFSET|TEMPORAL_MVP_ENABLED|STRONG_INTRA_SMOOTHING_ENABLED


Вывод данных буфера OUTPUT через debugfs
----------------------------------------

Если включён Kconfig **VISL_DEBUGFS**, visl будет наполнять
**/sys/kernel/debug/visl/bitstream** данными буфера OUTPUT в соответствии со
значениями bitstream_trace_frame_start и bitstream_trace_nframes. Это может
выявить ошибки, поскольку неисправные клиенты могут не суметь правильно
заполнить буферы.

Для каждого обработанного буфера OUTPUT создаётся отдельный файл. Его имя
содержит целое число, обозначающее порядковый номер буфера, т.е.:

.. code-block:: c

	snprintf(name, 32, "bitstream%d", run->src->sequence);

Вывод значений сводится просто к чтению из файла, т.е.:

Для буфера с sequence == 0:

.. code-block:: bash

        $ xxd /sys/kernel/debug/visl/bitstream/bitstream0
        00000000: 2601 af04 d088 bc25 a173 0e41 a4f2 3274  &......%.s.A..2t
        00000010: c668 cb28 e775 b4ac f53a ba60 f8fd 3aa1  .h.(.u...:.`..:.
        00000020: 46b4 bcfc 506c e227 2372 e5f5 d7ea 579f  F...Pl.'#r....W.
        00000030: 6371 5eb5 0eb8 23b5 ca6a 5de5 983a 19e4  cq^...#..j]..:..
        00000040: e8c3 4320 b4ba a226 cbc1 4138 3a12 32d6  ..C ...&..A8:.2.
        00000050: fef3 247b 3523 4e90 9682 ac8e eb0c a389  ..${5#N.........
        00000060: ddd0 6cfc 0187 0e20 7aae b15b 1812 3d33  ..l.... z..[..=3
        00000070: e1c5 f425 a83a 00b7 4f18 8127 3c4c aefb  ...%.:..O..'<L..

Для буфера с sequence == 1:

.. code-block:: bash

        $ xxd /sys/kernel/debug/visl/bitstream/bitstream1
        00000000: 0201 d021 49e1 0c40 aa11 1449 14a6 01dc  ...!I..@...I....
        00000010: 7023 889a c8cd 2cd0 13b4 dab0 e8ca 21fe  p#....,.......!.
        00000020: c4c8 ab4c 486e 4e2f b0df 96cc c74e 8dde  ...LHnN/.....N..
        00000030: 8ce7 ee36 d880 4095 4d64 30a0 ff4f 0c5e  ...6..@.Md0..O.^
        00000040: f16b a6a1 d806 ca2a 0ece a673 7bea 1f37  .k.....*...s{..7
        00000050: 370f 5bb9 1dc4 ba21 6434 bc53 0173 cba0  7.[....!d4.S.s..
        00000060: dfe6 bc99 01ea b6e0 346b 92b5 c8de 9f5d  ........4k.....]
        00000070: e7cc 3484 1769 fef2 a693 a945 2c8b 31da  ..4..i.....E,.1.

И так далее.

По умолчанию файлы удаляются во время STREAMOFF. Это сделано для того, чтобы
уменьшить объём беспорядка.
