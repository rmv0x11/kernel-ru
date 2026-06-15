.. SPDX-License-Identifier: GPL-2.0

.. include:: <isonum.txt>

==============================================================================
Руководство администратора и пользователя по подсистеме мультимедиа
==============================================================================

Этот раздел содержит сведения об использовании подсистемы мультимедиа и
поддерживаемых ею драйверов.

Смотрите:

Documentation/userspace-api/media/index.rst

  - для API пространства пользователя, используемых на устройствах мультимедиа.

Documentation/driver-api/media/index.rst

  - для информации о разработке драйверов и API ядра, используемых
    устройствами мультимедиа;

Documentation/process/debugging/media_specific_debugging_guide.rst

  - для рекомендаций по основным инструментам и приёмам отладки драйверов в
    этой подсистеме

.. toctree::
	:caption: Содержание
	:maxdepth: 2
	:numbered:

	intro
	building

	remote-controller

	cec

	dvb

	cardlist

	v4l-drivers
	dvb-drivers

**Авторское право** |copy| 1999-2020 : Разработчики LinuxTV

::

  This documentation is free software; you can redistribute it and/or modify it
  under the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option) any
  later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
  more details.

  For more details see the file COPYING in the source distribution of Linux.
