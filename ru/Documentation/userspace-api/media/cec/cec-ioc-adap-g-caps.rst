.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: CEC

.. _CEC_ADAP_G_CAPS:

*********************
ioctl CEC_ADAP_G_CAPS
*********************

Имя
===

CEC_ADAP_G_CAPS - Запрос возможностей устройства

Обзор
=====

.. c:macro:: CEC_ADAP_G_CAPS

``int ioctl(int fd, CEC_ADAP_G_CAPS, struct cec_caps *argp)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращаемый :c:func:`open()`.

``argp``

Описание
========

Все устройства cec обязаны поддерживать :ref:`ioctl CEC_ADAP_G_CAPS <CEC_ADAP_G_CAPS>`. Чтобы
запросить информацию об устройстве, приложения вызывают этот ioctl с указателем на
структуру :c:type:`cec_caps`. Драйвер заполняет структуру и
возвращает информацию приложению. Этот ioctl никогда не завершается с ошибкой.

.. tabularcolumns:: |p{1.2cm}|p{2.5cm}|p{13.6cm}|

.. c:type:: cec_caps

.. flat-table:: struct cec_caps
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 16

    * - char
      - ``driver[32]``
      - Имя драйвера адаптера cec.
    * - char
      - ``name[32]``
      - Имя данного адаптера CEC. Сочетание ``driver`` и
	``name`` должно быть уникальным.
    * - __u32
      - ``available_log_addrs``
      - Максимальное количество логических адресов, которые можно настроить.
    * - __u32
      - ``capabilities``
      - Возможности адаптера CEC, см.
	:ref:`cec-capabilities`.
    * - __u32
      - ``version``
      - Версия API фреймворка CEC, отформатированная с помощью макроса
	``KERNEL_VERSION()``.

.. tabularcolumns:: |p{4.4cm}|p{2.5cm}|p{10.4cm}|

.. _cec-capabilities:

.. flat-table:: Флаги возможностей CEC
    :header-rows:  0
    :stub-columns: 0
    :widths:       3 1 8

    * .. _`CEC-CAP-PHYS-ADDR`:

      - ``CEC_CAP_PHYS_ADDR``
      - 0x00000001
      - Пространство пользователя (userspace) должно настроить физический адрес, вызвав
	:ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>`. Если
	эта возможность не установлена, то установка физического адреса
	выполняется ядром всякий раз, когда EDID устанавливается (для приёмника
	HDMI) или считывается (для передатчика HDMI).
    * .. _`CEC-CAP-LOG-ADDRS`:

      - ``CEC_CAP_LOG_ADDRS``
      - 0x00000002
      - Пространство пользователя (userspace) должно настроить логические адреса, вызвав
	:ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`. Если
	эта возможность не установлена, то это настроит
	ядро.
    * .. _`CEC-CAP-TRANSMIT`:

      - ``CEC_CAP_TRANSMIT``
      - 0x00000004
      - Пространство пользователя (userspace) может передавать сообщения CEC, вызвав
	:ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`. Это подразумевает, что
	userspace также может быть последователем (follower), поскольку способность передавать
	сообщения является обязательным условием для того, чтобы стать последователем. Если эта
	возможность не установлена, то ядро будет обрабатывать все передачи
	CEC и обрабатывать все получаемые им сообщения CEC.
    * .. _`CEC-CAP-PASSTHROUGH`:

      - ``CEC_CAP_PASSTHROUGH``
      - 0x00000008
      - Пространство пользователя (userspace) может использовать сквозной режим (passthrough), вызвав
	:ref:`ioctl CEC_S_MODE <CEC_S_MODE>`.
    * .. _`CEC-CAP-RC`:

      - ``CEC_CAP_RC``
      - 0x00000010
      - Данный адаптер поддерживает протокол дистанционного управления.
    * .. _`CEC-CAP-MONITOR-ALL`:

      - ``CEC_CAP_MONITOR_ALL``
      - 0x00000020
      - Оборудование CEC может отслеживать все сообщения, а не только адресованные и
	широковещательные сообщения.
    * .. _`CEC-CAP-NEEDS-HPD`:

      - ``CEC_CAP_NEEDS_HPD``
      - 0x00000040
      - Оборудование CEC активно только тогда, когда вывод HDMI Hotplug Detect находится в
        высоком состоянии. Это делает невозможным использование CEC для пробуждения дисплеев, которые
	устанавливают вывод HPD в низкое состояние в режиме ожидания, но сохраняют шину CEC
	активной.
    * .. _`CEC-CAP-MONITOR-PIN`:

      - ``CEC_CAP_MONITOR_PIN``
      - 0x00000080
      - Оборудование CEC может отслеживать изменения вывода CEC с низкого на высокое напряжение
        и наоборот. В режиме отслеживания вывода приложение будет
	получать события ``CEC_EVENT_PIN_CEC_LOW`` и ``CEC_EVENT_PIN_CEC_HIGH``.
    * .. _`CEC-CAP-CONNECTOR-INFO`:

      - ``CEC_CAP_CONNECTOR_INFO``
      - 0x00000100
      - Если эта возможность установлена, то можно использовать :ref:`CEC_ADAP_G_CONNECTOR_INFO`.
    * .. _`CEC-CAP-REPLY-VENDOR-ID`:

      - ``CEC_CAP_REPLY_VENDOR_ID``
      - 0x00000200
      - Если эта возможность установлена, то можно использовать
        :ref:`CEC_MSG_FL_REPLY_VENDOR_ID <cec-msg-flags>`.

Возвращаемое значение
=====================

При успехе возвращается 0, при ошибке -1, и переменная ``errno`` устанавливается
соответствующим образом. Общие коды ошибок описаны в главе
:ref:`Generic Error Codes <gen-errors>`.
