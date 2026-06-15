.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: CEC

.. _CEC_ADAP_LOG_ADDRS:
.. _CEC_ADAP_G_LOG_ADDRS:
.. _CEC_ADAP_S_LOG_ADDRS:

****************************************************
ioctl'ы CEC_ADAP_G_LOG_ADDRS и CEC_ADAP_S_LOG_ADDRS
****************************************************

Имя
===

CEC_ADAP_G_LOG_ADDRS, CEC_ADAP_S_LOG_ADDRS - Получить или задать логические адреса

Краткое описание
=================

.. c:macro:: CEC_ADAP_G_LOG_ADDRS

``int ioctl(int fd, CEC_ADAP_G_LOG_ADDRS, struct cec_log_addrs *argp)``

.. c:macro:: CEC_ADAP_S_LOG_ADDRS

``int ioctl(int fd, CEC_ADAP_S_LOG_ADDRS, struct cec_log_addrs *argp)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращаемый :c:func:`open()`.

``argp``
    Указатель на struct :c:type:`cec_log_addrs`.

Описание
========

Чтобы запросить текущие логические адреса CEC, приложения вызывают
:ref:`ioctl CEC_ADAP_G_LOG_ADDRS <CEC_ADAP_G_LOG_ADDRS>` с указателем на
struct :c:type:`cec_log_addrs`, в которую драйвер записывает логические адреса.

Чтобы задать новые логические адреса, приложения заполняют
struct :c:type:`cec_log_addrs` и вызывают :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
с указателем на эту структуру. :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
доступен только если установлен ``CEC_CAP_LOG_ADDRS`` (иначе возвращается код
ошибки ``ENOTTY``). :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
может вызываться только файловым дескриптором в режиме инициатора (см. :ref:`CEC_S_MODE`); в противном
случае будет возвращён код ошибки ``EBUSY``.

Чтобы очистить существующие логические адреса, установите ``num_log_addrs`` в 0. Все остальные поля
в этом случае будут проигнорированы. Адаптер перейдёт в неконфигурированное состояние, а поля
``cec_version``, ``vendor_id`` и ``osd_name`` будут сброшены в значения по умолчанию
(CEC версии 2.0, отсутствие vendor ID и пустое имя OSD).

