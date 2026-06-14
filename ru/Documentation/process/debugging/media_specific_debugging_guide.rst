.. SPDX-License-Identifier: GPL-2.0

================================================
Отладка и трассировка в подсистеме media
================================================

Этот документ служит отправной точкой и справочником по отладке драйверов
устройств в подсистеме media, а также по отладке этих драйверов из пространства
пользователя (userspace).

.. contents::
    :depth: 3

Общие советы по отладке
-----------------------

Общие рекомендации см. в :doc:`документе с общими советами
</process/debugging/index>`.

В следующих разделах показаны некоторые из доступных инструментов.

Параметр модуля dev_debug
-------------------------

Каждое видеоустройство предоставляет параметр ``dev_debug``, который позволяет
получить дополнительную информацию о выполняемых в фоне IOCTL.::

  # cat /sys/class/video4linux/video3/name
  rkvdec
  # echo 0xff > /sys/class/video4linux/video3/dev_debug
  # dmesg -wH
  [...] videodev: v4l2_open: video3: open (0)
  [  +0.000036] video3: VIDIOC_QUERYCAP: driver=rkvdec, card=rkvdec,
  bus=platform:rkvdec, version=0x00060900, capabilities=0x84204000,
  device_caps=0x04204000

Полную документацию см. в :ref:`driver-api/media/v4l2-dev:video device
debugging`

dev_dbg() / v4l2_dbg()
----------------------

Два оператора отладочной печати, специфичные для устройств и для подсистемы
v4l2; не добавляйте их в окончательную версию своего кода, если только они не
имеют долгосрочной ценности для исследований.

Общий обзор см. в руководстве
:ref:`process/debugging/driver_development_debugging_guide:printk() и его аналоги`.

- В чём разница между ними?

  - v4l2_dbg() использует под капотом v4l2_printk(), который, в свою очередь,
    напрямую обращается к printk(), поэтому он не может быть целью динамической
    отладки (dynamic debug)
  - dev_dbg() может быть целью динамической отладки
  - v4l2_dbg() имеет более специфичный формат префикса для подсистемы media,
    тогда как dev_dbg отображает только имя драйвера и местоположение лога

Динамическая отладка
--------------------

Способ сократить отладочный вывод до того, что вам нужно.

Общие рекомендации см. в руководстве
:ref:`process/debugging/userspace_debugging_guide:dynamic debug`.

Вот один пример, включающий все доступные pr_debug() в файле::

  $ alias ddcmd='echo $* > /proc/dynamic_debug/control'
  $ ddcmd '-p; file v4l2-h264.c +p'
  $ grep =p /proc/dynamic_debug/control
   drivers/media/v4l2-core/v4l2-h264.c:372 [v4l2_h264]print_ref_list_b =p
   "ref_pic_list_b%u (cur_poc %u%c) %s"
   drivers/media/v4l2-core/v4l2-h264.c:333 [v4l2_h264]print_ref_list_p =p
   "ref_pic_list_p (cur_poc %u%c) %s\n"

Ftrace
------

Внутренний трассировщик ядра, который может трассировать статически предопределённые
события, вызовы функций и т. п. Очень полезен для отладки проблем без изменения
ядра и для понимания поведения подсистем.

Общие рекомендации см. в руководстве
:ref:`process/debugging/userspace_debugging_guide:ftrace`.

DebugFS
-------

Этот инструмент позволяет выгружать или изменять внутренние значения вашего
драйвера в файлы в специальной файловой системе.

Общие рекомендации см. в руководстве
:ref:`process/debugging/driver_development_debugging_guide:debugfs`.

Perf и альтернативы
-------------------

Инструменты для измерения различной статистики работающей системы с целью
диагностики неполадок.

Общие рекомендации см. в руководстве
:ref:`process/debugging/userspace_debugging_guide:Perf и альтернативы`.

Пример для media-устройств:

Сбор статистических данных для задачи декодирования: (этот пример выполнен на
SoC RK3399 с драйвером кодека rkvdec с использованием `набора тестов fluster
<https://github.com/fluendo/fluster>`__)::

  perf stat -d python3 fluster.py run -d GStreamer-H.264-V4L2SL-Gst1.0 -ts
  JVT-AVC_V1 -tv AUD_MW_E -j1
  ...
  Performance counter stats for 'python3 fluster.py run -d
  GStreamer-H.264-V4L2SL-Gst1.0 -ts JVT-AVC_V1 -tv AUD_MW_E -j1 -v':

         7794.23 msec task-clock:u                     #    0.697 CPUs utilized
               0      context-switches:u               #    0.000 /sec
               0      cpu-migrations:u                 #    0.000 /sec
           11901      page-faults:u                    #    1.527 K/sec
       882671556      cycles:u                         #    0.113 GHz                         (95.79%)
       711708695      instructions:u                   #    0.81  insn per cycle              (95.79%)
        10581935      branches:u                       #    1.358 M/sec                       (15.13%)
         6871144      branch-misses:u                  #   64.93% of all branches             (95.79%)
       281716547      L1-dcache-loads:u                #   36.144 M/sec                       (95.79%)
         9019581      L1-dcache-load-misses:u          #    3.20% of all L1-dcache accesses   (95.79%)
 <not supported>      LLC-loads:u
 <not supported>      LLC-load-misses:u

    11.180830431 seconds time elapsed

     1.502318000 seconds user
     6.377221000 seconds sys

Доступность событий и метрик зависит от системы, на которой вы работаете.

Проверка ошибок и анализ паник
------------------------------

Различные параметры конфигурации ядра для улучшения обнаружения ошибок в ядре
Linux ценой снижения производительности.

Общие рекомендации см. в руководстве
:ref:`process/debugging/driver_development_debugging_guide:KASAN, UBSAN,
lockdep и другие средства проверки ошибок`.

Проверка драйвера с помощью v4l2-compliance
-------------------------------------------

Для проверки того, что драйвер соответствует API v4l2, используется инструмент
v4l2-compliance, входящий в состав `v4l_utils
<https://git.linuxtv.org/v4l-utils.git>`__ — набора инструментов пространства
пользователя для работы с подсистемой media.

Чтобы увидеть подробную media-топологию (и проверить её), используйте::

  v4l2-compliance -M /dev/mediaX --verbose

Вы также можете запустить полную проверку соответствия для всех устройств,
указанных в media-топологии, с помощью::

  v4l2-compliance -m /dev/mediaX

Отладка проблем с приёмом видео
-------------------------------

Реализация vidioc_log_status в драйвере: это позволяет записывать текущий статус
в журнал ядра. Она вызывается командой v4l2-ctl --log-status. Очень полезно для
отладки проблем с приёмом видео (TV/S-Video/HDMI и т. д.), поскольку видеосигнал
является внешним (а значит, непредсказуемым). Менее полезно для входов с сенсоров
камеры, так как вы контролируете то, что делает сенсор камеры.

Обычно можно просто присвоить значение по умолчанию::

  .vidioc_log_status  = v4l2_ctrl_log_status,

Но вы также можете создать собственный обратный вызов, чтобы формировать
пользовательский журнал статуса.

Пример можно найти в драйвере cobalt
(`drivers/media/pci/cobalt/cobalt-v4l2.c <https://elixir.bootlin.com/linux/v6.11.6/source/drivers/media/pci/cobalt/cobalt-v4l2.c#L567>`__).

**Copyright** ©2024 : Collabora
