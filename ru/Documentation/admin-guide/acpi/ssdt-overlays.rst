.. SPDX-License-Identifier: GPL-2.0

==================
Оверлеи SSDT
==================

Чтобы поддерживать открытые (open-ended) аппаратные конфигурации ACPI (например,
отладочные платы), необходим способ дополнить конфигурацию ACPI, предоставляемую
образом прошивки (firmware). Типичный пример — подключение датчиков на шинах
I2C / SPI на отладочных платах.

Хотя этого можно добиться, создав платформенный драйвер ядра или перекомпилировав
образ прошивки с обновлёнными таблицами ACPI, ни то ни другое не практично:
первое плодит специфичный для платы код ядра, тогда как второе требует доступа к
инструментам прошивки, которые зачастую недоступны публично.

Поскольку ACPI поддерживает внешние ссылки в коде AML, более практичный способ
дополнить конфигурацию ACPI прошивки — динамическая загрузка определяемых
пользователем таблиц SSDT, содержащих специфичную для платы информацию.

Например, чтобы перечислить акселерометр Bosch BMA222E на шине I2C отладочной
платы Minnowboard MAX, выведенной через разъём LSE [1], можно использовать
следующий код ASL::

    DefinitionBlock ("minnowmax.aml", "SSDT", 1, "Vendor", "Accel", 0x00000003)
    {
        External (\_SB.I2C6, DeviceObj)

        Scope (\_SB.I2C6)
        {
            Device (STAC)
            {
                Name (_HID, "BMA222E")
                Name (RBUF, ResourceTemplate ()
                {
                    I2cSerialBus (0x0018, ControllerInitiated, 0x00061A80,
                                AddressingMode7Bit, "\\_SB.I2C6", 0x00,
                                ResourceConsumer, ,)
                    GpioInt (Edge, ActiveHigh, Exclusive, PullDown, 0x0000,
                            "\\_SB.GPO2", 0x00, ResourceConsumer, , )
                    { // Pin list
                        0
                    }
                })

                Method (_CRS, 0, Serialized)
                {
                    Return (RBUF)
                }
            }
        }
    }

который затем можно скомпилировать в двоичный формат AML::

    $ iasl minnowmax.asl

    Intel ACPI Component Architecture
    ASL Optimizing Compiler version 20140214-64 [Mar 29 2014]
    Copyright (c) 2000 - 2014 Intel Corporation

    ASL Input:     minnomax.asl - 30 lines, 614 bytes, 7 keywords
    AML Output:    minnowmax.aml - 165 bytes, 6 named objects, 1 executable opcodes

[1] https://www.elinux.org/Minnowboard:MinnowMax#Low_Speed_Expansion_.28Top.29

Получившийся код AML затем может быть загружен ядром одним из приведённых ниже
способов.

Загрузка таблиц ACPI SSDT из initrd
===================================

Этот вариант позволяет загружать определяемые пользователем таблицы SSDT из
initrd и полезен, когда система не поддерживает EFI или когда для EFI недостаточно
места для хранения.

Он работает аналогично переопределению/обновлению таблиц ACPI на основе initrd:
код SSDT AML должен быть размещён в первом, несжатом initrd по пути
"kernel/firmware/acpi". Можно использовать несколько файлов, и это приведёт к
загрузке нескольких таблиц. Разрешены только таблицы SSDT и OEM. Подробнее см.
initrd_table_override.txt.

Вот пример::

    # Add the raw ACPI tables to an uncompressed cpio archive.
    # They must be put into a /kernel/firmware/acpi directory inside the
    # cpio archive.
    # The uncompressed cpio archive must be the first.
    # Other, typically compressed cpio archives, must be
    # concatenated on top of the uncompressed one.
    mkdir -p kernel/firmware/acpi
    cp ssdt.aml kernel/firmware/acpi

    # Create the uncompressed cpio archive and concatenate the original initrd
    # on top:
    find kernel | cpio -H newc --create > /boot/instrumented_initrd
    cat /boot/initrd >>/boot/instrumented_initrd

Загрузка таблиц ACPI SSDT из переменных EFI
===========================================

Это предпочтительный метод, когда платформа поддерживает EFI, поскольку он
обеспечивает постоянный и независимый от ОС способ хранения определяемых
пользователем таблиц SSDT. Также ведётся работа по реализации поддержки EFI для
загрузки определяемых пользователем таблиц SSDT, и использование этого метода
упростит переход на механизм загрузки EFI, когда он появится. Чтобы включить его,
параметр CONFIG_EFI_CUSTOM_SSDT_OVERLAYS должен быть установлен в y.

Чтобы загрузить таблицы SSDT из переменной EFI, можно использовать параметр
командной строки ядра ``"efivar_ssdt=..."`` (имя ограничено 16 символами).
Аргументом этого параметра является имя используемой переменной. Если существует
несколько переменных с одинаковым именем, но с разными GUID производителя, будут
загружены все они.

Чтобы сохранить код AML в переменной EFI, можно использовать файловую систему
efivarfs. Во всех недавних дистрибутивах она включена и смонтирована по умолчанию
в /sys/firmware/efi/efivars.

Создание нового файла в /sys/firmware/efi/efivars автоматически создаст новую
переменную EFI. Обновление файла в /sys/firmware/efi/efivars обновит переменную
EFI. Обратите внимание, что имя файла должно иметь специальный формат
"Name-GUID" и что первые 4 байта в файле (в формате little-endian) представляют
атрибуты переменной EFI (см. EFI_VARIABLE_MASK в include/linux/efi.h). Запись в
файл также должна выполняться одной операцией записи.

Например, можно использовать следующий bash-скрипт для создания/обновления
переменной EFI с содержимым из заданного файла::

    #!/bin/sh -e

    while [ -n "$1" ]; do
            case "$1" in
            "-f") filename="$2"; shift;;
            "-g") guid="$2"; shift;;
            *) name="$1";;
            esac
            shift
    done

    usage()
    {
            echo "Syntax: ${0##*/} -f filename [ -g guid ] name"
            exit 1
    }

    [ -n "$name" -a -f "$filename" ] || usage

    EFIVARFS="/sys/firmware/efi/efivars"

    [ -d "$EFIVARFS" ] || exit 2

    if stat -tf $EFIVARFS | grep -q -v de5e81e4; then
            mount -t efivarfs none $EFIVARFS
    fi

    # try to pick up an existing GUID
    [ -n "$guid" ] || guid=$(find "$EFIVARFS" -name "$name-*" | head -n1 | cut -f2- -d-)

    # use a randomly generated GUID
    [ -n "$guid" ] || guid="$(cat /proc/sys/kernel/random/uuid)"

    # efivarfs expects all of the data in one write
    tmp=$(mktemp)
    /bin/echo -ne "\007\000\000\000" | cat - $filename > $tmp
    dd if=$tmp of="$EFIVARFS/$name-$guid" bs=$(stat -c %s $tmp)
    rm $tmp

Загрузка таблиц ACPI SSDT из configfs
=====================================

Этот вариант позволяет загружать определяемые пользователем таблицы SSDT из
пространства пользователя через интерфейс configfs. Параметр
CONFIG_ACPI_CONFIGFS должен быть выбран, а configfs должна быть смонтирована.
В следующих примерах предполагается, что configfs смонтирована в
/sys/kernel/config.

Новые таблицы можно загрузить, создавая новые каталоги в
/sys/kernel/config/acpi/table и записывая код SSDT AML в атрибут aml::

    cd /sys/kernel/config/acpi/table
    mkdir my_ssdt
    cat ~/ssdt.aml > my_ssdt/aml