Если физический адрес корректен (см. :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>`),
то этот ioctl будет блокироваться до тех пор, пока не будут заняты все запрошенные логические
адреса. Если файловый дескриптор находится в неблокирующем режиме, то он не будет ожидать
занятия логических адресов, а просто вернёт 0.

Событие :ref:`CEC_EVENT_STATE_CHANGE <CEC-EVENT-STATE-CHANGE>` отправляется, когда
логические адреса заняты или очищены.

Попытка вызвать :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`, когда
типы логических адресов уже определены, завершится с ошибкой ``EBUSY``.

.. c:type:: cec_log_addrs

.. tabularcolumns:: |p{1.0cm}|p{8.0cm}|p{8.0cm}|

.. cssclass:: longtable

.. flat-table:: struct cec_log_addrs
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 16

    * - __u8
      - ``log_addr[CEC_MAX_LOG_ADDRS]``
      - Фактические логические адреса, которые были заняты. Устанавливается
	драйвером. Если ни один логический адрес не удалось занять, то полю присваивается
	``CEC_LOG_ADDR_INVALID``. Если данный адаптер находится в состоянии Unregistered, то
	``log_addr[0]`` устанавливается в 0xf, а все остальные — в
	``CEC_LOG_ADDR_INVALID``.
    * - __u16
      - ``log_addr_mask``
      - Битовая маска всех логических адресов, занятых этим адаптером. Если
	данный адаптер находится в состоянии Unregistered, то ``log_addr_mask`` устанавливает бит 15
	и сбрасывает все остальные биты. Если данный адаптер вообще не сконфигурирован,
	то ``log_addr_mask`` устанавливается в 0. Устанавливается драйвером.
    * - __u8
      - ``cec_version``
      - Версия CEC, которую должен использовать данный адаптер. См.
	:ref:`cec-versions`. Используется для реализации сообщений
	``CEC_MSG_CEC_VERSION`` и ``CEC_MSG_REPORT_FEATURES``.
	Обратите внимание, что :ref:`CEC_OP_CEC_VERSION_1_3A <CEC-OP-CEC-VERSION-1-3A>` не разрешена
	фреймворком CEC.
    * - __u8
      - ``num_log_addrs``
      - Количество логических адресов для настройки. Должно быть ≤
	``available_log_addrs``, возвращаемого
	:ref:`CEC_ADAP_G_CAPS`. Все массивы в
	этой структуре заполняются только до индекса
	``available_log_addrs``-1. Остальные элементы массива будут
	проигнорированы. Обратите внимание, что стандарт CEC 2.0 допускает максимум 2
	логических адреса, хотя некоторое оборудование поддерживает больше.
	``CEC_MAX_LOG_ADDRS`` равно 4. Драйвер вернёт фактическое
	количество логических адресов, которые он смог занять, и оно может быть меньше
	запрошенного. Если это поле установлено в 0, то адаптер CEC
	должен очистить все занятые логические адреса, а все остальные
	поля будут проигнорированы.
    * - __u32
      - ``vendor_id``
      - Vendor ID — это 24-битное число, идентифицирующее конкретного
	производителя или организацию. На основе этого ID могут быть определены команды,
	специфичные для производителя. Если vendor ID не требуется, установите его в
	``CEC_VENDOR_ID_NONE``.
    * - __u32
      - ``flags``
      - Флаги. См. :ref:`cec-log-addrs-flags` для списка доступных флагов.
    * - char
      - ``osd_name[15]``
      - Имя On-Screen Display, возвращаемое сообщением
	``CEC_MSG_SET_OSD_NAME``.
    * - __u8
      - ``primary_device_type[CEC_MAX_LOG_ADDRS]``
      - Первичный тип устройства для каждого логического адреса. См.
	:ref:`cec-prim-dev-types` для возможных типов.
    * - __u8
      - ``log_addr_type[CEC_MAX_LOG_ADDRS]``
      - Типы логических адресов. См. :ref:`cec-log-addr-types` для
	возможных типов. Драйвер обновит это поле фактическим
	типом логического адреса, который он занял (например, ему может потребоваться откатиться
	к :ref:`CEC_LOG_ADDR_TYPE_UNREGISTERED <CEC-LOG-ADDR-TYPE-UNREGISTERED>`).
    * - __u8
      - ``all_device_types[CEC_MAX_LOG_ADDRS]``
      - Специфично для CEC 2.0: битовая маска всех типов устройств. См.
	:ref:`cec-all-dev-types-flags`. Используется в сообщении CEC 2.0
	``CEC_MSG_REPORT_FEATURES``. Для CEC 1.4 вы можете либо оставить
	это поле равным 0, либо заполнить его согласно рекомендациям CEC 2.0, чтобы
	предоставить фреймворку CEC больше информации о типе устройства, даже
	если фреймворк не будет использовать её напрямую в сообщении CEC.
    * - __u8
      - ``features[CEC_MAX_LOG_ADDRS][12]``
      - Возможности (features) для каждого логического адреса. Используется в сообщении CEC 2.0
	``CEC_MSG_REPORT_FEATURES``. Эти 12 байт включают как
	RC Profile, так и Device Features. Для CEC 1.4 вы можете либо оставить
        это поле полностью равным 0, либо заполнить его согласно рекомендациям CEC 2.0, чтобы
        предоставить фреймворку CEC больше информации о типе устройства, даже
        если фреймворк не будет использовать её напрямую в сообщении CEC.

.. tabularcolumns:: |p{7.8cm}|p{1.0cm}|p{8.5cm}|

.. _cec-log-addrs-flags:

.. flat-table:: Флаги для struct cec_log_addrs
    :header-rows:  0
    :stub-columns: 0
    :widths:       3 1 4

    * .. _`CEC-LOG-ADDRS-FL-ALLOW-UNREG-FALLBACK`:

      - ``CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK``
      - 1
      - По умолчанию, если ни один логический адрес запрошенного типа не удаётся занять, то
	адаптер вернётся в неконфигурированное состояние. Если этот флаг установлен, то он
	откатится к логическому адресу Unregistered. Обратите внимание, что если логический адрес
	Unregistered был запрошен явно, то этот флаг не имеет эффекта.
    * .. _`CEC-LOG-ADDRS-FL-ALLOW-RC-PASSTHRU`:

      - ``CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU``
      - 2
      - По умолчанию сообщения ``CEC_MSG_USER_CONTROL_PRESSED`` и ``CEC_MSG_USER_CONTROL_RELEASED``
        передаются только подписчикам (follower'ам), если они есть. Если этот флаг установлен,
	то эти сообщения также передаются в подсистему ввода с пульта дистанционного управления
	и будут выглядеть как нажатия клавиш. Эту функциональность необходимо включать явно.
	Если CEC используется, например, для ввода паролей, то вы можете не захотеть включать это,
	чтобы избежать тривиального перехвата нажатий клавиш.
    * .. _`CEC-LOG-ADDRS-FL-CDC-ONLY`:

      - ``CEC_LOG_ADDRS_FL_CDC_ONLY``
      - 4
      - Если этот флаг установлен, то устройство является CDC-Only. CDC-Only-устройства CEC —
	это устройства CEC, которые могут обрабатывать только сообщения CDC.

	Все остальные сообщения игнорируются.

.. tabularcolumns:: |p{7.8cm}|p{1.0cm}|p{8.5cm}|

.. _cec-versions:

.. flat-table:: Версии CEC
    :header-rows:  0
    :stub-columns: 0
    :widths:       3 1 4

    * .. _`CEC-OP-CEC-VERSION-1-3A`:

      - ``CEC_OP_CEC_VERSION_1_3A``
      - 4
      - Версия CEC согласно стандарту HDMI 1.3a.
    * .. _`CEC-OP-CEC-VERSION-1-4B`:

      - ``CEC_OP_CEC_VERSION_1_4B``
      - 5
      - Версия CEC согласно стандарту HDMI 1.4b.
    * .. _`CEC-OP-CEC-VERSION-2-0`:

      - ``CEC_OP_CEC_VERSION_2_0``
      - 6
      - Версия CEC согласно стандарту HDMI 2.0.

.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.5cm}|

.. _cec-prim-dev-types:

.. flat-table:: Первичные типы устройств CEC
    :header-rows:  0
    :stub-columns: 0
    :widths:       3 1 4

    * .. _`CEC-OP-PRIM-DEVTYPE-TV`:

      - ``CEC_OP_PRIM_DEVTYPE_TV``
      - 0
      - Использовать для телевизора.
    * .. _`CEC-OP-PRIM-DEVTYPE-RECORD`:

      - ``CEC_OP_PRIM_DEVTYPE_RECORD``
      - 1
      - Использовать для записывающего устройства.
    * .. _`CEC-OP-PRIM-DEVTYPE-TUNER`:

      - ``CEC_OP_PRIM_DEVTYPE_TUNER``
      - 3
      - Использовать для устройства с тюнером.
    * .. _`CEC-OP-PRIM-DEVTYPE-PLAYBACK`:

      - ``CEC_OP_PRIM_DEVTYPE_PLAYBACK``
      - 4
      - Использовать для устройства воспроизведения.
    * .. _`CEC-OP-PRIM-DEVTYPE-AUDIOSYSTEM`:

      - ``CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM``
      - 5
      - Использовать для аудиосистемы (например, аудио/видео-ресивера).
    * .. _`CEC-OP-PRIM-DEVTYPE-SWITCH`:

      - ``CEC_OP_PRIM_DEVTYPE_SWITCH``
      - 6
      - Использовать для коммутатора CEC.
    * .. _`CEC-OP-PRIM-DEVTYPE-VIDEOPROC`:

      - ``CEC_OP_PRIM_DEVTYPE_VIDEOPROC``
      - 7
      - Использовать для устройства обработки видео.

.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.5cm}|

