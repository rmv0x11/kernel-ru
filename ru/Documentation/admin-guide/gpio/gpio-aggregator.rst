.. SPDX-License-Identifier: GPL-2.0-only

GPIO Aggregator
===============

GPIO Aggregator предоставляет механизм для агрегирования GPIO и представления их
как нового gpio_chip.  Это поддерживает следующие сценарии использования.


Агрегирование GPIO с помощью Sysfs
----------------------------------

Контроллеры GPIO экспортируются в пространство пользователя (userspace) через
символьные устройства /dev/gpiochip*.  Контроль доступа к этим устройствам
обеспечивается стандартными правами файловой системы UNIX по принципу «всё или
ничего»: либо контроллер GPIO доступен пользователю, либо нет.

GPIO Aggregator предоставляет контроль доступа для набора из одного или
нескольких GPIO путём их агрегирования в новый gpio_chip, который может быть
назначен группе или пользователю с помощью стандартных механизмов владения и
прав доступа к файлам UNIX.  Кроме того, это упрощает и делает более безопасным
экспорт GPIO в виртуальную машину, так как ВМ может просто захватить контроллер
GPIO целиком и больше не должна заботиться о том, какие GPIO захватывать, а какие
нет, что уменьшает поверхность атаки.

Агрегированные контроллеры GPIO создаются и уничтожаются путём записи в файлы
атрибутов «только для записи» в sysfs.

    /sys/bus/platform/drivers/gpio-aggregator/

	"new_device" ...
		Пространство пользователя может попросить ядро создать
		агрегированный контроллер GPIO, записав в файл "new_device"
		строку, описывающую агрегируемые GPIO, в формате

		.. code-block:: none

		    [<gpioA>] [<gpiochipB> <offsets>] ...

		Где:

		    "<gpioA>" ...
			    это имя линии GPIO,

		    "<gpiochipB>" ...
			    это метка чипа GPIO, и

		    "<offsets>" ...
			    это разделённый запятыми список смещений GPIO и/или
			    диапазонов смещений GPIO, обозначаемых дефисами.

		Пример: Создать новый агрегатор GPIO путём агрегирования линии
		GPIO 19 чипа "e6052000.gpio" и линий GPIO 20-21 чипа
		"e6050000.gpio" в новый gpio_chip:

		.. code-block:: sh

		    $ echo 'e6052000.gpio 19 e6050000.gpio 20-21' > new_device

	"delete_device" ...
		Пространство пользователя может попросить ядро уничтожить
		агрегированный контроллер GPIO после использования, записав его
		имя устройства в файл "delete_device".

		Пример: Уничтожить ранее созданный агрегированный контроллер
		GPIO, который предполагается равным "gpio-aggregator.0":

		.. code-block:: sh

		    $ echo gpio-aggregator.0 > delete_device


Агрегирование GPIO с помощью Configfs
-------------------------------------

**Group:** ``/config/gpio-aggregator``

    Это корневой каталог дерева configfs для gpio-aggregator.

**Group:** ``/config/gpio-aggregator/<example-name>``

    Этот каталог представляет устройство-агрегатор GPIO. Вы можете присвоить
    любое имя ``<example-name>`` (например, ``agg0``), кроме имён, начинающихся
    с префикса ``_sysfs``, которые зарезервированы для автоматически
    генерируемых записей configfs, соответствующих устройствам, созданным через
    Sysfs.

**Attribute:** ``/config/gpio-aggregator/<example-name>/live``

    Атрибут ``live`` позволяет инициировать фактическое создание устройства
    после того, как оно полностью настроено. Допустимые значения:

    * ``1``, ``yes``, ``true`` : включить виртуальное устройство
    * ``0``, ``no``, ``false`` : выключить виртуальное устройство

**Attribute:** ``/config/gpio-aggregator/<example-name>/dev_name``

    Доступный только для чтения атрибут ``dev_name`` показывает имя устройства в
    том виде, в каком оно появится в системе на шине platform (например,
    ``gpio-aggregator.0``). Это полезно для идентификации символьного устройства
    вновь созданного агрегатора. Если это ``gpio-aggregator.0``, то путь
    ``/sys/devices/platform/gpio-aggregator.0/gpiochipX`` сообщает вам, что
    идентификатор устройства GPIO равен ``X``.

Вы должны создать подкаталоги для каждой виртуальной линии, которую хотите
создать, назвав их в точности ``line0``, ``line1``, ..., ``lineY``, если вы
хотите создать ``Y+1`` (Y >= 0) линий.  Настройте все линии перед активацией
устройства, установив ``live`` в 1.

**Group:** ``/config/gpio-aggregator/<example-name>/<lineY>/``

    Этот каталог представляет линию GPIO для включения в агрегатор.

**Attribute:** ``/config/gpio-aggregator/<example-name>/<lineY>/key``

