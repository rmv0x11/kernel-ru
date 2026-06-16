.. SPDX-License-Identifier: GPL-2.0

Драйвер cx2341x
===============

Несжатый формат файла
---------------------

cx23416 может выдавать (а cx23415 также может читать) необработанный вывод YUV.
Формат кадра YUV — это NV12 с линейным тайлингом 16x16 (V4L2_PIX_FMT_NV12_16L16).

Используется формат YUV 4:2:0, в котором приходится 1 байт Y на пиксель и по 1
байту U и V на четыре пикселя.

Данные кодируются в виде двух плоскостей макроблоков: первая содержит значения
Y, вторая — макроблоки UV.

Плоскость Y делится на блоки 16x16 пикселей слева направо и сверху вниз. Каждый
блок передаётся по очереди, построчно.

Таким образом, первые 16 байт — это первая строка верхнего левого блока, вторые
16 байт — вторая строка верхнего левого блока и т. д. После передачи этого блока
передаётся первая строка блока, расположенного справа от первого блока, и т. д.

Плоскость UV делится на блоки из 16x8 значений UV слева направо, сверху вниз.
Каждый блок передаётся по очереди, построчно.

Таким образом, первые 16 байт — это первая строка верхнего левого блока, и они
содержат 8 пар значений UV (всего 16 байт). Вторые 16 байт — это вторая строка
из 8 пар UV верхнего левого блока и т. д. После передачи этого блока передаётся
первая строка блока, расположенного справа от первого блока, и т. д.

Приведённый ниже код дан в качестве примера того, как преобразовать
V4L2_PIX_FMT_NV12_16L16 в отдельные плоскости Y, U и V. Этот код предполагает
кадры размером 720x576 (PAL) пикселей.

Ширина кадра всегда равна 720 пикселям независимо от фактически указанной ширины.

Если высота не кратна 32 строкам, то в захваченном видео отсутствуют макроблоки
в конце, и оно непригодно для использования. Поэтому высота должна быть кратна 32.

Пример несжатого формата на языке c
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: c

	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	static unsigned char frame[576*720*3/2];
	static unsigned char framey[576*720];
	static unsigned char frameu[576*720 / 4];
	static unsigned char framev[576*720 / 4];

	static void de_macro_y(unsigned char* dst, unsigned char *src, int dstride, int w, int h)
	{
	unsigned int y, x, i;

	// descramble Y plane
	// dstride = 720 = w
	// The Y plane is divided into blocks of 16x16 pixels
	// Each block in transmitted in turn, line-by-line.
	for (y = 0; y < h; y += 16) {
		for (x = 0; x < w; x += 16) {
		for (i = 0; i < 16; i++) {
			memcpy(dst + x + (y + i) * dstride, src, 16);
			src += 16;
		}
		}
	}
	}

	static void de_macro_uv(unsigned char *dstu, unsigned char *dstv, unsigned char *src, int dstride, int w, int h)
	{
	unsigned int y, x, i;

	// descramble U/V plane
	// dstride = 720 / 2 = w
	// The U/V values are interlaced (UVUV...).
	// Again, the UV plane is divided into blocks of 16x16 UV values.
	// Each block in transmitted in turn, line-by-line.
	for (y = 0; y < h; y += 16) {
		for (x = 0; x < w; x += 8) {
		for (i = 0; i < 16; i++) {
			int idx = x + (y + i) * dstride;

			dstu[idx+0] = src[0];  dstv[idx+0] = src[1];
			dstu[idx+1] = src[2];  dstv[idx+1] = src[3];
			dstu[idx+2] = src[4];  dstv[idx+2] = src[5];
			dstu[idx+3] = src[6];  dstv[idx+3] = src[7];
			dstu[idx+4] = src[8];  dstv[idx+4] = src[9];
			dstu[idx+5] = src[10]; dstv[idx+5] = src[11];
			dstu[idx+6] = src[12]; dstv[idx+6] = src[13];
			dstu[idx+7] = src[14]; dstv[idx+7] = src[15];
			src += 16;
		}
		}
	}
	}

	/*************************************************************************/
	int main(int argc, char **argv)
	{
	FILE *fin;
	int i;

	if (argc == 1) fin = stdin;
	else fin = fopen(argv[1], "r");

	if (fin == NULL) {
		fprintf(stderr, "cannot open input\n");
		exit(-1);
	}
	while (fread(frame, sizeof(frame), 1, fin) == 1) {
		de_macro_y(framey, frame, 720, 720, 576);
		de_macro_uv(frameu, framev, frame + 720 * 576, 720 / 2, 720 / 2, 576 / 2);
		fwrite(framey, sizeof(framey), 1, stdout);
		fwrite(framev, sizeof(framev), 1, stdout);
		fwrite(frameu, sizeof(frameu), 1, stdout);
	}
	fclose(fin);
	return 0;
	}


Формат встроенных данных VBI V4L2_MPEG_STREAM_VBI_FMT_IVTV
----------------------------------------------------------

Автор: Hans Verkuil <hverkuil@kernel.org>


В этом разделе описывается формат V4L2_MPEG_STREAM_VBI_FMT_IVTV данных VBI,
встроенных в программный поток MPEG-2. Этот формат отчасти продиктован некоторыми
аппаратными ограничениями драйвера ivtv (драйвера для микросхем Conexant
cx23415/6), в частности максимальным размером данных VBI. Всё, что длиннее,
обрезается при воспроизведении потока MPEG через cx23415.

Преимущество этого формата в том, что он очень компактен и что все данные VBI для
всех строк могут быть сохранены, по-прежнему укладываясь в максимально допустимый
размер.

Идентификатор потока (stream ID) данных VBI равен 0xBD. Максимальный размер
встроенных данных составляет 4 + 43 * 36, что складывается из 4 байт заголовка и
2 * 18 строк VBI с заголовком в 1 байт и полезной нагрузкой в 42 байта каждая.
Всё, что выходит за этот предел, обрезается прошивкой (firmware) cx23415/6. Кроме
данных строк VBI, нам также нужны 36 бит для битовой маски, определяющей, какие
строки захватываются, и 4 байта для magic cookie, указывающего, что этот пакет
данных содержит данные VBI формата V4L2_MPEG_STREAM_VBI_FMT_IVTV. Если
используются все строки, то места для битовой маски уже не остаётся. Чтобы решить
эту проблему, были введены два разных магических числа:

'itv0': после этого магического числа следуют два значения unsigned long. Биты
0-17 первого unsigned long обозначают, какие строки первого поля захватываются.
Биты 18-31 первого unsigned long и биты 0-3 второго unsigned long используются для
второго поля.

'ITV0': это магическое число предполагает, что захватываются все строки VBI, т. е.
неявно подразумевает, что битовые маски равны 0xffffffff и 0xf.

После этих magic cookie (и 8-байтовой битовой маски в случае cookie 'itv0')
начинаются захваченные строки VBI:

Для каждой строки младшие 4 бита первого байта содержат тип данных. Возможные
значения показаны в таблице ниже. Полезная нагрузка располагается в следующих 42
байтах.

Вот список возможных типов данных:

.. code-block:: c

	#define IVTV_SLICED_TYPE_TELETEXT       0x1     // Teletext (uses lines 6-22 for PAL)
	#define IVTV_SLICED_TYPE_CC             0x4     // Closed Captions (line 21 NTSC)
	#define IVTV_SLICED_TYPE_WSS            0x5     // Wide Screen Signal (line 23 PAL)
	#define IVTV_SLICED_TYPE_VPS            0x7     // Video Programming System (PAL) (line 16)