.. _cec-log-addr-types:

.. flat-table:: Типы логических адресов CEC
    :header-rows:  0
    :stub-columns: 0
    :widths:       3 1 16

    * .. _`CEC-LOG-ADDR-TYPE-TV`:

      - ``CEC_LOG_ADDR_TYPE_TV``
      - 0
      - Использовать для телевизора.
    * .. _`CEC-LOG-ADDR-TYPE-RECORD`:

      - ``CEC_LOG_ADDR_TYPE_RECORD``
      - 1
      - Использовать для записывающего устройства.
    * .. _`CEC-LOG-ADDR-TYPE-TUNER`:

      - ``CEC_LOG_ADDR_TYPE_TUNER``
      - 2
      - Использовать для устройства-тюнера.
    * .. _`CEC-LOG-ADDR-TYPE-PLAYBACK`:

      - ``CEC_LOG_ADDR_TYPE_PLAYBACK``
      - 3
      - Использовать для устройства воспроизведения.
    * .. _`CEC-LOG-ADDR-TYPE-AUDIOSYSTEM`:

      - ``CEC_LOG_ADDR_TYPE_AUDIOSYSTEM``
      - 4
      - Использовать для устройства-аудиосистемы.
    * .. _`CEC-LOG-ADDR-TYPE-SPECIFIC`:

      - ``CEC_LOG_ADDR_TYPE_SPECIFIC``
      - 5
      - Использовать для второго телевизора или для устройства обработки видео.
    * .. _`CEC-LOG-ADDR-TYPE-UNREGISTERED`:

      - ``CEC_LOG_ADDR_TYPE_UNREGISTERED``
      - 6
      - Использовать, если вы просто хотите остаться незарегистрированным. Используется для чистых
	коммутаторов CEC или устройств CDC-only (CDC: Capability Discovery and
	Control).


