.. SPDX-License-Identifier: GPL-2.0

.. include:: <isonum.txt>

Драйвер процессора обработки изображений (ISP) OMAP 3
=====================================================

Copyright |copy| 2010 Nokia Corporation

Copyright |copy| 2009 Texas Instruments, Inc.

Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
Sakari Ailus <sakari.ailus@iki.fi>, David Cohen <dacohen@gmail.com>


Введение
--------

Этот файл документирует драйвер процессора обработки изображений (ISP) Texas
Instruments OMAP 3, расположенный в drivers/media/platform/ti/omap3isp.
Изначальный драйвер был написан компанией Texas Instruments, однако с тех пор
он был переписан (дважды) в Nokia.

Драйвер успешно использовался на следующих версиях OMAP 3:

- 3430
- 3530
- 3630

Драйвер реализует интерфейсы V4L2, Media controller и v4l2_subdev.
Поддерживаются драйверы сенсоров, объективов и вспышек, использующие интерфейс
v4l2_subdev в ядре.


Разделение на subdev'ы
----------------------

ISP OMAP 3 разделён на subdev'ы V4L2, причём каждый из блоков внутри ISP имеет
один subdev, представляющий его. Каждый из subdev'ов предоставляет интерфейс
subdev V4L2 в пространство пользователя (userspace).

- OMAP3 ISP CCP2
- OMAP3 ISP CSI2a
- OMAP3 ISP CCDC
- OMAP3 ISP preview
- OMAP3 ISP resizer
- OMAP3 ISP AEWB
- OMAP3 ISP AF
- OMAP3 ISP histogram

Каждое возможное соединение (link) в ISP моделируется соединением в интерфейсе
Media controller. Пример программы см. в [#]_.


Управление ISP OMAP 3
---------------------

В общем случае настройки, переданные в ISP OMAP 3, вступают в силу в начале
следующего кадра. Это происходит, когда модуль становится бездействующим
(idle) в течение периода вертикального гашения (vertical blanking) на сенсоре.
В режиме «память-в-память» (memory-to-memory) конвейер выполняется по одному
кадру за раз. Применение настроек происходит между кадрами.

Все блоки в ISP, за исключением приёмника CSI-2 и, возможно, приёмника CCP2,
требуют получения полных кадров. Поэтому сенсоры никогда не должны отправлять
ISP частичные кадры.

Autoidle имеет проблемы с некоторыми блоками ISP, по крайней мере на 3430.
Autoidle включается на 3630 только тогда, когда параметр модуля omap3isp
autoidle отличен от нуля.

Технические справочные руководства (TRM) и другая документация
--------------------------------------------------------------

OMAP 3430 TRM:
<URL:http://focus.ti.com/pdfs/wtbu/OMAP34xx_ES3.1.x_PUBLIC_TRM_vZM.zip>
Дата обращения 2011-03-05.

OMAP 35xx TRM:
<URL:http://www.ti.com/litv/pdf/spruf98o> Дата обращения 2011-03-05.

OMAP 3630 TRM:
<URL:http://focus.ti.com/pdfs/wtbu/OMAP36xx_ES1.x_PUBLIC_TRM_vQ.zip>
Дата обращения 2011-03-05.

DM 3730 TRM:
<URL:http://www.ti.com/litv/pdf/sprugn4h> Дата обращения 2011-03-06.


Ссылки
------

.. [#] http://git.ideasonboard.org/?p=media-ctl.git;a=summary
