.. SPDX-License-Identifier: GPL-2.0

=============================================================
API символьного устройства GPIO для пространства пользователя
=============================================================

Это последняя версия (v2) API символьного устройства, как она определена в
``include/uapi/linux/gpio.h.``

Впервые добавлена в 5.10.

.. note::
   НЕ злоупотребляйте API пространства пользователя для управления аппаратурой,
   у которой есть полноценные драйверы ядра. Возможно, для вашего сценария
   использования драйвер уже существует, и имеющийся драйвер ядра наверняка
   предоставит более качественное решение, чем дёрганье битов из пространства
   пользователя.

   Прочитайте Documentation/driver-api/gpio/drivers-on-gpio.rst, чтобы не
   изобретать заново велосипеды ядра в пространстве пользователя.

   Аналогично, для многофункциональных линий могут существовать другие
   подсистемы, такие как Documentation/spi/index.rst, Documentation/i2c/index.rst,
   Documentation/driver-api/pwm.rst, Documentation/w1/index.rst и т. д., которые
   предоставляют подходящие драйверы и API для вашего оборудования.

Базовые примеры использования API символьного устройства можно найти в ``tools/gpio/*``.

API построен вокруг двух основных объектов: :ref:`gpio-v2-chip` и
:ref:`gpio-v2-line-request`.

.. _gpio-v2-chip:

Чип
===

Чип (Chip) представляет один GPIO-чип и предоставляется пространству пользователя
с помощью файлов устройств вида ``/dev/gpiochipX``.

Каждый чип поддерживает некоторое количество GPIO-линий,
:c:type:`chip.lines<gpiochip_info>`. Линии на чипе идентифицируются по смещению
``offset`` в диапазоне от 0 до ``chip.lines - 1``, то есть `[0,chip.lines)`.

Линии запрашиваются у чипа с помощью gpio-v2-get-line-ioctl.rst, и полученный
запрос линий используется для доступа к линиям GPIO-чипа или для отслеживания
краевых событий на линиях.

В рамках данной документации файловый дескриптор, возвращаемый при вызове `open()`
для файла GPIO-устройства, называется ``chip_fd``.

Операции
--------

Над чипом могут выполняться следующие операции:

.. toctree::
   :titlesonly:

   Получить линию <gpio-v2-get-line-ioctl>
   Получить информацию о чипе <gpio-get-chipinfo-ioctl>
   Получить информацию о линии <gpio-v2-get-lineinfo-ioctl>
   Отслеживать информацию о линии <gpio-v2-get-lineinfo-watch-ioctl>
   Прекратить отслеживание информации о линии <gpio-get-lineinfo-unwatch-ioctl>
   Чтение событий изменения информации о линии <gpio-v2-lineinfo-changed-read>

.. _gpio-v2-line-request:

Запрос линий
============

Запросы линий создаются с помощью gpio-v2-get-line-ioctl.rst и предоставляют
доступ к набору запрошенных линий.  Запрос линий предоставляется пространству
пользователя через анонимный файловый дескриптор, возвращаемый в
:c:type:`request.fd<gpio_v2_line_request>` вызовом gpio-v2-get-line-ioctl.rst.

В рамках данной документации файловый дескриптор запроса линий называется
``req_fd``.

Операции
--------

Над запросом линий могут выполняться следующие операции:

.. toctree::
   :titlesonly:

   Получить значения линий <gpio-v2-line-get-values-ioctl>
   Установить значения линий <gpio-v2-line-set-values-ioctl>
   Чтение краевых событий линий <gpio-v2-line-event-read>
   Переконфигурировать линии <gpio-v2-line-set-config-ioctl>

Типы
====

Этот раздел содержит структуры и перечисления, на которые ссылается API v2, как
они определены в ``include/uapi/linux/gpio.h``.

.. kernel-doc:: include/uapi/linux/gpio.h
   :identifiers:
    gpio_v2_line_attr_id
    gpio_v2_line_attribute
    gpio_v2_line_changed_type
    gpio_v2_line_config
    gpio_v2_line_config_attribute
    gpio_v2_line_event
    gpio_v2_line_event_id
    gpio_v2_line_flag
    gpio_v2_line_info
    gpio_v2_line_info_changed
    gpio_v2_line_request
    gpio_v2_line_values
    gpiochip_info

.. toctree::
   :hidden:

   error-codes
