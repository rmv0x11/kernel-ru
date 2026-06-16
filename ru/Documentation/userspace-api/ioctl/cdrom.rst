=================================
Сводка вызовов ioctl для CDROM
=================================

- Edward A. Falk <efalk@google.com>

Ноябрь 2004 г.

Этот документ пытается описать вызовы ioctl(2), поддерживаемые
уровнем CDROM.  По большей части они реализованы (по состоянию на Linux 2.6)
в drivers/cdrom/cdrom.c и drivers/block/scsi_ioctl.c

Значения ioctl перечислены в <linux/cdrom.h>.  На момент написания
они таковы:

	========================  ===============================================
	CDROMPAUSE		  Приостановить аудиооперацию
	CDROMRESUME		  Возобновить приостановленную аудиооперацию
	CDROMPLAYMSF		  Воспроизвести аудио MSF (struct cdrom_msf)
	CDROMPLAYTRKIND		  Воспроизвести аудио по дорожке/индексу (struct cdrom_ti)
	CDROMREADTOCHDR		  Прочитать заголовок TOC (struct cdrom_tochdr)
	CDROMREADTOCENTRY	  Прочитать запись TOC (struct cdrom_tocentry)
	CDROMSTOP		  Остановить привод cdrom
	CDROMSTART		  Запустить привод cdrom
	CDROMEJECT		  Извлечь носитель cdrom
	CDROMVOLCTRL		  Управлять выходной громкостью (struct cdrom_volctrl)
	CDROMSUBCHNL		  Прочитать данные подканала (struct cdrom_subchnl)
	CDROMREADMODE2		  Прочитать данные CDROM в режиме 2 (2336 байт)
				  (struct cdrom_read)
	CDROMREADMODE1		  Прочитать данные CDROM в режиме 1 (2048 байт)
				  (struct cdrom_read)
	CDROMREADAUDIO		  (struct cdrom_read_audio)
	CDROMEJECT_SW		  включить(1)/отключить(0) автоизвлечение
	CDROMMULTISESSION	  Получить адрес начала последней сессии
				  мультисессионных дисков
				  (struct cdrom_multisession)
	CDROM_GET_MCN		  Получить «Universal Product Code»,
				  если он доступен (struct cdrom_mcn)
	CDROM_GET_UPC		  Устарел, используйте вместо него CDROM_GET_MCN.
	CDROMRESET		  аппаратный сброс привода
	CDROMVOLREAD		  Получить настройку громкости привода
				  (struct cdrom_volctrl)
	CDROMREADRAW		  прочитать данные в режиме raw (2352 байта)
				  (struct cdrom_read)
	CDROMREADCOOKED		  прочитать данные в режиме cooked
	CDROMSEEK		  позиционирование по адресу msf
	CDROMPLAYBLK		  только для scsi-cd, (struct cdrom_blk)
	CDROMREADALL		  прочитать все 2646 байт
	CDROMGETSPINDOWN	  вернуть 4-битное значение spindown
	CDROMSETSPINDOWN	  установить 4-битное значение spindown
	CDROMCLOSETRAY		  парный к CDROMEJECT
	CDROM_SET_OPTIONS	  Установить параметры поведения
	CDROM_CLEAR_OPTIONS	  Сбросить параметры поведения
	CDROM_SELECT_SPEED	  Установить скорость CD-ROM
	CDROM_SELECT_DISC	  Выбрать диск (для музыкальных автоматов)
	CDROM_MEDIA_CHANGED	  Проверить, был ли изменён носитель
	CDROM_TIMED_MEDIA_CHANGE  Проверить, был ли изменён носитель
				  с заданного момента времени
				  (struct cdrom_timed_media_change_info)
	CDROM_DRIVE_STATUS	  Получить положение лотка и т. п.
	CDROM_DISC_STATUS	  Получить тип диска и т. п.
	CDROM_CHANGER_NSLOTS	  Получить количество слотов
	CDROM_LOCKDOOR		  заблокировать или разблокировать дверцу
	CDROM_DEBUG		  Включить/выключить отладочные сообщения
	CDROM_GET_CAPABILITY	  получить возможности
	CDROMAUDIOBUFSIZ	  установить размер аудиобуфера
	DVD_READ_STRUCT		  Прочитать структуру
	DVD_WRITE_STRUCT	  Записать структуру
	DVD_AUTH		  Аутентификация
	CDROM_SEND_PACKET	  отправить пакет приводу
	CDROM_NEXT_WRITABLE	  получить следующий записываемый блок
	CDROM_LAST_WRITTEN	  получить последний записанный на диск блок
	========================  ===============================================


