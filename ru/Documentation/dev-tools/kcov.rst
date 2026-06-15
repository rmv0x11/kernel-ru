KCOV: покрытие кода для фаззинга
================================

KCOV собирает и предоставляет информацию о покрытии кода ядра в форме, пригодной
для фаззинга с управлением по покрытию (coverage-guided fuzzing). Данные о
покрытии работающего ядра экспортируются через файл ``kcov`` в debugfs. Сбор
покрытия включается на уровне отдельной задачи, благодаря чему KCOV может
зафиксировать точное покрытие одного системного вызова.

Обратите внимание, что KCOV не ставит целью собрать как можно больше покрытия.
Его цель — собрать более или менее стабильное покрытие, являющееся функцией
входных данных системного вызова. Для достижения этой цели он не собирает
покрытие в программных/аппаратных прерываниях (если не включён удалённый сбор
покрытия, см. ниже) и из некоторых принципиально недетерминированных частей ядра
(например, планировщика, блокировок).

Помимо сбора покрытия кода, KCOV также может собирать операнды сравнений.
Подробности см. в разделе «Comparison operands collection».

Помимо сбора данных о покрытии из обработчиков системных вызовов, KCOV также может
собирать покрытие для аннотированных частей ядра, выполняющихся в фоновых задачах
ядра или программных прерываниях. Подробности см. в разделе «Remote coverage
collection».

Предварительные требования
---------------------------

KCOV опирается на инструментацию компилятора и требует GCC 6.1.0 или новее
либо любой версии Clang, поддерживаемой ядром.

Сбор операндов сравнений поддерживается при использовании GCC 8+ или Clang.

Чтобы включить KCOV, сконфигурируйте ядро с параметром::

        CONFIG_KCOV=y

Чтобы включить сбор операндов сравнений, установите::

	CONFIG_KCOV_ENABLE_COMPARISONS=y

Данные о покрытии становятся доступны только после монтирования debugfs::

        mount -t debugfs none /sys/kernel/debug

Сбор покрытия
-------------

Следующая программа демонстрирует, как использовать KCOV для сбора покрытия для
одного системного вызова изнутри тестовой программы:

