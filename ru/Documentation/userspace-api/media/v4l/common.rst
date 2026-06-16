.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: V4L

.. _common:

#######################
Общие элементы API
#######################
Программирование устройства V4L2 состоит из следующих шагов:

-  Открытие устройства

-  Изменение свойств устройства, выбор видео- и аудиовхода, видеостандарта,
   яркости изображения и прочего

-  Согласование формата данных

-  Согласование метода ввода/вывода

-  Собственно цикл ввода/вывода

-  Закрытие устройства

На практике большинство шагов необязательны и могут выполняться не по порядку.
Это зависит от типа устройства V4L2; подробнее об этом можно прочитать в
:ref:`devices`. В этой главе мы рассмотрим базовые концепции, применимые ко
всем устройствам.


.. toctree::
    :maxdepth: 1

    open
    querycap
    app-pri
    video
    audio
    tuner
    standard
    dv-timings
    control
    extended-controls
    ext-ctrls-camera
    ext-ctrls-flash
    ext-ctrls-image-source
    ext-ctrls-image-process
    ext-ctrls-codec
    ext-ctrls-codec-stateless
    ext-ctrls-jpeg
    ext-ctrls-dv
    ext-ctrls-rf-tuner
    ext-ctrls-fm-tx
    ext-ctrls-fm-rx
    ext-ctrls-detect
    ext-ctrls-colorimetry
    fourcc
    format
    planar-apis
    selection-api
    crop
    streaming-par