.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.5cm}|

.. _cec-all-dev-types-flags:

.. flat-table:: Флаги всех типов устройств CEC
    :header-rows:  0
    :stub-columns: 0
    :widths:       3 1 4

    * .. _`CEC-OP-ALL-DEVTYPE-TV`:

      - ``CEC_OP_ALL_DEVTYPE_TV``
      - 0x80
      - Поддерживает тип TV.
    * .. _`CEC-OP-ALL-DEVTYPE-RECORD`:

      - ``CEC_OP_ALL_DEVTYPE_RECORD``
      - 0x40
      - Поддерживает тип Recording.
    * .. _`CEC-OP-ALL-DEVTYPE-TUNER`:

      - ``CEC_OP_ALL_DEVTYPE_TUNER``
      - 0x20
      - Поддерживает тип Tuner.
    * .. _`CEC-OP-ALL-DEVTYPE-PLAYBACK`:

      - ``CEC_OP_ALL_DEVTYPE_PLAYBACK``
      - 0x10
      - Поддерживает тип Playback.
    * .. _`CEC-OP-ALL-DEVTYPE-AUDIOSYSTEM`:

      - ``CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM``
      - 0x08
      - Поддерживает тип Audio System.
    * .. _`CEC-OP-ALL-DEVTYPE-SWITCH`:

      - ``CEC_OP_ALL_DEVTYPE_SWITCH``
      - 0x04
      - Поддерживает тип CEC Switch или Video Processing.


Возвращаемое значение
=====================

При успехе возвращается 0, при ошибке -1, а переменная ``errno`` устанавливается
соответствующим образом. Общие коды ошибок описаны в главе
:ref:`Generic Error Codes <gen-errors>`.

:ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>` может вернуть следующие
коды ошибок:

ENOTTY
    Возможность ``CEC_CAP_LOG_ADDRS`` не была установлена, поэтому этот ioctl не поддерживается.

EBUSY
    Адаптер CEC в данный момент конфигурирует себя, либо он уже сконфигурирован и
    ``num_log_addrs`` отлично от нуля, либо другой файловый дескриптор находится в эксклюзивном режиме
    подписчика или инициатора, либо файловый дескриптор находится в режиме ``CEC_MODE_NO_INITIATOR``.

EINVAL
    Содержимое struct :c:type:`cec_log_addrs` некорректно.
