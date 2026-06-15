.. SPDX-License-Identifier: GPL-2.0

==================================================================
API символьного устройства GPIO для пространства пользователя (v1)
==================================================================

.. warning::
   Этот API устарел и заменён chardev.rst (v2).

   Новые разработки должны использовать API v2, а существующим разработкам
   рекомендуется как можно скорее перейти на него, так как этот API будет
   удалён в будущем. API v2 является функциональным надмножеством API v1,
   поэтому любой вызов v1 может быть напрямую преобразован в эквивалент v2.

   Этот интерфейс будет продолжать поддерживаться на время переходного
   периода, но новая функциональность будет добавляться только в новый API.

Впервые добавлен в 4.8.

API построен вокруг трёх основных объектов: :ref:`gpio-v1-chip`,
:ref:`gpio-v1-line-handle` и :ref:`gpio-v1-line-event`.

Там, где в этом документе используется термин «line event» (событие линии),
он относится к запросу, который может отслеживать линию на предмет событий
фронта (edge events), а не к самим событиям фронта.

.. _gpio-v1-chip:

Chip
====

Chip представляет собой одну микросхему GPIO и предоставляется пространству
пользователя через файлы устройств вида ``/dev/gpiochipX``.

Каждая микросхема поддерживает некоторое число линий GPIO,
:c:type:`chip.lines<gpiochip_info>`. Линии на микросхеме идентифицируются
по ``offset`` в диапазоне от 0 до ``chip.lines - 1``, то есть `[0,chip.lines)`.

Линии запрашиваются у микросхемы либо с помощью gpio-get-linehandle-ioctl.rst,
и получаемый дескриптор линии (line handle) используется для доступа к линиям
микросхемы GPIO, либо с помощью gpio-get-lineevent-ioctl.rst, и получаемое
событие линии (line event) используется для отслеживания линии GPIO на предмет
событий фронта.

В рамках этой документации файловый дескриптор, возвращаемый при вызове `open()`
для файла устройства GPIO, называется ``chip_fd``.

Операции
--------

С микросхемой могут выполняться следующие операции:

.. toctree::
   :titlesonly:

   Get Line Handle <gpio-get-linehandle-ioctl>
   Get Line Event <gpio-get-lineevent-ioctl>
   Get Chip Info <gpio-get-chipinfo-ioctl>
   Get Line Info <gpio-get-lineinfo-ioctl>
   Watch Line Info <gpio-get-lineinfo-watch-ioctl>
   Unwatch Line Info <gpio-get-lineinfo-unwatch-ioctl>
   Read Line Info Changed Events <gpio-lineinfo-changed-read>

.. _gpio-v1-line-handle:

Line Handle
===========

Дескрипторы линий (line handle) создаются с помощью
gpio-get-linehandle-ioctl.rst и предоставляют доступ к набору запрошенных
линий.  Дескриптор линии предоставляется пространству пользователя через
анонимный файловый дескриптор, возвращаемый в
:c:type:`request.fd<gpiohandle_request>` функцией gpio-get-linehandle-ioctl.rst.

В рамках этой документации файловый дескриптор дескриптора линии называется
``handle_fd``.

Операции
--------

С дескриптором линии могут выполняться следующие операции:

.. toctree::
   :titlesonly:

   Get Line Values <gpio-handle-get-line-values-ioctl>
   Set Line Values <gpio-handle-set-line-values-ioctl>
   Reconfigure Lines <gpio-handle-set-config-ioctl>

.. _gpio-v1-line-event:

Line Event
==========

События линий (line event) создаются с помощью gpio-get-lineevent-ioctl.rst
и предоставляют доступ к запрошенной линии.  Событие линии предоставляется
пространству пользователя через анонимный файловый дескриптор, возвращаемый в
:c:type:`request.fd<gpioevent_request>` функцией gpio-get-lineevent-ioctl.rst.

В рамках этой документации файловый дескриптор события линии называется
``event_fd``.

Операции
--------

С событием линии могут выполняться следующие операции:

.. toctree::
   :titlesonly:

   Get Line Value <gpio-handle-get-line-values-ioctl>
   Read Line Edge Events <gpio-lineevent-data-read>

Типы
====

Этот раздел содержит структуры, на которые ссылается ABI v1.

:c:type:`struct gpiochip_info<gpiochip_info>` является общей для ABI v1 и v2.

.. kernel-doc:: include/uapi/linux/gpio.h
   :identifiers:
    gpioevent_data
    gpioevent_request
    gpiohandle_config
    gpiohandle_data
    gpiohandle_request
    gpioline_info
    gpioline_info_changed

.. toctree::
   :hidden:

   error-codes