**Attribute:** ``/config/gpio-aggregator/<example-name>/<lineY>/offset``

    Значения по умолчанию после создания каталога ``<lineY>``:

    * ``key`` : <пусто>
    * ``offset`` : -1

    ``key`` всегда должен быть задан явно, тогда как ``offset`` зависит от
    обстоятельств. Для каждого ``<lineY>`` существуют два шаблона настройки:

    (a). Для поиска по имени линии GPIO:

         * Установите ``key`` равным имени линии.
         * Убедитесь, что ``offset`` остаётся -1 (значение по умолчанию).

    (b). Для поиска по имени чипа GPIO и смещению линии внутри чипа:

         * Установите ``key`` равным имени чипа.
         * Установите ``offset`` равным смещению линии (0 <= ``offset`` < 65535).

**Attribute:** ``/config/gpio-aggregator/<example-name>/<lineY>/name``

    Атрибут ``name`` задаёт пользовательское имя для lineY. Если он не задан,
    линия останется без имени.

После завершения настройки атрибут ``'live'`` должен быть установлен в 1, чтобы
создать устройство-агрегатор. Его можно установить обратно в 0, чтобы уничтожить
виртуальное устройство. Модуль будет синхронно ожидать успешного зондирования
(probe) нового устройства-агрегатора, и если этого не произойдёт, запись в
``'live'`` приведёт к ошибке. Это поведение отличается от случая, когда вы
создаёте устройство через интерфейс sysfs ``new_device``.

.. note::

   Для агрегаторов, созданных через Sysfs, записи configfs генерируются
   автоматически и появляются как ``/config/gpio-aggregator/_sysfs.<N>/``. Вы
   не можете добавлять или удалять каталоги линий с помощью mkdir(2)/rmdir(2).
   Чтобы изменить линии, вы должны использовать интерфейс "delete_device" для
   демонтажа существующего устройства и настроить его заново с нуля. Тем не
   менее, вы по-прежнему можете переключать агрегатор с помощью атрибута
   ``live`` и вручную изменять атрибуты ``key``, ``offset`` и ``name`` для
   каждой линии, когда ``live`` установлен в 0 (т.е. когда агрегатор не ожидает
   отложенного зондирования).

Примеры команд настройки
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: sh

    # Create a directory for an aggregator device
    $ mkdir /sys/kernel/config/gpio-aggregator/agg0

    # Configure each line
    $ mkdir /sys/kernel/config/gpio-aggregator/agg0/line0
    $ echo gpiochip0 > /sys/kernel/config/gpio-aggregator/agg0/line0/key
    $ echo 6         > /sys/kernel/config/gpio-aggregator/agg0/line0/offset
    $ echo test0     > /sys/kernel/config/gpio-aggregator/agg0/line0/name
    $ mkdir /sys/kernel/config/gpio-aggregator/agg0/line1
    $ echo gpiochip0 > /sys/kernel/config/gpio-aggregator/agg0/line1/key
    $ echo 7         > /sys/kernel/config/gpio-aggregator/agg0/line1/offset
    $ echo test1     > /sys/kernel/config/gpio-aggregator/agg0/line1/name

    # Activate the aggregator device
    $ echo 1         > /sys/kernel/config/gpio-aggregator/agg0/live


Универсальный драйвер GPIO
--------------------------

GPIO Aggregator также может использоваться как универсальный драйвер для
простого устройства, управляемого через GPIO и описанного в DT, без выделенного
драйвера в ядре.  Это полезно в промышленном управлении и похоже, например, на
spidev, который позволяет пользователю взаимодействовать с устройством SPI из
пространства пользователя.

Привязка устройства к GPIO Aggregator выполняется либо путём изменения драйвера
gpio-aggregator, либо путём записи в файл "driver_override" в Sysfs.

Пример: Если "door" — это устройство, управляемое через GPIO и описанное в DT,
использующее собственное значение compatible::

	door {
		compatible = "myvendor,mydoor";

		gpios = <&gpio2 19 GPIO_ACTIVE_HIGH>,
			<&gpio2 20 GPIO_ACTIVE_LOW>;
		gpio-line-names = "open", "lock";
	};

его можно привязать к GPIO Aggregator одним из способов:

1. Добавив его значение compatible в ``gpio_aggregator_dt_ids[]``,
2. Выполнив привязку вручную с помощью "driver_override":

.. code-block:: sh

    $ echo gpio-aggregator > /sys/bus/platform/devices/door/driver_override
    $ echo door > /sys/bus/platform/drivers/gpio-aggregator/bind

После этого создаётся новый gpiochip "door":

.. code-block:: sh

    $ gpioinfo door
    gpiochip12 - 2 lines:
	    line   0:       "open"       unused   input  active-high
	    line   1:       "lock"       unused   input  active-high
