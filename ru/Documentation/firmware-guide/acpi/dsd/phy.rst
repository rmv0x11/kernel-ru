.. SPDX-License-Identifier: GPL-2.0

==============================
Шина MDIO и PHY в ACPI
==============================

PHY на шине MDIO [phy] опрашиваются и регистрируются с помощью
fwnode_mdiobus_register_phy().

Позднее, для подключения этих PHY к их соответствующим MAC, на
зарегистрированные на шине MDIO PHY необходимо сослаться.

Этот документ вводит два свойства _DSD, которые предназначены для
подключения PHY на шине MDIO [dsd-properties-rules] к уровню MAC.

Эти свойства определены в соответствии с документом "Device
Properties UUID For _DSD" [dsd-guide], и в содержащих их дескрипторах
данных устройства (Device Data Descriptors) должен использоваться UUID
daffd814-6eba-4d8c-8a91-bc9bbf4aa301.

phy-handle
----------
Для каждого узла MAC свойство устройства "phy-handle" используется для
ссылки на PHY, зарегистрированный на шине MDIO. Это обязательно для
сетевых интерфейсов, у которых PHY подключены к MAC через шину MDIO.

Во время инициализации драйвера шины MDIO PHY на этой шине опрашиваются
с помощью объекта _ADR, как показано ниже, и регистрируются на шине MDIO.

.. code-block:: none

      Scope(\_SB.MDI0)
      {
        Device(PHY1) {
          Name (_ADR, 0x1)
        } // end of PHY1

        Device(PHY2) {
          Name (_ADR, 0x2)
        } // end of PHY2
      }

Позднее, во время инициализации драйвера MAC, зарегистрированные
устройства PHY необходимо получить с шины MDIO. Для этого драйверу MAC
нужны ссылки на ранее зарегистрированные PHY, которые предоставляются
как ссылки на объект устройства (например, \_SB.MDI0.PHY1).

phy-mode
--------
Свойство _DSD "phy-mode" используется для описания подключения к PHY.
Допустимые значения "phy-mode" определены в [ethernet-controller].

managed
-------
Необязательное свойство, которое задаёт тип управления PHY.
Допустимые значения "managed" определены в [ethernet-controller].

fixed-link
----------
"fixed-link" описывается узлом-потомком, содержащим только данные, для
порта MAC, который связывается в пакете _DSD через иерархическое
расширение данных (UUID dbb8e3e6-5886-4ba6-8795-1319f52a966b в
соответствии с документом [dsd-guide] "_DSD Implementation Guide").
Этот узел-потомок должен включать обязательное свойство ("speed") и,
возможно, необязательные — полный список параметров и их значений
указан в [ethernet-controller].

Следующий пример на ASL иллюстрирует использование этих свойств.

Запись DSDT для узла MDIO
-------------------------

Шина MDIO имеет компонент SoC (контроллер MDIO) и платформенный
компонент (PHY на шине MDIO).

a) Кремниевый компонент
Этот узел описывает контроллер MDIO, MDI0
-----------------------------------------

.. code-block:: none

	Scope(_SB)
	{
	  Device(MDI0) {
	    Name(_HID, "NXP0006")
	    Name(_CCA, 1)
	    Name(_UID, 0)
	    Name(_CRS, ResourceTemplate() {
	      Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
	      Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
	       {
		 MDI0_IT
	       }
	    }) // end of _CRS for MDI0
	  } // end of MDI0
	}

b) Платформенный компонент
Узлы PHY1 и PHY2 представляют PHY, подключённые к шине MDIO MDI0
----------------------------------------------------------------

.. code-block:: none

	Scope(\_SB.MDI0)
	{
	  Device(PHY1) {
	    Name (_ADR, 0x1)
	  } // end of PHY1

	  Device(PHY2) {
	    Name (_ADR, 0x2)
	  } // end of PHY2
	}

Записи DSDT, представляющие узлы MAC
------------------------------------

Ниже приведены узлы MAC, в которых даются ссылки на узлы PHY.
phy-mode и phy-handle используются так, как пояснялось ранее.
-------------------------------------------------------------

.. code-block:: none

	Scope(\_SB.MCE0.PR17)
	{
	  Name (_DSD, Package () {
	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
		 Package () {
		     Package (2) {"phy-mode", "rgmii-id"},
		     Package (2) {"phy-handle", \_SB.MDI0.PHY1}
	      }
	   })
	}

	Scope(\_SB.MCE0.PR18)
	{
	  Name (_DSD, Package () {
	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
		Package () {
		    Package (2) {"phy-mode", "rgmii-id"},
		    Package (2) {"phy-handle", \_SB.MDI0.PHY2}}
	    }
	  })
	}

Пример узла MAC, в котором задано свойство "managed".
-----------------------------------------------------

.. code-block:: none

	Scope(\_SB.PP21.ETH0)
	{
	  Name (_DSD, Package () {
	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
		 Package () {
		     Package () {"phy-mode", "sgmii"},
		     Package () {"managed", "in-band-status"}
		 }
	   })
	}

Пример узла MAC с узлом-потомком "fixed-link".
----------------------------------------------

.. code-block:: none

	Scope(\_SB.PP21.ETH1)
	{
	  Name (_DSD, Package () {
	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
		 Package () {
		     Package () {"phy-mode", "sgmii"},
		 },
	    ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
		 Package () {
		     Package () {"fixed-link", "LNK0"}
		 }
	  })
	  Name (LNK0, Package(){ // Data-only subnode of port
	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
		 Package () {
		     Package () {"speed", 1000},
		     Package () {"full-duplex", 1}
		 }
	  })
	}

Список литературы
=================

[phy] Documentation/networking/phy.rst

[dsd-properties-rules]
    Documentation/firmware-guide/acpi/DSD-properties-rules.rst

[ethernet-controller]
    Documentation/devicetree/bindings/net/ethernet-controller.yaml

[dsd-guide] DSD Guide.
    https://github.com/UEFI/DSD-Guide/blob/main/dsd-guide.adoc, referenced
    2021-11-30.
