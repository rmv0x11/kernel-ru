==================
Управление памятью
==================

Подсистема управления памятью Linux отвечает, как следует из её названия,
за управление памятью в системе. Это включает реализацию виртуальной памяти
и подкачки по требованию (demand paging), выделение памяти как для внутренних
структур ядра, так и для программ пространства пользователя, отображение файлов
в адресное пространство процессов и множество других интересных вещей.

Управление памятью Linux — сложная система с множеством настраиваемых параметров.
Большинство этих параметров доступны через файловую систему ``/proc`` и могут быть
прочитаны и изменены с помощью ``sysctl``. Эти API описаны в
Documentation/admin-guide/sysctl/vm.rst и в `man 5 proc`_.

.. _man 5 proc: http://man7.org/linux/man-pages/man5/proc.5.html

У управления памятью Linux есть собственный жаргон, и если вы с ним ещё не знакомы,
рекомендуем прочитать Documentation/admin-guide/mm/concepts.rst.

Здесь мы подробно описываем, как взаимодействовать с различными механизмами
управления памятью в Linux.

.. toctree::
   :maxdepth: 1

   concepts
   cma_debugfs
   damon/index
   hugetlbpage
   idle_page_tracking
   ksm
   memory-hotplug
   multigen_lru
   nommu-mmap
   numa_memory_policy
   numaperf
   pagemap
   shrinker_debugfs
   slab
   soft-dirty
   transhuge
   userfaultfd
   zswap
   kho
