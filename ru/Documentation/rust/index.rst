.. SPDX-License-Identifier: GPL-2.0

Rust
====

Документация, связанная с использованием Rust в ядре. Чтобы начать использовать
Rust в ядре, прочитайте руководство quick-start.rst.


Документация кода
-----------------

Для заданной конфигурации ядра ядро может сгенерировать документацию кода на Rust,
то есть HTML, формируемый инструментом ``rustdoc``.

.. only:: rustdoc and html

	Эта документация ядра была собрана вместе с `документацией кода на Rust
	<rustdoc/kernel/index.html>`_.

.. only:: not rustdoc and html

	Эта документация ядра была собрана без документации кода на Rust.

Предварительно сгенерированная версия доступна по адресу:

	https://rust.docs.kernel.org

Дополнительные сведения см. в разделе :ref:`Документация кода <rust_code_documentation>`.

.. toctree::
    :maxdepth: 1

    quick-start
    general-information
    coding-guidelines
    arch-support
    testing

Учебные материалы по Rust также можно найти в соответствующем разделе в
:doc:`../process/kernel-docs`.
