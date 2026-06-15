.. SPDX-License-Identifier: GPL-2.0

==============================================
Как заставить работать карты bt8xx
==============================================

Авторы:
	 Richard Walker,
	 Jamie Honan,
	 Michael Hunold,
	 Manu Abraham,
	 Uwe Bugla,
	 Michael Krufky

Общая информация
----------------

В качестве PCI-интерфейса этот класс карт использует bt878a, и для доступа к
шине i2c и выводам gpio чипсета bt8xx им требуется драйвер bttv.

Полный список карт на основе PCI-моста Conexant Bt8xx, поддерживаемых ядром
Linux, см. в Documentation/admin-guide/media/bttv-cardlist.rst.

Чтобы можно было скомпилировать ядро, следует включить некоторые параметры
конфигурации::

    ./scripts/config -e PCI
    ./scripts/config -e INPUT
    ./scripts/config -m I2C
    ./scripts/config -m MEDIA_SUPPORT
    ./scripts/config -e MEDIA_PCI_SUPPORT
    ./scripts/config -e MEDIA_ANALOG_TV_SUPPORT
    ./scripts/config -e MEDIA_DIGITAL_TV_SUPPORT
    ./scripts/config -e MEDIA_RADIO_SUPPORT
    ./scripts/config -e RC_CORE
    ./scripts/config -m VIDEO_BT848
    ./scripts/config -m DVB_BT8XX

Если вы хотите автоматически поддерживать все возможные варианты карт Bt8xx,
вам также следует выполнить::

    ./scripts/config -e MEDIA_SUBDRV_AUTOSELECT

.. note::

   Используйте следующие параметры с осторожностью, поскольку отключение
   драйверов, которые на самом деле необходимы, может привести к появлению
   DVB-устройств, которые невозможно настроить из-за отсутствия поддержки
   драйверов.

Если ваша цель — поддержать только конкретную плату, вы можете вместо этого
отключить MEDIA_SUBDRV_AUTOSELECT и вручную выбрать драйверы фронтендов,
необходимые для вашей платы. Так вы сможете сэкономить немного оперативной
памяти.

Сделать это можно, вызвав make xconfig/qconfig/menuconfig и просмотрев
параметры в указанных пунктах меню (доступны, только если отключён
``Autoselect ancillary drivers``:

#) ``Device drivers`` => ``Multimedia support`` => ``Customize TV tuners``
#) ``Device drivers`` => ``Multimedia support`` => ``Customize DVB frontends``

Затем в каждом из перечисленных выше меню выберите специфичные для вашей
карты модули фронтенда и тюнера.


Загрузка модулей
----------------

Обычный случай: если драйвер bttv обнаруживает DVB-карту на базе bt8xx, все
модули фронтенда и бэкенда будут загружены автоматически.

Исключениями являются:

- Старые ТВ-карты без EEPROM, имеющие общий идентификатор подсистемы PCI;
- Старые карты TwinHan DST или их клоны с CA-слотом или без него, не
  содержащие Eeprom.

В следующих случаях может потребоваться переопределить определение типа PCI
для драйверов bttv и dvb-bt8xx путём передачи параметров modprobe.

Запуск TwinHan и клонов
~~~~~~~~~~~~~~~~~~~~~~~~

Как показано в Documentation/admin-guide/media/bttv-cardlist.rst, TwinHan и
клоны используют параметр modprobe ``card=113``. Поэтому, чтобы корректно
определить такую карту для устройств без EEPROM, следует использовать::

	$ modprobe bttv card=113
	$ modprobe dst

Полезные параметры для уровня детализации и отладки модуля dst::

	verbose=0:		messages are disabled
		1:		only error messages are displayed
		2:		notifications are displayed
		3:		other useful messages are displayed
		4:		debug setting
	dst_addons=0:		card is a free to air (FTA) card only
		0x20:	card has a conditional access slot for scrambled channels
	dst_algo=0:		(default) Software tuning algorithm
	         1:		Hardware tuning algorithm


Автоматически определяемые значения задаются «строкой ответа» (response
string) карт.

В своих журналах вы увидите, например: dst_get_device_id: Recognize [DSTMCI].

Для сообщений об ошибках присылайте полный журнал с активированным verbose=4.
См. также Documentation/admin-guide/media/ci.rst.

Запуск нескольких карт
~~~~~~~~~~~~~~~~~~~~~~~

Полный список идентификаторов карт (Card ID) см. в
Documentation/admin-guide/media/bttv-cardlist.rst. Несколько примеров:

	===========================	===
	Brand name			ID
	===========================	===
	Pinnacle PCTV Sat		 94
	Nebula Electronics Digi TV	104
	pcHDTV HD-2000 TV		112
	Twinhan DST and clones		113
	Avermedia AverTV DVB-T 77:	123
	Avermedia AverTV DVB-T 761	124
	DViCO FusionHDTV DVB-T Lite	128
	DViCO FusionHDTV 5 Lite		135
	===========================	===

.. note::

   Когда у вас несколько карт, порядок идентификаторов карт должен
   соответствовать порядку, в котором они обнаруживаются системой. Обратите
   внимание, что удаление/установка других PCI-карт может изменить порядок
   обнаружения.

Пример::

	$ modprobe bttv card=113 card=135

В случае дальнейших проблем подпишитесь и присылайте вопросы в список
рассылки: linux-media@vger.kernel.org.

Зондирование карт с повреждённым идентификатором подсистемы PCI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Существуют некоторые карты TwinHan, EEPROM которых по той или иной причине
оказался повреждён. У таких карт нет правильного идентификатора подсистемы
PCI. Тем не менее, можно принудительно выполнить зондирование карт с помощью::

	$ echo 109e 0878 $subvendor $subdevice > \
		/sys/bus/pci/drivers/bt878/new_id

Два указанных там числа::

	109e: PCI_VENDOR_ID_BROOKTREE
	0878: PCI_DEVICE_ID_BROOKTREE_878
