.. SPDX-License-Identifier: GPL-2.0
.. include:: <isonum.txt>

============================================
Описание светодиодов и ссылки на них в ACPI
============================================

Отдельные светодиоды (LED) описываются узлами иерархического расширения данных
[5] под узлом устройства — микросхемы драйвера светодиодов. Свойство "reg" в
специфичных для светодиода узлах задаёт числовой ID каждого отдельного выхода
светодиода, к которому подключены светодиоды. [leds] Узлы иерархических данных
именуются "led@X", где X — номер выхода светодиода.

Ссылки на светодиоды в Device tree документированы в [video-interfaces], в
описании свойства "flash-leds". Если коротко, на светодиоды ссылаются напрямую
с помощью phandle.

ACPI позволяет (как и DT) использовать целочисленные аргументы после ссылки.
Комбинация ссылки на устройство драйвера светодиодов и целочисленного аргумента,
указывающего на свойство "reg" соответствующего светодиода, используется для
идентификации отдельных светодиодов. Значение свойства "reg" — это контракт
между прошивкой (firmware) и программным обеспечением, оно однозначно
идентифицирует выходы драйвера светодиодов.

Под устройством драйвера светодиодов первая запись в списке пакетов
иерархического расширения данных должна содержать строку "led@", за которой
следует номер светодиода, а затем имя объекта, на который ссылаются. Этот объект
должен быть назван "LED", за которым следует номер светодиода.

Пример
======

Ниже приведён пример на ASL для устройства датчика камеры и устройства драйвера
светодиодов для двух светодиодов. Объекты, не относящиеся к светодиодам или
ссылкам на них, опущены. ::

	Device (LED)
	{
		Name (_DSD, Package () {
			ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
			Package () {
				Package () { "led@0", LED0 },
				Package () { "led@1", LED1 },
			}
		})
		Name (LED0, Package () {
			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
			Package () {
				Package () { "reg", 0 },
				Package () { "flash-max-microamp", 1000000 },
				Package () { "flash-timeout-us", 200000 },
				Package () { "led-max-microamp", 100000 },
				Package () { "label", "white:flash" },
			}
		})
		Name (LED1, Package () {
			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
			Package () {
				Package () { "reg", 1 },
				Package () { "led-max-microamp", 10000 },
				Package () { "label", "red:indicator" },
			}
		})
	}

	Device (SEN)
	{
		Name (_DSD, Package () {
			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
			Package () {
				Package () {
					"flash-leds",
					Package () { "^LED.LED0", "^LED.LED1" },
				}
			}
		})
	}

где
::

	LED	устройство драйвера светодиодов
	LED0	первый светодиод
	LED1	второй светодиод
	SEN	устройство датчика камеры (или другое устройство, к которому относится светодиод)

Ссылки
======

[acpi] Advanced Configuration and Power Interface Specification.
    https://uefi.org/specifications/ACPI/6.4/, referenced 2021-11-30.

[data-node-ref] Documentation/firmware-guide/acpi/dsd/data-node-references.rst

[devicetree] Devicetree. https://www.devicetree.org, referenced 2019-02-21.

[dsd-guide] DSD Guide.
    https://github.com/UEFI/DSD-Guide/blob/main/dsd-guide.adoc, referenced
    2021-11-30.

[leds] Documentation/devicetree/bindings/leds/common.yaml

[video-interfaces] Documentation/devicetree/bindings/media/video-interfaces.yaml