Приведённая ниже информация была получена из чтения исходного кода
ядра.  Вероятно, со временем будут внесены некоторые исправления.

------------------------------------------------------------------------------

Общее:

	Если не указано иное, все вызовы ioctl возвращают 0 при успехе
	и -1 с errno, установленным в соответствующее значение, при ошибке.  (Некоторые
	ioctl возвращают неотрицательные значения данных.)

	Если не указано иное, все вызовы ioctl возвращают -1 и устанавливают
	errno в EFAULT при неудачной попытке скопировать данные в адресное
	пространство пользователя или из него.

	Отдельные драйверы могут возвращать коды ошибок, не перечисленные здесь.

	Если не указано иное, все структуры данных и константы
	определены в <linux/cdrom.h>

------------------------------------------------------------------------------


CDROMPAUSE
	Приостановить аудиооперацию


	использование::

	  ioctl(fd, CDROMPAUSE, 0);


	входные данные:
		нет


	выходные данные:
		нет


	возврат ошибки:
	  - ENOSYS	привод cd не способен воспроизводить аудио.


CDROMRESUME
	Возобновить приостановленную аудиооперацию


	использование::

	  ioctl(fd, CDROMRESUME, 0);


	входные данные:
		нет


	выходные данные:
		нет


	возврат ошибки:
	  - ENOSYS	привод cd не способен воспроизводить аудио.


CDROMPLAYMSF
	Воспроизвести аудио MSF

	(struct cdrom_msf)


	использование::

	  struct cdrom_msf msf;

	  ioctl(fd, CDROMPLAYMSF, &msf);

	входные данные:
		структура cdrom_msf, описывающая воспроизводимый сегмент музыки


	выходные данные:
		нет


	возврат ошибки:
	  - ENOSYS	привод cd не способен воспроизводить аудио.

	примечания:
		- MSF означает minutes-seconds-frames (минуты-секунды-кадры)
		- LBA означает logical block address (адрес логического блока)
		- Сегмент описывается как время начала и окончания, где каждое время
		  описывается как minutes:seconds:frames (минуты:секунды:кадры).
		  Кадр составляет 1/75 секунды.


CDROMPLAYTRKIND
	Воспроизвести аудио по дорожке/индексу

	(struct cdrom_ti)


	использование::

	  struct cdrom_ti ti;

	  ioctl(fd, CDROMPLAYTRKIND, &ti);

	входные данные:
		структура cdrom_ti, описывающая воспроизводимый сегмент музыки


	выходные данные:
		нет


	возврат ошибки:
	  - ENOSYS	привод cd не способен воспроизводить аудио.

	примечания:
		- Сегмент описывается как время начала и окончания, где каждое время
		  описывается как дорожка и индекс.



CDROMREADTOCHDR
	Прочитать заголовок TOC

	(struct cdrom_tochdr)


	использование::

	  cdrom_tochdr header;

	  ioctl(fd, CDROMREADTOCHDR, &header);

	входные данные:
		структура cdrom_tochdr


	выходные данные:
		структура cdrom_tochdr


	возврат ошибки:
	  - ENOSYS	привод cd не способен воспроизводить аудио.



CDROMREADTOCENTRY
	Прочитать запись TOC

	(struct cdrom_tocentry)


	использование::

	  struct cdrom_tocentry entry;

	  ioctl(fd, CDROMREADTOCENTRY, &entry);

	входные данные:
		структура cdrom_tocentry


	выходные данные:
		структура cdrom_tocentry


	возврат ошибки:
	  - ENOSYS	привод cd не способен воспроизводить аудио.
	  - EINVAL	entry.cdte_format не CDROM_MSF и не CDROM_LBA
	  - EINVAL	запрошенная дорожка вне допустимых границ
	  - EIO		ошибка ввода-вывода при чтении TOC

	примечания:
		- TOC означает Table Of Contents (оглавление)
		- MSF означает minutes-seconds-frames (минуты-секунды-кадры)
		- LBA означает logical block address (адрес логического блока)



