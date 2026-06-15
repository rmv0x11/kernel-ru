.. SPDX-License-Identifier: GPL-2.0

Undefined Behavior Sanitizer - UBSAN
====================================

UBSAN — это средство проверки неопределённого поведения во время выполнения.

UBSAN использует инструментацию во время компиляции для отлова неопределённого
поведения (UB). Компилятор вставляет код, который выполняет определённые виды
проверок перед операциями, способными вызвать UB. Если проверка не проходит
(то есть обнаружено UB), для вывода сообщения об ошибке вызывается функция
__ubsan_handle_*.

В GCC эта возможность присутствует начиная с версии 4.9.x [1_] (см. опцию
``-fsanitize=undefined`` и её подопции). В GCC 5.x реализовано больше
средств проверки [2_].

Пример отчёта
-------------

::

	 ================================================================================
	 UBSAN: Undefined behaviour in ../include/linux/bitops.h:110:33
	 shift exponent 32 is to large for 32-bit type 'unsigned int'
	 CPU: 0 PID: 0 Comm: swapper Not tainted 4.4.0-rc1+ #26
	  0000000000000000 ffffffff82403cc8 ffffffff815e6cd6 0000000000000001
	  ffffffff82403cf8 ffffffff82403ce0 ffffffff8163a5ed 0000000000000020
	  ffffffff82403d78 ffffffff8163ac2b ffffffff815f0001 0000000000000002
	 Call Trace:
	  [<ffffffff815e6cd6>] dump_stack+0x45/0x5f
	  [<ffffffff8163a5ed>] ubsan_epilogue+0xd/0x40
	  [<ffffffff8163ac2b>] __ubsan_handle_shift_out_of_bounds+0xeb/0x130
	  [<ffffffff815f0001>] ? radix_tree_gang_lookup_slot+0x51/0x150
	  [<ffffffff8173c586>] _mix_pool_bytes+0x1e6/0x480
	  [<ffffffff83105653>] ? dmi_walk_early+0x48/0x5c
	  [<ffffffff8173c881>] add_device_randomness+0x61/0x130
	  [<ffffffff83105b35>] ? dmi_save_one_device+0xaa/0xaa
	  [<ffffffff83105653>] dmi_walk_early+0x48/0x5c
	  [<ffffffff831066ae>] dmi_scan_machine+0x278/0x4b4
	  [<ffffffff8111d58a>] ? vprintk_default+0x1a/0x20
	  [<ffffffff830ad120>] ? early_idt_handler_array+0x120/0x120
	  [<ffffffff830b2240>] setup_arch+0x405/0xc2c
	  [<ffffffff830ad120>] ? early_idt_handler_array+0x120/0x120
	  [<ffffffff830ae053>] start_kernel+0x83/0x49a
	  [<ffffffff830ad120>] ? early_idt_handler_array+0x120/0x120
	  [<ffffffff830ad386>] x86_64_start_reservations+0x2a/0x2c
	  [<ffffffff830ad4f3>] x86_64_start_kernel+0x16b/0x17a
	 ================================================================================

Использование
-------------

Чтобы включить UBSAN, сконфигурируйте ядро с параметром::

  CONFIG_UBSAN=y

Чтобы исключить файлы из инструментации, используйте::

  UBSAN_SANITIZE_main.o := n

а чтобы исключить все цели в одном каталоге, используйте::

  UBSAN_SANITIZE := n

Когда инструментация отключена для всех целей, отдельные файлы можно включить
с помощью::

  UBSAN_SANITIZE_main.o := y

Обнаружение невыровненных обращений управляется отдельной опцией —
CONFIG_UBSAN_ALIGNMENT. По умолчанию она отключена на архитектурах, которые
поддерживают невыровненные обращения (CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y).
Её всё же можно включить в конфигурации, но учтите, что это породит большое
количество отчётов UBSAN.

Ссылки
------

.. _1: https://gcc.gnu.org/onlinedocs/gcc-4.9.0/gcc/Debugging-Options.html
.. _2: https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
.. _3: https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
