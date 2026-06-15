==============
Драйвер btmrvl
==============

Все команды используются через интерфейс debugfs.

Установка/получение конфигураций драйвера
=========================================

Путь:	/debug/btmrvl/config/

gpiogap=[n], hscfgcmd
	Эти команды используются для настройки параметров засыпания хоста (host sleep)::
	bit 8:0  -- Gap
	bit 16:8 -- GPIO

	где GPIO — номер вывода GPIO, используемого для пробуждения хоста.
	Это может быть любой допустимый номер вывода GPIO (например, 0-7) или 0xff (вместо
	него будет использовано пробуждение через интерфейс SDIO).

	где Gap — промежуток в миллисекундах между сигналом пробуждения и
	событием пробуждения, либо 0xff для специальной настройки засыпания хоста.

	Использование::

		# Use SDIO interface to wake up the host and set GAP to 0x80:
		echo 0xff80 > /debug/btmrvl/config/gpiogap
		echo 1 > /debug/btmrvl/config/hscfgcmd

		# Use GPIO pin #3 to wake up the host and set GAP to 0xff:
		echo 0x03ff >  /debug/btmrvl/config/gpiogap
		echo 1 > /debug/btmrvl/config/hscfgcmd

psmode=[n], pscmd
	Эти команды используются для включения/выключения режима автоматического засыпания

	где опция::

			1 	-- Enable auto sleep mode
			0 	-- Disable auto sleep mode

	Использование::

		# Enable auto sleep mode
		echo 1 > /debug/btmrvl/config/psmode
		echo 1 > /debug/btmrvl/config/pscmd

		# Disable auto sleep mode
		echo 0 > /debug/btmrvl/config/psmode
		echo 1 > /debug/btmrvl/config/pscmd


hsmode=[n], hscmd
	Эти команды используются для включения засыпания хоста или пробуждения прошивки

	где опция::

			1	-- Enable host sleep
			0	-- Wake up firmware

	Использование::

		# Enable host sleep
		echo 1 > /debug/btmrvl/config/hsmode
		echo 1 > /debug/btmrvl/config/hscmd

		# Wake up firmware
		echo 0 > /debug/btmrvl/config/hsmode
		echo 1 > /debug/btmrvl/config/hscmd


Получение состояния драйвера
============================

Путь:	/debug/btmrvl/status/

Использование::

	cat /debug/btmrvl/status/<args>

где args:

curpsmode
	Эта команда отображает текущее состояние автоматического засыпания.

psstate
	Эта команда отображает состояние энергосбережения.

hsstate
	Эта команда отображает состояние засыпания хоста.

txdnldrdy
	Эта команда отображает значение флага готовности загрузки Tx.

Выдача необработанной команды hci
=================================

Используйте hcitool для выдачи необработанной команды hci, см. руководство по hcitool

Использование::

	Hcitool cmd <ogf> <ocf> [Parameters]

Команда управления интерфейсом::

	hcitool cmd 0x3f 0x5b 0xf5 0x01 0x00    --Enable All interface
	hcitool cmd 0x3f 0x5b 0xf5 0x01 0x01    --Enable Wlan interface
	hcitool cmd 0x3f 0x5b 0xf5 0x01 0x02    --Enable BT interface
	hcitool cmd 0x3f 0x5b 0xf5 0x00 0x00    --Disable All interface
	hcitool cmd 0x3f 0x5b 0xf5 0x00 0x01    --Disable Wlan interface
	hcitool cmd 0x3f 0x5b 0xf5 0x00 0x02    --Disable BT interface

Прошивка SD8688
===============

Образы:

- /lib/firmware/sd8688_helper.bin
- /lib/firmware/sd8688.bin


Образы можно загрузить с:

git.infradead.org/users/dwmw2/linux-firmware.git/libertas/