CDROMSTOP
	Остановить привод cdrom


	использование::

	  ioctl(fd, CDROMSTOP, 0);


	входные данные:
		нет


	выходные данные:
		нет


	возврат ошибки:
	  - ENOSYS	привод cd не способен воспроизводить аудио.

	примечания:
	  - Точная интерпретация этого ioctl зависит от устройства,
	    но большинство, по-видимому, замедляет вращение привода (spin down).


CDROMSTART
	Запустить привод cdrom


	использование::

	  ioctl(fd, CDROMSTART, 0);


	входные данные:
		нет


	выходные данные:
		нет


	возврат ошибки:
	  - ENOSYS	привод cd не способен воспроизводить аудио.

	примечания:
	  - Точная интерпретация этого ioctl зависит от устройства,
	    но большинство, по-видимому, раскручивает привод (spin up) и/или
	    закрывает лоток.  Другие устройства полностью игнорируют этот ioctl.


CDROMEJECT
	- Извлечь носитель cdrom


	использование::

	  ioctl(fd, CDROMEJECT, 0);


	входные данные:
		нет


	выходные данные:
		нет


	возврат ошибок:
	  - ENOSYS	привод cd не способен извлекать носитель
	  - EBUSY	другие процессы обращаются к приводу или дверца заблокирована

	примечания:
		- См. CDROM_LOCKDOOR ниже.




CDROMCLOSETRAY
	парный к CDROMEJECT


	использование::

	  ioctl(fd, CDROMCLOSETRAY, 0);


	входные данные:
		нет


	выходные данные:
		нет


	возврат ошибок:
	  - ENOSYS	привод cd не способен закрывать лоток
	  - EBUSY	другие процессы обращаются к приводу или дверца заблокирована

	примечания:
		- См. CDROM_LOCKDOOR ниже.




CDROMVOLCTRL
	Управлять выходной громкостью (struct cdrom_volctrl)


	использование::

	  struct cdrom_volctrl volume;

	  ioctl(fd, CDROMVOLCTRL, &volume);

	входные данные:
		структура cdrom_volctrl, содержащая значения громкости
		для не более чем 4 каналов.

	выходные данные:
		нет


	возврат ошибки:
	  - ENOSYS	привод cd не способен воспроизводить аудио.



CDROMVOLREAD
	Получить настройку громкости привода

	(struct cdrom_volctrl)


	использование::

	  struct cdrom_volctrl volume;

	  ioctl(fd, CDROMVOLREAD, &volume);

	входные данные:
		нет


	выходные данные:
		Текущие настройки громкости.


	возврат ошибки:
	  - ENOSYS	привод cd не способен воспроизводить аудио.



CDROMSUBCHNL
	Прочитать данные подканала

	(struct cdrom_subchnl)


	использование::

	  struct cdrom_subchnl q;

	  ioctl(fd, CDROMSUBCHNL, &q);

	входные данные:
		структура cdrom_subchnl


	выходные данные:
		структура cdrom_subchnl


	возврат ошибки:
	  - ENOSYS	привод cd не способен воспроизводить аудио.
	  - EINVAL	формат не CDROM_MSF и не CDROM_LBA

	примечания:
		- Формат при возврате преобразуется в CDROM_MSF или CDROM_LBA
		  согласно запросу пользователя



