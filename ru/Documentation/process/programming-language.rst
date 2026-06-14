.. _programming_language:

Язык программирования
=====================

Ядро Linux написано на языке программирования C [c-language]_.
Точнее говоря, оно обычно компилируется с помощью ``gcc`` [gcc]_
в режиме ``-std=gnu11`` [gcc-c-dialect-options]_: это GNU-диалект ISO C11.
Также поддерживается ``clang`` [clang]_; см. документацию по
:ref:`сборке Linux с помощью Clang/LLVM <kbuild_llvm>`.

Этот диалект содержит множество расширений языка [gnu-extensions]_,
и многие из них повсеместно используются в ядре как нечто само собой разумеющееся.

Атрибуты
--------

Одно из распространённых расширений, используемых по всему ядру, — это атрибуты
[gcc-attribute-syntax]_. Атрибуты позволяют вводить
определяемую реализацией семантику для языковых сущностей (таких как переменные,
функции или типы) без необходимости вносить существенные синтаксические изменения
в язык (например, добавлять новое ключевое слово) [n2049]_.

В некоторых случаях атрибуты необязательны (то есть компилятор, который их не
поддерживает, всё равно должен порождать корректный код, пусть даже более
медленный или с меньшим числом проверок/диагностик на этапе компиляции).

Ядро определяет псевдоключевые слова (например, ``__pure``) вместо
непосредственного использования синтаксиса атрибутов GNU (например, ``__attribute__((__pure__))``),
чтобы определять, какие из них доступны для использования, и/или чтобы сократить код.

За дополнительной информацией обращайтесь к ``include/linux/compiler_attributes.h``.

Rust
----

Ядро поддерживает язык программирования Rust
[rust-language]_ при включённом ``CONFIG_RUST``. Он компилируется с помощью ``rustc`` [rustc]_
в режиме ``--edition=2021`` [rust-editions]_. Издания (editions) — это способ вносить
небольшие изменения в язык, не обладающие обратной совместимостью.

Помимо этого, в ядре используются некоторые нестабильные возможности
[rust-unstable-features]_. Нестабильные возможности в будущем могут измениться, поэтому
важной целью является достижение состояния, при котором используются только стабильные возможности.

За дополнительной информацией обращайтесь к Documentation/rust/index.rst.

.. [c-language] http://www.open-std.org/jtc1/sc22/wg14/www/standards
.. [gcc] https://gcc.gnu.org
.. [clang] https://clang.llvm.org
.. [gcc-c-dialect-options] https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html
.. [gnu-extensions] https://gcc.gnu.org/onlinedocs/gcc/C-Extensions.html
.. [gcc-attribute-syntax] https://gcc.gnu.org/onlinedocs/gcc/Attribute-Syntax.html
.. [n2049] http://www.open-std.org/jtc1/sc22/wg14/www/docs/n2049.pdf
.. [rust-language] https://www.rust-lang.org
.. [rustc] https://doc.rust-lang.org/rustc/
.. [rust-editions] https://doc.rust-lang.org/edition-guide/editions/
.. [rust-unstable-features] https://github.com/Rust-for-Linux/linux/issues/2
