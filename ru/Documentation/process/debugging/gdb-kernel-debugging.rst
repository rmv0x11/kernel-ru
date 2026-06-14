.. highlight:: none

Отладка ядра и модулей через gdb
================================

Отладчик ядра kgdb, гипервизоры вроде QEMU, а также аппаратные интерфейсы на
основе JTAG позволяют отлаживать ядро Linux и его модули во время выполнения с
помощью gdb. Gdb обладает мощным интерфейсом для написания сценариев на python.
Ядро предоставляет набор вспомогательных сценариев, которые могут упростить
типичные шаги отладки ядра. Это краткое руководство о том, как их включить и
использовать. Оно ориентировано на виртуальные машины QEMU/KVM в качестве цели,
но примеры можно перенести и на другие gdb-заглушки.


Требования
----------

- gdb 7.2+ (рекомендуется: 7.4+) с включённой поддержкой python (как правило,
  это так в дистрибутивах)


Подготовка
----------

- Создайте виртуальную Linux-машину для QEMU/KVM (подробнее см. www.linux-kvm.org
  и www.qemu.org). Для кросс-разработки на https://landley.net/aboriginal/bin
  хранится набор образов машин и тулчейнов, с которых может быть удобно начать.

- Соберите ядро с включённым CONFIG_GDB_SCRIPTS, но оставьте
  CONFIG_DEBUG_INFO_REDUCED выключенным. Если ваша архитектура поддерживает
  CONFIG_FRAME_POINTER, оставьте его включённым.

- Установите это ядро в гостевой системе, при необходимости отключите KASLR,
  добавив "nokaslr" в командную строку ядра.
  Кроме того, QEMU позволяет загружать ядро напрямую с помощью ключей командной
  строки -kernel, -append, -initrd. Это обычно полезно только в том случае, если
  вы не зависите от модулей. Подробнее об этом режиме см. документацию QEMU. В
  этом случае следует собирать ядро с отключённым CONFIG_RANDOMIZE_BASE, если
  архитектура поддерживает KASLR.

- Соберите gdb-сценарии (требуется на ядрах v5.1 и выше)::

    make scripts_gdb

- Включите gdb-заглушку QEMU/KVM, либо

    - на этапе запуска ВМ, добавив "-s" в командную строку QEMU

  либо

    - во время выполнения, выполнив "gdbserver" из консоли монитора
      QEMU

- cd /path/to/linux-build

- Запустите gdb: gdb vmlinux

  Примечание: некоторые дистрибутивы могут ограничивать автозагрузку
  gdb-сценариев только известными безопасными каталогами. Если gdb сообщает об
  отказе загрузить vmlinux-gdb.py, добавьте::

    add-auto-load-safe-path /path/to/linux-build

  в ~/.gdbinit. Подробнее см. справку gdb.

- Подключитесь к загруженной гостевой системе::

    (gdb) target remote :1234


Примеры использования gdb-помощников, предоставляемых Linux
-----------------------------------------------------------

- Загрузка символов модулей (и основного ядра)::

    (gdb) lx-symbols
    loading vmlinux
    scanning for modules in /home/user/linux/build
    loading @0xffffffffa0020000: /home/user/linux/build/net/netfilter/xt_tcpudp.ko
    loading @0xffffffffa0016000: /home/user/linux/build/net/netfilter/xt_pkttype.ko
    loading @0xffffffffa0002000: /home/user/linux/build/net/netfilter/xt_limit.ko
    loading @0xffffffffa00ca000: /home/user/linux/build/net/packet/af_packet.ko
    loading @0xffffffffa003c000: /home/user/linux/build/fs/fuse/fuse.ko
    ...
    loading @0xffffffffa0000000: /home/user/linux/build/drivers/ata/ata_generic.ko

- Установка точки останова на какой-либо ещё не загруженной функции модуля,
  например::

    (gdb) b btrfs_init_sysfs
    Function "btrfs_init_sysfs" not defined.
    Make breakpoint pending on future shared library load? (y or [n]) y
    Breakpoint 1 (btrfs_init_sysfs) pending.

- Продолжение выполнения на целевой системе::

    (gdb) c

- Загрузите модуль на целевой системе и наблюдайте за загрузкой символов, а
  также за срабатыванием точки останова::

    loading @0xffffffffa0034000: /home/user/linux/build/lib/libcrc32c.ko
    loading @0xffffffffa0050000: /home/user/linux/build/lib/lzo/lzo_compress.ko
    loading @0xffffffffa006e000: /home/user/linux/build/lib/zlib_deflate/zlib_deflate.ko
    loading @0xffffffffa01b1000: /home/user/linux/build/fs/btrfs/btrfs.ko

    Breakpoint 1, btrfs_init_sysfs () at /home/user/linux/fs/btrfs/sysfs.c:36
    36              btrfs_kset = kset_create_and_add("btrfs", NULL, fs_kobj);

- Вывод дампа буфера журнала целевого ядра::

    (gdb) lx-dmesg
    [     0.000000] Initializing cgroup subsys cpuset
    [     0.000000] Initializing cgroup subsys cpu
    [     0.000000] Linux version 3.8.0-rc4-dbg+ (...
    [     0.000000] Command line: root=/dev/sda2 resume=/dev/sda1 vga=0x314
    [     0.000000] e820: BIOS-provided physical RAM map:
    [     0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
    [     0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
    ....

- Изучение полей текущей структуры task (поддерживается только на x86 и arm64)::

    (gdb) p $lx_current().pid
    $1 = 4998
    (gdb) p $lx_current().comm
    $2 = "modprobe\000\000\000\000\000\000\000"

- Использование per-cpu функции для текущего или указанного CPU::

    (gdb) p $lx_per_cpu(runqueues).nr_running
    $3 = 1
    (gdb) p $lx_per_cpu(runqueues, 2).nr_running
    $4 = 0

- Погружение в hrtimers с помощью помощника container_of::

    (gdb) set $leftmost = $lx_per_cpu(hrtimer_bases).clock_base[0].active.rb_root.rb_leftmost
    (gdb) p *$container_of($leftmost, "struct hrtimer", "node")
    $5 = {
      node = {
        node = {
          __rb_parent_color = 18446612686384860673,
          rb_right = 0xffff888231da8b00,
          rb_left = 0x0
        },
        expires = 1228461000000
      },
      _softexpires = 1228461000000,
      function = 0xffffffff8137ab20 <tick_nohz_handler>,
      base = 0xffff888231d9b4c0,
      state = 1 '\001',
      is_rel = 0 '\000',
      is_soft = 0 '\000',
      is_hard = 1 '\001'
    }


Список команд и функций
-----------------------

Количество команд и функций удобства может со временем меняться, это лишь снимок
исходной версии::

 (gdb) apropos lx
 function lx_current -- Return current task
 function lx_module -- Find module by name and return the module variable
 function lx_per_cpu -- Return per-cpu variable
 function lx_task_by_pid -- Find Linux task by PID and return the task_struct variable
 function lx_thread_info -- Calculate Linux thread_info from task variable
 lx-dmesg -- Print Linux kernel log buffer
 lx-lsmod -- List currently loaded modules
 lx-symbols -- (Re-)load symbols of Linux kernel and currently loaded modules

Подробную справку можно получить через "help <command-name>" для команд и "help
function <function-name>" для функций удобства.
