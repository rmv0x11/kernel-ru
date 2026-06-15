.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later

.. _net:

#####################################
Сетевой API цифрового ТВ (Digital TV)
#####################################

Сетевое устройство цифрового ТВ управляет отображением пакетов данных,
входящих в состав транспортного потока, в виртуальный сетевой интерфейс,
видимый через стандартный сетевой стек протоколов Linux.

В настоящее время поддерживаются две инкапсуляции:

-  `Multi Protocol Encapsulation (MPE) <http://en.wikipedia.org/wiki/Multiprotocol_Encapsulation>`__

-  `Ultra Lightweight Encapsulation (ULE) <http://en.wikipedia.org/wiki/Unidirectional_Lightweight_Encapsulation>`__

Чтобы создать виртуальные сетевые интерфейсы Linux, приложение должно
сообщить ядру, какие PID и какие типы инкапсуляции присутствуют в
транспортном потоке. Это делается через узел устройства
``/dev/dvb/adapter?/net?``. Данные будут доступны через виртуальные
сетевые интерфейсы ``dvb?_?`` и управляться/маршрутизироваться
стандартными утилитами ip (такими как ip, route, netstat, ifconfig и т. д.).

Типы данных и определения ioctl задаются в заголовочном файле
``linux/dvb/net.h``.


.. _net_fcalls:

Вызовы функций сетевого API цифрового ТВ
########################################

.. toctree::
    :maxdepth: 1

    net-types
    net-add-if
    net-remove-if
    net-get-if
