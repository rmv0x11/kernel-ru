.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: V4L

.. _codec-stateless-controls:

*****************************************************
Справочник по элементам управления Stateless Codec
*****************************************************

Класс элементов управления Stateless Codec предназначен для поддержки
декодеров и кодеров без сохранения состояния (stateless), то есть аппаратных
ускорителей.

Эти драйверы обычно поддерживаются интерфейсом :ref:`stateless_decoder`
и работают с разобранными пиксельными форматами, такими как V4L2_PIX_FMT_H264_SLICE.

Идентификатор элемента управления Stateless Codec
==================================================

.. _codec-stateless-control-id:

``V4L2_CID_CODEC_STATELESS_CLASS (class)``
    Дескриптор класса Stateless Codec.

.. _v4l2-codec-stateless-h264:

``V4L2_CID_STATELESS_H264_SPS (struct)``
    Задаёт набор параметров последовательности (sequence parameter set,
    извлечённый из битового потока) для связанных с ним данных среза H264.
    Сюда входят необходимые параметры для настройки аппаратного конвейера
    декодирования H264 без сохранения состояния. Параметры битового потока
    определяются согласно :ref:`h264`, раздел 7.4.2.1.1 "Sequence Parameter Set Data
    Semantics". Для получения дополнительной информации обращайтесь к указанной
    выше спецификации, если только нет явного комментария, утверждающего иное.

.. c:type:: v4l2_ctrl_h264_sps

.. raw:: latex

    \small

.. tabularcolumns:: |p{1.2cm}|p{8.6cm}|p{7.5cm}|

.. flat-table:: struct v4l2_ctrl_h264_sps
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``profile_idc``
      -
    * - __u8
      - ``constraint_set_flags``
      - См. :ref:`Флаги набора ограничений набора параметров последовательности <h264_sps_constraints_set_flags>`
    * - __u8
      - ``level_idc``
      -
    * - __u8
      - ``seq_parameter_set_id``
      -
    * - __u8
      - ``chroma_format_idc``
      -
    * - __u8
      - ``bit_depth_luma_minus8``
      -
    * - __u8
      - ``bit_depth_chroma_minus8``
      -
    * - __u8
      - ``log2_max_frame_num_minus4``
      -
    * - __u8
      - ``pic_order_cnt_type``
      -
    * - __u8
      - ``log2_max_pic_order_cnt_lsb_minus4``
      -
    * - __u8
      - ``max_num_ref_frames``
      -
    * - __u8
      - ``num_ref_frames_in_pic_order_cnt_cycle``
      -
    * - __s32
      - ``offset_for_ref_frame[255]``
      -
    * - __s32
      - ``offset_for_non_ref_pic``
      -
    * - __s32
      - ``offset_for_top_to_bottom_field``
      -
    * - __u16
      - ``pic_width_in_mbs_minus1``
      -
    * - __u16
      - ``pic_height_in_map_units_minus1``
      -
    * - __u32
      - ``flags``
      - См. :ref:`Флаги набора параметров последовательности <h264_sps_flags>`

.. raw:: latex

    \normalsize

.. _h264_sps_constraints_set_flags:

``Sequence Parameter Set Constraints Set Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_H264_SPS_CONSTRAINT_SET0_FLAG``
      - 0x00000001
      -
    * - ``V4L2_H264_SPS_CONSTRAINT_SET1_FLAG``
      - 0x00000002
      -
    * - ``V4L2_H264_SPS_CONSTRAINT_SET2_FLAG``
      - 0x00000004
      -
    * - ``V4L2_H264_SPS_CONSTRAINT_SET3_FLAG``
      - 0x00000008
      -
    * - ``V4L2_H264_SPS_CONSTRAINT_SET4_FLAG``
      - 0x00000010
      -
    * - ``V4L2_H264_SPS_CONSTRAINT_SET5_FLAG``
      - 0x00000020
      -

.. _h264_sps_flags:

``Sequence Parameter Set Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_H264_SPS_FLAG_SEPARATE_COLOUR_PLANE``
      - 0x00000001
      -
    * - ``V4L2_H264_SPS_FLAG_QPPRIME_Y_ZERO_TRANSFORM_BYPASS``
      - 0x00000002
      -
    * - ``V4L2_H264_SPS_FLAG_DELTA_PIC_ORDER_ALWAYS_ZERO``
      - 0x00000004
      -
    * - ``V4L2_H264_SPS_FLAG_GAPS_IN_FRAME_NUM_VALUE_ALLOWED``
      - 0x00000008
      -
    * - ``V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY``
      - 0x00000010
      -
    * - ``V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD``
      - 0x00000020
      -
    * - ``V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE``
      - 0x00000040
      -

``V4L2_CID_STATELESS_H264_PPS (struct)``
    Задаёт набор параметров изображения (picture parameter set, извлечённый из
    битового потока) для связанных с ним данных среза H264. Сюда входят
    необходимые параметры для настройки аппаратного конвейера декодирования
    H264 без сохранения состояния.  Параметры битового потока определяются
    согласно :ref:`h264`, раздел 7.4.2.2 "Picture Parameter Set RBSP
    Semantics". Для получения дополнительной информации обращайтесь к указанной
    выше спецификации, если только нет явного комментария, утверждающего иное.

.. c:type:: v4l2_ctrl_h264_pps

.. raw:: latex

    \small

.. flat-table:: struct v4l2_ctrl_h264_pps
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``pic_parameter_set_id``
      -
    * - __u8
      - ``seq_parameter_set_id``
      -
    * - __u8
      - ``num_slice_groups_minus1``
      -
    * - __u8
      - ``num_ref_idx_l0_default_active_minus1``
      -
    * - __u8
      - ``num_ref_idx_l1_default_active_minus1``
      -
    * - __u8
      - ``weighted_bipred_idc``
      -
    * - __s8
      - ``pic_init_qp_minus26``
      -
    * - __s8
      - ``pic_init_qs_minus26``
      -
    * - __s8
      - ``chroma_qp_index_offset``
      -
    * - __s8
      - ``second_chroma_qp_index_offset``
      -
    * - __u16
      - ``flags``
      - См. :ref:`Флаги набора параметров изображения <h264_pps_flags>`

.. raw:: latex

    \normalsize

.. _h264_pps_flags:

``Picture Parameter Set Flags``

.. raw:: latex

    \begingroup
    \scriptsize
    \setlength{\tabcolsep}{2pt}