CDROMREADRAW
	прочитать данные в режиме raw (2352 байта)

	(struct cdrom_read)

	использование::

	  union {

	    struct cdrom_msf msf;		/* input */
	    char buffer[CD_FRAMESIZE_RAW];	/* return */
	  } arg;
	  ioctl(fd, CDROMREADRAW, &arg);

	входные данные:
		структура cdrom_msf, указывающая адрес для чтения.

		Значимы только начальные значения.

	выходные данные:
		Данные, записанные по адресу, предоставленному пользователем.


	возврат ошибки:
	  - EINVAL	адрес меньше 0 или msf меньше 0:2:0
	  - ENOMEM	нехватка памяти

	примечания:
		- По состоянию на 2.6.8.1 комментарии в <linux/cdrom.h> указывают, что этот
		  ioctl принимает структуру cdrom_read, но фактический исходный код
		  читает структуру cdrom_msf и записывает буфер данных по
		  тому же адресу.

		- Значения MSF преобразуются в значения LBA по следующей формуле::

		    lba = (((m * CD_SECS) + s) * CD_FRAMES + f) - CD_MSF_OFFSET;




CDROMREADMODE1
	Прочитать данные CDROM в режиме 1 (2048 байт)

	(struct cdrom_read)

	примечания:
		Идентичен CDROMREADRAW за исключением того, что размер блока составляет
		CD_FRAMESIZE (2048) байт



CDROMREADMODE2
	Прочитать данные CDROM в режиме 2 (2336 байт)

	(struct cdrom_read)

	примечания:
		Идентичен CDROMREADRAW за исключением того, что размер блока составляет
		CD_FRAMESIZE_RAW0 (2336) байт



CDROMREADAUDIO
	(struct cdrom_read_audio)

	использование::

	  struct cdrom_read_audio ra;

	  ioctl(fd, CDROMREADAUDIO, &ra);

	входные данные:
		структура cdrom_read_audio, содержащая точку начала
		чтения и длину

	выходные данные:
		аудиоданные, возвращаемые в буфер, указанный ra


	возврат ошибки:
	  - EINVAL	формат не CDROM_MSF и не CDROM_LBA
	  - EINVAL	nframes вне диапазона [1 75]
	  - ENXIO	у привода нет очереди (вероятно, означает недопустимый fd)
	  - ENOMEM	нехватка памяти


CDROMEJECT_SW
	включить(1)/отключить(0) автоизвлечение


	использование::

	  int val;

	  ioctl(fd, CDROMEJECT_SW, val);

	входные данные:
		Флаг, задающий флаг автоизвлечения.


	выходные данные:
		нет


	возврат ошибки:
	  - ENOSYS	Привод не способен извлекать носитель.
	  - EBUSY	Дверца заблокирована




CDROMMULTISESSION
	Получить адрес начала последней сессии мультисессионных дисков

	(struct cdrom_multisession)

	использование::

	  struct cdrom_multisession ms_info;

	  ioctl(fd, CDROMMULTISESSION, &ms_info);

	входные данные:
		структура cdrom_multisession, содержащая желаемый

	  формат.

	выходные данные:
		структура cdrom_multisession заполняется информацией
		last_session.

	возврат ошибки:
	  - EINVAL	формат не CDROM_MSF и не CDROM_LBA


CDROM_GET_MCN
	Получить «Universal Product Code»,
	если он доступен

	(struct cdrom_mcn)


	использование::

	  struct cdrom_mcn mcn;

	  ioctl(fd, CDROM_GET_MCN, &mcn);

	входные данные:
		нет


	выходные данные:
		Universal Product Code


	возврат ошибки:
	  - ENOSYS	Привод не способен читать данные MCN.

	примечания:
		- Комментарии в исходном коде сообщают::

		    The following function is implemented, although very few
		    audio discs give Universal Product Code information, which
		    should just be the Medium Catalog Number on the box.  Note,
		    that the way the code is written on the CD is /not/ uniform
		    across all discs!




CDROM_GET_UPC
	CDROM_GET_MCN  (устарел)


	Не реализован, по состоянию на 2.6.8.1



CDROMRESET
	аппаратный сброс привода


	использование::

	  ioctl(fd, CDROMRESET, 0);


	входные данные:
		нет


	выходные данные:
		нет


	возврат ошибки:
	  - EACCES	Доступ запрещён:  требуется CAP_SYS_ADMIN
	  - ENOSYS	Привод не способен выполнять сброс.




