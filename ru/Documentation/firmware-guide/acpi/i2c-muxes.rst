.. SPDX-License-Identifier: GPL-2.0

=======================
I2C-мультиплексоры ACPI
=======================

Чтобы описать иерархию устройств I2C, включающую I2C-мультиплексоры, требуется
ACPI-область Device () для каждого канала мультиплексора.

Рассмотрим следующую топологию::

    +------+   +------+
    | SMB1 |-->| MUX0 |--CH00--> i2c client A (0x50)
    |      |   | 0x70 |--CH01--> i2c client B (0x50)
    +------+   +------+

которой соответствует следующий ASL (в области \_SB)::

    Device (SMB1)
    {
        Name (_HID, ...)
        Device (MUX0)
        {
            Name (_HID, ...)
            Name (_CRS, ResourceTemplate () {
                I2cSerialBus (0x70, ControllerInitiated, I2C_SPEED,
                            AddressingMode7Bit, "\\_SB.SMB1", 0x00,
                            ResourceConsumer,,)
            }

            Device (CH00)
            {
                Name (_ADR, 0)

                Device (CLIA)
                {
                    Name (_HID, ...)
                    Name (_CRS, ResourceTemplate () {
                        I2cSerialBus (0x50, ControllerInitiated, I2C_SPEED,
                                    AddressingMode7Bit, "\\_SB.SMB1.MUX0.CH00",
                                    0x00, ResourceConsumer,,)
                    }
                }
            }

            Device (CH01)
            {
                Name (_ADR, 1)

                Device (CLIB)
                {
                    Name (_HID, ...)
                    Name (_CRS, ResourceTemplate () {
                        I2cSerialBus (0x50, ControllerInitiated, I2C_SPEED,
                                    AddressingMode7Bit, "\\_SB.SMB1.MUX0.CH01",
                                    0x00, ResourceConsumer,,)
                    }
                }
            }
        }
    }
