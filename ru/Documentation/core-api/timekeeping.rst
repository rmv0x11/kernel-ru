Аксессоры ktime
===============

Драйверы устройств могут читать текущее время с помощью ktime_get() и множества
связанных функций, объявленных в linux/timekeeping.h. Как правило, при прочих
равных предпочтительнее использовать аксессор с более коротким именем, чем с более
длинным, если оба одинаково подходят для конкретного сценария использования.

Базовые интерфейсы на основе ktime_t
------------------------------------

Рекомендуемая простейшая форма возвращает непрозрачный ktime_t, при этом есть
варианты, возвращающие время для разных опорных часов:


.. c:function:: ktime_t ktime_get( void )

	CLOCK_MONOTONIC

	Полезен для надёжных временных меток и точного измерения коротких
	интервалов времени. Отсчёт начинается с момента загрузки системы, но
	останавливается на время приостановки (suspend).

.. c:function:: ktime_t ktime_get_boottime( void )

	CLOCK_BOOTTIME

	Как ktime_get(), но не останавливается во время приостановки. Это можно
	использовать, например, для времён истечения срока действия ключей, которые
	нужно синхронизировать с другими машинами через операцию приостановки.

.. c:function:: ktime_t ktime_get_real( void )

	CLOCK_REALTIME

	Возвращает время относительно эпохи UNIX, начинающейся в 1970 году, по
	всемирному координированному времени (UTC), так же как gettimeofday() в
	пространстве пользователя. Используется для всех временных меток, которые
	должны сохраняться между перезагрузками, например для времён inode, но его
	следует избегать для внутренних нужд, поскольку оно может прыгать назад из-за
	обновления секунды координации (leap second), корректировки NTP или операции
	settimeofday() из пространства пользователя.

.. c:function:: ktime_t ktime_get_clocktai( void )

	 CLOCK_TAI

	Как ktime_get_real(), но использует опору на международное атомное время
	(TAI) вместо UTC, чтобы избежать скачков при обновлениях секунды координации.
	В ядре это требуется редко.

.. c:function:: ktime_t ktime_get_raw( void )

	CLOCK_MONOTONIC_RAW

	Как ktime_get(), но работает с той же частотой, что и аппаратный clocksource,
	без корректировок (NTP) на уход часов. В ядре это также требуется редко.

вывод в наносекундах, timespec64 и секундах
-------------------------------------------

Для всех вышеперечисленных существуют варианты, возвращающие время в другом
формате в зависимости от того, что требуется пользователю:

.. c:function:: u64 ktime_get_ns( void )
		u64 ktime_get_boottime_ns( void )
		u64 ktime_get_real_ns( void )
		u64 ktime_get_clocktai_ns( void )
		u64 ktime_get_raw_ns( void )

	То же, что и обычные функции ktime_get, но возвращают число наносекунд в виде
	u64 в соответствующей опоре времени, что может быть удобнее для некоторых
	вызывающих.

.. c:function:: void ktime_get_ts64( struct timespec64 * )
		void ktime_get_boottime_ts64( struct timespec64 * )
		void ktime_get_real_ts64( struct timespec64 * )
		void ktime_get_clocktai_ts64( struct timespec64 * )
		void ktime_get_raw_ts64( struct timespec64 * )

	То же, что и выше, но возвращают время в виде 'struct timespec64',
	разделённое на секунды и наносекунды. Это позволяет избежать лишнего деления
	при печати времени или при передаче его во внешний интерфейс, ожидающий
	структуру 'timespec' или 'timeval'.

.. c:function:: time64_t ktime_get_seconds( void )
		time64_t ktime_get_boottime_seconds( void )
		time64_t ktime_get_real_seconds( void )
		time64_t ktime_get_clocktai_seconds( void )
		time64_t ktime_get_raw_seconds( void )

	Возвращают грубую (coarse-grained) версию времени в виде скалярного
	time64_t. Это позволяет избежать обращения к аппаратным часам и округляет
	секунды вниз до полных секунд последнего тика таймера, используя
	соответствующую опору.

Грубый (coarse) и fast_ns доступ
--------------------------------

Существует несколько дополнительных вариантов для более специализированных
случаев:

.. c:function:: ktime_t ktime_get_coarse( void )
		ktime_t ktime_get_coarse_boottime( void )
		ktime_t ktime_get_coarse_real( void )
		ktime_t ktime_get_coarse_clocktai( void )