CDROMREADCOOKED
	прочитать данные в режиме cooked


	использование::

	  u8 buffer[CD_FRAMESIZE]

	  ioctl(fd, CDROMREADCOOKED, buffer);

	входные данные:
		нет


	выходные данные:
		2048 байт данных, режим «cooked».


	примечания:
		Реализован не на всех приводах.





CDROMREADALL
	прочитать все 2646 байт


	То же, что CDROMREADCOOKED, но читает 2646 байт.



CDROMSEEK
	позиционирование по адресу msf


	использование::

	  struct cdrom_msf msf;

	  ioctl(fd, CDROMSEEK, &msf);

	входные данные:
		Адрес MSF для позиционирования.


	выходные данные:
		нет




CDROMPLAYBLK
	только для scsi-cd

	(struct cdrom_blk)


	использование::

	  struct cdrom_blk blk;

	  ioctl(fd, CDROMPLAYBLK, &blk);

	входные данные:
		Воспроизводимая область


	выходные данные:
		нет




CDROMGETSPINDOWN
	Устарел, был только для ide-cd


	использование::

	  char spindown;

	  ioctl(fd, CDROMGETSPINDOWN, &spindown);

	входные данные:
		нет


	выходные данные:
		Текущее 4-битное значение spindown.





CDROMSETSPINDOWN
	Устарел, был только для ide-cd


	использование::

	  char spindown

	  ioctl(fd, CDROMSETSPINDOWN, &spindown);

	входные данные:
		4-битное значение, используемое для управления spindown (TODO: more detail here)


	выходные данные:
		нет






CDROM_SET_OPTIONS
	Установить параметры поведения


	использование::

	  int options;

	  ioctl(fd, CDROM_SET_OPTIONS, options);

	входные данные:
		Новые значения параметров привода.  Логическое «или» из:

	    ==============      ==================================
	    CDO_AUTO_CLOSE	закрывать лоток при первом open(2)
	    CDO_AUTO_EJECT	открывать лоток при последнем release
	    CDO_USE_FFLAGS	использовать информацию O_NONBLOCK при open
	    CDO_LOCK		блокировать лоток при открытых файлах
	    CDO_CHECK_TYPE	проверять тип при открытии для данных
	    ==============      ==================================

	выходные данные:
		Возвращает результирующие настройки параметров в
		возвращаемом значении ioctl.  Возвращает -1 при ошибке.

	возврат ошибки:
	  - ENOSYS	выбранные параметры не поддерживаются приводом.




CDROM_CLEAR_OPTIONS
	Сбросить параметры поведения


	То же, что CDROM_SET_OPTIONS, за исключением того, что выбранные параметры
	отключаются.



CDROM_SELECT_SPEED
	Установить скорость CD-ROM


	использование::

	  int speed;

	  ioctl(fd, CDROM_SELECT_SPEED, speed);

	входные данные:
		Новая скорость привода.


	выходные данные:
		нет


	возврат ошибки:
	  - ENOSYS	выбор скорости не поддерживается приводом.



CDROM_SELECT_DISC
	Выбрать диск (для музыкальных автоматов)


	использование::

	  int disk;

	  ioctl(fd, CDROM_SELECT_DISC, disk);

	входные данные:
		Диск для загрузки в привод.


	выходные данные:
		нет


	возврат ошибки:
	  - EINVAL	номер диска превышает вместимость привода



CDROM_MEDIA_CHANGED
	Проверить, был ли изменён носитель


	использование::

	  int slot;

	  ioctl(fd, CDROM_MEDIA_CHANGED, slot);

	входные данные:
		Номер проверяемого слота, всегда ноль, кроме музыкальных автоматов.

		Также может принимать специальные значения CDSL_NONE или CDSL_CURRENT

	выходные данные:
		Возвращаемое значение ioctl равно 0 или 1 в зависимости от того,

	  был ли изменён носитель, либо -1 при ошибке.

	возврат ошибок:
	  - ENOSYS	Привод не может обнаружить смену носителя
	  - EINVAL	номер слота превышает вместимость привода
	  - ENOMEM	Нехватка памяти



