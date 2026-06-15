.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later

.. _frontend-properties:

***************
Типы свойств
***************

Настройка на физический канал цифрового ТВ и запуск его декодирования
требуют изменения набора параметров, чтобы управлять тюнером,
демодулятором, линейным малошумящим усилителем (Linear Low-noise Amplifier,
LNA) и задавать антенную подсистему через управление спутниковым
оборудованием — Satellite Equipment Control, SEC (в спутниковых системах).
Конкретные параметры специфичны для каждого стандарта цифрового ТВ и могут
меняться по мере развития спецификаций цифрового ТВ.

В прошлом (вплоть до версии 3 DVB API — DVBv3) использовалась стратегия с
объединением (union), в которое были сгруппированы параметры, необходимые
для настройки систем доставки DVB-S, DVB-C, DVB-T и ATSC. Проблема в том,
что с появлением стандартов второго поколения размер такого объединения
стал недостаточно велик, чтобы сгруппировать структуры, которые потребовались
бы для этих новых стандартов. Кроме того, его расширение нарушило бы
совместимость с userspace.

Поэтому устаревший подход на основе объединений/структур был признан
устаревшим в пользу подхода на основе набора свойств. При таком подходе
:ref:`FE_GET_PROPERTY и FE_SET_PROPERTY <FE_GET_PROPERTY>` используются
для настройки фронтенда и чтения его состояния.

Конкретное действие определяется набором пар cmd/data структуры dtv_property.
Одним вызовом ioctl можно получить/установить до 64 свойств.

В этом разделе описан новый и рекомендуемый способ настройки фронтенда,
поддерживающий все системы доставки цифрового ТВ.

.. note::

   1. В версии 3 Linux DVB API настройка фронтенда выполнялась через
      структуру :c:type:`dvb_frontend_parameters`.

   2. Не используйте вызовы версии 3 DVB API на оборудовании, поддерживающем
      более новые стандарты. Такой API не предоставляет поддержки либо
      предоставляет очень ограниченную поддержку новых стандартов и/или
      нового оборудования.

   3. В настоящее время большинство фронтендов поддерживают несколько систем
      доставки. Только с помощью вызовов версии 5 DVB API можно переключаться
      между несколькими системами доставки, поддерживаемыми фронтендом.

   4. Версия 5 DVB API также называется *S2API*, поскольку первым новым
      стандартом, добавленным в неё, был DVB-S2.

**Пример**: чтобы настроить оборудование на канал DVB-C на частоте 651 кГц,
модулированный 256-QAM, FEC 3/4 и со скоростью передачи символов 5,217
Мбод, на ioctl :ref:`FE_SET_PROPERTY <FE_GET_PROPERTY>` следует отправить
такие свойства:

  :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>` = SYS_DVBC_ANNEX_A

  :ref:`DTV_FREQUENCY <DTV-FREQUENCY>` = 651000000

  :ref:`DTV_MODULATION <DTV-MODULATION>` = QAM_256

  :ref:`DTV_INVERSION <DTV-INVERSION>` = INVERSION_AUTO

  :ref:`DTV_SYMBOL_RATE <DTV-SYMBOL-RATE>` = 5217000

  :ref:`DTV_INNER_FEC <DTV-INNER-FEC>` = FEC_3_4

  :ref:`DTV_TUNE <DTV-TUNE>`

Код, который выполнял бы вышеописанное, показан в
:ref:`dtv-prop-example`.

.. code-block:: c
    :caption: Example: Setting digital TV frontend properties
    :name: dtv-prop-example

    #include <stdio.h>
    #include <fcntl.h>
    #include <sys/ioctl.h>
    #include <linux/dvb/frontend.h>

    static struct dtv_property props[] = {
	{ .cmd = DTV_DELIVERY_SYSTEM, .u.data = SYS_DVBC_ANNEX_A },
	{ .cmd = DTV_FREQUENCY,       .u.data = 651000000 },
	{ .cmd = DTV_MODULATION,      .u.data = QAM_256 },
	{ .cmd = DTV_INVERSION,       .u.data = INVERSION_AUTO },
	{ .cmd = DTV_SYMBOL_RATE,     .u.data = 5217000 },
	{ .cmd = DTV_INNER_FEC,       .u.data = FEC_3_4 },
	{ .cmd = DTV_TUNE }
    };

    static struct dtv_properties dtv_prop = {
	.num = 6, .props = props
    };

    int main(void)
    {
	int fd = open("/dev/dvb/adapter0/frontend0", O_RDWR);

	if (!fd) {
	    perror ("open");
	    return -1;
	}
	if (ioctl(fd, FE_SET_PROPERTY, &dtv_prop) == -1) {
	    perror("ioctl");
	    return -1;
	}
	printf("Frontend set\\n");
	return 0;
    }

.. attention:: Хотя код ядра можно вызывать напрямую, как в примере выше,
   настоятельно рекомендуется использовать
   `libdvbv5 <https://linuxtv.org/docs/libdvbv5/index.html>`__, поскольку
   она предоставляет абстракцию для работы с поддерживаемыми стандартами
   цифрового ТВ и методы для типовых операций, таких как сканирование
   программ и чтение/запись файлов дескрипторов каналов.

.. toctree::
    :maxdepth: 1

    fe_property_parameters
    frontend-stat-properties
    frontend-property-terrestrial-systems
    frontend-property-cable-systems
    frontend-property-satellite-systems
    frontend-header