.. code-block:: c

    #include <stdio.h>
    #include <stddef.h>
    #include <stdint.h>
    #include <stdlib.h>
    #include <sys/types.h>
    #include <sys/stat.h>
    #include <sys/ioctl.h>
    #include <sys/mman.h>
    #include <unistd.h>
    #include <fcntl.h>
    #include <linux/types.h>

    #define KCOV_INIT_TRACE			_IOR('c', 1, unsigned long)
    #define KCOV_ENABLE			_IO('c', 100)
    #define KCOV_DISABLE			_IO('c', 101)
    #define COVER_SIZE			(64<<10)

    #define KCOV_TRACE_PC  0
    #define KCOV_TRACE_CMP 1

    int main(int argc, char **argv)
    {
	int fd;
	unsigned long *cover, n, i;

	/* A single fd descriptor allows coverage collection on a single
	 * thread.
	 */
	fd = open("/sys/kernel/debug/kcov", O_RDWR);
	if (fd == -1)
		perror("open"), exit(1);
	/* Setup trace mode and trace size. */
	if (ioctl(fd, KCOV_INIT_TRACE, COVER_SIZE))
		perror("ioctl"), exit(1);
	/* Mmap buffer shared between kernel- and user-space. */
	cover = (unsigned long*)mmap(NULL, COVER_SIZE * sizeof(unsigned long),
				     PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if ((void*)cover == MAP_FAILED)
		perror("mmap"), exit(1);
	/* Enable coverage collection on the current thread. */
	if (ioctl(fd, KCOV_ENABLE, KCOV_TRACE_PC))
		perror("ioctl"), exit(1);
	/* Reset coverage from the tail of the ioctl() call. */
	__atomic_store_n(&cover[0], 0, __ATOMIC_RELAXED);
	/* Call the target syscall call. */
	read(-1, NULL, 0);
	/* Read number of PCs collected. */
	n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
	for (i = 0; i < n; i++)
		printf("0x%lx\n", cover[i + 1]);
	/* Disable coverage collection for the current thread. After this call
	 * coverage can be enabled for a different thread.
	 */
	if (ioctl(fd, KCOV_DISABLE, 0))
		perror("ioctl"), exit(1);
	/* Free resources. */
	if (munmap(cover, COVER_SIZE * sizeof(unsigned long)))
		perror("munmap"), exit(1);
	if (close(fd))
		perror("close"), exit(1);
	return 0;
    }

После пропускания через ``addr2line`` вывод программы выглядит следующим образом::

    SyS_read
    fs/read_write.c:562
    __fdget_pos
    fs/file.c:774
    __fget_light
    fs/file.c:746
    __fget_light
    fs/file.c:750
    __fget_light
    fs/file.c:760
    __fdget_pos
    fs/file.c:784
    SyS_read
    fs/read_write.c:562

Если программе нужно собирать покрытие из нескольких потоков (независимо), ей
необходимо открыть ``/sys/kernel/debug/kcov`` в каждом потоке отдельно.

Интерфейс сделан мелкозернистым, чтобы обеспечить эффективное ветвление (forking)
тестовых процессов. То есть родительский процесс открывает
``/sys/kernel/debug/kcov``, включает режим трассировки, отображает (mmap) буфер
покрытия, а затем в цикле порождает дочерние процессы. Дочерним процессам нужно
лишь включить покрытие (оно автоматически отключается при завершении потока).

Comparison operands collection
-------------------------------

Сбор операндов сравнений аналогичен сбору покрытия:

.. code-block:: c

    /* Same includes and defines as above. */

    /* Number of 64-bit words per record. */
    #define KCOV_WORDS_PER_CMP 4

    /*
     * The format for the types of collected comparisons.
     *
     * Bit 0 shows whether one of the arguments is a compile-time constant.
     * Bits 1 & 2 contain log2 of the argument size, up to 8 bytes.
     */

    #define KCOV_CMP_CONST          (1 << 0)
    #define KCOV_CMP_SIZE(n)        ((n) << 1)
    #define KCOV_CMP_MASK           KCOV_CMP_SIZE(3)

    int main(int argc, char **argv)
    {
	int fd;
	uint64_t *cover, type, arg1, arg2, is_const, size;
	unsigned long n, i;

	fd = open("/sys/kernel/debug/kcov", O_RDWR);
	if (fd == -1)
		perror("open"), exit(1);
	if (ioctl(fd, KCOV_INIT_TRACE, COVER_SIZE))
		perror("ioctl"), exit(1);
	/*
	* Note that the buffer pointer is of type uint64_t*, because all
	* the comparison operands are promoted to uint64_t.
	*/
	cover = (uint64_t *)mmap(NULL, COVER_SIZE * sizeof(unsigned long),
				     PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if ((void*)cover == MAP_FAILED)
		perror("mmap"), exit(1);
	/* Note KCOV_TRACE_CMP instead of KCOV_TRACE_PC. */
	if (ioctl(fd, KCOV_ENABLE, KCOV_TRACE_CMP))
		perror("ioctl"), exit(1);
	__atomic_store_n(&cover[0], 0, __ATOMIC_RELAXED);
	read(-1, NULL, 0);
	/* Read number of comparisons collected. */
	n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
	for (i = 0; i < n; i++) {
		uint64_t ip;

		type = cover[i * KCOV_WORDS_PER_CMP + 1];
		/* arg1 and arg2 - operands of the comparison. */
		arg1 = cover[i * KCOV_WORDS_PER_CMP + 2];
		arg2 = cover[i * KCOV_WORDS_PER_CMP + 3];
		/* ip - caller address. */
		ip = cover[i * KCOV_WORDS_PER_CMP + 4];
		/* size of the operands. */
		size = 1 << ((type & KCOV_CMP_MASK) >> 1);
		/* is_const - true if either operand is a compile-time constant.*/
		is_const = type & KCOV_CMP_CONST;
		printf("ip: 0x%lx type: 0x%lx, arg1: 0x%lx, arg2: 0x%lx, "
			"size: %lu, %s\n",
			ip, type, arg1, arg2, size,
		is_const ? "const" : "non-const");
	}
	if (ioctl(fd, KCOV_DISABLE, 0))
		perror("ioctl"), exit(1);
	/* Free resources. */
	if (munmap(cover, COVER_SIZE * sizeof(unsigned long)))
		perror("munmap"), exit(1);
	if (close(fd))
		perror("close"), exit(1);
	return 0;
    }

Обратите внимание, что режимы KCOV (сбор покрытия кода или операндов сравнений)
являются взаимоисключающими.

Remote coverage collection
---------------------------

Помимо сбора данных о покрытии из обработчиков системных вызовов, инициированных
процессом из пространства пользователя, KCOV также может собирать покрытие для
частей ядра, выполняющихся в других контекстах, — так называемое «удалённое»
(remote) покрытие.

Использование KCOV для сбора удалённого покрытия требует:

1. Модификации кода ядра для аннотирования секции кода, из которой должно
   собираться покрытие, с помощью ``kcov_remote_start`` и ``kcov_remote_stop``.

2. Использования ``KCOV_REMOTE_ENABLE`` вместо ``KCOV_ENABLE`` в процессе
   пространства пользователя, который собирает покрытие.

Как аннотации ``kcov_remote_start`` и ``kcov_remote_stop``, так и ioctl
``KCOV_REMOTE_ENABLE`` принимают дескрипторы (handles), идентифицирующие
конкретные секции сбора покрытия. Способ использования дескриптора зависит от
контекста, в котором выполняется соответствующая секция кода.

KCOV поддерживает сбор удалённого покрытия из следующих контекстов:

1. Глобальные фоновые задачи ядра. Это задачи, которые порождаются во время
   загрузки ядра в ограниченном числе экземпляров (например, один рабочий поток
   ``hub_event`` USB порождается на каждый USB HCD).

2. Локальные фоновые задачи ядра. Они порождаются, когда процесс пространства
   пользователя взаимодействует с некоторым интерфейсом ядра, и обычно
   завершаются при выходе процесса (например, рабочие потоки vhost).

3. Программные прерывания.

Для случаев №1 и №3 необходимо выбрать уникальный глобальный дескриптор и
передать его в соответствующий вызов ``kcov_remote_start``. Затем процесс
пространства пользователя должен передать этот дескриптор в
``KCOV_REMOTE_ENABLE`` в поле-массиве ``handles`` структуры
``kcov_remote_arg``. Это привяжет используемое устройство KCOV к секции кода, на
которую ссылается этот дескриптор. Можно передать сразу несколько глобальных
дескрипторов, идентифицирующих разные секции кода.

Для случая №2 процесс пространства пользователя вместо этого должен передать
ненулевой дескриптор через поле ``common_handle`` структуры ``kcov_remote_arg``.
Этот общий (common) дескриптор сохраняется в поле ``kcov_handle`` в текущем
``task_struct`` и должен быть передан вновь порождаемым локальным задачам через
специальные модификации кода ядра. Эти задачи, в свою очередь, должны
использовать переданный дескриптор в своих аннотациях ``kcov_remote_start`` и
``kcov_remote_stop``.

KCOV следует предопределённому формату как для глобальных, так и для общих
дескрипторов. Каждый дескриптор — это целое число ``u64``. В настоящее время
используются только старший байт и младшие 4 байта. Байты 4–7 зарезервированы и
должны быть нулевыми.

Для глобальных дескрипторов старший байт дескриптора обозначает id подсистемы, к
которой принадлежит этот дескриптор. Например, KCOV использует ``1`` в качестве
id подсистемы USB. Младшие 4 байта глобального дескриптора обозначают id
экземпляра задачи в пределах этой подсистемы. Например, каждый рабочий поток
``hub_event`` использует номер шины USB в качестве id экземпляра задачи.

Для общих дескрипторов в качестве id подсистемы используется зарезервированное
значение ``0``, так как такие дескрипторы не принадлежат конкретной подсистеме.
Младшие 4 байта общего дескриптора идентифицируют коллективный экземпляр всех
локальных задач, порождённых процессом пространства пользователя, который передал
общий дескриптор в ``KCOV_REMOTE_ENABLE``.

На практике для id экземпляра общего дескриптора можно использовать любое
значение, если покрытие собирается только из одного процесса пространства
пользователя в системе. Однако если общие дескрипторы используются несколькими
процессами, для каждого процесса необходимо использовать уникальные id
экземпляров. Один из вариантов — использовать id процесса в качестве id
экземпляра общего дескриптора.

Следующая программа демонстрирует использование KCOV для сбора покрытия как из
локальных задач, порождённых процессом, так и из глобальной задачи, обслуживающей
USB-шину №1:

.. code-block:: c

    /* Same includes and defines as above. */

    struct kcov_remote_arg {
	__u32		trace_mode;
	__u32		area_size;
	__u32		num_handles;
	__aligned_u64	common_handle;
	__aligned_u64	handles[0];
    };

    #define KCOV_INIT_TRACE			_IOR('c', 1, unsigned long)
    #define KCOV_DISABLE			_IO('c', 101)
    #define KCOV_REMOTE_ENABLE		_IOW('c', 102, struct kcov_remote_arg)

    #define COVER_SIZE	(64 << 10)

    #define KCOV_TRACE_PC	0

    #define KCOV_SUBSYSTEM_COMMON	(0x00ull << 56)
    #define KCOV_SUBSYSTEM_USB	(0x01ull << 56)

    #define KCOV_SUBSYSTEM_MASK	(0xffull << 56)
    #define KCOV_INSTANCE_MASK	(0xffffffffull)

    static inline __u64 kcov_remote_handle(__u64 subsys, __u64 inst)
    {
	if (subsys & ~KCOV_SUBSYSTEM_MASK || inst & ~KCOV_INSTANCE_MASK)
		return 0;
	return subsys | inst;
    }

    #define KCOV_COMMON_ID	0x42
    #define KCOV_USB_BUS_NUM	1

    int main(int argc, char **argv)
    {
	int fd;
	unsigned long *cover, n, i;
	struct kcov_remote_arg *arg;

	fd = open("/sys/kernel/debug/kcov", O_RDWR);
	if (fd == -1)
		perror("open"), exit(1);
	if (ioctl(fd, KCOV_INIT_TRACE, COVER_SIZE))
		perror("ioctl"), exit(1);
	cover = (unsigned long*)mmap(NULL, COVER_SIZE * sizeof(unsigned long),
				     PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if ((void*)cover == MAP_FAILED)
		perror("mmap"), exit(1);

	/* Enable coverage collection via common handle and from USB bus #1. */
	arg = calloc(1, sizeof(*arg) + sizeof(uint64_t));
	if (!arg)
		perror("calloc"), exit(1);
	arg->trace_mode = KCOV_TRACE_PC;
	arg->area_size = COVER_SIZE;
	arg->num_handles = 1;
	arg->common_handle = kcov_remote_handle(KCOV_SUBSYSTEM_COMMON,
							KCOV_COMMON_ID);
	arg->handles[0] = kcov_remote_handle(KCOV_SUBSYSTEM_USB,
						KCOV_USB_BUS_NUM);
	if (ioctl(fd, KCOV_REMOTE_ENABLE, arg))
		perror("ioctl"), free(arg), exit(1);
	free(arg);

	/*
	 * Here the user needs to trigger execution of a kernel code section
	 * that is either annotated with the common handle, or to trigger some
	 * activity on USB bus #1.
	 */
	sleep(2);

        /*
         * The load to the coverage count should be an acquire to pair with
         * pair with the corresponding write memory barrier (smp_wmb()) on
         * the kernel-side in kcov_move_area().
         */
	n = __atomic_load_n(&cover[0], __ATOMIC_ACQUIRE);
	for (i = 0; i < n; i++)
		printf("0x%lx\n", cover[i + 1]);
	if (ioctl(fd, KCOV_DISABLE, 0))
		perror("ioctl"), exit(1);
	if (munmap(cover, COVER_SIZE * sizeof(unsigned long)))
		perror("munmap"), exit(1);
	if (close(fd))
		perror("close"), exit(1);
	return 0;
    }