CDROM_DRIVE_STATUS
	Получить положение лотка и т. п.


	использование::

	  int slot;

	  ioctl(fd, CDROM_DRIVE_STATUS, slot);

	входные данные:
		Номер проверяемого слота, всегда ноль, кроме музыкальных автоматов.

		Также может принимать специальные значения CDSL_NONE или CDSL_CURRENT

	выходные данные:
		Возвращаемое значение ioctl будет одним из следующих значений

	  из <linux/cdrom.h>:

	    =================== ==========================
	    CDS_NO_INFO		Информация недоступна.
	    CDS_NO_DISC
	    CDS_TRAY_OPEN
	    CDS_DRIVE_NOT_READY
	    CDS_DISC_OK
	    -1			ошибка
	    =================== ==========================

	возврат ошибок:
	  - ENOSYS	Привод не может определить состояние привода
	  - EINVAL	номер слота превышает вместимость привода
	  - ENOMEM	Нехватка памяти




CDROM_DISC_STATUS
	Получить тип диска и т. п.


	использование::

	  ioctl(fd, CDROM_DISC_STATUS, 0);


	входные данные:
		нет


	выходные данные:
		Возвращаемое значение ioctl будет одним из следующих значений

	  из <linux/cdrom.h>:

	    - CDS_NO_INFO
	    - CDS_AUDIO
	    - CDS_MIXED
	    - CDS_XA_2_2
	    - CDS_XA_2_1
	    - CDS_DATA_1

	возврат ошибок:
		на данный момент отсутствует

	примечания:
	    - Комментарии в исходном коде сообщают::


		Ok, this is where problems start.  The current interface for
		the CDROM_DISC_STATUS ioctl is flawed.  It makes the false
		assumption that CDs are all CDS_DATA_1 or all CDS_AUDIO, etc.
		Unfortunately, while this is often the case, it is also
		very common for CDs to have some tracks with data, and some
		tracks with audio.	Just because I feel like it, I declare
		the following to be the best way to cope.  If the CD has
		ANY data tracks on it, it will be returned as a data CD.
		If it has any XA tracks, I will return it as that.	Now I
		could simplify this interface by combining these returns with
		the above, but this more clearly demonstrates the problem
		with the current interface.  Too bad this wasn't designed
		to use bitmasks...	       -Erik

		Well, now we have the option CDS_MIXED: a mixed-type CD.
		User level programmers might feel the ioctl is not very
		useful.
				---david




CDROM_CHANGER_NSLOTS
	Получить количество слотов


	использование::

	  ioctl(fd, CDROM_CHANGER_NSLOTS, 0);


	входные данные:
		нет


	выходные данные:
		Возвращаемое значение ioctl будет числом слотов в
		устройстве смены CD.  Обычно 1 для устройств без поддержки нескольких дисков.

	возврат ошибок:
		отсутствует



CDROM_LOCKDOOR
	заблокировать или разблокировать дверцу


	использование::

	  int lock;

	  ioctl(fd, CDROM_LOCKDOOR, lock);

	входные данные:
		Флаг блокировки дверцы, 1=заблокировать, 0=разблокировать


	выходные данные:
		нет


	возврат ошибок:
	  - EDRIVE_CANT_DO_THIS

				Функция блокировки дверцы не поддерживается.
	  - EBUSY

				Попытка разблокировки, когда привод открыт
				несколькими пользователями и нет CAP_SYS_ADMIN

	примечания:
		По состоянию на 2.6.8.1 флаг блокировки является глобальной блокировкой,
		что означает, что все приводы CD будут заблокированы или разблокированы вместе.  Это
		вероятно, ошибка.

		Значение EDRIVE_CANT_DO_THIS определено в <linux/cdrom.h>
		и в настоящее время (2.6.8.1) совпадает с EOPNOTSUPP



CDROM_DEBUG
	Включить/выключить отладочные сообщения


	использование::

	  int debug;

	  ioctl(fd, CDROM_DEBUG, debug);

	входные данные:
		Флаг отладки cdrom, 0=отключить, 1=включить


	выходные данные:
		Возвращаемое значение ioctl будет новым флагом отладки.


	возврат ошибки:
	  - EACCES	Доступ запрещён:  требуется CAP_SYS_ADMIN



