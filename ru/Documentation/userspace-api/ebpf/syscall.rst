.. SPDX-License-Identifier: GPL-2.0

Системный вызов eBPF
--------------------

:Authors: - Alexei Starovoitov <ast@kernel.org>
          - Joe Stringer <joe@wand.net.nz>
          - Michael Kerrisk <mtk.manpages@gmail.com>

Основная информация о системном вызове bpf доступна в `man-pages`_
для `bpf(2)`_.

Справочник по подкомандам bpf()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. kernel-doc:: include/uapi/linux/bpf.h
   :doc: eBPF Syscall Preamble

.. kernel-doc:: include/uapi/linux/bpf.h
   :doc: eBPF Syscall Commands

.. Links:
.. _man-pages: https://www.kernel.org/doc/man-pages/
.. _bpf(2): https://man7.org/linux/man-pages/man2/bpf.2.html
