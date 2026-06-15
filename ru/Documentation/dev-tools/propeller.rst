.. SPDX-License-Identifier: GPL-2.0

==============================================
Использование Propeller с ядром Linux
==============================================

Это включает поддержку сборки с Propeller для ядра при использовании
компилятора Clang. Propeller — это метод оптимизации на основе профилей
(profile-guided optimization, PGO), используемый для оптимизации бинарных
исполняемых файлов. Как и AutoFDO, он использует аппаратное сэмплирование для
сбора информации о частоте выполнения различных путей кода внутри бинарного
файла. В отличие от AutoFDO, эта информация затем используется непосредственно
перед фазой компоновки (linking) для оптимизации (среди прочего) размещения
блоков внутри функций и между ними.

Несколько важных замечаний о применении оптимизации Propeller:

#. Хотя Propeller можно использовать как самостоятельный шаг оптимизации,
   настоятельно рекомендуется применять его поверх AutoFDO,
   AutoFDO+ThinLTO или Instrument FDO. Остальная часть этого документа
   предполагает именно такую парадигму.

#. Propeller использует ещё один раунд профилирования поверх
   AutoFDO/AutoFDO+ThinLTO/iFDO. Весь процесс сборки включает
   "build-afdo - train-afdo - build-propeller - train-propeller -
   build-optimized".

#. Propeller требует LLVM версии 19 или новее для Clang/Clang++
   и компоновщика (ld.lld).

#. Помимо тулчейна LLVM, Propeller требует инструмент преобразования
   профилей: https://github.com/google/autofdo версии
   после v0.30.1: https://github.com/google/autofdo/releases/tag/v0.30.1.

Процесс оптимизации Propeller включает следующие шаги:

#. Первоначальная сборка: соберите бинарный файл AutoFDO или AutoFDO+ThinLTO
   так, как вы делаете это обычно, но с набором флагов времени компиляции /
   времени компоновки, чтобы внутри бинарного файла ядра была создана
   специальная секция метаданных. Эта специальная секция предназначена только
   для использования инструментом профилирования, она не является частью
   образа времени выполнения и не изменяет секции текста ядра времени
   выполнения.

#. Профилирование: указанное выше ядро затем запускается с репрезентативной
   рабочей нагрузкой для сбора данных о частоте выполнения. Эти данные
   собираются с помощью аппаратного сэмплирования, через perf. Propeller
   наиболее эффективен на платформах, поддерживающих продвинутые возможности
   PMU, такие как LBR на машинах Intel. Этот шаг аналогичен профилированию
   ядра для AutoFDO (точные параметры perf могут отличаться).

#. Генерация профиля Propeller: выходной файл perf преобразуется в
   пару профилей Propeller с помощью офлайн-инструмента.

#. Оптимизированная сборка: соберите оптимизированный бинарный файл AutoFDO
   или AutoFDO+ThinLTO так, как вы делаете это обычно, но с флагом времени
   компиляции / времени компоновки, чтобы подхватить профили времени
   компиляции и времени компоновки Propeller. Этот шаг сборки использует
   3 профиля — профиль AutoFDO, профиль времени компиляции Propeller и
   профиль времени компоновки Propeller.

#. Развёртывание: оптимизированный бинарный файл ядра развёртывается и
   используется в производственных средах, обеспечивая повышенную
   производительность и сниженную задержку (latency).

Подготовка
==========

Сконфигурируйте ядро с::

   CONFIG_AUTOFDO_CLANG=y
   CONFIG_PROPELLER_CLANG=y

Настройка
=========

Настройка CONFIG_PROPELLER_CLANG по умолчанию охватывает объекты пространства
ядра для сборок Propeller. Однако можно включить или отключить сборку Propeller
для отдельных файлов и каталогов, добавив строку, аналогичную следующей, в
соответствующий Makefile ядра:

- Для включения одного файла (например, foo.o)::

   PROPELLER_PROFILE_foo.o := y

- Для включения всех файлов в одном каталоге::

   PROPELLER_PROFILE := y

- Для отключения одного файла::

   PROPELLER_PROFILE_foo.o := n

- Для отключения всех файлов в одном каталоге::

   PROPELLER__PROFILE := n


Рабочий процесс
===============

Вот пример рабочего процесса для сборки ядра AutoFDO+Propeller:

1) Предполагая, что профиль AutoFDO уже собран в соответствии с
   инструкциями в документе AutoFDO, соберите ядро на хост-машине,
   с конфигурациями сборки AutoFDO и Propeller ::

      CONFIG_AUTOFDO_CLANG=y
      CONFIG_PROPELLER_CLANG=y

   и ::

      $ make LLVM=1 CLANG_AUTOFDO_PROFILE=<autofdo-profile-name>

2) Установите ядро на тестовую машину.

3) Запустите нагрузочные тесты. Опция '-c' в perf задаёт период события
   сэмплирования. Для этой цели мы рекомендуем использовать подходящее
   простое число, например 500009.

   - Для платформ Intel::

      $ perf record -e BR_INST_RETIRED.NEAR_TAKEN:k -a -N -b -c <count> -o <perf_file> -- <loadtest>

   - Для платформ AMD::

      $ perf record --pfm-event RETIRED_TAKEN_BRANCH_INSTRUCTIONS:k -a -N -b -c <count> -o <perf_file> -- <loadtest>

   Обратите внимание, что вы можете повторить приведённые выше шаги для сбора
   нескольких <perf_file>.

4) (Необязательно) Скачайте сырой файл (файлы) perf на хост-машину.

5) Используйте инструмент create_llvm_prof (https://github.com/google/autofdo)
   для генерации профиля Propeller. ::

      $ create_llvm_prof --binary=<vmlinux> --profile=<perf_file>
                         --format=propeller --propeller_output_module_name
                         --out=<propeller_profile_prefix>_cc_profile.txt
                         --propeller_symorder=<propeller_profile_prefix>_ld_profile.txt

   "<propeller_profile_prefix>" может быть чем-то вроде "/home/user/dir/any_string".

   Эта команда генерирует пару профилей Propeller:
   "<propeller_profile_prefix>_cc_profile.txt" и
   "<propeller_profile_prefix>_ld_profile.txt".

   Если на предыдущем шаге было собрано более 1 perf_file,
   вы можете создать временный файл списка "<perf_file_list>", где каждая
   строка содержит имя одного файла perf, и запустить::

      $ create_llvm_prof --binary=<vmlinux> --profile=@<perf_file_list>
                         --format=propeller --propeller_output_module_name
                         --out=<propeller_profile_prefix>_cc_profile.txt
                         --propeller_symorder=<propeller_profile_prefix>_ld_profile.txt

6) Пересоберите ядро, используя профили AutoFDO и Propeller. ::

      CONFIG_AUTOFDO_CLANG=y
      CONFIG_PROPELLER_CLANG=y

   и ::

      $ make LLVM=1 CLANG_AUTOFDO_PROFILE=<profile_file> CLANG_PROPELLER_PROFILE_PREFIX=<propeller_profile_prefix>