CDROM_GET_CAPABILITY
	получить возможности


	использование::

	  ioctl(fd, CDROM_GET_CAPABILITY, 0);


	входные данные:
		нет


	выходные данные:
		Возвращаемое значение ioctl — текущие флаги возможностей
		устройства.  См. CDC_CLOSE_TRAY, CDC_OPEN_TRAY и т. п.



CDROMAUDIOBUFSIZ
	установить размер аудиобуфера


	использование::

	  int arg;

	  ioctl(fd, CDROMAUDIOBUFSIZ, val);

	входные данные:
		Новый размер аудиобуфера


	выходные данные:
		Возвращаемое значение ioctl — новый размер аудиобуфера, либо -1
		при ошибке.

	возврат ошибки:
	  - ENOSYS	Не поддерживается этим драйвером.

	примечания:
		Поддерживается не всеми драйверами.




DVD_READ_STRUCT			Прочитать структуру

	использование::

	  dvd_struct s;

	  ioctl(fd, DVD_READ_STRUCT, &s);

	входные данные:
		структура dvd_struct, содержащая:

	    =================== ==========================================
	    type		задаёт желаемую информацию, одно из
				DVD_STRUCT_PHYSICAL, DVD_STRUCT_COPYRIGHT,
				DVD_STRUCT_DISCKEY, DVD_STRUCT_BCA,
				DVD_STRUCT_MANUFACT
	    physical.layer_num	желаемый слой, индексация с 0
	    copyright.layer_num	желаемый слой, индексация с 0
	    disckey.agid
	    =================== ==========================================

	выходные данные:
		структура dvd_struct, содержащая:

	    =================== ================================
	    physical		для type == DVD_STRUCT_PHYSICAL
	    copyright		для type == DVD_STRUCT_COPYRIGHT
	    disckey.value	для type == DVD_STRUCT_DISCKEY
	    bca.{len,value}	для type == DVD_STRUCT_BCA
	    manufact.{len,valu}	для type == DVD_STRUCT_MANUFACT
	    =================== ================================

	возврат ошибок:
	  - EINVAL	physical.layer_num превышает количество слоёв
	  - EIO		Получен недопустимый ответ от привода



DVD_WRITE_STRUCT		Записать структуру

	Не реализован, по состоянию на 2.6.8.1



DVD_AUTH			Аутентификация

	использование::

	  dvd_authinfo ai;

	  ioctl(fd, DVD_AUTH, &ai);

	входные данные:
		структура dvd_authinfo.  См. <linux/cdrom.h>


	выходные данные:
		структура dvd_authinfo.


	возврат ошибки:
	  - ENOTTY	ai.type не распознан.



CDROM_SEND_PACKET
	отправить пакет приводу


	использование::

	  struct cdrom_generic_command cgc;

	  ioctl(fd, CDROM_SEND_PACKET, &cgc);

	входные данные:
		структура cdrom_generic_command, содержащая отправляемый пакет.


	выходные данные:
		нет

	  структура cdrom_generic_command, содержащая результаты.

	возврат ошибки:
	  - EIO

				команда не выполнена.
	  - EPERM

				Операция не разрешена либо потому, что
				команда записи была выполнена на приводе,
				открытом только для чтения, либо потому, что команда
				требует CAP_SYS_RAWIO
	  - EINVAL

				cgc.data_direction не установлено



CDROM_NEXT_WRITABLE
	получить следующий записываемый блок


	использование::

	  long next;

	  ioctl(fd, CDROM_NEXT_WRITABLE, &next);

	входные данные:
		нет


	выходные данные:
		Следующий записываемый блок.


	примечания:
		Если устройство не поддерживает этот ioctl напрямую,

	  ioctl вернёт CDROM_LAST_WRITTEN + 7.



CDROM_LAST_WRITTEN
	получить последний записанный на диск блок


	использование::

	  long last;

	  ioctl(fd, CDROM_LAST_WRITTEN, &last);

	входные данные:
		нет


	выходные данные:
		Последний записанный на диск блок


	примечания:
		Если устройство не поддерживает этот ioctl напрямую,
		результат выводится из оглавления диска.  Если
		оглавление не удаётся прочитать, этот ioctl возвращает
		ошибку.
