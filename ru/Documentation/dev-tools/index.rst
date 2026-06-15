==============================================
Инструменты разработки для ядра
==============================================

Этот документ представляет собой подборку документов об инструментах разработки,
которые можно использовать для работы над ядром. На данный момент документы были
собраны вместе без сколько-нибудь значимых усилий по их интеграции в единое
связное целое; патчи приветствуются!

Краткий обзор инструментов, специфичных для тестирования, можно найти в
Documentation/dev-tools/testing-overview.rst

Инструменты, специфичные для отладки, можно найти в
Documentation/process/debugging/index.rst

.. toctree::
   :caption: Содержание
   :maxdepth: 2

   testing-overview
   checkpatch
   clang-format
   coccinelle
   context-analysis
   sparse
   kcov
   gcov
   kasan
   kmsan
   ubsan
   kmemleak
   kcsan
   lkmm/index
   kfence
   kselftest
   kunit/index
   ktap
   checkuapi
   gpio-sloppy-logic-analyzer
   autofdo
   propeller
   container