.. tabularcolumns:: |p{9.8cm}|p{1.0cm}|p{6.5cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       10 1 4

    * - ``V4L2_H264_PPS_FLAG_ENTROPY_CODING_MODE``
      - 0x0001
      -
    * - ``V4L2_H264_PPS_FLAG_BOTTOM_FIELD_PIC_ORDER_IN_FRAME_PRESENT``
      - 0x0002
      -
    * - ``V4L2_H264_PPS_FLAG_WEIGHTED_PRED``
      - 0x0004
      -
    * - ``V4L2_H264_PPS_FLAG_DEBLOCKING_FILTER_CONTROL_PRESENT``
      - 0x0008
      -
    * - ``V4L2_H264_PPS_FLAG_CONSTRAINED_INTRA_PRED``
      - 0x0010
      -
    * - ``V4L2_H264_PPS_FLAG_REDUNDANT_PIC_CNT_PRESENT``
      - 0x0020
      -
    * - ``V4L2_H264_PPS_FLAG_TRANSFORM_8X8_MODE``
      - 0x0040
      -
    * - ``V4L2_H264_PPS_FLAG_SCALING_MATRIX_PRESENT``
      - 0x0080
      - Для этого изображения должен использоваться
        ``V4L2_CID_STATELESS_H264_SCALING_MATRIX``.

.. raw:: latex

    \endgroup

``V4L2_CID_STATELESS_H264_SCALING_MATRIX (struct)``
    Задаёт матрицу масштабирования (извлечённую из битового потока) для
    связанных с ней данных среза H264. Параметры битового потока
    определяются согласно :ref:`h264`, раздел 7.4.2.1.1.1 "Scaling
    List Semantics". Для получения дополнительной информации обращайтесь к указанной
    выше спецификации, если только нет явного комментария, утверждающего иное.

.. c:type:: v4l2_ctrl_h264_scaling_matrix

.. raw:: latex

    \small

.. tabularcolumns:: |p{0.6cm}|p{4.8cm}|p{11.9cm}|

.. flat-table:: struct v4l2_ctrl_h264_scaling_matrix
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``scaling_list_4x4[6][16]``
      - Матрица масштабирования после применения процесса обратного сканирования.
        Ожидаемый порядок списков: Intra Y, Intra Cb, Intra Cr, Inter Y,
        Inter Cb, Inter Cr. Значения в каждом списке масштабирования
        ожидаются в порядке растрового сканирования.
    * - __u8
      - ``scaling_list_8x8[6][64]``
      - Матрица масштабирования после применения процесса обратного сканирования.
        Ожидаемый порядок списков: Intra Y, Inter Y, Intra Cb, Inter Cb,
        Intra Cr, Inter Cr. Значения в каждом списке масштабирования
        ожидаются в порядке растрового сканирования.

``V4L2_CID_STATELESS_H264_SLICE_PARAMS (struct)``
    Задаёт параметры среза (извлечённые из битового потока)
    для связанных с ними данных среза H264. Сюда входят необходимые
    параметры для настройки аппаратного конвейера декодирования H264
    без сохранения состояния.  Параметры битового потока определяются согласно
    :ref:`h264`, раздел 7.4.3 "Slice Header Semantics". Для получения
    дополнительной информации обращайтесь к указанной выше спецификации, если
    только нет явного комментария, утверждающего иное.

.. c:type:: v4l2_ctrl_h264_slice_params

.. raw:: latex

    \small

.. tabularcolumns:: |p{4.0cm}|p{5.9cm}|p{7.4cm}|

.. flat-table:: struct v4l2_ctrl_h264_slice_params
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u32
      - ``header_bit_size``
      - Смещение в битах до slice_data() от начала этого среза.
    * - __u32
      - ``first_mb_in_slice``
      -
    * - __u8
      - ``slice_type``
      -
    * - __u8
      - ``colour_plane_id``
      -
    * - __u8
      - ``redundant_pic_cnt``
      -
    * - __u8
      - ``cabac_init_idc``
      -
    * - __s8
      - ``slice_qp_delta``
      -
    * - __s8
      - ``slice_qs_delta``
      -
    * - __u8
      - ``disable_deblocking_filter_idc``
      -
    * - __s8
      - ``slice_alpha_c0_offset_div2``
      -
    * - __s8
      - ``slice_beta_offset_div2``
      -
    * - __u8
      - ``num_ref_idx_l0_active_minus1``
      - Если флаг num_ref_idx_active_override_flag не установлен, это поле должно
        быть установлено в значение num_ref_idx_l0_default_active_minus1
    * - __u8
      - ``num_ref_idx_l1_active_minus1``
      - Если флаг num_ref_idx_active_override_flag не установлен, это поле должно
        быть установлено в значение num_ref_idx_l1_default_active_minus1
    * - __u8
      - ``reserved``
      - Приложения и драйверы должны установить это в ноль.
    * - struct :c:type:`v4l2_h264_reference`
      - ``ref_pic_list0[32]``
      - Список опорных изображений после применения модификаций уровня среза
    * - struct :c:type:`v4l2_h264_reference`
      - ``ref_pic_list1[32]``
      - Список опорных изображений после применения модификаций уровня среза
    * - __u32
      - ``flags``
      - См. :ref:`Флаги параметров среза <h264_slice_flags>`

.. raw:: latex

    \normalsize

.. _h264_slice_flags:

``Slice Parameter Set Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_H264_SLICE_FLAG_DIRECT_SPATIAL_MV_PRED``
      - 0x00000001
      -
    * - ``V4L2_H264_SLICE_FLAG_SP_FOR_SWITCH``
      - 0x00000002
      -

``V4L2_CID_STATELESS_H264_PRED_WEIGHTS (struct)``
    Таблица весов предсказания, определённая согласно :ref:`h264`,
    раздел 7.4.3.2 "Prediction Weight Table Semantics".
    Таблица весов предсказания должна передаваться приложениями
    при условиях, описанных в разделе 7.3.3 "Slice header
    syntax".

.. c:type:: v4l2_ctrl_h264_pred_weights

.. raw:: latex

    \small

.. tabularcolumns:: |p{4.9cm}|p{4.9cm}|p{7.5cm}|

.. flat-table:: struct v4l2_ctrl_h264_pred_weights
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u16
      - ``luma_log2_weight_denom``
      -
    * - __u16
      - ``chroma_log2_weight_denom``
      -
    * - struct :c:type:`v4l2_h264_weight_factors`
      - ``weight_factors[2]``
      - Весовые коэффициенты по индексу 0 — это весовые коэффициенты для опорного
        списка 0, а по индексу 1 — для опорного списка 1.

.. raw:: latex

    \normalsize

.. c:type:: v4l2_h264_weight_factors

.. raw:: latex

    \small

.. tabularcolumns:: |p{1.0cm}|p{4.5cm}|p{11.8cm}|

.. flat-table:: struct v4l2_h264_weight_factors
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __s16
      - ``luma_weight[32]``
      -
    * - __s16
      - ``luma_offset[32]``
      -
    * - __s16
      - ``chroma_weight[32][2]``
      -
    * - __s16
      - ``chroma_offset[32][2]``
      -

.. raw:: latex

    \normalsize

``Picture Reference``

.. c:type:: v4l2_h264_reference

.. cssclass:: longtable

.. flat-table:: struct v4l2_h264_reference
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``fields``
      - Задаёт, как изображение используется в качестве опорного. См. :ref:`Поля опорного изображения <h264_ref_fields>`
    * - __u8
      - ``index``
      - Индекс в массиве :c:type:`v4l2_ctrl_h264_decode_params`.dpb.

.. _h264_ref_fields:

``Reference Fields``

.. raw:: latex

    \small

.. tabularcolumns:: |p{5.4cm}|p{0.8cm}|p{11.1cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_H264_TOP_FIELD_REF``
      - 0x1
      - Верхнее поле в паре полей используется для краткосрочного опорного кадра.
    * - ``V4L2_H264_BOTTOM_FIELD_REF``
      - 0x2
      - Нижнее поле в паре полей используется для краткосрочного опорного кадра.
    * - ``V4L2_H264_FRAME_REF``
      - 0x3
      - Кадр (или верхнее/нижнее поля, если это пара полей)
        используется для краткосрочного опорного кадра.

.. raw:: latex

    \normalsize

``V4L2_CID_STATELESS_H264_DECODE_PARAMS (struct)``
    Задаёт параметры декодирования (извлечённые из битового потока)
    для связанных с ними данных среза H264. Сюда входят необходимые
    параметры для настройки аппаратного конвейера декодирования H264
    без сохранения состояния. Параметры битового потока определяются согласно
    :ref:`h264`. Для получения дополнительной информации обращайтесь к указанной
    выше спецификации, если только нет явного комментария, утверждающего иное.

.. c:type:: v4l2_ctrl_h264_decode_params

.. raw:: latex

    \small

.. tabularcolumns:: |p{4.0cm}|p{5.9cm}|p{7.4cm}|

.. flat-table:: struct v4l2_ctrl_h264_decode_params
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - struct :c:type:`v4l2_h264_dpb_entry`
      - ``dpb[16]``
      -
    * - __u16
      - ``nal_ref_idc``
      - Значение опорного идентификатора NAL, поступающее из заголовка NAL Unit
    * - __u16
      - ``frame_num``
      -
    * - __s32
      - ``top_field_order_cnt``
      - Счётчик порядка изображений (Picture Order Count) для закодированного верхнего поля
    * - __s32
      - ``bottom_field_order_cnt``
      - Счётчик порядка изображений (Picture Order Count) для закодированного нижнего поля
    * - __u16
      - ``idr_pic_id``
      -
    * - __u16
      - ``pic_order_cnt_lsb``
      -
    * - __s32
      - ``delta_pic_order_cnt_bottom``
      -
    * - __s32
      - ``delta_pic_order_cnt0``
      -
    * - __s32
      - ``delta_pic_order_cnt1``
      -
    * - __u32
      - ``dec_ref_pic_marking_bit_size``
      - Размер в битах синтаксического элемента dec_ref_pic_marking().
    * - __u32
      - ``pic_order_cnt_bit_size``
      - Совокупный размер в битах синтаксических элементов, связанных со счётчиком
        порядка изображений: pic_order_cnt_lsb, delta_pic_order_cnt_bottom,
        delta_pic_order_cnt0 и delta_pic_order_cnt1.
    * - __u32
      - ``slice_group_change_cycle``
      -
    * - __u32
      - ``reserved``
      - Приложения и драйверы должны установить это в ноль.
    * - __u32
      - ``flags``
      - См. :ref:`Флаги параметров декодирования <h264_decode_params_flags>`

.. raw:: latex

    \normalsize

.. _h264_decode_params_flags:

``Decode Parameters Flags``

.. raw:: latex

    \small

.. tabularcolumns:: |p{8.3cm}|p{2.1cm}|p{6.9cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_H264_DECODE_PARAM_FLAG_IDR_PIC``
      - 0x00000001
      - Это изображение является изображением IDR
    * - ``V4L2_H264_DECODE_PARAM_FLAG_FIELD_PIC``
      - 0x00000002
      -
    * - ``V4L2_H264_DECODE_PARAM_FLAG_BOTTOM_FIELD``
      - 0x00000004
      -
    * - ``V4L2_H264_DECODE_PARAM_FLAG_PFRAME``
      - 0x00000008
      -
    * - ``V4L2_H264_DECODE_PARAM_FLAG_BFRAME``
      - 0x00000010
      -

.. raw:: latex

    \normalsize

.. c:type:: v4l2_h264_dpb_entry

.. raw:: latex

    \small

.. tabularcolumns:: |p{1.0cm}|p{4.9cm}|p{11.4cm}|

.. flat-table:: struct v4l2_h264_dpb_entry
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u64
      - ``reference_ts``
      - Временная метка буфера захвата V4L2, используемого в качестве опорного,
        применяется с кадрами, закодированными как B и P. Временная метка ссылается
        на поле ``timestamp`` в структуре :c:type:`v4l2_buffer`. Используйте
        функцию :c:func:`v4l2_timeval_to_ns()` для преобразования структуры
        :c:type:`timeval` в структуре :c:type:`v4l2_buffer` в __u64.
    * - __u32
      - ``pic_num``
      - Для краткосрочных опорных кадров это должно совпадать с производным значением PicNum
	(8-28), а для долгосрочных опорных кадров — с производным значением
	LongTermPicNum (8-29). При декодировании кадров (в отличие от полей)
	pic_num совпадает с FrameNumWrap.
    * - __u16
      - ``frame_num``
      - Для краткосрочных опорных кадров это должно совпадать со значением frame_num из
	синтаксиса заголовка среза (драйвер при необходимости выполнит свёртку значения). Для
	долгосрочных опорных кадров это должно быть установлено в значение
	long_term_frame_idx, описанное в синтаксисе dec_ref_pic_marking().
    * - __u8
      - ``fields``
      - Задаёт, как используется элемент DPB в качестве опорного. См. :ref:`Поля опорного изображения <h264_ref_fields>`
    * - __u8
      - ``reserved[5]``
      - Приложения и драйверы должны установить это в ноль.
    * - __s32
      - ``top_field_order_cnt``
      -
    * - __s32
      - ``bottom_field_order_cnt``
      -
    * - __u32
      - ``flags``
      - См. :ref:`Флаги элемента DPB <h264_dpb_flags>`

.. raw:: latex

    \normalsize

.. _h264_dpb_flags:

``DPB Entries Flags``

.. raw:: latex

    \small

.. tabularcolumns:: |p{7.7cm}|p{2.1cm}|p{7.5cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_H264_DPB_ENTRY_FLAG_VALID``
      - 0x00000001
      - Элемент DPB действителен (непустой) и должен учитываться.
    * - ``V4L2_H264_DPB_ENTRY_FLAG_ACTIVE``
      - 0x00000002
      - Элемент DPB используется в качестве опорного.
    * - ``V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM``
      - 0x00000004
      - Элемент DPB используется в качестве долгосрочного опорного.
    * - ``V4L2_H264_DPB_ENTRY_FLAG_FIELD``
      - 0x00000008
      - Элемент DPB представляет собой одиночное поле или дополняющую пару полей.

.. raw:: latex

    \normalsize

``V4L2_CID_STATELESS_H264_DECODE_MODE (enum)``
    Задаёт используемый режим декодирования. В настоящее время предоставляет
    декодирование на основе срезов и на основе кадров, но позже могут быть
    добавлены новые режимы.
    Этот элемент управления используется как модификатор для пиксельного формата
    V4L2_PIX_FMT_H264_SLICE. Приложения, поддерживающие V4L2_PIX_FMT_H264_SLICE,
    обязаны устанавливать этот элемент управления, чтобы задать режим декодирования,
    ожидаемый для буфера.
    Драйверы могут предоставлять один или несколько режимов декодирования
    в зависимости от того, что они способны поддерживать.

.. c:type:: v4l2_stateless_h264_decode_mode

.. raw:: latex

    \scriptsize

.. tabularcolumns:: |p{7.4cm}|p{0.3cm}|p{9.6cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_STATELESS_H264_DECODE_MODE_SLICE_BASED``
      - 0
      - Декодирование выполняется с гранулярностью среза.
        Буфер OUTPUT должен содержать один срез.
        Когда выбран этот режим, элемент управления ``V4L2_CID_STATELESS_H264_SLICE_PARAMS``
        должен быть установлен. Когда кадр состоит из нескольких срезов,
        требуется использование флага ``V4L2_BUF_CAP_SUPPORTS_M2M_HOLD_CAPTURE_BUF``.
    * - ``V4L2_STATELESS_H264_DECODE_MODE_FRAME_BASED``
      - 1
      - Декодирование выполняется с гранулярностью кадра.
        Буфер OUTPUT должен содержать все срезы, необходимые для декодирования
        кадра. Буфер OUTPUT также должен содержать оба поля.
        Этот режим будет поддерживаться устройствами, которые
        разбирают заголовок(и) среза(ов) аппаратно. Когда выбран этот режим,
        элемент управления ``V4L2_CID_STATELESS_H264_SLICE_PARAMS``
        не должен быть установлен.

.. raw:: latex

    \normalsize

``V4L2_CID_STATELESS_H264_START_CODE (enum)``
    Задаёт стартовый код среза H264, ожидаемый для каждого среза.
    Этот элемент управления используется как модификатор для пиксельного формата
    V4L2_PIX_FMT_H264_SLICE. Приложения, поддерживающие V4L2_PIX_FMT_H264_SLICE,
    обязаны устанавливать этот элемент управления, чтобы задать стартовый код,
    ожидаемый для буфера.
    Драйверы могут предоставлять один или несколько стартовых кодов
    в зависимости от того, что они способны поддерживать.

.. c:type:: v4l2_stateless_h264_start_code

.. raw:: latex

    \small

.. tabularcolumns:: |p{7.9cm}|p{0.4cm}|p{9.0cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       4 1 4

    * - ``V4L2_STATELESS_H264_START_CODE_NONE``
      - 0
      - Выбор этого значения задаёт, что срезы H264 передаются
        драйверу без какого-либо стартового кода. Данные битового потока должны
        соответствовать :ref:`h264` 7.3.1 NAL unit syntax, следовательно, содержат
        байты предотвращения эмуляции (emulation prevention bytes), когда это требуется.
    * - ``V4L2_STATELESS_H264_START_CODE_ANNEX_B``
      - 1
      - Выбор этого значения задаёт, что срезы H264 ожидаются
        с префиксом из стартовых кодов Annex B. Согласно :ref:`h264`
        допустимые стартовые коды могут быть 3-байтовыми 0x000001 или 4-байтовыми 0x00000001.

.. raw:: latex

    \normalsize

.. _codec-stateless-fwht:

``V4L2_CID_STATELESS_FWHT_PARAMS (struct)``
    Задаёт параметры FWHT (Fast Walsh Hadamard Transform, быстрого преобразования
    Уолша — Адамара, извлечённые из битового потока) для связанных с ними данных FWHT.
    Сюда входят необходимые параметры для настройки аппаратного конвейера декодирования
    FWHT без сохранения состояния.
    Этот кодек специфичен для тестового драйвера vicodec.

.. c:type:: v4l2_ctrl_fwht_params

.. raw:: latex

    \small

.. tabularcolumns:: |p{1.4cm}|p{3.9cm}|p{12.0cm}|

.. flat-table:: struct v4l2_ctrl_fwht_params
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u64
      - ``backward_ref_ts``
      - Временная метка буфера захвата V4L2, используемого в качестве обратного
        опорного, применяется с кадрами, закодированными как P. Временная метка ссылается на
	поле ``timestamp`` в структуре :c:type:`v4l2_buffer`. Используйте
	функцию :c:func:`v4l2_timeval_to_ns()` для преобразования структуры
	:c:type:`timeval` в структуре :c:type:`v4l2_buffer` в __u64.
    * - __u32
      - ``version``
      - Версия кодека. Установите в ``V4L2_FWHT_VERSION``.
    * - __u32
      - ``width``
      - Ширина кадра.
    * - __u32
      - ``height``
      - Высота кадра.
    * - __u32
      - ``flags``
      - Флаги кадра, см. :ref:`fwht-flags`.
    * - __u32
      - ``colorspace``
      - Цветовое пространство кадра, из enum :c:type:`v4l2_colorspace`.
    * - __u32
      - ``xfer_func``
      - Передаточная функция, из enum :c:type:`v4l2_xfer_func`.
    * - __u32
      - ``ycbcr_enc``
      - Кодирование Y'CbCr, из enum :c:type:`v4l2_ycbcr_encoding`.
    * - __u32
      - ``quantization``
      - Диапазон квантования, из enum :c:type:`v4l2_quantization`.

.. raw:: latex

    \normalsize

.. _fwht-flags:

Флаги FWHT
==========

.. raw:: latex

    \small

.. tabularcolumns:: |p{7.0cm}|p{2.3cm}|p{8.0cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       3 1 4

    * - ``V4L2_FWHT_FL_IS_INTERLACED``
      - 0x00000001
      - Установлен, если это чересстрочный формат.
    * - ``V4L2_FWHT_FL_IS_BOTTOM_FIRST``
      - 0x00000002
      - Установлен, если это чересстрочный формат с нижним полем первым (NTSC).
    * - ``V4L2_FWHT_FL_IS_ALTERNATE``
      - 0x00000004
      - Установлен, если каждый «кадр» содержит только одно поле.
    * - ``V4L2_FWHT_FL_IS_BOTTOM_FIELD``
      - 0x00000008
      - Если был установлен V4L2_FWHT_FL_IS_ALTERNATE, то этот флаг устанавливается, если данный «кадр» — это
	нижнее поле, иначе это верхнее поле.
    * - ``V4L2_FWHT_FL_LUMA_IS_UNCOMPRESSED``
      - 0x00000010
      - Установлен, если плоскость Y' (яркость) не сжата.
    * - ``V4L2_FWHT_FL_CB_IS_UNCOMPRESSED``
      - 0x00000020
      - Установлен, если плоскость Cb не сжата.
    * - ``V4L2_FWHT_FL_CR_IS_UNCOMPRESSED``
      - 0x00000040
      - Установлен, если плоскость Cr не сжата.
    * - ``V4L2_FWHT_FL_CHROMA_FULL_HEIGHT``
      - 0x00000080
      - Установлен, если плоскость цветности имеет ту же высоту, что и плоскость яркости,
	иначе плоскость цветности имеет половину высоты плоскости яркости.
    * - ``V4L2_FWHT_FL_CHROMA_FULL_WIDTH``
      - 0x00000100
      - Установлен, если плоскость цветности имеет ту же ширину, что и плоскость яркости,
	иначе плоскость цветности имеет половину ширины плоскости яркости.
    * - ``V4L2_FWHT_FL_ALPHA_IS_UNCOMPRESSED``
      - 0x00000200
      - Установлен, если альфа-плоскость не сжата.
    * - ``V4L2_FWHT_FL_I_FRAME``
      - 0x00000400
      - Установлен, если это I-кадр.
    * - ``V4L2_FWHT_FL_COMPONENTS_NUM_MSK``
      - 0x00070000
      - Число цветовых компонентов минус один.
    * - ``V4L2_FWHT_FL_PIXENC_MSK``
      - 0x00180000
      - Маска для кодирования пикселей.
    * - ``V4L2_FWHT_FL_PIXENC_YUV``
      - 0x00080000
      - Установлен, если кодирование пикселей — YUV.
    * - ``V4L2_FWHT_FL_PIXENC_RGB``
      - 0x00100000
      - Установлен, если кодирование пикселей — RGB.
    * - ``V4L2_FWHT_FL_PIXENC_HSV``
      - 0x00180000
      - Установлен, если кодирование пикселей — HSV.

.. raw:: latex

    \normalsize

.. _v4l2-codec-stateless-vp8:

``V4L2_CID_STATELESS_VP8_FRAME (struct)``
    Задаёт параметры кадра для связанных с ними разобранных данных кадра VP8.
    Сюда входят необходимые параметры для
    настройки аппаратного конвейера декодирования VP8 без сохранения состояния.
    Параметры битового потока определяются согласно :ref:`vp8`.

.. c:type:: v4l2_ctrl_vp8_frame

.. raw:: latex

    \small

.. tabularcolumns:: |p{7.0cm}|p{4.6cm}|p{5.7cm}|

.. cssclass:: longtable

.. flat-table:: struct v4l2_ctrl_vp8_frame
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - struct :c:type:`v4l2_vp8_segment`
      - ``segment``
      - Структура с метаданными корректировок на основе сегментов.
    * - struct :c:type:`v4l2_vp8_loop_filter`
      - ``lf``
      - Структура с метаданными корректировок уровня контурного фильтра (loop filter).
    * - struct :c:type:`v4l2_vp8_quantization`
      - ``quant``
      - Структура с метаданными индексов деквантования VP8.
    * - struct :c:type:`v4l2_vp8_entropy`
      - ``entropy``
      - Структура с метаданными вероятностей энтропийного кодера VP8.
    * - struct :c:type:`v4l2_vp8_entropy_coder_state`
      - ``coder_state``
      - Структура с состоянием энтропийного кодера VP8.
    * - __u16
      - ``width``
      - Ширина кадра. Должна быть установлена для всех кадров.
    * - __u16
      - ``height``
      - Высота кадра. Должна быть установлена для всех кадров.
    * - __u8
      - ``horizontal_scale``
      - Горизонтальный коэффициент масштабирования.
    * - __u8
      - ``vertical_scale``
      - Вертикальный коэффициент масштабирования.
    * - __u8
      - ``version``
      - Версия битового потока.
    * - __u8
      - ``prob_skip_false``
      - Указывает вероятность того, что макроблок не пропускается.
    * - __u8
      - ``prob_intra``
      - Указывает вероятность того, что макроблок предсказан внутри кадра (intra).
    * - __u8
      - ``prob_last``
      - Указывает вероятность того, что для межкадрового предсказания используется
        последний опорный кадр
    * - __u8
      - ``prob_gf``
      - Указывает вероятность того, что для межкадрового предсказания используется
        золотой (golden) опорный кадр
    * - __u8
      - ``num_dct_parts``
      - Число разделов коэффициентов DCT. Должно быть одним из: 1, 2, 4 или 8.
    * - __u32
      - ``first_part_size``
      - Размер первого раздела, то есть управляющего раздела.
    * - __u32
      - ``first_part_header_bits``
      - Размер в битах части заголовка первого раздела.
    * - __u32
      - ``dct_part_sizes[8]``
      - Размеры коэффициентов DCT.
    * - __u64
      - ``last_frame_ts``
      - Временная метка буфера захвата V4L2, используемого в качестве последнего опорного
        кадра, применяется с межкадрово закодированными кадрами. Временная метка ссылается на поле ``timestamp`` в
	структуре :c:type:`v4l2_buffer`. Используйте функцию :c:func:`v4l2_timeval_to_ns()`
	для преобразования структуры :c:type:`timeval` в структуре
	:c:type:`v4l2_buffer` в __u64.
    * - __u64
      - ``golden_frame_ts``
      - Временная метка буфера захвата V4L2, используемого в качестве последнего опорного
        кадра, применяется с межкадрово закодированными кадрами. Временная метка ссылается на поле ``timestamp`` в
	структуре :c:type:`v4l2_buffer`. Используйте функцию :c:func:`v4l2_timeval_to_ns()`
	для преобразования структуры :c:type:`timeval` в структуре
	:c:type:`v4l2_buffer` в __u64.
    * - __u64
      - ``alt_frame_ts``
      - Временная метка буфера захвата V4L2, используемого в качестве альтернативного опорного
        кадра, применяется с межкадрово закодированными кадрами. Временная метка ссылается на поле ``timestamp`` в
	структуре :c:type:`v4l2_buffer`. Используйте функцию :c:func:`v4l2_timeval_to_ns()`
	для преобразования структуры :c:type:`timeval` в структуре
	:c:type:`v4l2_buffer` в __u64.
    * - __u64
      - ``flags``
      - См. :ref:`Флаги кадра <vp8_frame_flags>`

.. raw:: latex

    \normalsize

.. _vp8_frame_flags:

``Frame Flags``

.. tabularcolumns:: |p{9.8cm}|p{0.8cm}|p{6.7cm}|

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_VP8_FRAME_FLAG_KEY_FRAME``
      - 0x01
      - Указывает, является ли кадр ключевым.
    * - ``V4L2_VP8_FRAME_FLAG_EXPERIMENTAL``
      - 0x02
      - Экспериментальный битовый поток.
    * - ``V4L2_VP8_FRAME_FLAG_SHOW_FRAME``
      - 0x04
      - Флаг показа кадра, указывает, предназначен ли кадр для отображения.
    * - ``V4L2_VP8_FRAME_FLAG_MB_NO_SKIP_COEFF``
      - 0x08
      - Включить/отключить пропуск макроблоков без ненулевых коэффициентов.
    * - ``V4L2_VP8_FRAME_FLAG_SIGN_BIAS_GOLDEN``
      - 0x10
      - Знак векторов движения, когда используется золотой кадр.
    * - ``V4L2_VP8_FRAME_FLAG_SIGN_BIAS_ALT``
      - 0x20
      - Знак векторов движения, когда используется альтернативный (alt) кадр.

.. c:type:: v4l2_vp8_entropy_coder_state

.. cssclass:: longtable

.. tabularcolumns:: |p{1.0cm}|p{2.0cm}|p{14.3cm}|

.. flat-table:: struct v4l2_vp8_entropy_coder_state
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``range``
      - значение состояния кодера для "Range"
    * - __u8
      - ``value``
      - значение состояния кодера для "Value"-
    * - __u8
      - ``bit_count``
      - число оставшихся битов.
    * - __u8
      - ``padding``
      - Приложения и драйверы должны установить это в ноль.

.. c:type:: v4l2_vp8_segment

.. cssclass:: longtable

.. tabularcolumns:: |p{1.2cm}|p{4.0cm}|p{12.1cm}|

.. flat-table:: struct v4l2_vp8_segment
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __s8
      - ``quant_update[4]``
      - Знаковое обновление значения квантователя.
    * - __s8
      - ``lf_update[4]``
      - Знаковое обновление значения уровня контурного фильтра.
    * - __u8
      - ``segment_probs[3]``
      - Вероятности сегментов.
    * - __u8
      - ``padding``
      - Приложения и драйверы должны установить это в ноль.
    * - __u32
      - ``flags``
      - См. :ref:`Флаги сегмента <vp8_segment_flags>`

.. _vp8_segment_flags:

``Segment Flags``

.. raw:: latex

    \small

.. tabularcolumns:: |p{10cm}|p{1.0cm}|p{6.3cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_VP8_SEGMENT_FLAG_ENABLED``
      - 0x01
      - Включить/отключить корректировки на основе сегментов.
    * - ``V4L2_VP8_SEGMENT_FLAG_UPDATE_MAP``
      - 0x02
      - Указывает, обновляется ли в этом кадре карта сегментации макроблоков.
    * - ``V4L2_VP8_SEGMENT_FLAG_UPDATE_FEATURE_DATA``
      - 0x04
      - Указывает, обновляются ли в этом кадре данные признаков сегмента.
    * - ``V4L2_VP8_SEGMENT_FLAG_DELTA_VALUE_MODE``
      - 0x08
      - Если установлен, режим данных признаков сегмента — delta-value.
        Если сброшен, режим — absolute-value.

.. raw:: latex

    \normalsize

.. c:type:: v4l2_vp8_loop_filter

.. cssclass:: longtable

.. tabularcolumns:: |p{1.5cm}|p{3.9cm}|p{11.9cm}|

.. flat-table:: struct v4l2_vp8_loop_filter
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __s8
      - ``ref_frm_delta[4]``
      - Знаковое дельта-значение корректировки на основе опорного кадра.
    * - __s8
      - ``mb_mode_delta[4]``
      - Знаковое дельта-значение корректировки на основе режима предсказания макроблока.
    * - __u8
      - ``sharpness_level``
      - Уровень резкости
    * - __u8
      - ``level``
      - Уровень фильтра
    * - __u16
      - ``padding``
      - Приложения и драйверы должны установить это в ноль.
    * - __u32
      - ``flags``
      - См. :ref:`Флаги контурного фильтра <vp8_loop_filter_flags>`

.. _vp8_loop_filter_flags:

``Loop Filter Flags``

.. tabularcolumns:: |p{7.0cm}|p{1.2cm}|p{9.1cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_VP8_LF_ADJ_ENABLE``
      - 0x01
      - Включить/отключить корректировку контурного фильтра на уровне макроблока.
    * - ``V4L2_VP8_LF_DELTA_UPDATE``
      - 0x02
      - Указывает, обновляются ли дельта-значения, используемые в корректировке.
    * - ``V4L2_VP8_LF_FILTER_TYPE_SIMPLE``
      - 0x04
      - Если установлен, указывает, что тип фильтра — simple (простой).
        Если сброшен, тип фильтра — normal (обычный).

.. c:type:: v4l2_vp8_quantization

.. tabularcolumns:: |p{1.5cm}|p{3.5cm}|p{12.3cm}|

.. flat-table:: struct v4l2_vp8_quantization
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``y_ac_qi``
      - Индекс таблицы AC-коэффициентов яркости.
    * - __s8
      - ``y_dc_delta``
      - Дельта-значение DC яркости.
    * - __s8
      - ``y2_dc_delta``
      - Дельта-значение DC блока Y2.
    * - __s8
      - ``y2_ac_delta``
      - Дельта-значение AC блока Y2.
    * - __s8
      - ``uv_dc_delta``
      - Дельта-значение DC цветности.
    * - __s8
      - ``uv_ac_delta``
      - Дельта-значение AC цветности.
    * - __u16
      - ``padding``
      - Приложения и драйверы должны установить это в ноль.

.. c:type:: v4l2_vp8_entropy

.. cssclass:: longtable

.. tabularcolumns:: |p{1.5cm}|p{5.8cm}|p{10.0cm}|

.. flat-table:: struct v4l2_vp8_entropy
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``coeff_probs[4][8][3][11]``
      - Вероятности обновления коэффициентов.
    * - __u8
      - ``y_mode_probs[4]``
      - Вероятности обновления режима яркости.
    * - __u8
      - ``uv_mode_probs[3]``
      - Вероятности обновления режима цветности.
    * - __u8
      - ``mv_probs[2][19]``
      - Вероятности обновления декодирования MV.
    * - __u8
      - ``padding[3]``
      - Приложения и драйверы должны установить это в ноль.

.. _v4l2-codec-stateless-mpeg2:

``V4L2_CID_STATELESS_MPEG2_SEQUENCE (struct)``
    Задаёт параметры последовательности (извлечённые из битового потока) для
    связанных с ними данных среза MPEG-2. Сюда входят поля, соответствующие синтаксическим
    элементам из частей sequence header и sequence extension битового потока,
    как указано в :ref:`mpeg2part2`.

.. c:type:: v4l2_ctrl_mpeg2_sequence

.. raw:: latex

    \small

.. cssclass:: longtable

.. tabularcolumns:: |p{1.4cm}|p{6.5cm}|p{9.4cm}|

.. flat-table:: struct v4l2_ctrl_mpeg2_sequence
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u16
      - ``horizontal_size``
      - Ширина отображаемой части компонента яркости кадра.
    * - __u16
      - ``vertical_size``
      - Высота отображаемой части компонента яркости кадра.
    * - __u32
      - ``vbv_buffer_size``
      - Используется для вычисления требуемого размера верификатора буферизации видео
	(video buffering verifier), определяемого (в битах) как: 16 * 1024 * vbv_buffer_size.
    * - __u16
      - ``profile_and_level_indication``
      - Текущее указание профиля и уровня, извлечённое из
	битового потока.
    * - __u8
      - ``chroma_format``
      - Формат субдискретизации цветности (1: 4:2:0, 2: 4:2:2, 3: 4:4:4).
    * - __u8
      - ``flags``
      - См. :ref:`Флаги последовательности MPEG-2 <mpeg2_sequence_flags>`.

.. _mpeg2_sequence_flags:

``MPEG-2 Sequence Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_MPEG2_SEQ_FLAG_PROGRESSIVE``
      - 0x01
      - Указание на то, что все кадры последовательности являются прогрессивными, а не
	чересстрочными.

.. raw:: latex

    \normalsize

``V4L2_CID_STATELESS_MPEG2_PICTURE (struct)``
    Задаёт параметры изображения (извлечённые из битового потока) для
    связанных с ними данных среза MPEG-2. Сюда входят поля, соответствующие синтаксическим
    элементам из частей picture header и picture coding extension битового
    потока, как указано в :ref:`mpeg2part2`.

.. c:type:: v4l2_ctrl_mpeg2_picture

.. raw:: latex

    \small

.. cssclass:: longtable

.. tabularcolumns:: |p{1.0cm}|p{5.6cm}|p{10.7cm}|

.. flat-table:: struct v4l2_ctrl_mpeg2_picture
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u64
      - ``backward_ref_ts``
      - Временная метка буфера захвата V4L2, используемого в качестве обратного опорного,
        применяется с кадрами, закодированными как B и P. Временная метка ссылается на
	поле ``timestamp`` в структуре :c:type:`v4l2_buffer`. Используйте
	функцию :c:func:`v4l2_timeval_to_ns()` для преобразования структуры
	:c:type:`timeval` в структуре :c:type:`v4l2_buffer` в __u64.
    * - __u64
      - ``forward_ref_ts``
      - Временная метка буфера захвата V4L2, используемого в качестве прямого опорного,
        применяется с кадрами, закодированными как B. Временная метка ссылается на поле ``timestamp`` в
	структуре :c:type:`v4l2_buffer`. Используйте функцию :c:func:`v4l2_timeval_to_ns()`
	для преобразования структуры :c:type:`timeval` в структуре
	:c:type:`v4l2_buffer` в __u64.
    * - __u32
      - ``flags``
      - См. :ref:`Флаги изображения MPEG-2 <mpeg2_picture_flags>`.
    * - __u8
      - ``f_code[2][2]``
      - Коды векторов движения.
    * - __u8
      - ``picture_coding_type``
      - Тип кодирования изображения для кадра, охватываемого текущим срезом
	(V4L2_MPEG2_PIC_CODING_TYPE_I, V4L2_MPEG2_PIC_CODING_TYPE_P или
	V4L2_MPEG2_PIC_CODING_TYPE_B).
    * - __u8
      - ``picture_structure``
      - Структура изображения (1: чересстрочное верхнее поле, 2: чересстрочное нижнее поле,
	3: прогрессивный кадр).
    * - __u8
      - ``intra_dc_precision``
      - Точность дискретного косинусного преобразования (0: точность 8 бит,
	1: точность 9 бит, 2: точность 10 бит, 3: точность 11 бит).
    * - __u8
      - ``reserved[5]``
      - Приложения и драйверы должны установить это в ноль.

.. _mpeg2_picture_flags:

``MPEG-2 Picture Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_MPEG2_PIC_FLAG_TOP_FIELD_FIRST``
      - 0x00000001
      - Если установлен и это чересстрочный поток, верхнее поле выводится первым.
    * - ``V4L2_MPEG2_PIC_FLAG_FRAME_PRED_DCT``
      - 0x00000002
      - Если установлен, используются только frame-DCT и предсказание кадра.
    * - ``V4L2_MPEG2_PIC_FLAG_CONCEALMENT_MV``
      - 0x00000004
      -  Если установлен, векторы движения кодируются для внутрикадровых макроблоков.
    * - ``V4L2_MPEG2_PIC_FLAG_Q_SCALE_TYPE``
      - 0x00000008
      - Этот флаг влияет на процесс обратного квантования.
    * - ``V4L2_MPEG2_PIC_FLAG_INTRA_VLC``
      - 0x00000010
      - Этот флаг влияет на декодирование данных коэффициентов преобразования.
    * - ``V4L2_MPEG2_PIC_FLAG_ALT_SCAN``
      - 0x00000020
      - Этот флаг влияет на декодирование данных коэффициентов преобразования.
    * - ``V4L2_MPEG2_PIC_FLAG_REPEAT_FIRST``
      - 0x00000040
      - Этот флаг влияет на процесс декодирования прогрессивных кадров.
    * - ``V4L2_MPEG2_PIC_FLAG_PROGRESSIVE``
      - 0x00000080
      - Указывает, является ли текущий кадр прогрессивным.

.. raw:: latex

    \normalsize

``V4L2_CID_STATELESS_MPEG2_QUANTISATION (struct)``
    Задаёт матрицы квантования в порядке зигзагообразного сканирования для
    связанных с ними данных среза MPEG-2. Этот элемент управления инициализируется ядром
    значениями матриц по умолчанию. Если битовый поток передаёт загрузку
    пользовательских матриц квантования, приложения должны использовать этот элемент управления.
    Приложения также должны устанавливать элемент управления, загружая значения
    по умолчанию, если матрицы квантования необходимо сбросить, например на
    заголовке последовательности. Этот процесс описан в разделе 6.3.7
    "Quant matrix extension" спецификации.

.. c:type:: v4l2_ctrl_mpeg2_quantisation

.. tabularcolumns:: |p{0.8cm}|p{8.0cm}|p{8.5cm}|

.. cssclass:: longtable

.. raw:: latex

    \small

.. flat-table:: struct v4l2_ctrl_mpeg2_quantisation
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``intra_quantiser_matrix[64]``
      - Коэффициенты матрицы квантования для внутрикадрово-закодированных кадров, в порядке
	зигзагообразного сканирования. Они актуальны как для компонента яркости, так и для цветности,
	хотя могут быть заменены специфической для цветности матрицей для
	форматов YUV, отличных от 4:2:0.
    * - __u8
      - ``non_intra_quantiser_matrix[64]``
      - Коэффициенты матрицы квантования для не-внутрикадрово-закодированных кадров, в
	порядке зигзагообразного сканирования. Они актуальны как для компонента яркости, так и для цветности,
	хотя могут быть заменены специфической для цветности матрицей
	для форматов YUV, отличных от 4:2:0.
    * - __u8
      - ``chroma_intra_quantiser_matrix[64]``
      - Коэффициенты матрицы квантования для компонента цветности
	внутрикадрово-закодированных кадров, в порядке зигзагообразного сканирования. Актуальны только для
	форматов YUV, отличных от 4:2:0.
    * - __u8
      - ``chroma_non_intra_quantiser_matrix[64]``
      - Коэффициенты матрицы квантования для компонента цветности
	не-внутрикадрово-закодированных кадров, в порядке зигзагообразного сканирования. Актуальны только для
	форматов YUV, отличных от 4:2:0.

.. raw:: latex

    \normalsize

.. _v4l2-codec-stateless-vp9:

``V4L2_CID_STATELESS_VP9_COMPRESSED_HDR (struct)``
    Хранит обновления вероятностей VP9, разобранные из заголовка текущего сжатого
    кадра. Нулевое значение в элементе массива означает отсутствие обновления соответствующей
    вероятности. Обновления, связанные с векторами движения, содержат новое значение или ноль. Все
    остальные обновления содержат значения, преобразованные с помощью inv_map_table[] (см. 6.3.5 в
    :ref:`vp9`).

.. c:type:: v4l2_ctrl_vp9_compressed_hdr

.. tabularcolumns:: |p{1cm}|p{4.8cm}|p{11.4cm}|

.. cssclass:: longtable

.. flat-table:: struct v4l2_ctrl_vp9_compressed_hdr
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``tx_mode``
      - Задаёт режим TX. См. :ref:`Режим TX <vp9_tx_mode>` для дополнительной информации.
    * - __u8
      - ``tx8[2][1]``
      - Дельта вероятностей TX 8x8.
    * - __u8
      - ``tx16[2][2]``
      - Дельта вероятностей TX 16x16.
    * - __u8
      - ``tx32[2][3]``
      - Дельта вероятностей TX 32x32.
    * - __u8
      - ``coef[4][2][2][6][6][3]``
      - Дельта вероятностей коэффициентов.
    * - __u8
      - ``skip[3]``
      - Дельта вероятностей пропуска.
    * - __u8
      - ``inter_mode[7][3]``
      - Дельта вероятностей режима межкадрового предсказания.
    * - __u8
      - ``interp_filter[4][2]``
      - Дельта вероятностей фильтра интерполяции.
    * - __u8
      - ``is_inter[4]``
      - Дельта вероятностей того, что блок является межкадровым.
    * - __u8
      - ``comp_mode[5]``
      - Дельта вероятностей режима составного предсказания.
    * - __u8
      - ``single_ref[5][2]``
      - Дельта вероятностей одиночного опорного кадра.
    * - __u8
      - ``comp_ref[5]``
      - Дельта вероятностей составного опорного кадра.
    * - __u8
      - ``y_mode[4][9]``
      - Дельта вероятностей режима предсказания Y.
    * - __u8
      - ``uv_mode[10][9]``
      - Дельта вероятностей режима предсказания UV.
    * - __u8
      - ``partition[16][3]``
      - Дельта вероятностей разбиения.
    * - __u8
      - ``mv.joint[3]``
      - Дельта вероятностей совместного компонента вектора движения.
    * - __u8
      - ``mv.sign[2]``
      - Дельта вероятностей знака вектора движения.
    * - __u8
      - ``mv.classes[2][10]``
      - Дельта вероятностей класса вектора движения.
    * - __u8
      - ``mv.class0_bit[2]``
      - Дельта вероятностей бита class0 вектора движения.
    * - __u8
      - ``mv.bits[2][10]``
      - Дельта вероятностей битов вектора движения.
    * - __u8
      - ``mv.class0_fr[2][2][3]``
      - Дельта вероятностей дробного бита class0 вектора движения.
    * - __u8
      - ``mv.fr[2][3]``
      - Дельта вероятностей дробного бита вектора движения.
    * - __u8
      - ``mv.class0_hp[2]``
      - Дельта вероятностей дробного бита высокой точности class0 вектора движения.
    * - __u8
      - ``mv.hp[2]``
      - Дельта вероятностей дробного бита высокой точности вектора движения.

.. _vp9_tx_mode:

``TX Mode``

.. tabularcolumns:: |p{6.5cm}|p{0.5cm}|p{10.3cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_VP9_TX_MODE_ONLY_4X4``
      - 0
      - Размер преобразования 4x4.
    * - ``V4L2_VP9_TX_MODE_ALLOW_8X8``
      - 1
      - Размер преобразования может быть до 8x8.
    * - ``V4L2_VP9_TX_MODE_ALLOW_16X16``
      - 2
      - Размер преобразования может быть до 16x16.
    * - ``V4L2_VP9_TX_MODE_ALLOW_32X32``
      - 3
      - размер преобразования может быть до 32x32.
    * - ``V4L2_VP9_TX_MODE_SELECT``
      - 4
      - Битовый поток содержит размер преобразования для каждого блока.

См. раздел '7.3.1 Tx mode semantics' спецификации :ref:`vp9` для дополнительной информации.

``V4L2_CID_STATELESS_VP9_FRAME (struct)``
    Задаёт параметры кадра для связанного с ним запроса декодирования кадра VP9.
    Сюда входят необходимые параметры для настройки аппаратного конвейера
    декодирования VP9 без сохранения состояния. Параметры битового потока определяются согласно
    :ref:`vp9`.

.. c:type:: v4l2_ctrl_vp9_frame

.. raw:: latex

    \small

.. tabularcolumns:: |p{4.7cm}|p{5.5cm}|p{7.1cm}|

.. cssclass:: longtable

.. flat-table:: struct v4l2_ctrl_vp9_frame
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - struct :c:type:`v4l2_vp9_loop_filter`
      - ``lf``
      - Параметры контурного фильтра. См. struct :c:type:`v4l2_vp9_loop_filter` для дополнительной информации.
    * - struct :c:type:`v4l2_vp9_quantization`
      - ``quant``
      - Параметры квантования. См. :c:type:`v4l2_vp9_quantization` для дополнительной информации.
    * - struct :c:type:`v4l2_vp9_segmentation`
      - ``seg``
      - Параметры сегментации. См. :c:type:`v4l2_vp9_segmentation` для дополнительной информации.
    * - __u32
      - ``flags``
      - Комбинация флагов V4L2_VP9_FRAME_FLAG_*. См. :ref:`Флаги кадра<vp9_frame_flags>`.
    * - __u16
      - ``compressed_header_size``
      - Размер сжатого заголовка в байтах.
    * - __u16
      - ``uncompressed_header_size``
      - Размер несжатого заголовка в байтах.
    * - __u16
      - ``frame_width_minus_1``
      - Прибавьте 1, чтобы получить ширину кадра, выраженную в пикселях. См. раздел 7.2.3 в :ref:`vp9`.
    * - __u16
      - ``frame_height_minus_1``
      - Прибавьте 1, чтобы получить высоту кадра, выраженную в пикселях. См. раздел 7.2.3 в :ref:`vp9`.
    * - __u16
      - ``render_width_minus_1``
      - Прибавьте 1, чтобы получить ожидаемую ширину рендеринга, выраженную в пикселях. Она
        не используется в процессе декодирования, но может использоваться аппаратными масштабаторами для
        подготовки кадра, готового к выводу на экран (scanout). См. раздел 7.2.4 в :ref:`vp9`.
    * - __u16
      - render_height_minus_1
      - Прибавьте 1, чтобы получить ожидаемую высоту рендеринга, выраженную в пикселях. Она
        не используется в процессе декодирования, но может использоваться аппаратными масштабаторами для
        подготовки кадра, готового к выводу на экран (scanout). См. раздел 7.2.4 в :ref:`vp9`.
    * - __u64
      - ``last_frame_ts``
      - временная метка «последнего» опорного буфера.
	Временная метка ссылается на поле ``timestamp`` в
        структуре :c:type:`v4l2_buffer`. Используйте функцию :c:func:`v4l2_timeval_to_ns()`
        для преобразования структуры :c:type:`timeval` в структуре
        :c:type:`v4l2_buffer` в __u64.
    * - __u64
      - ``golden_frame_ts``
      - временная метка «золотого» опорного буфера.
	Временная метка ссылается на поле ``timestamp`` в
        структуре :c:type:`v4l2_buffer`. Используйте функцию :c:func:`v4l2_timeval_to_ns()`
        для преобразования структуры :c:type:`timeval` в структуре
        :c:type:`v4l2_buffer` в __u64.
    * - __u64
      - ``alt_frame_ts``
      - временная метка «альтернативного» опорного буфера.
	Временная метка ссылается на поле ``timestamp`` в
        структуре :c:type:`v4l2_buffer`. Используйте функцию :c:func:`v4l2_timeval_to_ns()`
        для преобразования структуры :c:type:`timeval` в структуре
        :c:type:`v4l2_buffer` в __u64.
    * - __u8
      - ``ref_frame_sign_bias``
      - битовое поле, задающее, установлен ли знаковый сдвиг (sign bias) для данного
        опорного кадра. См. :ref:`Знаковый сдвиг опорного кадра<vp9_ref_frame_sign_bias>`
        для дополнительной информации.
    * - __u8
      - ``reset_frame_context``
      - задаёт, должен ли контекст кадра быть сброшен в значения по умолчанию. См.
        :ref:`Сброс контекста кадра<vp9_reset_frame_context>` для дополнительной информации.
    * - __u8
      - ``frame_context_idx``
      - Контекст кадра, который должен использоваться/обновляться.
    * - __u8
      - ``profile``
      - Профиль VP9. Может быть 0, 1, 2 или 3.
    * - __u8
      - ``bit_depth``
      - Глубина компонента в битах. Может быть 8, 10 или 12. Обратите внимание, что не все профили
        поддерживают глубину 10 и/или 12 бит.
    * - __u8
      - ``interpolation_filter``
      - Задаёт выбор фильтра, используемого для выполнения межкадрового предсказания. См.
        :ref:`Фильтр интерполяции<vp9_interpolation_filter>` для дополнительной информации.
    * - __u8
      - ``tile_cols_log2``
      - Задаёт двоичный логарифм ширины каждой плитки (tile) (где
        ширина измеряется в единицах блоков 8x8). Должно быть меньше или равно
        6.
    * - __u8
      - ``tile_rows_log2``
      - Задаёт двоичный логарифм высоты каждой плитки (tile) (где
        высота измеряется в единицах блоков 8x8).
    * - __u8
      - ``reference_mode``
      - Задаёт тип используемого межкадрового предсказания. См.
        :ref:`Режим опорного кадра<vp9_reference_mode>` для дополнительной информации. Обратите внимание, что
	он выводится в рамках процесса разбора сжатого заголовка и
	по этой причине должен был бы быть частью необязательного элемента управления
	:c:type: `v4l2_ctrl_vp9_compressed_hdr`. Это значение можно безопасно
	установить в ноль, если драйверу не требуются сжатые
	заголовки.
    * - __u8
      - ``reserved[7]``
      - Приложения и драйверы должны установить это в ноль.

.. raw:: latex

    \normalsize

.. _vp9_frame_flags:

``Frame Flags``

.. tabularcolumns:: |p{10.0cm}|p{1.2cm}|p{6.1cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_VP9_FRAME_FLAG_KEY_FRAME``
      - 0x001
      - Кадр является ключевым.
    * - ``V4L2_VP9_FRAME_FLAG_SHOW_FRAME``
      - 0x002
      - Кадр должен быть отображён.
    * - ``V4L2_VP9_FRAME_FLAG_ERROR_RESILIENT``
      - 0x004
      - Декодирование должно быть устойчивым к ошибкам.
    * - ``V4L2_VP9_FRAME_FLAG_INTRA_ONLY``
      - 0x008
      - Кадр не ссылается на другие кадры.
    * - ``V4L2_VP9_FRAME_FLAG_ALLOW_HIGH_PREC_MV``
      - 0x010
      - Кадр может использовать векторы движения высокой точности.
    * - ``V4L2_VP9_FRAME_FLAG_REFRESH_FRAME_CTX``
      - 0x020
      - Контекст кадра должен быть обновлён после декодирования.
    * - ``V4L2_VP9_FRAME_FLAG_PARALLEL_DEC_MODE``
      - 0x040
      - Используется параллельное декодирование.
    * - ``V4L2_VP9_FRAME_FLAG_X_SUBSAMPLING``
      - 0x080
      - Вертикальная субдискретизация включена.
    * - ``V4L2_VP9_FRAME_FLAG_Y_SUBSAMPLING``
      - 0x100
      - Горизонтальная субдискретизация включена.
    * - ``V4L2_VP9_FRAME_FLAG_COLOR_RANGE_FULL_SWING``
      - 0x200
      - Используется полный диапазон UV.

.. _vp9_ref_frame_sign_bias:

``Reference Frame Sign Bias``

.. tabularcolumns:: |p{7.0cm}|p{1.2cm}|p{9.1cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_VP9_SIGN_BIAS_LAST``
      - 0x1
      - Знаковый сдвиг установлен для последнего опорного кадра.
    * - ``V4L2_VP9_SIGN_BIAS_GOLDEN``
      - 0x2
      - Знаковый сдвиг установлен для золотого опорного кадра.
    * - ``V4L2_VP9_SIGN_BIAS_ALT``
      - 0x2
      - Знаковый сдвиг установлен для альтернативного опорного кадра.

.. _vp9_reset_frame_context:

``Reset Frame Context``

.. tabularcolumns:: |p{7.0cm}|p{1.2cm}|p{9.1cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_VP9_RESET_FRAME_CTX_NONE``
      - 0
      - Не сбрасывать ни один контекст кадра.
    * - ``V4L2_VP9_RESET_FRAME_CTX_SPEC``
      - 1
      - Сбросить контекст кадра, на который указывает
        :c:type:`v4l2_ctrl_vp9_frame`.frame_context_idx.
    * - ``V4L2_VP9_RESET_FRAME_CTX_ALL``
      - 2
      - Сбросить все контексты кадра.

См. раздел '7.2 Uncompressed header semantics' спецификации :ref:`vp9`
для дополнительной информации.

.. _vp9_interpolation_filter:

``Interpolation Filter``

.. tabularcolumns:: |p{9.0cm}|p{1.2cm}|p{7.1cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_VP9_INTERP_FILTER_EIGHTTAP``
      - 0
      - Восьмиотводный фильтр.
    * - ``V4L2_VP9_INTERP_FILTER_EIGHTTAP_SMOOTH``
      - 1
      - Восьмиотводный сглаживающий фильтр.
    * - ``V4L2_VP9_INTERP_FILTER_EIGHTTAP_SHARP``
      - 2
      - Восьмиотводный резкий фильтр.
    * - ``V4L2_VP9_INTERP_FILTER_BILINEAR``
      - 3
      - Билинейный фильтр.
    * - ``V4L2_VP9_INTERP_FILTER_SWITCHABLE``
      - 4
      - Выбор фильтра сигнализируется на уровне блока.

См. раздел '7.2.7 Interpolation filter semantics' спецификации :ref:`vp9`
для дополнительной информации.

.. _vp9_reference_mode:

``Reference Mode``

.. tabularcolumns:: |p{9.6cm}|p{0.5cm}|p{7.2cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_VP9_REFERENCE_MODE_SINGLE_REFERENCE``
      - 0
      - Указывает, что все межкадровые блоки используют только один опорный кадр
        для формирования предсказания с компенсацией движения.
    * - ``V4L2_VP9_REFERENCE_MODE_COMPOUND_REFERENCE``
      - 1
      - Требует, чтобы все межкадровые блоки использовали составной режим. Предсказание по
        одному опорному кадру не допускается.
    * - ``V4L2_VP9_REFERENCE_MODE_SELECT``
      - 2
      - Позволяет каждому отдельному межкадровому блоку выбирать между режимами
        одиночного и составного предсказания.

См. раздел '7.3.6 Frame reference mode semantics' спецификации :ref:`vp9` для дополнительной информации.

.. c:type:: v4l2_vp9_segmentation

Кодирует параметры квантования. См. раздел '7.2.10 Segmentation
params syntax' спецификации :ref:`vp9` для дополнительной информации.

.. tabularcolumns:: |p{0.8cm}|p{5cm}|p{11.4cm}|

.. cssclass:: longtable

.. flat-table:: struct v4l2_vp9_segmentation
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``feature_data[8][4]``
      - Данные, привязанные к каждому признаку. Запись данных действительна только если признак
        включён. Массив должен индексироваться номером сегмента в качестве первого измерения
        (0..7) и одним из V4L2_VP9_SEG_* в качестве второго измерения.
        См. :ref:`Идентификаторы признаков сегмента<vp9_segment_feature>`.
    * - __u8
      - ``feature_enabled[8]``
      - Битовая маска, определяющая, какие признаки включены в каждом сегменте. Значение для каждого
        сегмента — это комбинация значений V4L2_VP9_SEGMENT_FEATURE_ENABLED(id), где id —
        одно из V4L2_VP9_SEG_*. См. :ref:`Идентификаторы признаков сегмента<vp9_segment_feature>`.
    * - __u8
      - ``tree_probs[7]``
      - Задаёт значения вероятностей, используемые при декодировании Segment-ID.
        См. раздел '5.15 Segmentation map' в :ref:`vp9` для дополнительной информации.
    * - __u8
      - ``pred_probs[3]``
      - Задаёт значения вероятностей, используемые при декодировании
        Predicted-Segment-ID. См. раздел '6.4.14 Get segment id syntax'
        в :ref:`vp9` для дополнительной информации.
    * - __u8
      - ``flags``
      - Комбинация флагов V4L2_VP9_SEGMENTATION_FLAG_*. См.
        :ref:`Флаги сегментации<vp9_segmentation_flags>`.
    * - __u8
      - ``reserved[5]``
      - Приложения и драйверы должны установить это в ноль.

.. _vp9_segment_feature:

``Segment feature IDs``

.. tabularcolumns:: |p{6.0cm}|p{1cm}|p{10.3cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_VP9_SEG_LVL_ALT_Q``
      - 0
      - Признак сегмента — квантователь.
    * - ``V4L2_VP9_SEG_LVL_ALT_L``
      - 1
      - Признак сегмента — контурный фильтр.
    * - ``V4L2_VP9_SEG_LVL_REF_FRAME``
      - 2
      - Признак сегмента — опорный кадр.
    * - ``V4L2_VP9_SEG_LVL_SKIP``
      - 3
      - Признак сегмента — пропуск.
    * - ``V4L2_VP9_SEG_LVL_MAX``
      - 4
      - Число признаков сегмента.

.. _vp9_segmentation_flags:

``Segmentation Flags``

.. tabularcolumns:: |p{10.6cm}|p{0.8cm}|p{5.9cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_VP9_SEGMENTATION_FLAG_ENABLED``
      - 0x01
      - Указывает, что этот кадр использует инструмент сегментации.
    * - ``V4L2_VP9_SEGMENTATION_FLAG_UPDATE_MAP``
      - 0x02
      - Указывает, что карта сегментации должна обновляться при
        декодировании этого кадра.
    * - ``V4L2_VP9_SEGMENTATION_FLAG_TEMPORAL_UPDATE``
      - 0x04
      - Указывает, что обновления карты сегментации кодируются
        относительно существующей карты сегментации.
    * - ``V4L2_VP9_SEGMENTATION_FLAG_UPDATE_DATA``
      - 0x08
      - Указывает, что для каждого сегмента вот-вот будут заданы новые
        параметры.
    * - ``V4L2_VP9_SEGMENTATION_FLAG_ABS_OR_DELTA_UPDATE``
      - 0x10
      - Указывает, что параметры сегментации представляют собой фактические значения,
        которые должны использоваться.

.. c:type:: v4l2_vp9_quantization

Кодирует параметры квантования. См. раздел '7.2.9 Quantization params
syntax' спецификации VP9 для дополнительной информации.

.. tabularcolumns:: |p{0.8cm}|p{4cm}|p{12.4cm}|

.. cssclass:: longtable

.. flat-table:: struct v4l2_vp9_quantization
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``base_q_idx``
      - Указывает базовый qindex кадра.
    * - __s8
      - ``delta_q_y_dc``
      - Указывает квантователь Y DC относительно base_q_idx.
    * - __s8
      - ``delta_q_uv_dc``
      - Указывает квантователь UV DC относительно base_q_idx.
    * - __s8
      - ``delta_q_uv_ac``
      - Указывает квантователь UV AC относительно base_q_idx.
    * - __u8
      - ``reserved[4]``
      - Приложения и драйверы должны установить это в ноль.

.. c:type:: v4l2_vp9_loop_filter

Эта структура содержит все параметры, связанные с контурным фильтром. См. разделы
'7.2.8 Loop filter semantics' спецификации :ref:`vp9` для дополнительной информации.

.. tabularcolumns:: |p{0.8cm}|p{4cm}|p{12.4cm}|

.. cssclass:: longtable

.. flat-table:: struct v4l2_vp9_loop_filter
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __s8
      - ``ref_deltas[4]``
      - Содержит корректировку уровня фильтра, необходимую на основе выбранного
        опорного кадра.
    * - __s8
      - ``mode_deltas[2]``
      - Содержит корректировку уровня фильтра, необходимую на основе выбранного
        режима.
    * - __u8
      - ``level``
      - Указывает силу контурного фильтра.
    * - __u8
      - ``sharpness``
      - Указывает уровень резкости.
    * - __u8
      - ``flags``
      - Комбинация флагов V4L2_VP9_LOOP_FILTER_FLAG_*.
        См. :ref:`Флаги контурного фильтра <vp9_loop_filter_flags>`.
    * - __u8
      - ``reserved[7]``
      - Приложения и драйверы должны установить это в ноль.


.. _vp9_loop_filter_flags:

``Loop Filter Flags``

.. tabularcolumns:: |p{9.6cm}|p{0.5cm}|p{7.2cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_VP9_LOOP_FILTER_FLAG_DELTA_ENABLED``
      - 0x1
      - Когда установлен, уровень фильтра зависит от режима и опорного кадра, используемого
        для предсказания блока.
    * - ``V4L2_VP9_LOOP_FILTER_FLAG_DELTA_UPDATE``
      - 0x2
      - Когда установлен, битовый поток содержит дополнительные синтаксические элементы, которые
        задают, какие дельты режима и опорного кадра должны быть обновлены.

.. _v4l2-codec-stateless-hevc:

``V4L2_CID_STATELESS_HEVC_SPS (struct)``
    Задаёт поля набора параметров последовательности (Sequence Parameter Set,
    извлечённые из битового потока) для связанных с ними данных среза HEVC.
    Эти параметры битового потока определяются согласно :ref:`hevc`.
    Они описаны в разделе 7.4.3.2 "Sequence parameter set RBSP
    semantics" спецификации.

.. c:type:: v4l2_ctrl_hevc_sps

.. raw:: latex

    \small

.. tabularcolumns:: |p{1.2cm}|p{9.2cm}|p{6.9cm}|

.. cssclass:: longtable

.. flat-table:: struct v4l2_ctrl_hevc_sps
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``video_parameter_set_id``
      - Задаёт значение vps_video_parameter_set_id активного VPS,
        как описано в разделе "7.4.3.2.1 General sequence parameter set RBSP semantics"
        спецификаций H.265.
    * - __u8
      - ``seq_parameter_set_id``
      - Предоставляет идентификатор SPS для ссылки на него из других синтаксических элементов,
        как описано в разделе "7.4.3.2.1 General sequence parameter set RBSP semantics"
        спецификаций H.265.
    * - __u16
      - ``pic_width_in_luma_samples``
      - Задаёт ширину каждого декодированного изображения в единицах отсчётов яркости.
    * - __u16
      - ``pic_height_in_luma_samples``
      - Задаёт высоту каждого декодированного изображения в единицах отсчётов яркости.
    * - __u8
      - ``bit_depth_luma_minus8``
      - Это значение плюс 8 задаёт битовую глубину отсчётов массива яркости.
    * - __u8
      - ``bit_depth_chroma_minus8``
      - Это значение плюс 8 задаёт битовую глубину отсчётов массивов цветности.
    * - __u8
      - ``log2_max_pic_order_cnt_lsb_minus4``
      - Задаёт значение переменной MaxPicOrderCntLsb.
    * - __u8
      - ``sps_max_dec_pic_buffering_minus1``
      - Это значение плюс 1 задаёт максимальный требуемый размер буфера декодированных изображений для
        закодированной видеопоследовательности (CVS).
    * - __u8
      - ``sps_max_num_reorder_pics``
      - Указывает максимально допустимое число изображений.
    * - __u8
      - ``sps_max_latency_increase_plus1``
      - Используется для сигнализации MaxLatencyPictures, что указывает максимальное число
        изображений, которые могут предшествовать любому изображению в порядке вывода и следовать за этим
        изображением в порядке декодирования.
    * - __u8
      - ``log2_min_luma_coding_block_size_minus3``
      - Это значение плюс 3 задаёт минимальный размер блока кодирования яркости.
    * - __u8
      - ``log2_diff_max_min_luma_coding_block_size``
      - Задаёт разницу между максимальным и минимальным размером блока кодирования яркости.
    * - __u8
      - ``log2_min_luma_transform_block_size_minus2``
      - Это значение плюс 2 задаёт минимальный размер блока преобразования яркости.
    * - __u8
      - ``log2_diff_max_min_luma_transform_block_size``
      - Задаёт разницу между максимальным и минимальным размером блока преобразования яркости.
    * - __u8
      - ``max_transform_hierarchy_depth_inter``
      - Задаёт максимальную глубину иерархии для единиц преобразования единиц кодирования, закодированных
        в режиме межкадрового предсказания.
    * - __u8
      - ``max_transform_hierarchy_depth_intra``
      - Задаёт максимальную глубину иерархии для единиц преобразования единиц кодирования, закодированных в
        режиме внутрикадрового предсказания.
    * - __u8
      - ``pcm_sample_bit_depth_luma_minus1``
      - Это значение плюс 1 задаёт число бит, используемых для представления каждого из значений отсчётов PCM
        компонента яркости.
    * - __u8
      - ``pcm_sample_bit_depth_chroma_minus1``
      - Задаёт число бит, используемых для представления каждого из значений отсчётов PCM
        компонентов цветности.
    * - __u8
      - ``log2_min_pcm_luma_coding_block_size_minus3``
      - Плюс 3 задаёт минимальный размер блоков кодирования.
    * - __u8
      - ``log2_diff_max_min_pcm_luma_coding_block_size``
      - Задаёт разницу между максимальным и минимальным размером блоков кодирования.
    * - __u8
      - ``num_short_term_ref_pic_sets``
      - Задаёт число синтаксических структур st_ref_pic_set(), включённых в SPS.
    * - __u8
      - ``num_long_term_ref_pics_sps``
      - Задаёт число кандидатов в долгосрочные опорные изображения, которые
        заданы в SPS.
    * - __u8
      - ``chroma_format_idc``
      - Задаёт дискретизацию цветности.
    * - __u8
      - ``sps_max_sub_layers_minus1``
      - Это значение плюс 1 задаёт максимальное число временных подслоёв.
    * - __u64
      - ``flags``
      - См. :ref:`Флаги набора параметров последовательности <hevc_sps_flags>`

.. raw:: latex

    \normalsize

.. _hevc_sps_flags:

``Sequence Parameter Set Flags``

.. raw:: latex

    \small

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_HEVC_SPS_FLAG_SEPARATE_COLOUR_PLANE``
      - 0x00000001
      -
    * - ``V4L2_HEVC_SPS_FLAG_SCALING_LIST_ENABLED``
      - 0x00000002
      -
    * - ``V4L2_HEVC_SPS_FLAG_AMP_ENABLED``
      - 0x00000004
      -
    * - ``V4L2_HEVC_SPS_FLAG_SAMPLE_ADAPTIVE_OFFSET``
      - 0x00000008
      -
    * - ``V4L2_HEVC_SPS_FLAG_PCM_ENABLED``
      - 0x00000010
      -
    * - ``V4L2_HEVC_SPS_FLAG_PCM_LOOP_FILTER_DISABLED``
      - 0x00000020
      -
    * - ``V4L2_HEVC_SPS_FLAG_LONG_TERM_REF_PICS_PRESENT``
      - 0x00000040
      -
    * - ``V4L2_HEVC_SPS_FLAG_SPS_TEMPORAL_MVP_ENABLED``
      - 0x00000080
      -
    * - ``V4L2_HEVC_SPS_FLAG_STRONG_INTRA_SMOOTHING_ENABLED``
      - 0x00000100
      -

.. raw:: latex

    \normalsize

``V4L2_CID_STATELESS_HEVC_PPS (struct)``
    Задаёт поля набора параметров изображения (Picture Parameter Set,
    извлечённые из битового потока) для связанных с ними данных среза HEVC.
    Эти параметры битового потока определяются согласно :ref:`hevc`.
    Они описаны в разделе 7.4.3.3 "Picture parameter set RBSP
    semantics" спецификации.

.. c:type:: v4l2_ctrl_hevc_pps

.. tabularcolumns:: |p{1.2cm}|p{8.6cm}|p{7.5cm}|

.. cssclass:: longtable

.. flat-table:: struct v4l2_ctrl_hevc_pps
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``pic_parameter_set_id``
      - Идентифицирует PPS для ссылки на него из других синтаксических элементов.
    * - __u8
      - ``num_extra_slice_header_bits``
      - Задаёт число дополнительных бит заголовка среза, которые присутствуют
        в slice header RBSP для закодированных изображений, ссылающихся на PPS.
    * - __u8
      - ``num_ref_idx_l0_default_active_minus1``
      - Это значение плюс 1 задаёт подразумеваемое значение num_ref_idx_l0_active_minus1.
    * - __u8
      - ``num_ref_idx_l1_default_active_minus1``
      - Это значение плюс 1 задаёт подразумеваемое значение num_ref_idx_l1_active_minus1.
    * - __s8
      - ``init_qp_minus26``
      - Это значение плюс 26 задаёт начальное значение SliceQp Y для каждого среза,
        ссылающегося на PPS.
    * - __u8
      - ``diff_cu_qp_delta_depth``
      - Задаёт разницу между размером блока дерева кодирования яркости
        и минимальным размером блока кодирования яркости единиц кодирования, которые
        передают cu_qp_delta_abs и cu_qp_delta_sign_flag.
    * - __s8
      - ``pps_cb_qp_offset``
      - Задаёт смещения параметра квантования яркости Cb.
    * - __s8
      - ``pps_cr_qp_offset``
      - Задаёт смещения параметра квантования яркости Cr.
    * - __u8
      - ``num_tile_columns_minus1``
      - Это значение плюс 1 задаёт число столбцов плиток, разбивающих изображение.
    * - __u8
      - ``num_tile_rows_minus1``
      - Это значение плюс 1 задаёт число строк плиток, разбивающих изображение.
    * - __u8
      - ``column_width_minus1[20]``
      - Это значение плюс 1 задаёт ширину i-го столбца плиток в единицах
        блоков дерева кодирования.
    * - __u8
      - ``row_height_minus1[22]``
      - Это значение плюс 1 задаёт высоту i-й строки плиток в единицах блоков дерева
        кодирования.
    * - __s8
      - ``pps_beta_offset_div2``
      - Задаёт смещения параметра деблокирования по умолчанию для beta, делённые на 2.
    * - __s8
      - ``pps_tc_offset_div2``
      - Задаёт смещения параметра деблокирования по умолчанию для tC, делённые на 2.
    * - __u8
      - ``log2_parallel_merge_level_minus2``
      - Это значение плюс 2 задаёт значение переменной Log2ParMrgLevel.
    * - __u8
      - ``padding[4]``
      - Приложения и драйверы должны установить это в ноль.
    * - __u64
      - ``flags``
      - См. :ref:`Флаги набора параметров изображения <hevc_pps_flags>`

.. _hevc_pps_flags:

``Picture Parameter Set Flags``

.. raw:: latex

    \small

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_HEVC_PPS_FLAG_DEPENDENT_SLICE_SEGMENT_ENABLED``
      - 0x00000001
      -
    * - ``V4L2_HEVC_PPS_FLAG_OUTPUT_FLAG_PRESENT``
      - 0x00000002
      -
    * - ``V4L2_HEVC_PPS_FLAG_SIGN_DATA_HIDING_ENABLED``
      - 0x00000004
      -
    * - ``V4L2_HEVC_PPS_FLAG_CABAC_INIT_PRESENT``
      - 0x00000008
      -
    * - ``V4L2_HEVC_PPS_FLAG_CONSTRAINED_INTRA_PRED``
      - 0x00000010
      -
    * - ``V4L2_HEVC_PPS_FLAG_TRANSFORM_SKIP_ENABLED``
      - 0x00000020
      -
    * - ``V4L2_HEVC_PPS_FLAG_CU_QP_DELTA_ENABLED``
      - 0x00000040
      -
    * - ``V4L2_HEVC_PPS_FLAG_PPS_SLICE_CHROMA_QP_OFFSETS_PRESENT``
      - 0x00000080
      -
    * - ``V4L2_HEVC_PPS_FLAG_WEIGHTED_PRED``
      - 0x00000100
      -
    * - ``V4L2_HEVC_PPS_FLAG_WEIGHTED_BIPRED``
      - 0x00000200
      -
    * - ``V4L2_HEVC_PPS_FLAG_TRANSQUANT_BYPASS_ENABLED``
      - 0x00000400
      -
    * - ``V4L2_HEVC_PPS_FLAG_TILES_ENABLED``
      - 0x00000800
      -
    * - ``V4L2_HEVC_PPS_FLAG_ENTROPY_CODING_SYNC_ENABLED``
      - 0x00001000
      -
    * - ``V4L2_HEVC_PPS_FLAG_LOOP_FILTER_ACROSS_TILES_ENABLED``
      - 0x00002000
      -
    * - ``V4L2_HEVC_PPS_FLAG_PPS_LOOP_FILTER_ACROSS_SLICES_ENABLED``
      - 0x00004000
      -
    * - ``V4L2_HEVC_PPS_FLAG_DEBLOCKING_FILTER_OVERRIDE_ENABLED``
      - 0x00008000
      -
    * - ``V4L2_HEVC_PPS_FLAG_PPS_DISABLE_DEBLOCKING_FILTER``
      - 0x00010000
      -
    * - ``V4L2_HEVC_PPS_FLAG_LISTS_MODIFICATION_PRESENT``
      - 0x00020000
      -
    * - ``V4L2_HEVC_PPS_FLAG_SLICE_SEGMENT_HEADER_EXTENSION_PRESENT``
      - 0x00040000
      -
    * - ``V4L2_HEVC_PPS_FLAG_DEBLOCKING_FILTER_CONTROL_PRESENT``
      - 0x00080000
      - Задаёт наличие синтаксических элементов управления фильтром деблокирования в
        PPS
    * - ``V4L2_HEVC_PPS_FLAG_UNIFORM_SPACING``
      - 0x00100000
      - Задаёт, что границы столбцов плиток, а также границы строк плиток,
        распределены равномерно по изображению

.. raw:: latex

    \normalsize

``V4L2_CID_STATELESS_HEVC_SLICE_PARAMS (struct)``
    Задаёт различные специфические для среза параметры, особенно из заголовка
    NAL unit, общего заголовка сегмента среза и частей параметров взвешенного
    предсказания битового потока.
    Эти параметры битового потока определяются согласно :ref:`hevc`.
    Они описаны в разделе 7.4.7 "General slice segment header
    semantics" спецификации.
    Этот элемент управления — динамически изменяемый одномерный массив,
    при его использовании должен быть установлен флаг V4L2_CTRL_FLAG_DYNAMIC_ARRAY.

.. c:type:: v4l2_ctrl_hevc_slice_params

.. raw:: latex

    \scriptsize

.. tabularcolumns:: |p{5.4cm}|p{6.8cm}|p{5.1cm}|

.. cssclass:: longtable

.. flat-table:: struct v4l2_ctrl_hevc_slice_params
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u32
      - ``bit_size``
      - Размер (в битах) данных текущего среза.
    * - __u32
      - ``data_byte_offset``
      - Смещение (в байтах) до видеоданных в данных текущего среза.
    * - __u32
      - ``num_entry_point_offsets``
      - Задаёт число синтаксических элементов смещения точек входа в заголовке среза.
        Когда драйвер это поддерживает, должен быть установлен
        ``V4L2_CID_STATELESS_HEVC_ENTRY_POINT_OFFSETS``.
    * - __u8
      - ``nal_unit_type``
      - Задаёт тип кодирования среза (B, P или I).
    * - __u8
      - ``nuh_temporal_id_plus1``
      - Минус 1 задаёт временной идентификатор для NAL unit.
    * - __u8
      - ``slice_type``
      -
	(V4L2_HEVC_SLICE_TYPE_I, V4L2_HEVC_SLICE_TYPE_P или
	V4L2_HEVC_SLICE_TYPE_B).
    * - __u8
      - ``colour_plane_id``
      - Задаёт цветовую плоскость, связанную с текущим срезом.
    * - __s32
      - ``slice_pic_order_cnt``
      - Задаёт счётчик порядка изображений.
    * - __u8
      - ``num_ref_idx_l0_active_minus1``
      - Это значение плюс 1 задаёт максимальный опорный индекс для списка опорных изображений 0,
        который может использоваться для декодирования среза.
    * - __u8
      - ``num_ref_idx_l1_active_minus1``
      - Это значение плюс 1 задаёт максимальный опорный индекс для списка опорных изображений 1,
        который может использоваться для декодирования среза.
    * - __u8
      - ``collocated_ref_idx``
      - Задаёт опорный индекс совмещённого (collocated) изображения, используемого для
        временного предсказания векторов движения.
    * - __u8
      - ``five_minus_max_num_merge_cand``
      - Задаёт максимальное число кандидатов предсказания векторов движения для слияния (merge),
        поддерживаемых в срезе, вычитаемое из 5.
    * - __s8
      - ``slice_qp_delta``
      - Задаёт начальное значение QpY, которое должно использоваться для блоков кодирования в срезе.
    * - __s8
      - ``slice_cb_qp_offset``
      - Задаёт разницу, которая должна быть добавлена к значению pps_cb_qp_offset.
    * - __s8
      - ``slice_cr_qp_offset``
      - Задаёт разницу, которая должна быть добавлена к значению pps_cr_qp_offset.
    * - __s8
      - ``slice_act_y_qp_offset``
      - Задаёт смещение к яркости параметра квантования qP, выведенного в разделе 8.6.2
    * - __s8
      - ``slice_act_cb_qp_offset``
      - Задаёт смещение к cb параметра квантования qP, выведенного в разделе 8.6.2
    * - __s8
      - ``slice_act_cr_qp_offset``
      - Задаёт смещение к cr параметра квантования qP, выведенного в разделе 8.6.2
    * - __s8
      - ``slice_beta_offset_div2``
      - Задаёт смещения параметра деблокирования для beta, делённые на 2.
    * - __s8
      - ``slice_tc_offset_div2``
      - Задаёт смещения параметра деблокирования для tC, делённые на 2.
    * - __u8
      - ``pic_struct``
      - Указывает, должно ли изображение отображаться как кадр или как одно или несколько полей.
    * - __u32
      - ``slice_segment_addr``
      - Задаёт адрес первого блока дерева кодирования в сегменте среза.
    * - __u8
      - ``ref_idx_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
      - Список опорных элементов L0 в виде индексов в DPB.
    * - __u8
      - ``ref_idx_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
      - Список опорных элементов L1 в виде индексов в DPB.
    * - __u16
      - ``short_term_ref_pic_set_size``
      - Задаёт размер в битах краткосрочного набора опорных изображений, описанного как st_ref_pic_set()
        в спецификации, включённого в заголовок среза или SPS (раздел 7.3.6.1).
    * - __u16
      - ``long_term_ref_pic_set_size``
      - Задаёт размер в битах долгосрочного набора опорных изображений, включённого в заголовок среза
        или SPS. Это число бит в условном блоке if(long_term_ref_pics_present_flag)
        в разделе 7.3.6.1 спецификации.
    * - __u8
      - ``padding``
      - Приложения и драйверы должны установить это в ноль.
    * - struct :c:type:`v4l2_hevc_pred_weight_table`
      - ``pred_weight_table``
      - Коэффициенты весов предсказания для межкадрового предсказания изображений.
    * - __u64
      - ``flags``
      - См. :ref:`Флаги параметров среза <hevc_slice_params_flags>`

.. raw:: latex

    \normalsize

.. _hevc_slice_params_flags:

``Slice Parameters Flags``

.. raw:: latex

    \scriptsize

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_HEVC_SLICE_PARAMS_FLAG_SLICE_SAO_LUMA``
      - 0x00000001
      -
    * - ``V4L2_HEVC_SLICE_PARAMS_FLAG_SLICE_SAO_CHROMA``
      - 0x00000002
      -
    * - ``V4L2_HEVC_SLICE_PARAMS_FLAG_SLICE_TEMPORAL_MVP_ENABLED``
      - 0x00000004
      -
    * - ``V4L2_HEVC_SLICE_PARAMS_FLAG_MVD_L1_ZERO``
      - 0x00000008
      -
    * - ``V4L2_HEVC_SLICE_PARAMS_FLAG_CABAC_INIT``
      - 0x00000010
      -
    * - ``V4L2_HEVC_SLICE_PARAMS_FLAG_COLLOCATED_FROM_L0``
      - 0x00000020
      -
    * - ``V4L2_HEVC_SLICE_PARAMS_FLAG_USE_INTEGER_MV``
      - 0x00000040
      -
    * - ``V4L2_HEVC_SLICE_PARAMS_FLAG_SLICE_DEBLOCKING_FILTER_DISABLED``
      - 0x00000080
      -
    * - ``V4L2_HEVC_SLICE_PARAMS_FLAG_SLICE_LOOP_FILTER_ACROSS_SLICES_ENABLED``
      - 0x00000100
      -
    * - ``V4L2_HEVC_SLICE_PARAMS_FLAG_DEPENDENT_SLICE_SEGMENT``
      - 0x00000200
      -

.. raw:: latex

    \normalsize

``V4L2_CID_STATELESS_HEVC_ENTRY_POINT_OFFSETS (integer)``
    Задаёт смещения точек входа в байтах.
    Этот элемент управления — динамически изменяемый массив. Число смещений точек
    входа сообщается полем ``elems``.
    Этот параметр битового потока определяется согласно :ref:`hevc`.
    Они описаны в разделе 7.4.7.1 "General slice segment header
    semantics" спецификации.
    Когда в запросе передаётся несколько срезов, длина
    этого массива должна быть суммой num_entry_point_offsets всех
    срезов в запросе.

``V4L2_CID_STATELESS_HEVC_SCALING_MATRIX (struct)``
    Задаёт параметры матрицы масштабирования HEVC, используемые для процесса масштабирования
    коэффициентов преобразования.
    Эти матрица и параметры определяются согласно :ref:`hevc`.
    Они описаны в разделе 7.4.5 "Scaling list data semantics"
    спецификации.

.. c:type:: v4l2_ctrl_hevc_scaling_matrix

.. raw:: latex

    \scriptsize

.. tabularcolumns:: |p{5.4cm}|p{6.8cm}|p{5.1cm}|

.. cssclass:: longtable

.. flat-table:: struct v4l2_ctrl_hevc_scaling_matrix
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``scaling_list_4x4[6][16]``
      - Список масштабирования используется для процесса масштабирования
        коэффициентов преобразования. Значения в каждом списке масштабирования ожидаются
        в порядке растрового сканирования.
    * - __u8
      - ``scaling_list_8x8[6][64]``
      - Список масштабирования используется для процесса масштабирования
        коэффициентов преобразования. Значения в каждом списке масштабирования ожидаются
        в порядке растрового сканирования.
    * - __u8
      - ``scaling_list_16x16[6][64]``
      - Список масштабирования используется для процесса масштабирования
        коэффициентов преобразования. Значения в каждом списке масштабирования ожидаются
        в порядке растрового сканирования.
    * - __u8
      - ``scaling_list_32x32[2][64]``
      - Список масштабирования используется для процесса масштабирования
        коэффициентов преобразования. Значения в каждом списке масштабирования ожидаются
        в порядке растрового сканирования.
    * - __u8
      - ``scaling_list_dc_coef_16x16[6]``
      - Список масштабирования используется для процесса масштабирования
        коэффициентов преобразования. Значения в каждом списке масштабирования ожидаются
        в порядке растрового сканирования.
    * - __u8
      - ``scaling_list_dc_coef_32x32[2]``
      - Список масштабирования используется для процесса масштабирования
        коэффициентов преобразования. Значения в каждом списке масштабирования ожидаются
        в порядке растрового сканирования.

.. raw:: latex

    \normalsize

.. c:type:: v4l2_hevc_dpb_entry

.. raw:: latex

    \small

.. tabularcolumns:: |p{1.0cm}|p{4.2cm}|p{12.1cm}|

.. flat-table:: struct v4l2_hevc_dpb_entry
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u64
      - ``timestamp``
      - Временная метка буфера захвата V4L2, используемого в качестве опорного, применяется
        с кадрами, закодированными как B и P. Временная метка ссылается на
	поле ``timestamp`` в структуре :c:type:`v4l2_buffer`. Используйте
	функцию :c:func:`v4l2_timeval_to_ns()` для преобразования структуры
	:c:type:`timeval` в структуре :c:type:`v4l2_buffer` в __u64.
    * - __u8
      - ``flags``
      - Флаг долгосрочного (long term) опорного кадра
        (V4L2_HEVC_DPB_ENTRY_LONG_TERM_REFERENCE). Флаг устанавливается, как
        описано в спецификации ITU HEVC, глава "8.3.2 Decoding
        process for reference picture set".
    * - __u8
      - ``field_pic``
      - Является ли опорный кадр изображением-полем или кадром.
        См. :ref:`Флаги HEVC dpb field pic <hevc_dpb_field_pic_flags>`
    * - __s32
      - ``pic_order_cnt_val``
      - Счётчик порядка изображений текущего изображения.
    * - __u8
      - ``padding[2]``
      - Приложения и драйверы должны установить это в ноль.

.. raw:: latex

    \normalsize

.. _hevc_dpb_field_pic_flags:

``HEVC dpb field pic Flags``

.. raw:: latex

    \scriptsize

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_HEVC_SEI_PIC_STRUCT_FRAME``
      - 0
      - (прогрессивный) кадр
    * - ``V4L2_HEVC_SEI_PIC_STRUCT_TOP_FIELD``
      - 1
      - Верхнее поле
    * - ``V4L2_HEVC_SEI_PIC_STRUCT_BOTTOM_FIELD``
      - 2
      - Нижнее поле
    * - ``V4L2_HEVC_SEI_PIC_STRUCT_TOP_BOTTOM``
      - 3
      - Верхнее поле, нижнее поле, в этом порядке
    * - ``V4L2_HEVC_SEI_PIC_STRUCT_BOTTOM_TOP``
      - 4
      - Нижнее поле, верхнее поле, в этом порядке
    * - ``V4L2_HEVC_SEI_PIC_STRUCT_TOP_BOTTOM_TOP``
      - 5
      - Верхнее поле, нижнее поле, повторённое верхнее поле, в этом порядке
    * - ``V4L2_HEVC_SEI_PIC_STRUCT_BOTTOM_TOP_BOTTOM``
      - 6
      - Нижнее поле, верхнее поле, повторённое нижнее поле, в этом порядке
    * - ``V4L2_HEVC_SEI_PIC_STRUCT_FRAME_DOUBLING``
      - 7
      - Удвоение кадра
    * - ``V4L2_HEVC_SEI_PIC_STRUCT_FRAME_TRIPLING``
      - 8
      - Утроение кадра
    * - ``V4L2_HEVC_SEI_PIC_STRUCT_TOP_PAIRED_PREVIOUS_BOTTOM``
      - 9
      - Верхнее поле в паре с предыдущим нижним полем в порядке вывода
    * - ``V4L2_HEVC_SEI_PIC_STRUCT_BOTTOM_PAIRED_PREVIOUS_TOP``
      - 10
      - Нижнее поле в паре с предыдущим верхним полем в порядке вывода
    * - ``V4L2_HEVC_SEI_PIC_STRUCT_TOP_PAIRED_NEXT_BOTTOM``
      - 11
      - Верхнее поле в паре со следующим нижним полем в порядке вывода
    * - ``V4L2_HEVC_SEI_PIC_STRUCT_BOTTOM_PAIRED_NEXT_TOP``
      - 12
      - Нижнее поле в паре со следующим верхним полем в порядке вывода

.. c:type:: v4l2_hevc_pred_weight_table

.. raw:: latex

    \footnotesize

.. tabularcolumns:: |p{0.8cm}|p{10.6cm}|p{5.9cm}|

.. flat-table:: struct v4l2_hevc_pred_weight_table
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __s8
      - ``delta_luma_weight_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
      - Разница весового коэффициента, применяемого к значению предсказания
        яркости для списка 0.
    * - __s8
      - ``luma_offset_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
      - Аддитивное смещение, применяемое к значению предсказания яркости для списка 0.
    * - __s8
      - ``delta_chroma_weight_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2]``
      - Разница весового коэффициента, применяемого к значению предсказания
        цветности для списка 0.
    * - __s8
      - ``chroma_offset_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2]``
      - Разница аддитивного смещения, применяемого к значениям предсказания
        цветности для списка 0.
    * - __s8
      - ``delta_luma_weight_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
      - Разница весового коэффициента, применяемого к значению предсказания
        яркости для списка 1.
    * - __s8
      - ``luma_offset_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
      - Аддитивное смещение, применяемое к значению предсказания яркости для списка 1.
    * - __s8
      - ``delta_chroma_weight_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2]``
      - Разница весового коэффициента, применяемого к значению предсказания
        цветности для списка 1.
    * - __s8
      - ``chroma_offset_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2]``
      - Разница аддитивного смещения, применяемого к значениям предсказания
        цветности для списка 1.
    * - __u8
      - ``luma_log2_weight_denom``
      - Двоичный логарифм знаменателя для всех весовых коэффициентов
        яркости.
    * - __s8
      - ``delta_chroma_log2_weight_denom``
      - Разница двоичного логарифма знаменателя для
        всех весовых коэффициентов цветности.
    * - __u8
      - ``padding[6]``
      - Приложения и драйверы должны установить это в ноль.

.. raw:: latex

    \normalsize

``V4L2_CID_STATELESS_HEVC_DECODE_MODE (enum)``
    Задаёт используемый режим декодирования. В настоящее время предоставляет
    декодирование на основе срезов и на основе кадров, но позже могут быть
    добавлены новые режимы.
    Этот элемент управления используется как модификатор для пиксельного формата
    V4L2_PIX_FMT_HEVC_SLICE. Приложения, поддерживающие V4L2_PIX_FMT_HEVC_SLICE,
    обязаны устанавливать этот элемент управления, чтобы задать режим декодирования,
    ожидаемый для буфера.
    Драйверы могут предоставлять один или несколько режимов декодирования
    в зависимости от того, что они способны поддерживать.

.. c:type:: v4l2_stateless_hevc_decode_mode

.. raw:: latex

    \small

.. tabularcolumns:: |p{9.4cm}|p{0.6cm}|p{7.3cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_STATELESS_HEVC_DECODE_MODE_SLICE_BASED``
      - 0
      - Декодирование выполняется с гранулярностью среза.
        Буфер OUTPUT должен содержать один срез.
    * - ``V4L2_STATELESS_HEVC_DECODE_MODE_FRAME_BASED``
      - 1
      - Декодирование выполняется с гранулярностью кадра.
        Буфер OUTPUT должен содержать все срезы, необходимые для декодирования
        кадра.

.. raw:: latex

    \normalsize

``V4L2_CID_STATELESS_HEVC_START_CODE (enum)``
    Задаёт стартовый код среза HEVC, ожидаемый для каждого среза.
    Этот элемент управления используется как модификатор для пиксельного формата
    V4L2_PIX_FMT_HEVC_SLICE. Приложения, поддерживающие V4L2_PIX_FMT_HEVC_SLICE,
    обязаны устанавливать этот элемент управления, чтобы задать стартовый код,
    ожидаемый для буфера.
    Драйверы могут предоставлять один или несколько стартовых кодов
    в зависимости от того, что они способны поддерживать.

.. c:type:: v4l2_stateless_hevc_start_code

.. tabularcolumns:: |p{9.2cm}|p{0.6cm}|p{7.5cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_STATELESS_HEVC_START_CODE_NONE``
      - 0
      - Выбор этого значения задаёт, что срезы HEVC передаются
        драйверу без какого-либо стартового кода. Данные битового потока должны
        соответствовать :ref:`hevc` 7.3.1.1 General NAL unit syntax, следовательно,
        содержат байты предотвращения эмуляции (emulation prevention bytes), когда это требуется.
    * - ``V4L2_STATELESS_HEVC_START_CODE_ANNEX_B``
      - 1
      - Выбор этого значения задаёт, что срезы HEVC ожидаются
        с префиксом из стартовых кодов Annex B. Согласно :ref:`hevc`
        допустимые стартовые коды могут быть 3-байтовыми 0x000001 или 4-байтовыми 0x00000001.

.. raw:: latex

    \normalsize

``V4L2_CID_MPEG_VIDEO_BASELAYER_PRIORITY_ID (integer)``
    Задаёт идентификатор приоритета для NAL unit, который будет применён к
    базовому слою. По умолчанию это значение установлено в 0 для базового слоя,
    а следующему слою будет присвоен идентификатор приоритета 1, 2, 3 и так далее.
    Видеокодер не может решить, какой идентификатор приоритета применить к слою,
    поэтому он должен поступать от клиента.
    Это применимо к H264, а допустимый диапазон — от 0 до 63.
    Источник Rec. ITU-T H.264 (06/2019); G.7.4.1.1, G.8.8.1.

``V4L2_CID_MPEG_VIDEO_LTR_COUNT (integer)``
    Задаёт максимальное число долгосрочных опорных (Long Term Reference, LTR) кадров
    в любой момент времени, которое кодер может хранить.
    Это применимо к кодерам H264 и HEVC.

``V4L2_CID_MPEG_VIDEO_FRAME_LTR_INDEX (integer)``
    После установки этого элемента управления кадр, который будет поставлен в очередь следующим,
    будет помечен как долгосрочный опорный (Long Term Reference, LTR) кадр
    и получит этот LTR-индекс, который находится в диапазоне от 0 до LTR_COUNT-1.
    Это применимо к кодерам H264 и HEVC.
    Источник Rec. ITU-T H.264 (06/2019); Table 7.9

``V4L2_CID_MPEG_VIDEO_USE_LTR_FRAMES (bitmask)``
    Задаёт долгосрочный(е) опорный(е) (Long Term Reference, LTR) кадр(ы), который(е) должен(ы) использоваться для
    кодирования следующего кадра, поставленного в очередь после установки этого элемента управления.
    Это предоставляет битовую маску, которая состоит из битов [0, LTR_COUNT-1].
    Это применимо к кодерам H264 и HEVC.

``V4L2_CID_STATELESS_HEVC_DECODE_PARAMS (struct)``
    Задаёт различные параметры декодирования, особенно счётчик порядка изображений
    (POC) опорных кадров для всех списков (short, long, before, current, after) и
    число элементов для каждого из них.
    Эти параметры определяются согласно :ref:`hevc`.
    Они описаны в разделе 8.3 "Slice decoding process"
    спецификации.

.. c:type:: v4l2_ctrl_hevc_decode_params

.. cssclass:: longtable

.. flat-table:: struct v4l2_ctrl_hevc_decode_params
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __s32
      - ``pic_order_cnt_val``
      - PicOrderCntVal, как описано в разделе 8.3.1 "Decoding process
        for picture order count" спецификации.
    * - __u16
      - ``short_term_ref_pic_set_size``
      - Задаёт размер в битах краткосрочного набора опорных изображений первого среза,
        описанного как st_ref_pic_set() в спецификации, включённого в заголовок среза
        или SPS (раздел 7.3.6.1).
    * - __u16
      - ``long_term_ref_pic_set_size``
      - Задаёт размер в битах долгосрочного набора опорных изображений первого среза,
        включённого в заголовок среза или SPS. Это число бит в условном блоке
        if(long_term_ref_pics_present_flag) в разделе 7.3.6.1 спецификации.
    * - __u8
      - ``num_active_dpb_entries``
      - Число элементов в ``dpb``.
    * - __u8
      - ``num_poc_st_curr_before``
      - Число опорных изображений в краткосрочном наборе, которые предшествуют
        текущему кадру.
    * - __u8
      - ``num_poc_st_curr_after``
      - Число опорных изображений в краткосрочном наборе, которые следуют после
        текущего кадра.
    * - __u8
      - ``num_poc_lt_curr``
      - Число опорных изображений в долгосрочном наборе.
    * - __u8
      - ``poc_st_curr_before[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
      - PocStCurrBefore, как описано в разделе 8.3.2 "Decoding process for reference
        picture set": предоставляет индекс краткосрочных опорных кадров "before" в массиве DPB.
    * - __u8
      - ``poc_st_curr_after[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
      - PocStCurrAfter, как описано в разделе 8.3.2 "Decoding process for reference
        picture set": предоставляет индекс краткосрочных опорных кадров "after" в массиве DPB.
    * - __u8
      - ``poc_lt_curr[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
      - PocLtCurr, как описано в разделе 8.3.2 "Decoding process for reference
        picture set": предоставляет индекс долгосрочных опорных кадров в массиве DPB.
    * - __u8
      - ``num_delta_pocs_of_ref_rps_idx``
      - Когда short_term_ref_pic_set_sps_flag в заголовке среза равен 0,
        он совпадает с производным значением NumDeltaPocs[RefRpsIdx]. Его можно использовать для разбора
        данных RPS в заголовках срезов вместо их пропуска с помощью @short_term_ref_pic_set_size.
        Когда значение short_term_ref_pic_set_sps_flag в заголовке среза
        равно 1, num_delta_pocs_of_ref_rps_idx должен быть установлен в 0.
    * - struct :c:type:`v4l2_hevc_dpb_entry`
      - ``dpb[V4L2_HEVC_DPB_ENTRIES_NUM_MAX]``
      - Буфер декодированных изображений (decoded picture buffer), для метаданных об опорных кадрах.
    * - __u64
      - ``flags``
      - См. :ref:`Флаги параметров декодирования <hevc_decode_params_flags>`

.. _hevc_decode_params_flags:

``Decode Parameters Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_HEVC_DECODE_PARAM_FLAG_IRAP_PIC``
      - 0x00000001
      -
    * - ``V4L2_HEVC_DECODE_PARAM_FLAG_IDR_PIC``
      - 0x00000002
      -
    * - ``V4L2_HEVC_DECODE_PARAM_FLAG_NO_OUTPUT_OF_PRIOR``
      - 0x00000004
      -

``V4L2_CID_STATELESS_HEVC_EXT_SPS_LT_RPS (struct)``
    Подмножество элемента управления :c:type:`v4l2_ctrl_hevc_sps`.
    Расширяет его списком параметров долгосрочных опорных наборов (Long-term reference sets).
    Эти параметры определяются согласно :ref:`hevc`.
    Они описаны в разделе 7.4.3.2.1 "General sequence parameter set
    RBSP semantics" спецификации.
    Этот элемент управления — динамически изменяемый одномерный массив.
    Значения в массиве следует игнорировать, когда либо
    num_long_term_ref_pics_sps равно 0, либо флаг
    V4L2_HEVC_SPS_FLAG_LONG_TERM_REF_PICS_PRESENT не установлен в
    :c:type:`v4l2_ctrl_hevc_sps`.

.. c:type:: v4l2_ctrl_hevc_ext_sps_lt_rps

.. cssclass:: longtable

.. flat-table:: struct v4l2_ctrl_hevc_ext_sps_lt_rps
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u16
      - ``lt_ref_pic_poc_lsb_sps``
      - Счётчик порядка долгосрочных опорных изображений, как описано в разделе 7.4.3.2.1
        "General sequence parameter set RBSP semantics" спецификации.
    * - __u16
      - ``flags``
      - См. :ref:`Флаги расширенного долгосрочного RPS <hevc_ext_sps_lt_rps_flags>`

.. _hevc_ext_sps_lt_rps_flags:

``Extended SPS Long-Term RPS Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_HEVC_EXT_SPS_LT_RPS_FLAG_USED_LT``
      - 0x00000001
      - Задаёт, используется ли долгосрочное опорное изображение 7.4.3.2.1 "General sequence parameter
        set RBSP semantics" спецификации.

``V4L2_CID_STATELESS_HEVC_EXT_SPS_ST_RPS (struct)``
    Подмножество элемента управления :c:type:`v4l2_ctrl_hevc_sps`.
    Расширяет его списком параметров краткосрочных опорных наборов (Short-term reference sets).
    Эти параметры определяются согласно :ref:`hevc`.
    Они описаны в разделе 7.4.8 "Short-term reference picture set
    semantics" спецификации.
    Этот элемент управления — динамически изменяемый одномерный массив.
    Значения в массиве следует игнорировать, когда
    num_short_term_ref_pic_sets равно 0.

.. c:type:: v4l2_ctrl_hevc_ext_sps_st_rps

.. cssclass:: longtable

.. flat-table:: struct v4l2_ctrl_hevc_ext_sps_st_rps
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``delta_idx_minus1``
      - Задаёт дельту относительно индекса. См. подробности в разделе 7.4.8 "Short-term
        reference picture set semantics" спецификации.
    * - __u8
      - ``delta_rps_sign``
      - Знак дельты, как указано в разделе 7.4.8 "Short-term reference picture set
        semantics" спецификации.
    * - __u8
      - ``num_negative_pics``
      - Число элементов краткосрочного RPS, имеющих значения счётчика порядка изображений меньше,
        чем значение счётчика порядка изображений текущего изображения.
    * - __u8
      - ``num_positive_pics``
      - Число элементов краткосрочного RPS, имеющих значения счётчика порядка изображений больше,
        чем значение счётчика порядка изображений текущего изображения.
    * - __u32
      - ``used_by_curr_pic``
      - Бит i задаёт, используется ли краткосрочный RPS i текущим изображением.
    * - __u32
      - ``use_delta_flag``
      - Бит i задаёт, включён ли краткосрочный RPS i в элементы краткосрочного RPS.
    * - __u16
      - ``abs_delta_rps_minus1``
      - Абсолютная дельта RPS, как указано в разделе 7.4.8 "Short-term reference picture set
        semantics" спецификации.
    * - __u16
      - ``delta_poc_s0_minus1[16]``
      - Задаёт дельту отрицательного счётчика порядка изображений для i-го элемента краткосрочного RPS.
        См. подробности в разделе 7.4.8 "Short-term reference picture set semantics"
        спецификации.
    * - __u16
      - ``delta_poc_s1_minus1[16]``
      - Задаёт дельту положительного счётчика порядка изображений для i-го элемента краткосрочного RPS.
        См. подробности в разделе 7.4.8 "Short-term reference picture set semantics"
        спецификации.
    * - __u16
      - ``flags``
      - См. :ref:`Флаги расширенного краткосрочного RPS <hevc_ext_sps_st_rps_flags>`

.. _hevc_ext_sps_st_rps_flags:

``Extended SPS Short-Term RPS Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_HEVC_EXT_SPS_ST_RPS_FLAG_INTER_REF_PIC_SET_PRED``
      - 0x00000001
      - Задаёт, предсказывается ли краткосрочный RPS из другого краткосрочного RPS. См. подробности в
        разделе 7.4.8 "Short-term reference picture set semantics" спецификации.

.. _v4l2-codec-stateless-av1:

``V4L2_CID_STATELESS_AV1_SEQUENCE (struct)``
    Представляет AV1 Sequence OBU (Open Bitstream Unit). См. раздел 5.5
    "Sequence header OBU syntax" в :ref:`av1` для дополнительной информации.

.. c:type:: v4l2_ctrl_av1_sequence

.. cssclass:: longtable

.. tabularcolumns:: |p{5.8cm}|p{4.8cm}|p{6.6cm}|

.. flat-table:: struct v4l2_ctrl_av1_sequence
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u32
      - ``flags``
      - См. :ref:`Флаги последовательности AV1 <av1_sequence_flags>`.
    * - __u8
      - ``seq_profile``
      - Задаёт функциональность, которую можно использовать в закодированной видеопоследовательности.
    * - __u8
      - ``order_hint_bits``
      - Задаёт число бит, используемых для поля order_hint в каждом кадре.
    * - __u8
      - ``bit_depth``
      - битовая глубина, используемая для последовательности, как описано в разделе 5.5.2
        "Color config syntax" в :ref:`av1` для дополнительной информации.
    * - __u8
      - ``reserved``
      - Приложения и драйверы должны установить это в ноль.
    * - __u16
      - ``max_frame_width_minus_1``
      - Задаёт максимальную ширину кадра минус 1 для кадров, представленных
        этим заголовком последовательности.
    * - __u16
      - ``max_frame_height_minus_1``
      - Задаёт максимальную высоту кадра минус 1 для кадров, представленных
        этим заголовком последовательности.

.. _av1_sequence_flags:

``AV1 Sequence Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_SEQUENCE_FLAG_STILL_PICTURE``
      - 0x00000001
      - Если установлен, задаёт, что закодированная видеопоследовательность содержит только один закодированный
        кадр. Если не установлен, задаёт, что закодированная видеопоследовательность содержит один
        или несколько закодированных кадров.
    * - ``V4L2_AV1_SEQUENCE_FLAG_USE_128X128_SUPERBLOCK``
      - 0x00000002
      - Если установлен, указывает, что суперблоки содержат 128x128 отсчётов яркости.
        Когда равно 0, это указывает, что суперблоки содержат 64x64 отсчёта яркости.
        Число содержащихся отсчётов цветности зависит от
        subsampling_x и subsampling_y.
    * - ``V4L2_AV1_SEQUENCE_FLAG_ENABLE_FILTER_INTRA``
      - 0x00000004
      - Если установлен, задаёт, что синтаксический элемент use_filter_intra может
        присутствовать. Если не установлен, задаёт, что синтаксический элемент use_filter_intra
        не будет присутствовать.
    * - ``V4L2_AV1_SEQUENCE_FLAG_ENABLE_INTRA_EDGE_FILTER``
      - 0x00000008
      - Задаёт, должен ли быть включён процесс фильтрации внутрикадровых краёв.
    * - ``V4L2_AV1_SEQUENCE_FLAG_ENABLE_INTERINTRA_COMPOUND``
      - 0x00000010
      - Если установлен, задаёт, что информация о режиме для межкадровых блоков может содержать
        синтаксический элемент interintra. Если не установлен, задаёт, что синтаксический элемент
        interintra не будет присутствовать.
    * - ``V4L2_AV1_SEQUENCE_FLAG_ENABLE_MASKED_COMPOUND``
      - 0x00000020
      - Если установлен, задаёт, что информация о режиме для межкадровых блоков может содержать
        синтаксический элемент compound_type. Если не установлен, задаёт, что синтаксический
        элемент compound_type не будет присутствовать.
    * - ``V4L2_AV1_SEQUENCE_FLAG_ENABLE_WARPED_MOTION``
      - 0x00000040
      - Если установлен, указывает, что синтаксический элемент allow_warped_motion может
        присутствовать. Если не установлен, указывает, что синтаксический элемент allow_warped_motion
        не будет присутствовать.
    * - ``V4L2_AV1_SEQUENCE_FLAG_ENABLE_DUAL_FILTER``
      - 0x00000080
      - Если установлен, указывает, что тип фильтра межкадрового предсказания может быть задан
        независимо в горизонтальном и вертикальном направлениях. Если флаг
        равен 0, может быть задан только один тип фильтра, который затем используется в
        обоих направлениях.
    * - ``V4L2_AV1_SEQUENCE_FLAG_ENABLE_ORDER_HINT``
      - 0x00000100
      - Если установлен, указывает, что могут использоваться инструменты, основанные на значениях
        подсказок порядка (order hints). Если не установлен, указывает, что инструменты, основанные на подсказках порядка,
        отключены.
    * - ``V4L2_AV1_SEQUENCE_FLAG_ENABLE_JNT_COMP``
      - 0x00000200
      - Если установлен, указывает, что процесс взвешивания по расстоянию может использоваться для
        межкадрового предсказания.
    * - ``V4L2_AV1_SEQUENCE_FLAG_ENABLE_REF_FRAME_MVS``
      - 0x00000400
      - Если установлен, указывает, что синтаксический элемент use_ref_frame_mvs может
        присутствовать. Если не установлен, указывает, что синтаксический элемент use_ref_frame_mvs
        не будет присутствовать.
    * - ``V4L2_AV1_SEQUENCE_FLAG_ENABLE_SUPERRES``
      - 0x00000800
      - Если установлен, задаёт, что синтаксический элемент use_superres будет присутствовать
        в несжатом заголовке. Если не установлен, задаёт, что синтаксический элемент use_superres
        не будет присутствовать (вместо этого use_superres будет установлен в
        0 в несжатом заголовке без чтения).
    * - ``V4L2_AV1_SEQUENCE_FLAG_ENABLE_CDEF``
      - 0x00001000
      - Если установлен, задаёт, что фильтрация cdef может быть включена. Если не установлен,
        задаёт, что фильтрация cdef отключена.
    * - ``V4L2_AV1_SEQUENCE_FLAG_ENABLE_RESTORATION``
      - 0x00002000
      - Если установлен, задаёт, что фильтрация восстановления контура (loop restoration) может быть включена. Если не
        установлен, задаёт, что фильтрация восстановления контура отключена.
    * - ``V4L2_AV1_SEQUENCE_FLAG_MONO_CHROME``
      - 0x00004000
      - Если установлен, указывает, что видео не содержит цветовых плоскостей U и V.
        Если не установлен, указывает, что видео содержит цветовые плоскости Y, U и V.
    * - ``V4L2_AV1_SEQUENCE_FLAG_COLOR_RANGE``
      - 0x00008000
      - Если установлен, сигнализирует представление с полным размахом, то есть "Full Range
        Quantization". Если не установлен, сигнализирует представление со студийным размахом, то есть
        "Limited Range Quantization".
    * - ``V4L2_AV1_SEQUENCE_FLAG_SUBSAMPLING_X``
      - 0x00010000
      - Задаёт формат субдискретизации цветности.
    * - ``V4L2_AV1_SEQUENCE_FLAG_SUBSAMPLING_Y``
      - 0x00020000
      - Задаёт формат субдискретизации цветности.
    * - ``V4L2_AV1_SEQUENCE_FLAG_FILM_GRAIN_PARAMS_PRESENT``
      - 0x00040000
      - Задаёт, присутствуют ли параметры зернистости плёнки (film grain) в закодированной видео-
        последовательности.
    * - ``V4L2_AV1_SEQUENCE_FLAG_SEPARATE_UV_DELTA_Q``
      - 0x00080000
      - Если установлен, указывает, что плоскости U и V могут иметь раздельные дельта-значения
        квантователя. Если не установлен, указывает, что плоскости U и V будут совместно использовать
        одно и то же дельта-значение квантователя.

``V4L2_CID_STATELESS_AV1_TILE_GROUP_ENTRY (struct)``
    Представляет одну плитку AV1 (tile) внутри группы плиток AV1. Обратите внимание, что MiRowStart,
    MiRowEnd, MiColStart и MiColEnd можно получить из структуры
    v4l2_av1_tile_info в структуре v4l2_ctrl_av1_frame с помощью tile_row и
    tile_col. См. раздел 6.10.1 "General tile group OBU semantics" в
    :ref:`av1` для дополнительной информации.

.. c:type:: v4l2_ctrl_av1_tile_group_entry

.. cssclass:: longtable

.. tabularcolumns:: |p{5.8cm}|p{4.8cm}|p{6.6cm}|

.. flat-table:: struct v4l2_ctrl_av1_tile_group_entry
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u32
      - ``tile_offset``
      - Смещение от данных OBU, то есть место, где фактически начинаются закодированные данные плитки.
    * - __u32
      - ``tile_size``
      - Задаёт размер в байтах закодированной плитки. Эквивалент "TileSize"
        в :ref:`av1`.
    * - __u32
      - ``tile_row``
      - Задаёт строку текущей плитки. Эквивалент "TileRow" в
        :ref:`av1`.
    * - __u32
      - ``tile_col``
      - Задаёт столбец текущей плитки. Эквивалент "TileColumn" в
        :ref:`av1`.

.. c:type:: v4l2_av1_warp_model

	Модель деформации AV1 (Warp Model), как описано в разделе 3 "Symbols and abbreviated terms"
	в :ref:`av1`.

.. raw:: latex

    \scriptsize

.. tabularcolumns:: |p{7.4cm}|p{0.3cm}|p{9.6cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_WARP_MODEL_IDENTITY``
      - 0
      - Модель деформации — просто тождественное преобразование.
    * - ``V4L2_AV1_WARP_MODEL_TRANSLATION``
      - 1
      - Модель деформации — чистый сдвиг (translation).
    * - ``V4L2_AV1_WARP_MODEL_ROTZOOM``
      - 2
      - Модель деформации — поворот + симметричное масштабирование + сдвиг.
    * - ``V4L2_AV1_WARP_MODEL_AFFINE``
      - 3
      - Модель деформации — общее аффинное преобразование.

.. c:type:: v4l2_av1_reference_frame

Опорные кадры AV1, как описано в разделе 6.10.24 "Ref frames semantics"
в :ref:`av1`.

.. raw:: latex

    \scriptsize

.. tabularcolumns:: |p{7.4cm}|p{0.3cm}|p{9.6cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_REF_INTRA_FRAME``
      - 0
      - Опорный внутрикадровый кадр (Intra Frame).
    * - ``V4L2_AV1_REF_LAST_FRAME``
      - 1
      - Опорный последний кадр (Last Frame).
    * - ``V4L2_AV1_REF_LAST2_FRAME``
      - 2
      - Опорный кадр Last2.
    * - ``V4L2_AV1_REF_LAST3_FRAME``
      - 3
      - Опорный кадр Last3.
    * - ``V4L2_AV1_REF_GOLDEN_FRAME``
      - 4
      - Опорный золотой кадр (Golden Frame).
    * - ``V4L2_AV1_REF_BWDREF_FRAME``
      - 5
      - Опорный кадр BWD.
    * - ``V4L2_AV1_REF_ALTREF2_FRAME``
      - 6
      - Опорный кадр ALTREF2.
    * - ``V4L2_AV1_REF_ALTREF_FRAME``
      - 7
      - Опорный кадр ALTREF.

.. c:type:: v4l2_av1_global_motion

Параметры глобального движения AV1 (Global Motion), как описано в разделе 6.8.17
"Global motion params semantics" в :ref:`av1`.

.. cssclass:: longtable

.. tabularcolumns:: |p{1.5cm}|p{5.8cm}|p{10.0cm}|

.. flat-table:: struct v4l2_av1_global_motion
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``flags[V4L2_AV1_TOTAL_REFS_PER_FRAME]``
      - Битовое поле, содержащее флаги для каждого опорного кадра. См.
        :ref:`Флаги глобального движения AV1 <av1_global_motion_flags>` для дополнительной
        информации.
    * - enum :c:type:`v4l2_av1_warp_model`
      - ``type[V4L2_AV1_TOTAL_REFS_PER_FRAME]``
      - Тип используемого преобразования глобального движения.
    * - __s32
      - ``params[V4L2_AV1_TOTAL_REFS_PER_FRAME][6]``
      - Это поле имеет тот же смысл, что и "gm_params" в :ref:`av1`.
    * - __u8
      - ``invalid``
      - Битовое поле, указывающее, недействительны ли параметры глобального движения для
        данного опорного кадра. См. раздел 7.11.3.6 Setup shear process и
        переменную "warpValid". Используйте V4L2_AV1_GLOBAL_MOTION_IS_INVALID(ref) для
        создания подходящей маски.
    * - __u8
      - ``reserved[3]``
      - Приложения и драйверы должны установить это в ноль.

.. _av1_global_motion_flags:

``AV1 Global Motion Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_GLOBAL_MOTION_FLAG_IS_GLOBAL``
      - 0x00000001
      - Задаёт, присутствуют ли параметры глобального движения для конкретного
        опорного кадра.
    * - ``V4L2_AV1_GLOBAL_MOTION_FLAG_IS_ROT_ZOOM``
      - 0x00000002
      - Задаёт, использует ли конкретный опорный кадр глобальное движение с поворотом и
        масштабированием.
    * - ``V4L2_AV1_GLOBAL_MOTION_FLAG_IS_TRANSLATION``
      - 0x00000004
      - Задаёт, использует ли конкретный опорный кадр глобальное движение со сдвигом
        (translation)

.. c:type:: v4l2_av1_frame_restoration_type

Тип восстановления кадра AV1 (Frame Restoration Type).

.. raw:: latex

    \scriptsize

.. tabularcolumns:: |p{7.4cm}|p{0.3cm}|p{9.6cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_FRAME_RESTORE_NONE``
      - 0
      - Фильтрация не применяется.
    * - ``V4L2_AV1_FRAME_RESTORE_WIENER``
      - 1
      - Вызывается процесс фильтра Винера.
    * - ``V4L2_AV1_FRAME_RESTORE_SGRPROJ``
      - 2
      - Вызывается процесс самонаправляемого (self guided) фильтра.
    * - ``V4L2_AV1_FRAME_RESTORE_SWITCHABLE``
      - 3
      - Фильтр восстановления является переключаемым.

.. c:type:: v4l2_av1_loop_restoration

Восстановление контура AV1 (Loop Restoration), как описано в разделе 6.10.15 "Loop restoration params
semantics" в :ref:`av1`.

.. cssclass:: longtable

.. tabularcolumns:: |p{1.5cm}|p{5.8cm}|p{10.0cm}|

.. flat-table:: struct v4l2_av1_loop_restoration
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``flags``
      - См. :ref:`Флаги восстановления контура AV1 <av1_loop_restoration_flags>`.
    * - __u8
      - ``lr_unit_shift``
      - Задаёт, должен ли размер восстановления яркости быть уменьшен вдвое.
    * - __u8
      - ``lr_uv_shift``
      - Задаёт, должен ли размер цветности быть равен половине размера яркости.
    * - __u8
      - ``reserved``
      - Приложения и драйверы должны установить это в ноль.
    * - :c:type:`v4l2_av1_frame_restoration_type`
      - ``frame_restoration_type[V4L2_AV1_NUM_PLANES_MAX]``
      - Задаёт тип восстановления, используемый для каждой плоскости.
    * - __u8
      - ``loop_restoration_size[V4L2_AV1_MAX_NUM_PLANES]``
      - Задаёт размер единиц восстановления контура в единицах отсчётов в
        текущей плоскости.

.. _av1_loop_restoration_flags:

``AV1 Loop Restoration Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_LOOP_RESTORATION_FLAG_USES_LR``
      - 0x00000001
      - Сохраняет тот же смысл, что и UsesLr в :ref:`av1`.
    * - ``V4L2_AV1_LOOP_RESTORATION_FLAG_USES_CHROMA_LR``
      - 0x00000002
      - Сохраняет тот же смысл, что и UsesChromaLr в :ref:`av1`.

.. c:type:: v4l2_av1_cdef

Семантика параметров CDEF AV1, как описано в разделе 6.10.14 "CDEF params
semantics" в :ref:`av1`.

.. cssclass:: longtable

.. tabularcolumns:: |p{1.5cm}|p{5.8cm}|p{10.0cm}|

.. flat-table:: struct v4l2_av1_cdef
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``damping_minus_3``
      - Управляет величиной демпфирования в фильтре устранения звона (deringing filter).
    * - __u8
      - ``bits``
      - Задаёт число бит, необходимых для указания, какой фильтр CDEF
        применять.
    * - __u8
      - ``y_pri_strength[V4L2_AV1_CDEF_MAX]``
      -  Задаёт силу первичного фильтра.
    * - __u8
      - ``y_sec_strength[V4L2_AV1_CDEF_MAX]``
      -  Задаёт силу вторичного фильтра.
    * - __u8
      - ``uv_pri_strength[V4L2_AV1_CDEF_MAX]``
      -  Задаёт силу первичного фильтра.
    * - __u8
      - ``uv_sec_strength[V4L2_AV1_CDEF_MAX]``
      -  Задаёт силу вторичного фильтра.

.. c:type:: v4l2_av1_segment_feature

Признаки сегмента AV1, как описано в разделе 3 "Symbols and abbreviated terms"
в :ref:`av1`.

.. raw:: latex

    \scriptsize

.. tabularcolumns:: |p{7.4cm}|p{0.3cm}|p{9.6cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_SEG_LVL_ALT_Q``
      - 0
      - Индекс признака сегмента — квантователь.
    * - ``V4L2_AV1_SEG_LVL_ALT_LF_Y_V``
      - 1
      - Индекс признака сегмента — вертикальный контурный фильтр яркости.
    * - ``V4L2_AV1_SEG_LVL_REF_FRAME``
      - 5
      - Индекс признака сегмента — опорный кадр.
    * - ``V4L2_AV1_SEG_LVL_REF_SKIP``
      - 6
      - Индекс признака сегмента — пропуск.
    * - ``V4L2_AV1_SEG_LVL_REF_GLOBALMV``
      - 7
      - Индекс признака — глобальный mv.
    * - ``V4L2_AV1_SEG_LVL_MAX``
      - 8
      - Число признаков сегмента.

.. c:type:: v4l2_av1_segmentation

Параметры сегментации AV1, как определено в разделе 6.8.13 "Segmentation params
semantics" в :ref:`av1`.

.. cssclass:: longtable

.. tabularcolumns:: |p{1.5cm}|p{5.8cm}|p{10.0cm}|

.. flat-table:: struct v4l2_av1_segmentation
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``flags``
      - См. :ref:`Флаги сегментации AV1 <av1_segmentation_flags>`
    * - __u8
      - ``last_active_seg_id``
      -  Указывает наибольший по номеру идентификатор сегмента, который имеет некоторый
         включённый признак. Используется при декодировании идентификатора сегмента, чтобы декодировать только
         варианты, соответствующие используемым сегментам.
    * - __u8
      - ``feature_enabled[V4L2_AV1_MAX_SEGMENTS]``
      - Битовая маска, определяющая, какие признаки включены в каждом сегменте. Используйте
        V4L2_AV1_SEGMENT_FEATURE_ENABLED для построения подходящей маски.
    * - __u16
      - ``feature_data[V4L2_AV1_MAX_SEGMENTS][V4L2_AV1_SEG_LVL_MAX]``
      -  Данные, привязанные к каждому признаку. Запись данных действительна только если признак
         включён.

.. _av1_segmentation_flags:

``AV1 Segmentation Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_SEGMENTATION_FLAG_ENABLED``
      - 0x00000001
      - Если установлен, указывает, что этот кадр использует инструмент сегментации. Если
        не установлен, указывает, что кадр не использует сегментацию.
    * - ``V4L2_AV1_SEGMENTATION_FLAG_UPDATE_MAP``
      - 0x00000002
      - Если установлен, указывает, что карта сегментации обновляется при
        декодировании этого кадра. Если не установлен, указывает, что используется карта сегментации
        из предыдущего кадра.
    * - ``V4L2_AV1_SEGMENTATION_FLAG_TEMPORAL_UPDATE``
      - 0x00000004
      - Если установлен, указывает, что обновления карты сегментации кодируются
        относительно существующей карты сегментации. Если не установлен, указывает, что
        новая карта сегментации кодируется без ссылки на существующую
        карту сегментации.
    * - ``V4L2_AV1_SEGMENTATION_FLAG_UPDATE_DATA``
      - 0x00000008
      - Если установлен, указывает, что обновления карты сегментации кодируются
        относительно существующей карты сегментации. Если не установлен, указывает, что
        новая карта сегментации кодируется без ссылки на существующую
        карту сегментации.
    * - ``V4L2_AV1_SEGMENTATION_FLAG_SEG_ID_PRE_SKIP``
      - 0x00000010
      - Если установлен, указывает, что идентификатор сегмента будет прочитан перед синтаксическим
        элементом skip. Если не установлен, указывает, что синтаксический элемент skip будет
        прочитан первым.

.. c:type:: v4l2_av1_loop_filter

Параметры контурного фильтра AV1, как определено в разделе 6.8.10 "Loop filter semantics" в
:ref:`av1`.

.. cssclass:: longtable

.. tabularcolumns:: |p{1.5cm}|p{5.8cm}|p{10.0cm}|

.. flat-table:: struct v4l2_av1_loop_filter
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``flags``
      - См.
        :ref:`Флаги контурного фильтра AV1 <av1_loop_filter_flags>` для дополнительной информации.
    * - __u8
      - ``level[4]``
      - Массив, содержащий значения силы контурного фильтра. Различные значения силы контурного
        фильтра из массива используются в зависимости от фильтруемой плоскости изображения
        и фильтруемого направления края (вертикального или горизонтального).
    * - __u8
      - ``sharpness``
      - указывает уровень резкости. loop_filter_level и
        loop_filter_sharpness вместе определяют, когда фильтруется край блока,
        и насколько фильтрация может изменить значения отсчётов. Процесс контурного
        фильтра описан в разделе 7.14 в :ref:`av1`.
    * - __u8
      - ``ref_deltas[V4L2_AV1_TOTAL_REFS_PER_FRAME]``
      - содержит корректировку уровня фильтра, необходимую на основе
        выбранного опорного кадра. Если этот синтаксический элемент отсутствует, он
        сохраняет своё предыдущее значение.
    * - __u8
      - ``mode_deltas[2]``
      - содержит корректировку уровня фильтра, необходимую на основе
        выбранного режима. Если этот синтаксический элемент отсутствует, он сохраняет своё
        предыдущее значение.
    * - __u8
      - ``delta_lf_res``
      - задаёт сдвиг влево, который должен быть применён к декодированным дельта-значениям
        контурного фильтра.

.. _av1_loop_filter_flags:

``AV1 Loop Filter Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_LOOP_FILTER_FLAG_DELTA_ENABLED``
      - 0x00000001
      - Если установлен, означает, что уровень фильтра зависит от режима и опорного
        кадра, используемого для предсказания блока. Если не установлен, означает, что уровень фильтра
        не зависит от режима и опорного кадра.
    * - ``V4L2_AV1_LOOP_FILTER_FLAG_DELTA_UPDATE``
      - 0x00000002
      - Если установлен, означает, что присутствуют дополнительные синтаксические элементы, которые задают,
        какие дельты режима и опорного кадра должны быть обновлены. Если не установлен,
        означает, что эти синтаксические элементы отсутствуют.
    * - ``V4L2_AV1_LOOP_FILTER_FLAG_DELTA_LF_PRESENT``
      - 0x00000004
      - Задаёт, присутствуют ли дельта-значения контурного фильтра
    * - ``V4L2_AV1_LOOP_FILTER_FLAG_DELTA_LF_MULTI``
      - 0x00000008
      - Значение, равное 1, задаёт, что отдельные дельты контурного фильтра
        отправляются для горизонтальных краёв яркости, вертикальных краёв яркости,
        краёв U и краёв V. Значение delta_lf_multi, равное 0,
        задаёт, что одна и та же дельта контурного фильтра используется для всех краёв.

.. c:type:: v4l2_av1_quantization

Параметры квантования AV1, как определено в разделе 6.8.11 "Quantization params
semantics" в :ref:`av1`.

.. cssclass:: longtable

.. tabularcolumns:: |p{1.5cm}|p{5.8cm}|p{10.0cm}|

.. flat-table:: struct v4l2_av1_quantization
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``flags``
      - См.
        :ref:`Флаги квантования AV1 <av1_quantization_flags>` для дополнительной информации.
    * - __u8
      - ``base_q_idx``
      - Указывает базовый qindex кадра. Используется для AC-коэффициентов Y и
        в качестве базового значения для других квантователей.
    * - __u8
      - ``delta_q_y_dc``
      - Указывает квантователь Y DC относительно base_q_idx.
    * - __u8
      - ``delta_q_u_dc``
      - Указывает квантователь U DC относительно base_q_idx.
    * - __u8
      - ``delta_q_u_ac``
      - Указывает квантователь U AC относительно base_q_idx.
    * - __u8
      - ``delta_q_v_dc``
      - Указывает квантователь V DC относительно base_q_idx.
    * - __u8
      - ``delta_q_v_ac``
      - Указывает квантователь V AC относительно base_q_idx.
    * - __u8
      - ``qm_y``
      - Задаёт уровень в матрице квантователя, который должен использоваться для
        декодирования плоскости яркости.
    * - __u8
      - ``qm_u``
      - Задаёт уровень в матрице квантователя, который должен использоваться для
        декодирования плоскости цветности U.
    * - __u8
      - ``qm_v``
      - Задаёт уровень в матрице квантователя, который должен использоваться для
        декодирования плоскости цветности V.
    * - __u8
      - ``delta_q_res``
      - Задаёт сдвиг влево, который должен быть применён к декодированным дельта-значениям
        индекса квантователя.

.. _av1_quantization_flags:

``AV1 Quantization Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_QUANTIZATION_FLAG_DIFF_UV_DELTA``
      - 0x00000001
      - Если установлен, указывает, что дельта-значения квантователя U и V кодируются
        раздельно. Если не установлен, указывает, что дельта-значения квантователя U и V
        совместно используют общее значение.
    * - ``V4L2_AV1_QUANTIZATION_FLAG_USING_QMATRIX``
      - 0x00000002
      - Если установлен, задаёт, что матрица квантователя будет использоваться для вычисления
        квантователей.
    * - ``V4L2_AV1_QUANTIZATION_FLAG_DELTA_Q_PRESENT``
      - 0x00000004
      - Задаёт, присутствуют ли дельта-значения индекса квантователя.

.. c:type:: v4l2_av1_tile_info

Информация о плитках AV1 (Tile info), как определено в разделе 6.8.14 "Tile info semantics" в ref:`av1`.

.. cssclass:: longtable

.. tabularcolumns:: |p{1.5cm}|p{5.8cm}|p{10.0cm}|

.. flat-table:: struct v4l2_av1_tile_info
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``flags``
      - См.
        :ref:`Флаги информации о плитках AV1 <av1_tile_info_flags>` для дополнительной информации.
    * - __u8
      - ``context_update_tile_id``
      - Задаёт, какую плитку использовать для обновления CDF.
    * - __u8
      - ``tile_cols``
      - Задаёт число плиток поперёк кадра.
    * - __u8
      - ``tile_rows``
      - Задаёт число плиток вдоль кадра.
    * - __u32
      - ``mi_col_starts[V4L2_AV1_MAX_TILE_COLS + 1]``
      - Массив, задающий начальный столбец (в единицах отсчётов яркости 4x4)
        для каждой плитки поперёк изображения.
    * - __u32
      - ``mi_row_starts[V4L2_AV1_MAX_TILE_ROWS + 1]``
      - Массив, задающий начальную строку (в единицах отсчётов яркости 4x4)
        для каждой плитки поперёк изображения.
    * - __u32
      - ``width_in_sbs_minus_1[V4L2_AV1_MAX_TILE_COLS]``
      - Задаёт ширину плитки минус 1 в единицах суперблоков.
    * - __u32
      - ``height_in_sbs_minus_1[V4L2_AV1_MAX_TILE_ROWS]``
      - Задаёт высоту плитки минус 1 в единицах суперблоков.
    * - __u8
      - ``tile_size_bytes``
      - Задаёт число байт, необходимых для кодирования размера каждой плитки.
    * - __u8
      - ``reserved[3]``
      - Приложения и драйверы должны установить это в ноль.

.. _av1_tile_info_flags:

``AV1 Tile Info Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_TILE_INFO_FLAG_UNIFORM_TILE_SPACING``
      - 0x00000001
      - Если установлен, означает, что плитки равномерно распределены по кадру. (Иными
        словами, все плитки одного размера, за исключением плиток у
        правого и нижнего края, которые могут быть меньше). Если не установлен, означает, что
        размеры плиток кодируются.

.. c:type:: v4l2_av1_frame_type

Тип кадра AV1 (Frame Type)

.. raw:: latex

    \scriptsize

.. tabularcolumns:: |p{7.4cm}|p{0.3cm}|p{9.6cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_KEY_FRAME``
      - 0
      - Ключевой кадр.
    * - ``V4L2_AV1_INTER_FRAME``
      - 1
      - Межкадровый кадр (Inter frame).
    * - ``V4L2_AV1_INTRA_ONLY_FRAME``
      - 2
      - Только внутрикадровый кадр (Intra-only frame).
    * - ``V4L2_AV1_SWITCH_FRAME``
      - 3
      - Кадр переключения (Switch frame).

.. c:type:: v4l2_av1_interpolation_filter

Фильтр интерполяции AV1 (Interpolation Filter)

.. raw:: latex

    \scriptsize

.. tabularcolumns:: |p{7.4cm}|p{0.3cm}|p{9.6cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_INTERPOLATION_FILTER_EIGHTTAP``
      - 0
      - Восьмиотводный фильтр.
    * - ``V4L2_AV1_INTERPOLATION_FILTER_EIGHTTAP_SMOOTH``
      - 1
      - Восьмиотводный сглаживающий фильтр.
    * - ``V4L2_AV1_INTERPOLATION_FILTER_EIGHTTAP_SHARP``
      - 2
      - Восьмиотводный резкий фильтр.
    * - ``V4L2_AV1_INTERPOLATION_FILTER_BILINEAR``
      - 3
      - Билинейный фильтр.
    * - ``V4L2_AV1_INTERPOLATION_FILTER_SWITCHABLE``
      - 4
      - Выбор фильтра сигнализируется на уровне блока.

.. c:type:: v4l2_av1_tx_mode

Режим Tx AV1 (Tx mode), как описано в разделе 6.8.21 "TX mode semantics" в :ref:`av1`.

.. raw:: latex

    \scriptsize

.. tabularcolumns:: |p{7.4cm}|p{0.3cm}|p{9.6cm}|

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_TX_MODE_ONLY_4X4``
      - 0
      -  Обратное преобразование будет использовать только преобразования 4x4.
    * - ``V4L2_AV1_TX_MODE_LARGEST``
      - 1
      - Обратное преобразование будет использовать наибольший размер преобразования, который помещается
        внутри блока.
    * - ``V4L2_AV1_TX_MODE_SELECT``
      - 2
      - Выбор размера преобразования явно задаётся для каждого блока.

``V4L2_CID_STATELESS_AV1_FRAME (struct)``
    Представляет Frame Header OBU. См. 6.8 "Frame Header OBU semantics" в
    :ref:`av1` для дополнительной информации.

.. c:type:: v4l2_ctrl_av1_frame

.. cssclass:: longtable

.. tabularcolumns:: |p{5.8cm}|p{4.8cm}|p{6.6cm}|

.. flat-table:: struct v4l2_ctrl_av1_frame
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - struct :c:type:`v4l2_av1_tile_info`
      - ``tile_info``
      - Информация о плитках
    * - struct :c:type:`v4l2_av1_quantization`
      - ``quantization``
      - Параметры квантования.
    * - __u8
      - ``superres_denom``
      - Знаменатель для коэффициента повышающего масштабирования (upscaling).
    * - struct :c:type:`v4l2_av1_segmentation`
      - ``segmentation``
      - Параметры сегментации.
    * - struct :c:type:`v4l2_av1_loop_filter`
      - ``loop_filter``
      - Параметры контурного фильтра
    * - struct :c:type:`v4l2_av1_cdef`
      - ``cdef``
      - Параметры CDEF
    * - __u8
      - ``skip_mode_frame[2]``
      - Задаёт кадры, которые будут использоваться для составного предсказания, когда skip_mode
        равен 1.
    * - __u8
      - ``primary_ref_frame``
      - Задаёт, какой опорный кадр содержит значения CDF и другое состояние,
        которое должно быть загружено в начале кадра.
    * - struct :c:type:`v4l2_av1_loop_restoration`
      - ``loop_restoration``
      - Параметры восстановления контура.
    * - struct :c:type:`v4l2_av1_global_motion`
      - ``global_motion``
      - Параметры глобального движения.
    * - __u32
      - ``flags``
      - См.
        :ref:`Флаги кадра AV1 <av1_frame_flags>` для дополнительной информации.
    * - enum :c:type:`v4l2_av1_frame_type`
      - ``frame_type``
      - Задаёт тип кадра AV1
    * - __u32
      - ``order_hint``
      - Задаёт OrderHintBits младших значащих бит ожидаемого выходного
        порядка для этого кадра.
    * - __u32
      - ``upscaled_width``
      - Ширина после повышающего масштабирования.
    * - enum :c:type:`v4l2_av1_interpolation_filter`
      - ``interpolation_filter``
      - Задаёт выбор фильтра, используемого для выполнения межкадрового предсказания.
    * - enum :c:type:`v4l2_av1_tx_mode`
      - ``tx_mode``
      - Задаёт, как определяется размер преобразования.
    * - __u32
      - ``frame_width_minus_1``
      - Прибавьте 1, чтобы получить ширину кадра.
    * - __u32
      - ``frame_height_minus_1``
      - Прибавьте 1, чтобы получить высоту кадра.
    * - __u16
      - ``render_width_minus_1``
      - Прибавьте 1, чтобы получить ширину рендеринга кадра в отсчётах яркости.
    * - __u16
      - ``render_height_minus_1``
      - Прибавьте 1, чтобы получить высоту рендеринга кадра в отсчётах яркости.
    * - __u32
      - ``current_frame_id``
      - Задаёт номер идентификатора кадра для текущего кадра. Номера
        идентификаторов кадров — это дополнительная информация, которая не влияет на процесс
        декодирования, но предоставляет декодерам способ обнаружения отсутствующих опорных
        кадров, чтобы можно было предпринять соответствующие действия.
    * - __u8
      - ``buffer_removal_time[V4L2_AV1_MAX_OPERATING_POINTS]``
      - Задаёт время удаления кадра в единицах тактов DecCT clock, отсчитываемых
        от времени удаления последней точки произвольного доступа для рабочей точки
        opNum.
    * - __u8
      - ``reserved[4]``
      - Приложения и драйверы должны установить это в ноль.
    * - __u32
      - ``order_hints[V4L2_AV1_TOTAL_REFS_PER_FRAME]``
      - Задаёт ожидаемую выходную подсказку порядка для каждого опорного кадра.
        Это поле соответствует переменной OrderHints из спецификации
        (раздел 5.9.2  "Uncompressed header syntax"). Поэтому оно используется только
        для не-внутрикадровых кадров и игнорируется в остальных случаях. order_hints[0]
        всегда игнорируется.
    * - __u64
      - ``reference_frame_ts[V4L2_AV1_TOTAL_REFS_PER_FRAME]``
      - Временная метка V4L2 для каждого из опорных кадров, перечисленных в
        enum :c:type:`v4l2_av1_reference_frame`, начиная с
        ``V4L2_AV1_REF_LAST_FRAME``. Она представляет состояние опорного
        слота, как описано в спецификации, и обновляется пространством пользователя через
        "Reference frame update process" в разделе 7.20. Временная метка ссылается
        на поле ``timestamp`` в структуре :c:type:`v4l2_buffer`. Используйте
        функцию :c:func:`v4l2_timeval_to_ns()` для преобразования структуры
        :c:type:`timeval` в структуре :c:type:`v4l2_buffer` в __u64.
    * - __s8
      - ``ref_frame_idx[V4L2_AV1_REFS_PER_FRAME]``
      - Индекс в ``reference_frame_ts``, представляющий упорядоченный список
        опорных кадров, используемых межкадровым кадром. Соответствует синтаксическому
        элементу битового потока с тем же именем.
    * - __u8
      - ``refresh_frame_flags``
      - Содержит битовую маску, которая задаёт, какие слоты опорных кадров будут
        обновлены текущим кадром после его декодирования.

.. _av1_frame_flags:

``AV1 Frame Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_FRAME_FLAG_SHOW_FRAME``
      - 0x00000001
      - Если установлен, задаёт, что этот кадр должен быть немедленно выведен после
        декодирования. Если не установлен, задаёт, что этот кадр не должен быть немедленно
        выведен; он может быть выведен позже, если в последующем несжатом заголовке используется
        show_existing_frame, равный 1.
    * - ``V4L2_AV1_FRAME_FLAG_SHOWABLE_FRAME``
      - 0x00000002
      - Если установлен, задаёт, что кадр может быть выведен с помощью
        механизма show_existing_frame. Если не установлен, задаёт, что этот кадр
        не будет выведен с помощью механизма show_existing_frame.
    * - ``V4L2_AV1_FRAME_FLAG_ERROR_RESILIENT_MODE``
      - 0x00000004
      - Задаёт, включён ли режим устойчивости к ошибкам.
    * - ``V4L2_AV1_FRAME_FLAG_DISABLE_CDF_UPDATE``
      - 0x00000008
      - Задаёт, должно ли обновление CDF в процессе декодирования символов быть
        отключено.
    * - ``V4L2_AV1_FRAME_FLAG_ALLOW_SCREEN_CONTENT_TOOLS``
      - 0x00000010
      - Если установлен, указывает, что внутрикадровые блоки могут использовать палитровое кодирование. Если не
        установлен, указывает, что палитровое кодирование никогда не используется.
    * - ``V4L2_AV1_FRAME_FLAG_FORCE_INTEGER_MV``
      - 0x00000020
      - Если установлен, задаёт, что векторы движения всегда будут целочисленными. Если не
        установлен, задаёт, что векторы движения могут содержать дробные биты.
    * - ``V4L2_AV1_FRAME_FLAG_ALLOW_INTRABC``
      - 0x00000040
      - Если установлен, указывает, что в этом кадре может использоваться внутрикадровое копирование блоков (intra block copy). Если
        не установлен, указывает, что внутрикадровое копирование блоков не допускается в этом кадре.
    * - ``V4L2_AV1_FRAME_FLAG_USE_SUPERRES``
      - 0x00000080
      - Если установлен, указывает, что требуется повышающее масштабирование.
    * - ``V4L2_AV1_FRAME_FLAG_ALLOW_HIGH_PRECISION_MV``
      - 0x00000100
      - Если установлен, задаёт, что векторы движения задаются с точностью до одной восьмой пикселя
        (eighth pel). Если не установлен, задаёт, что векторы движения задаются с
        точностью до одной четверти пикселя (quarter pel);
    * - ``V4L2_AV1_FRAME_FLAG_IS_MOTION_MODE_SWITCHABLE``
      - 0x00000200
      - Если не установлен, задаёт, что будет использоваться только режим движения SIMPLE.
    * - ``V4L2_AV1_FRAME_FLAG_USE_REF_FRAME_MVS``
      - 0x00000400
      - Если установлен, задаёт, что информация о векторах движения из предыдущего кадра
        может использоваться при декодировании текущего кадра. Если не установлен, задаёт, что
        эта информация использоваться не будет.
    * - ``V4L2_AV1_FRAME_FLAG_DISABLE_FRAME_END_UPDATE_CDF``
      - 0x00000800
      - Если установлен, указывает, что обновление CDF в конце кадра отключено. Если не
        установлен, указывает, что обновление CDF в конце кадра включено
    * - ``V4L2_AV1_FRAME_FLAG_ALLOW_WARPED_MOTION``
      - 0x00001000
      - Если установлен, указывает, что синтаксический элемент motion_mode может присутствовать; если
        не установлен, указывает, что синтаксический элемент motion_mode не будет
        присутствовать.
    * - ``V4L2_AV1_FRAME_FLAG_REFERENCE_SELECT``
      - 0x00002000
      - Если установлен, задаёт, что информация о режиме для межкадровых блоков содержит
        синтаксический элемент comp_mode, который указывает, использовать ли одиночное или
        составное опорное предсказание. Если не установлен, задаёт, что все межкадровые
        блоки будут использовать одиночное предсказание.
    * - ``V4L2_AV1_FRAME_FLAG_REDUCED_TX_SET``
      - 0x00004000
      - Если установлен, задаёт, что кадр ограничен сокращённым подмножеством
        полного набора типов преобразований.
    * - ``V4L2_AV1_FRAME_FLAG_SKIP_MODE_ALLOWED``
      - 0x00008000
      - Этот флаг сохраняет тот же смысл, что и SkipModeAllowed в :ref:`av1`.
    * - ``V4L2_AV1_FRAME_FLAG_SKIP_MODE_PRESENT``
      - 0x00010000
      - Если установлен, задаёт, что синтаксический элемент skip_mode будет присутствовать; если
        не установлен, задаёт, что skip_mode не будет использоваться для этого кадра.
    * - ``V4L2_AV1_FRAME_FLAG_FRAME_SIZE_OVERRIDE``
      - 0x00020000
      - Если установлен, задаёт, что размер кадра будет либо задан как
        размер одного из опорных кадров, либо вычислен из
        синтаксических элементов frame_width_minus_1 и frame_height_minus_1. Если не
        установлен, задаёт, что размер кадра равен размеру в заголовке
        последовательности.
    * - ``V4L2_AV1_FRAME_FLAG_BUFFER_REMOVAL_TIME_PRESENT``
      - 0x00040000
      - Если установлен, задаёт, что buffer_removal_time присутствует. Если не установлен,
        задаёт, что buffer_removal_time отсутствует.
    * - ``V4L2_AV1_FRAME_FLAG_FRAME_REFS_SHORT_SIGNALING``
      - 0x00080000
      - Если установлен, указывает, что только два опорных кадра сигнализируются явно.
        Если не установлен, указывает, что все опорные кадры сигнализируются явно.

``V4L2_CID_STATELESS_AV1_FILM_GRAIN (struct)``
    Представляет необязательные параметры зернистости плёнки (film grain). См. раздел
    6.8.20 "Film grain params semantics" в :ref:`av1` для дополнительной информации.

.. c:type:: v4l2_ctrl_av1_film_grain

.. cssclass:: longtable

.. tabularcolumns:: |p{1.5cm}|p{5.8cm}|p{10.0cm}|

.. flat-table:: struct v4l2_ctrl_av1_film_grain
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - __u8
      - ``flags``
      - См. :ref:`Флаги зернистости плёнки AV1 <av1_film_grain_flags>`.
    * - __u8
      - ``cr_mult``
      - Представляет множитель для компонента cr, используемый при выводе
        входного индекса для функции масштабирования компонента cr.
    * - __u16
      - ``grain_seed``
      - Задаёт начальное значение для псевдослучайных чисел, используемых при
        синтезе зернистости плёнки.
    * - __u8
      - ``film_grain_params_ref_idx``
      - Указывает, какой опорный кадр содержит параметры зернистости плёнки, которые должны
	использоваться для этого кадра.
    * - __u8
      - ``num_y_points``
      - Задаёт число точек для кусочно-линейной функции масштабирования
        компонента яркости.
    * - __u8
      - ``point_y_value[V4L2_AV1_MAX_NUM_Y_POINTS]``
      - Представляет координату x (значение яркости) для i-й точки
        кусочно-линейной функции масштабирования для компонента яркости. Значения
        сигнализируются по шкале 0..255. В случае 10-битного видео эти
        значения соответствуют значениям яркости, делённым на 4. В случае 12-битного видео,
        эти значения соответствуют значениям яркости, делённым на 16.
    * - __u8
      - ``point_y_scaling[V4L2_AV1_MAX_NUM_Y_POINTS]``
      - Представляет значение масштабирования (выходное) для i-й точки
        кусочно-линейной функции масштабирования для компонента яркости.
    * - __u8
      - ``num_cb_points``
      -  Задаёт число точек для кусочно-линейной функции масштабирования
         компонента cb.
    * - __u8
      - ``point_cb_value[V4L2_AV1_MAX_NUM_CB_POINTS]``
      - Представляет координату x для i-й точки
        кусочно-линейной функции масштабирования для компонента cb. Значения
        сигнализируются по шкале 0..255.
    * - __u8
      - ``point_cb_scaling[V4L2_AV1_MAX_NUM_CB_POINTS]``
      - Представляет значение масштабирования (выходное) для i-й точки
        кусочно-линейной функции масштабирования для компонента cb.
    * - __u8
      - ``num_cr_points``
      - Представляет число точек для кусочно-линейной
        функции масштабирования компонента cr.
    * - __u8
      - ``point_cr_value[V4L2_AV1_MAX_NUM_CR_POINTS]``
      - Представляет координату x для i-й точки
        кусочно-линейной функции масштабирования для компонента cr. Значения
        сигнализируются по шкале 0..255.
    * - __u8
      - ``point_cr_scaling[V4L2_AV1_MAX_NUM_CR_POINTS]``
      - Представляет значение масштабирования (выходное) для i-й точки
        кусочно-линейной функции масштабирования для компонента cr.
    * - __u8
      - ``grain_scaling_minus_8``
      - Представляет сдвиг - 8, применённый к значениям компонента цветности.
        grain_scaling_minus_8 может принимать значения 0..3 и определяет
        диапазон и шаг квантования стандартного отклонения зернистости плёнки.
    * - __u8
      - ``ar_coeff_lag``
      - Задаёт число авторегрессионных коэффициентов для яркости и
        цветности.
    * - __u8
      - ``ar_coeffs_y_plus_128[V4L2_AV1_AR_COEFFS_SIZE]``
      - Задаёт авторегрессионные коэффициенты, используемые для плоскости Y.
    * - __u8
      - ``ar_coeffs_cb_plus_128[V4L2_AV1_AR_COEFFS_SIZE]``
      - Задаёт авторегрессионные коэффициенты, используемые для плоскости U.
    * - __u8
      - ``ar_coeffs_cr_plus_128[V4L2_AV1_AR_COEFFS_SIZE]``
      - Задаёт авторегрессионные коэффициенты, используемые для плоскости V.
    * - __u8
      - ``ar_coeff_shift_minus_6``
      - Задаёт диапазон авторегрессионных коэффициентов. Значения 0,
        1, 2 и 3 соответствуют диапазонам авторегрессионных коэффициентов
        [-2, 2), [-1, 1), [-0.5, 0.5) и [-0.25, 0.25) соответственно.
    * - __u8
      - ``grain_scale_shift``
      - Задаёт, насколько гауссовы случайные числа должны быть уменьшены
        в процессе синтеза зернистости.
    * - __u8
      - ``cb_mult``
      - Представляет множитель для компонента cb, используемый при выводе
        входного индекса для функции масштабирования компонента cb.
    * - __u8
      - ``cb_luma_mult``
      - Представляет множитель для среднего компонента яркости, используемый при
        выводе входного индекса для функции масштабирования компонента cb.
    * - __u8
      - ``cr_luma_mult``
      - Представляет множитель для среднего компонента яркости, используемый при
        выводе входного индекса для функции масштабирования компонента cr.
    * - __u16
      - ``cb_offset``
      - Представляет смещение, используемое при выводе входного индекса для
        функции масштабирования компонента cb.
    * - __u16
      - ``cr_offset``
      - Представляет смещение, используемое при выводе входного индекса для
        функции масштабирования компонента cr.
    * - __u8
      - ``reserved[4]``
      - Приложения и драйверы должны установить это в ноль.

.. _av1_film_grain_flags:

``AV1 Film Grain Flags``

.. cssclass:: longtable

.. flat-table::
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    * - ``V4L2_AV1_FILM_GRAIN_FLAG_APPLY_GRAIN``
      - 0x00000001
      - Если установлен, задаёт, что к этому кадру должна быть добавлена зернистость плёнки. Если не
        установлен, задаёт, что зернистость плёнки добавляться не должна.
    * - ``V4L2_AV1_FILM_GRAIN_FLAG_UPDATE_GRAIN``
      - 0x00000002
      - Если установлен, означает, что должен быть отправлен новый набор параметров. Если не установлен,
        задаёт, что должен использоваться предыдущий набор параметров.
    * - ``V4L2_AV1_FILM_GRAIN_FLAG_CHROMA_SCALING_FROM_LUMA``
      - 0x00000004
      - Если установлен, задаёт, что масштабирование цветности выводится из масштабирования
        яркости.
    * - ``V4L2_AV1_FILM_GRAIN_FLAG_OVERLAP``
      - 0x00000008
      - Если установлен, указывает, что должно применяться перекрытие между блоками зернистости плёнки.
        Если не установлен, указывает, что перекрытие между блоками зернистости плёнки
        применяться не должно.
    * - ``V4L2_AV1_FILM_GRAIN_FLAG_CLIP_TO_RESTRICTED_RANGE``
      - 0x00000010
      - Если установлен, указывает, что к значениям отсчётов после добавления зернистости плёнки
        должно применяться ограничение (clipping) до ограниченного (студийного, то есть limited)
        диапазона (см. семантику для color_range для объяснения студийного размаха).
        Если не установлен, указывает, что к значениям отсчётов после добавления зернистости плёнки
        должно применяться ограничение до полного диапазона.