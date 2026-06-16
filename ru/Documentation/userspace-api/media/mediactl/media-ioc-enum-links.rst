.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: MC

.. _media_ioc_enum_links:

**************************
ioctl MEDIA_IOC_ENUM_LINKS
**************************

Имя
===

MEDIA_IOC_ENUM_LINKS - Перечисление всех контактов (pad) и связей (link) для заданной сущности

Синопсис
========

.. c:macro:: MEDIA_IOC_ENUM_LINKS

``int ioctl(int fd, MEDIA_IOC_ENUM_LINKS, struct media_links_enum *argp)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращённый :c:func:`open()`.

``argp``
    Указатель на struct :c:type:`media_links_enum`.

Описание
========

Чтобы перечислить контакты (pad) и/или связи (link) для заданной сущности,
приложения задают поле entity структуры struct :c:type:`media_links_enum`
и инициализируют массивы структур struct
:c:type:`media_pad_desc` и struct
:c:type:`media_link_desc`, на которые указывают
поля ``pads`` и ``links``. Затем они вызывают
ioctl MEDIA_IOC_ENUM_LINKS с указателем на эту структуру.

Если поле ``pads`` не равно NULL, драйвер заполняет массив ``pads``
информацией о контактах сущности. Массив должен иметь достаточно
места для хранения всех контактов сущности. Количество контактов можно получить
с помощью :ref:`MEDIA_IOC_ENUM_ENTITIES`.

Если поле ``links`` не равно NULL, драйвер заполняет массив ``links``
информацией об исходящих связях сущности. Массив должен иметь
достаточно места для хранения всех исходящих связей сущности. Количество
исходящих связей можно получить с помощью :ref:`MEDIA_IOC_ENUM_ENTITIES`.

В процессе перечисления возвращаются только прямые связи, исходящие из одного
из контактов-источников (source pad) сущности.

.. c:type:: media_links_enum

.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.5cm}|

.. flat-table:: struct media_links_enum
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    *  -  __u32
       -  ``entity``
       -  Идентификатор сущности, задаваемый приложением.

    *  -  struct :c:type:`media_pad_desc`
       -  \*\ ``pads``
       -  Указатель на массив контактов, выделенный приложением. Игнорируется, если
	  NULL.

    *  -  struct :c:type:`media_link_desc`
       -  \*\ ``links``
       -  Указатель на массив связей, выделенный приложением. Игнорируется, если
	  NULL.

    *  -  __u32
       -  ``reserved[4]``
       -  Зарезервировано для будущих расширений. Драйверы и приложения должны
          обнулить этот массив.

.. c:type:: media_pad_desc

.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.5cm}|

.. flat-table:: struct media_pad_desc
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    *  -  __u32
       -  ``entity``
       -  Идентификатор сущности, которой принадлежит этот контакт.

    *  -  __u16
       -  ``index``
       -  Индекс контакта, отсчёт начинается с 0.

    *  -  __u32
       -  ``flags``
       -  Флаги контакта, подробнее см. :ref:`media-pad-flag`.

    *  -  __u32
       -  ``reserved[2]``
       -  Зарезервировано для будущих расширений. Драйверы и приложения должны
          обнулить этот массив.


.. c:type:: media_link_desc

.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.5cm}|

.. flat-table:: struct media_link_desc
    :header-rows:  0
    :stub-columns: 0
    :widths:       1 1 2

    *  -  struct :c:type:`media_pad_desc`
       -  ``source``
       -  Контакт в начале этой связи.

    *  -  struct :c:type:`media_pad_desc`
       -  ``sink``
       -  Контакт в конце этой связи.

    *  -  __u32
       -  ``flags``
       -  Флаги связи, подробнее см. :ref:`media-link-flag`.

    *  -  __u32
       -  ``reserved[2]``
       -  Зарезервировано для будущих расширений. Драйверы и приложения должны
          обнулить этот массив.

Возвращаемое значение
=====================

При успехе возвращается 0, при ошибке -1, и переменная ``errno`` устанавливается
соответствующим образом. Общие коды ошибок описаны в главе
:ref:`Generic Error Codes <gen-errors>`.

EINVAL
    Поле ``id`` структуры struct :c:type:`media_links_enum`
    ссылается на несуществующую сущность.
