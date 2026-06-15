.. SPDX-License-Identifier: GPL-2.0

=====================
Intel North Mux-Agent
=====================

Введение
========

North Mux-Agent — это функция прошивки Intel PMC, которая поддерживается на
большинстве платформ на базе Intel, имеющих микроконтроллер PMC. Она
используется для настройки различных USB-мультиплексоров/демультиплексоров в
системе. Платформы, которые позволяют настраивать mux-agent из операционной
системы, имеют объект ACPI-устройства (узел) с HID "INTC105C", представляющий
его.

Драйвер North Mux-Agent (он же Intel PMC Mux Control, или просто mux-agent)
взаимодействует с микроконтроллером PMC, используя метод PMC IPC
(drivers/platform/x86/intel_scu_ipc.c). Драйвер регистрируется в классе USB
Type-C Mux Class, что позволяет драйверам USB Type-C Controller и Interface
настраивать ориентацию штекера кабеля и режим (с Alternate Modes). Драйвер также
регистрируется в классе USB Role Class, чтобы поддерживать оба режима — USB Host
и Device. Драйвер находится здесь: drivers/usb/typec/mux/intel_pmc_mux.c.

Узлы портов
===========

Общее
-----

Для каждого USB Type-C коннектора, находящегося под управлением mux-agent в
системе, существует отдельный дочерний узел под узлом устройства PMC mux-agent.
Эти узлы представляют не сами коннекторы, а «каналы» в mux-agent, которые
ассоциированы с коннекторами::

	Scope (_SB.PCI0.PMC.MUX)
	{
	    Device (CH0)
	    {
		Name (_ADR, 0)
	    }

	    Device (CH1)
	    {
		Name (_ADR, 1)
	    }
	}

_PLD (Physical Location of Device)
----------------------------------

Необязательный объект _PLD может использоваться с узлами портов (каналов). Если
_PLD задан, он должен соответствовать _PLD узла коннектора::

	Scope (_SB.PCI0.PMC.MUX)
	{
	    Device (CH0)
	    {
		Name (_ADR, 0)
	        Method (_PLD, 0, NotSerialized)
                {
		    /* Consider this as pseudocode. */
		    Return (\_SB.USBC.CON0._PLD())
		}
	    }
	}

Специфичные для mux-agent свойства устройства _DSD
--------------------------------------------------

Номера портов
~~~~~~~~~~~~~

Чтобы настроить мультиплексоры за USB Type-C коннектором, прошивке PMC необходимо
знать порт USB2 и порт USB3, которые ассоциированы с коннектором. Драйвер
извлекает правильные номера портов, считывая определённые свойства устройства
_DSD с именами "usb2-port-number" и "usb3-port-number". Эти свойства имеют
целочисленное значение, означающее индекс порта. Номер индекса порта начинается
с 1, а значение 0 недопустимо. Драйвер использует номера, извлечённые из этих
свойств устройства, как есть, при отправке сообщений, специфичных для mux-agent,
в PMC::

	Name (_DSD, Package () {
	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
	    Package() {
	        Package () {"usb2-port-number", 6},
	        Package () {"usb3-port-number", 3},
	    },
	})

Ориентация
~~~~~~~~~~

В зависимости от платформы линии данных и SBU, идущие от коннектора, могут быть
«фиксированными» с точки зрения mux-agent, что означает, что драйвер mux-agent
не должен настраивать их в соответствии с ориентацией штекера кабеля. Это может
происходить, например, если ретаймер на платформе обрабатывает ориентацию
штекера кабеля. Драйвер использует определённые свойства устройства
"sbu-orientation" (SBU) и "hsl-orientation" (данные), чтобы знать, являются ли
эти линии «фиксированными» и в какой ориентации. Значение этих свойств является
строковым и может быть одним из тех, что определены для ориентации USB Type-C
коннектора: "normal" или "reversed"::

	Name (_DSD, Package () {
	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
	    Package() {
	        Package () {"sbu-orientation", "normal"},
	        Package () {"hsl-orientation", "normal"},
	    },
	})

Пример ASL
==========

Следующий ASL — это пример, показывающий узел mux-agent и два коннектора под его
управлением::

	Scope (_SB.PCI0.PMC)
	{
	    Device (MUX)
	    {
	        Name (_HID, "INTC105C")

	        Device (CH0)
	        {
	            Name (_ADR, 0)

	            Name (_DSD, Package () {
	                ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
	                Package() {
	                    Package () {"usb2-port-number", 6},
	                    Package () {"usb3-port-number", 3},
	                    Package () {"sbu-orientation", "normal"},
	                    Package () {"hsl-orientation", "normal"},
	                },
	            })
	        }

	        Device (CH1)
	        {
	            Name (_ADR, 1)

	            Name (_DSD, Package () {
	                ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
	                Package() {
	                    Package () {"usb2-port-number", 5},
	                    Package () {"usb3-port-number", 2},
	                    Package () {"sbu-orientation", "normal"},
	                    Package () {"hsl-orientation", "normal"},
	                },
	            })
	        }
	    }
	}