.. c:function:: u64 ktime_get_coarse_ns( void )
		u64 ktime_get_coarse_boottime_ns( void )
		u64 ktime_get_coarse_real_ns( void )
		u64 ktime_get_coarse_clocktai_ns( void )

.. c:function:: void ktime_get_coarse_ts64( struct timespec64 * )
		void ktime_get_coarse_boottime_ts64( struct timespec64 * )
		void ktime_get_coarse_real_ts64( struct timespec64 * )
		void ktime_get_coarse_clocktai_ts64( struct timespec64 * )

	Они быстрее, чем не-грубые (non-coarse) версии, но менее точны и
	соответствуют CLOCK_MONOTONIC_COARSE и CLOCK_REALTIME_COARSE в пространстве
	пользователя, а также эквивалентным опорам времени boottime/tai/raw,
	недоступным в пространстве пользователя.

	Возвращаемое здесь время соответствует последнему тику таймера, который может
	отстоять в прошлом на величину до 10 мс (при CONFIG_HZ=100), так же как при
	чтении переменной 'jiffies'.  Они полезны только при вызове из быстрого пути
	(fast path), когда всё же ожидается точность лучше секундной, но нельзя легко
	использовать 'jiffies', например для временных меток inode. Пропуск
	обращения к аппаратным часам экономит около 100 циклов CPU на большинстве
	современных машин с надёжным счётчиком циклов, но до нескольких микросекунд на
	более старом оборудовании с внешним clocksource.

.. c:function:: u64 ktime_get_mono_fast_ns( void )
		u64 ktime_get_raw_fast_ns( void )
		u64 ktime_get_boot_fast_ns( void )
		u64 ktime_get_tai_fast_ns( void )
		u64 ktime_get_real_fast_ns( void )

	Эти варианты безопасно вызывать из любого контекста, в том числе из
	немаскируемого прерывания (NMI) во время обновления timekeeper, а также пока
	мы входим в приостановку с обесточенным clocksource. Это полезно в некотором
	коде трассировки или отладки, а также при отчётах о machine check, но
	большинство драйверов никогда не должны их вызывать, поскольку при
	определённых условиях время может прыгать.

Устаревшие интерфейсы времени
-----------------------------

В более старых ядрах использовались некоторые другие интерфейсы, которые сейчас
выводятся из употребления, но могут встречаться в сторонних драйверах,
портируемых сюда. В частности, все интерфейсы, возвращающие 'struct timeval' или
'struct timespec', были заменены, поскольку поле tv_sec переполняется в 2038 году
на 32-битных архитектурах. Вот рекомендуемые замены:

.. c:function:: void ktime_get_ts( struct timespec * )

	Вместо него используйте ktime_get() или ktime_get_ts64().

.. c:function:: void do_gettimeofday( struct timeval * )
		void getnstimeofday( struct timespec * )
		void getnstimeofday64( struct timespec64 * )
		void ktime_get_real_ts( struct timespec * )

	ktime_get_real_ts64() является прямой заменой, но рассмотрите использование
	монотонного времени (ktime_get_ts64()) и/или интерфейса на основе ktime_t
	(ktime_get()/ktime_get_real()).

.. c:function:: struct timespec current_kernel_time( void )
		struct timespec64 current_kernel_time64( void )
		struct timespec get_monotonic_coarse( void )
		struct timespec64 get_monotonic_coarse64( void )

	Они заменены на ktime_get_coarse_real_ts64() и ktime_get_coarse_ts64().
	Однако значительная часть кода, которой нужны грубые (coarse-grained)
	времена, может вместо этого использовать простой 'jiffies', тогда как
	некоторым драйверам в наши дни на самом деле могут быть нужны аксессоры с
	более высоким разрешением.

.. c:function:: struct timespec getrawmonotonic( void )
		struct timespec64 getrawmonotonic64( void )
		struct timespec timekeeping_clocktai( void )
		struct timespec64 timekeeping_clocktai64( void )
		struct timespec get_monotonic_boottime( void )
		struct timespec64 get_monotonic_boottime64( void )

	Они заменены на ktime_get_raw()/ktime_get_raw_ts64(),
	ktime_get_clocktai()/ktime_get_clocktai_ts64(), а также
	ktime_get_boottime()/ktime_get_boottime_ts64().
	Однако, если конкретный выбор источника часов для пользователя не важен,
	рассмотрите переход на ktime_get()/ktime_get_ts64() ради согласованности.
