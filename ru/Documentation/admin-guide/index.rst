==================================================================
Руководство по ядру Linux для пользователей и администраторов
==================================================================

Ниже приведена подборка ориентированных на пользователя документов,
которые добавлялись в ядро с течением времени. Пока что здесь мало
общего порядка или организации — этот материал не задумывался как
единый, цельный документ! Будем надеяться, что со временем ситуация
быстро улучшится.

Общие руководства по администрированию ядра
-------------------------------------------

Этот вводный раздел содержит общую информацию, включая файл README,
описывающий ядро в целом, документацию по параметрам ядра и т.д.

.. toctree::
   :maxdepth: 1

   README
   devices

   features

Значительную часть административного интерфейса ядра составляют
виртуальные файловые системы /proc и sysfs; в этих документах описано,
как с ними взаимодействовать

.. toctree::
   :maxdepth: 1

   sysfs-rules
   sysctl/index
   cputopology
   abi

Документация, связанная с безопасностью:

.. toctree::
   :maxdepth: 1

   hw-vuln/index
   LSM/index
   perf-security

Загрузка ядра
-------------

.. toctree::
   :maxdepth: 1

   bootconfig
   kernel-parameters
   efi-stub
   initrd


Выявление и идентификация проблем
---------------------------------

Здесь приведён набор документов, предназначенных для пользователей,
которые, в частности, пытаются отследить проблемы и ошибки.

.. toctree::
   :maxdepth: 1

   reporting-issues
   reporting-regressions
   quickly-build-trimmed-linux
   verify-bugs-and-bisect-regressions
   bug-hunting
   bug-bisect
   tainted-kernels
   ramoops
   dynamic-debug-howto
   init
   kdump/index
   perf/index
   pstore-blk
   clearing-warn-once
   kernel-per-CPU-kthreads
   lockup-watchdogs
   RAS/index
   sysrq


Основные подсистемы ядра
------------------------

В этих документах описаны административные интерфейсы основных подсистем
ядра, которые, вероятно, будут интересны практически в любой системе.

.. toctree::
   :maxdepth: 1

   cgroup-v2
   cgroup-v1/index
   cpu-load
   mm/index
   module-signing
   namespaces/index
   numastat
   pm/index
   syscall-user-dispatch

Поддержка неродных бинарных форматов. Обратите внимание, что некоторые из
этих документов... устарели...

.. toctree::
   :maxdepth: 1

   binfmt-misc
   java
   mono


Администрирование блочного уровня и файловых систем
---------------------------------------------------

.. toctree::
   :maxdepth: 1

   bcache
   binderfs
   blockdev/index
   cifs/index
   device-mapper/index
   ext4
   filesystem-monitoring
   nfs/index
   iostats
   jfs
   md
   ufs
   xfs

Руководства для конкретных устройств
------------------------------------

Как настроить оборудование в вашей системе Linux.

.. toctree::
   :maxdepth: 1

   acpi/index
   aoe/index
   auxdisplay/index
   braille-console
   btmrvl
   dell_rbu
   edid
   gpio/index
   hw_random
   laptops/index
   lcd-panel-cgram
   media/index
   nvme-multipath
   parport
   pnp
   rapidio
   rtc
   serial-console
   svga
   thermal/index
   thunderbolt
   vga-softcursor
   video-output

Анализ рабочих нагрузок
-----------------------

Это начало раздела с информацией, представляющей интерес для
разработчиков приложений и системных интеграторов, выполняющих анализ
ядра Linux для приложений, критичных к безопасности. Здесь будут
размещены документы, поддерживающие анализ взаимодействия ядра с
приложениями, а также ожидания от ключевых подсистем ядра.

.. toctree::
   :maxdepth: 1

   workload-tracing

Всё остальное
-------------

Несколько документов, которые трудно отнести к какой-либо категории и
которые, как правило, устарели.

.. toctree::
   :maxdepth: 1

   ldm
   unicode
