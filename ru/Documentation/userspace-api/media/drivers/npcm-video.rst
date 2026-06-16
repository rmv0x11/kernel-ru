.. SPDX-License-Identifier: GPL-2.0

.. include:: <isonum.txt>

Драйвер NPCM video
==================

Этот драйвер используется для управления движком захвата/дифференциации видео
(Video Capture/Differentiation, VCD) и движком кодирования и сжатия (Encoding
Compression Engine, ECE), присутствующими в SoC Nuvoton NPCM. VCD может
захватывать кадр из цифрового видеовхода и сравнивать два кадра в памяти, а
ECE может сжимать данные кадра в формат HEXTILE.

Элементы управления, специфичные для драйвера
---------------------------------------------

V4L2_CID_NPCM_CAPTURE_MODE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Движок VCD поддерживает два режима:

- режим COMPLETE:

  Захват следующего полного кадра в память.

- режим DIFF:

  Сравнение входящего кадра с кадром, сохранённым в памяти, и обновление
  дифференцированного кадра в памяти.

Приложение может использовать элемент управления ``V4L2_CID_NPCM_CAPTURE_MODE``
для задания режима VCD с помощью различных управляющих значений (enum
v4l2_npcm_capture_mode):

- ``V4L2_NPCM_CAPTURE_MODE_COMPLETE``: установит VCD в режим COMPLETE.
- ``V4L2_NPCM_CAPTURE_MODE_DIFF``: установит VCD в режим DIFF.

V4L2_CID_NPCM_RECT_COUNT
~~~~~~~~~~~~~~~~~~~~~~~~~~

При использовании формата V4L2_PIX_FMT_HEXTILE VCD захватит данные кадра, после
чего ECE сожмёт данные в прямоугольники HEXTILE и сохранит их в видеобуфере V4L2
с раскладкой, определённой в Remote Framebuffer Protocol:
::

           (RFC 6143, https://www.rfc-editor.org/rfc/rfc6143.html#section-7.6.1)

           +--------------+--------------+-------------------+
           | No. of bytes | Type [Value] | Description       |
           +--------------+--------------+-------------------+
           | 2            | U16          | x-position        |
           | 2            | U16          | y-position        |
           | 2            | U16          | width             |
           | 2            | U16          | height            |
           | 4            | S32          | encoding-type (5) |
           +--------------+--------------+-------------------+
           |             HEXTILE rectangle data              |
           +-------------------------------------------------+

Приложение может получить видеобуфер через VIDIOC_DQBUF, после чего вызвать
элемент управления ``V4L2_CID_NPCM_RECT_COUNT``, чтобы получить количество
прямоугольников HEXTILE в этом буфере.

Ссылки
------
include/uapi/linux/npcm-video.h

**Copyright** |copy| 2022 Nuvoton Technologies
