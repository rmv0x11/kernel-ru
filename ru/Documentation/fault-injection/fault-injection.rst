============================================================
Инфраструктура механизмов внедрения ошибок (fault injection)
============================================================

См. также опцию модуля "every_nth" для scsi_debug.


Доступные механизмы внедрения ошибок
------------------------------------

- failslab

  внедряет сбои выделения slab-памяти. (kmalloc(), kmem_cache_alloc(), ...)

- fail_page_alloc

  внедряет сбои выделения страниц. (alloc_pages(), get_free_pages(), ...)

- fail_usercopy

  внедряет сбои в функциях доступа к памяти пространства пользователя. (copy_from_user(), get_user(), ...)

- fail_futex

  внедряет ошибки взаимоблокировки futex и ошибки uaddr.

- fail_sunrpc

  внедряет сбои клиента и сервера RPC ядра.

- fail_make_request

  внедряет ошибки дискового ввода-вывода на устройствах, для которых это разрешено,
  путём установки /sys/block/<device>/make-it-fail или
  /sys/block/<device>/<partition>/make-it-fail. (submit_bio_noacct())

- fail_mmc_request

  внедряет ошибки данных MMC на устройствах, для которых это разрешено,
  путём установки записей debugfs в /sys/kernel/debug/mmc0/fail_mmc_request

- fail_function

  внедряет возврат ошибки в определённых функциях, помеченных
  макросом ALLOW_ERROR_INJECTION(), путём установки записей debugfs
  в /sys/kernel/debug/fail_function. Опция загрузки не поддерживается.

- fail_skb_realloc

  внедряет события перевыделения skb (буфера сокета) в сетевой путь. Основная
  цель — выявление и предотвращение проблем, связанных с неправильным управлением
  указателями в сетевой подсистеме. Принудительно вызывая перевыделение skb в
  стратегических точках, эта функциональность создаёт сценарии, в которых
  существующие указатели на заголовки skb становятся недействительными.

  Когда ошибка внедрена и перевыделение запущено, кэшированные указатели
  на заголовки и данные skb перестают ссылаться на действительные участки памяти.
  Это намеренное обесценивание помогает выявлять пути кода, в которых корректное
  обновление указателей пропускается после события перевыделения.

  Создавая эти контролируемые сценарии ошибок, система может перехватывать случаи,
  когда используются устаревшие указатели, что потенциально приводит к повреждению
  памяти или нестабильности системы.

  Чтобы выбрать интерфейс, на который воздействовать, запишите имя сети в
  /sys/kernel/debug/fail_skb_realloc/devname.
  Если это поле оставлено пустым (значение по умолчанию), перевыделение skb
  будет принудительно выполняться на всех сетевых интерфейсах.

  Эффективность этого обнаружения ошибок повышается при включённом KASAN,
  поскольку он помогает выявлять недействительные обращения к памяти и проблемы
  использования после освобождения (use-after-free, UAF).

- Внедрение ошибок NVMe

  внедряет код состояния NVMe и флаг повтора на устройствах, для которых это
  разрешено, путём установки записей debugfs в /sys/kernel/debug/nvme*/fault_inject.
  Код состояния по умолчанию — NVME_SC_INVALID_OPCODE без повтора. Код состояния и
  флаг повтора можно установить через debugfs.

- Внедрение ошибок драйвера блочного тестового устройства Null

  внедряет тайм-ауты ввода-вывода путём установки элементов конфигурации в
  /sys/kernel/config/nullb/<disk>/timeout_inject,
  внедряет запросы повторной постановки в очередь путём установки элементов
  конфигурации в /sys/kernel/config/nullb/<disk>/requeue_inject, и
  внедряет ошибки init_hctx() путём установки элементов конфигурации в
  /sys/kernel/config/nullb/<disk>/init_hctx_fault_inject.

Настройка поведения механизмов внедрения ошибок
-----------------------------------------------

записи debugfs
^^^^^^^^^^^^^^

модуль ядра fault-inject-debugfs предоставляет некоторые записи debugfs для настройки
механизмов внедрения ошибок во время выполнения.

- /sys/kernel/debug/fail*/probability:

	вероятность внедрения сбоя, в процентах.

	Формат: <percent>

	Учтите, что один сбой на сотню — это очень высокая частота ошибок
	для некоторых тестовых случаев. Рассмотрите установку probability=100 и настройку
	/sys/kernel/debug/fail*/interval для таких тестовых случаев.

- /sys/kernel/debug/fail*/interval:

	задаёт интервал между сбоями для вызовов
	should_fail(), которые проходят все остальные проверки.

	Учтите, что если вы включите это, установив interval>1, то вам,
	вероятно, потребуется задать probability=100.

- /sys/kernel/debug/fail*/times:

	задаёт, сколько раз максимум могут происходить сбои. Значение -1
	означает «без ограничения».

- /sys/kernel/debug/fail*/space:

	задаёт начальный «бюджет» ресурса, уменьшаемый на «size»
	при каждом вызове should_fail(,size). Внедрение сбоев
	подавляется, пока «space» не достигнет нуля.

- /sys/kernel/debug/fail*/verbose

	Формат: { 0 | 1 | 2 }

	задаёт детальность сообщений при внедрении
	сбоя. «0» означает отсутствие сообщений; «1» выведет только одну
	строку журнала на сбой; «2» выведет также трассировку вызовов — полезно
	для отладки проблем, выявленных внедрением ошибок.

- /sys/kernel/debug/fail*/task-filter:

	Формат: { 'Y' | 'N' }

	Значение «N» отключает фильтрацию по процессу (по умолчанию).
	Любое положительное значение ограничивает сбои только процессами, указанными в
	/proc/<pid>/make-it-fail==1.

- /sys/kernel/debug/fail*/require-start,
  /sys/kernel/debug/fail*/require-end,
  /sys/kernel/debug/fail*/reject-start,
  /sys/kernel/debug/fail*/reject-end:

	задаёт диапазон виртуальных адресов, проверяемых при
	обходе трассировки стека. Сбой внедряется, только если некоторый вызывающий
	объект в обходимой трассировке стека попадает в требуемый диапазон, и
	ни один не попадает в отвергаемый диапазон.
	Требуемый диапазон по умолчанию — [0,ULONG_MAX) (всё виртуальное адресное пространство).
	Отвергаемый диапазон по умолчанию — [0,0).

- /sys/kernel/debug/fail*/stacktrace-depth:

	задаёт максимальную глубину трассировки стека, обходимой при поиске
	вызывающего объекта в пределах [require-start,require-end) ИЛИ
	[reject-start,reject-end).

- /sys/kernel/debug/fail_page_alloc/ignore-gfp-highmem:

	Формат: { 'Y' | 'N' }

	по умолчанию «Y», установка «N» приведёт к внедрению сбоев также в
	выделения highmem/пользователя (выделения __GFP_HIGHMEM).

- /sys/kernel/debug/failslab/cache-filter
	Формат: { 'Y' | 'N' }

        по умолчанию «N», установка «Y» приведёт к внедрению сбоев только тогда,
        когда объекты запрашиваются из определённых кэшей.

        Выберите кэш, записав «1» в /sys/kernel/slab/<cache>/failslab:

- /sys/kernel/debug/failslab/ignore-gfp-wait:
- /sys/kernel/debug/fail_page_alloc/ignore-gfp-wait:

	Формат: { 'Y' | 'N' }

	по умолчанию «Y», установка «N» приведёт к внедрению сбоев также
	в выделения, которые могут уходить в сон (выделения __GFP_DIRECT_RECLAIM).

- /sys/kernel/debug/fail_page_alloc/min-order:

	задаёт минимальный порядок выделения страниц, в который внедряются
	сбои.

- /sys/kernel/debug/fail_futex/ignore-private:

	Формат: { 'Y' | 'N' }

	по умолчанию «N», установка «Y» отключит внедрение сбоев
	при работе с приватными (адресного пространства) futex.

- /sys/kernel/debug/fail_sunrpc/ignore-client-disconnect:

	Формат: { 'Y' | 'N' }

	по умолчанию «N», установка «Y» отключит внедрение
	разрыва соединения на клиенте RPC.

- /sys/kernel/debug/fail_sunrpc/ignore-server-disconnect:

	Формат: { 'Y' | 'N' }

	по умолчанию «N», установка «Y» отключит внедрение
	разрыва соединения на сервере RPC.

- /sys/kernel/debug/fail_sunrpc/ignore-cache-wait:

	Формат: { 'Y' | 'N' }

	по умолчанию «N», установка «Y» отключит внедрение
	ожидания кэша на сервере RPC.

- /sys/kernel/debug/fail_function/inject:

	Формат: { 'function-name' | '!function-name' | '' }

	задаёт целевую функцию внедрения ошибок по имени.
	Если имя функции начинается с префикса «!», заданная функция
	удаляется из списка внедрения. Если ничего не указано ('')
	список внедрения очищается.

- /sys/kernel/debug/fail_function/injectable:

	(только чтение) показывает функции, в которые можно внедрять ошибки, и какой тип
	значений ошибок может быть задан. Тип ошибки будет одним из
	перечисленных ниже;
	- NULL:	retval должно быть равно 0.
	- ERRNO: retval должно быть от -1 до -MAX_ERRNO (-4096).
	- ERR_NULL: retval должно быть 0 или от -1 до -MAX_ERRNO (-4096).

- /sys/kernel/debug/fail_function/<function-name>/retval:

	задаёт возвращаемое значение «ошибки» для внедрения в заданную функцию.
	Этот файл создаётся, когда пользователь задаёт новую запись внедрения.
	Учтите, что этот файл принимает только беззнаковые значения. Поэтому, если вы хотите
	использовать отрицательный errno, лучше использовать «printf» вместо «echo», например:
	$ printf %#x -12 > retval

- /sys/kernel/debug/fail_skb_realloc/devname:

        Задаёт сетевой интерфейс, на котором принудительно выполнять перевыделение SKB. Если
        оставлено пустым, перевыделение SKB будет применяться ко всем сетевым интерфейсам.

        Пример использования::

          # Принудительное перевыделение skb на eth0
          echo "eth0" > /sys/kernel/debug/fail_skb_realloc/devname

          # Сброс выбора и принудительное перевыделение skb на всех интерфейсах
          echo "" > /sys/kernel/debug/fail_skb_realloc/devname

Опция загрузки
^^^^^^^^^^^^^^

Чтобы внедрять ошибки, пока debugfs недоступна (на раннем этапе загрузки),
используйте опцию загрузки::

	failslab=
	fail_page_alloc=
	fail_usercopy=
	fail_make_request=
	fail_futex=
	fail_skb_realloc=
	mmc_core.fail_request=<interval>,<probability>,<space>,<times>

записи proc
^^^^^^^^^^^

- /proc/<pid>/fail-nth,
  /proc/self/task/<tid>/fail-nth:

	Запись целого числа N в этот файл заставляет N-й вызов в задаче завершиться сбоем.
	Чтение из этого файла возвращает целое значение. Значение «0» указывает,
	что ошибка, настроенная предыдущей записью в этот файл, была внедрена.
	Положительное целое N указывает, что ошибка ещё не была внедрена.
	Учтите, что этот файл включает все типы ошибок (slab, futex и т.д.).
	Эта настройка имеет приоритет над всеми другими общими настройками debugfs,
	такими как probability, interval, times и т.д. Но настройки конкретного механизма
	(например, fail_futex/ignore-private) имеют приоритет над ней.

	Эта функциональность предназначена для систематического тестирования ошибок в одном
	системном вызове. См. пример ниже.


Функции, в которые можно внедрять ошибки
----------------------------------------

Эта часть предназначена для разработчиков ядра, рассматривающих добавление функции в
макрос ALLOW_ERROR_INJECTION().

Требования к функциям, в которые можно внедрять ошибки
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Поскольку внедрение ошибок на уровне функций принудительно изменяет путь выполнения кода
и возвращает ошибку, даже если входные данные и условия корректны, это может
вызвать неожиданный сбой ядра, если разрешить внедрение ошибок в функцию,
в которую внедрять ошибки НЕЛЬЗЯ. Поэтому вы (и рецензенты) должны убедиться;

- Функция возвращает код ошибки при сбое, и вызывающие объекты должны проверять
  его корректно (необходимо восстановиться после него).

- Функция не выполняет никакого кода, который может изменить какое-либо состояние до
  первого возврата ошибки. Состояние включает глобальные или локальные, или входные
  переменные. Например, очистка хранилища выходного адреса (например, `*ret = NULL`),
  инкремент/декремент счётчика, установка флага, отключение вытеснения/прерываний или
  получение блокировки (если они восстанавливаются перед возвратом ошибки, это нормально.)

Первое требование важно, и оно приводит к тому, что функции освобождения
(освобождения объектов) обычно сложнее для внедрения ошибок, чем функции выделения.
Если ошибки таких функций освобождения обрабатываются некорректно,
это легко вызовет утечку памяти (вызывающий объект будет введён в заблуждение,
полагая, что объект был освобождён или повреждён.)

Второе предназначено для вызывающего объекта, который ожидает, что функция всегда
что-то делает. Поэтому, если внедрение ошибки в функцию пропускает всю
функцию целиком, ожидание не оправдывается и вызывает неожиданную ошибку.

Тип функций, в которые можно внедрять ошибки
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Каждая функция, в которую можно внедрять ошибки, будет иметь тип ошибки, заданный
макросом ALLOW_ERROR_INJECTION(). Вы должны выбирать его тщательно, если добавляете
новую функцию, в которую можно внедрять ошибки. Если выбран неправильный тип ошибки,
ядро может аварийно завершиться, поскольку может оказаться не в состоянии обработать ошибку.
В include/asm-generic/error-injection.h определены 4 типа ошибок

EI_ETYPE_NULL
  Эта функция вернёт `NULL` при сбое. Например, возвращает адрес выделенного
  объекта.

EI_ETYPE_ERRNO
  Эта функция вернёт код ошибки `-errno` при сбое. Например, вернёт
  -EINVAL, если входные данные неверны. Сюда же относятся функции, которые
  возвращают адрес, кодирующий `-errno` через макрос ERR_PTR().

EI_ETYPE_ERRNO_NULL
  Эта функция вернёт `-errno` или `NULL` при сбое. Если вызывающий объект
  этой функции проверяет возвращаемое значение с помощью макроса IS_ERR_OR_NULL(), этот
  тип будет уместен.

EI_ETYPE_TRUE
  Эта функция вернёт `true` (ненулевое положительное значение) при сбое.

Если вы зададите неправильный тип, например, EI_TYPE_ERRNO для функции,
которая возвращает выделенный объект, это может вызвать проблему, поскольку возвращаемое
значение не является адресом объекта, и вызывающий объект не сможет обратиться к адресу.


Как добавить новый механизм внедрения ошибок
--------------------------------------------

- #include <linux/fault-inject.h>

- определите атрибуты ошибки

  DECLARE_FAULT_ATTR(name);

  Подробности см. в определении struct fault_attr в fault-inject.h.

- предоставьте способ настройки атрибутов ошибки

- опция загрузки

  Если вам нужно включать механизм внедрения ошибок с момента загрузки, вы можете
  предоставить опцию загрузки для его настройки. Для этого есть вспомогательная функция:

	setup_fault_attr(attr, str);

- записи debugfs

  Этим способом пользуются failslab, fail_page_alloc, fail_usercopy и fail_make_request.
  Вспомогательные функции:

	fault_create_debugfs_attr(name, parent, attr);

- параметры модуля

  Если область действия механизма внедрения ошибок ограничена одним
  модулем ядра, лучше предоставить параметры модуля для
  настройки атрибутов ошибки.

- добавьте хук для вставки сбоев

  При возврате should_fail() значения true клиентский код должен внедрить сбой:

	should_fail(attr, size);

Примеры применения
------------------

- Внедрение сбоев выделения slab-памяти в код инициализации/выгрузки модуля::

    #!/bin/bash

    FAILTYPE=failslab
    echo Y > /sys/kernel/debug/$FAILTYPE/task-filter
    echo 10 > /sys/kernel/debug/$FAILTYPE/probability
    echo 100 > /sys/kernel/debug/$FAILTYPE/interval
    echo -1 > /sys/kernel/debug/$FAILTYPE/times
    echo 0 > /sys/kernel/debug/$FAILTYPE/space
    echo 2 > /sys/kernel/debug/$FAILTYPE/verbose
    echo Y > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait

    faulty_system()
    {
	bash -c "echo 1 > /proc/self/make-it-fail && exec $*"
    }

    if [ $# -eq 0 ]
    then
	echo "Usage: $0 modulename [ modulename ... ]"
	exit 1
    fi

    for m in $*
    do
	echo inserting $m...
	faulty_system modprobe $m

	echo removing $m...
	faulty_system modprobe -r $m
    done

------------------------------------------------------------------------------

- Внедрение сбоев выделения страниц только для определённого модуля::

    #!/bin/bash

    FAILTYPE=fail_page_alloc
    module=$1

    if [ -z $module ]
    then
	echo "Usage: $0 <modulename>"
	exit 1
    fi

    modprobe $module

    if [ ! -d /sys/module/$module/sections ]
    then
	echo Module $module is not loaded
	exit 1
    fi

    cat /sys/module/$module/sections/.text > /sys/kernel/debug/$FAILTYPE/require-start
    cat /sys/module/$module/sections/.data > /sys/kernel/debug/$FAILTYPE/require-end

    echo N > /sys/kernel/debug/$FAILTYPE/task-filter
    echo 10 > /sys/kernel/debug/$FAILTYPE/probability
    echo 100 > /sys/kernel/debug/$FAILTYPE/interval
    echo -1 > /sys/kernel/debug/$FAILTYPE/times
    echo 0 > /sys/kernel/debug/$FAILTYPE/space
    echo 2 > /sys/kernel/debug/$FAILTYPE/verbose
    echo Y > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
    echo Y > /sys/kernel/debug/$FAILTYPE/ignore-gfp-highmem
    echo 10 > /sys/kernel/debug/$FAILTYPE/stacktrace-depth

    trap "echo 0 > /sys/kernel/debug/$FAILTYPE/probability" SIGINT SIGTERM EXIT

    echo "Injecting errors into the module $module... (interrupt to stop)"
    sleep 1000000

------------------------------------------------------------------------------

- Внедрение ошибки open_ctree при монтировании btrfs::

    #!/bin/bash

    rm -f testfile.img
    dd if=/dev/zero of=testfile.img bs=1M seek=1000 count=1
    DEVICE=$(losetup --show -f testfile.img)
    mkfs.btrfs -f $DEVICE
    mkdir -p tmpmnt

    FAILTYPE=fail_function
    FAILFUNC=open_ctree
    echo $FAILFUNC > /sys/kernel/debug/$FAILTYPE/inject
    printf %#x -12 > /sys/kernel/debug/$FAILTYPE/$FAILFUNC/retval
    echo N > /sys/kernel/debug/$FAILTYPE/task-filter
    echo 100 > /sys/kernel/debug/$FAILTYPE/probability
    echo 0 > /sys/kernel/debug/$FAILTYPE/interval
    echo -1 > /sys/kernel/debug/$FAILTYPE/times
    echo 0 > /sys/kernel/debug/$FAILTYPE/space
    echo 1 > /sys/kernel/debug/$FAILTYPE/verbose

    mount -t btrfs $DEVICE tmpmnt
    if [ $? -ne 0 ]
    then
	echo "SUCCESS!"
    else
	echo "FAILED!"
	umount tmpmnt
    fi

    echo > /sys/kernel/debug/$FAILTYPE/inject

    rmdir tmpmnt
    losetup -d $DEVICE
    rm testfile.img

------------------------------------------------------------------------------

- Внедрение только сбоев выделения skbuff ::

    # mark skbuff_head_cache as faulty
    echo 1 > /sys/kernel/slab/skbuff_head_cache/failslab
    # Turn on cache filter (off by default)
    echo 1 > /sys/kernel/debug/failslab/cache-filter
    # Turn on fault injection
    echo 1 > /sys/kernel/debug/failslab/times
    echo 1 > /sys/kernel/debug/failslab/probability


Утилита для запуска команды с failslab или fail_page_alloc
----------------------------------------------------------
Чтобы упростить выполнение упомянутых выше задач, можно использовать
tools/testing/fault-injection/failcmd.sh. Для получения дополнительной информации запустите команду
"./tools/testing/fault-injection/failcmd.sh --help" и
см. следующие примеры.

Примеры:

Запуск команды "make -C tools/testing/selftests/ run_tests" с внедрением сбоя
выделения slab-памяти::

	# ./tools/testing/fault-injection/failcmd.sh \
		-- make -C tools/testing/selftests/ run_tests

То же, что и выше, за исключением задания максимум 100 сбоев вместо одного
сбоя максимум по умолчанию::

	# ./tools/testing/fault-injection/failcmd.sh --times=100 \
		-- make -C tools/testing/selftests/ run_tests

То же, что и выше, за исключением внедрения сбоя выделения страниц вместо сбоя
выделения slab-памяти::

	# env FAILCMD_TYPE=fail_page_alloc \
		./tools/testing/fault-injection/failcmd.sh --times=100 \
		-- make -C tools/testing/selftests/ run_tests

Систематические ошибки с использованием fail-nth
------------------------------------------------

Следующий код систематически внедряет ошибки в 0-й, 1-й, 2-й и так далее
механизмы в системном вызове socketpair()::

  #include <sys/types.h>
  #include <sys/stat.h>
  #include <sys/socket.h>
  #include <sys/syscall.h>
  #include <fcntl.h>
  #include <unistd.h>
  #include <string.h>
  #include <stdlib.h>
  #include <stdio.h>
  #include <errno.h>

  int main()
  {
	int i, err, res, fail_nth, fds[2];
	char buf[128];

	system("echo N > /sys/kernel/debug/failslab/ignore-gfp-wait");
	sprintf(buf, "/proc/self/task/%ld/fail-nth", syscall(SYS_gettid));
	fail_nth = open(buf, O_RDWR);
	for (i = 1;; i++) {
		sprintf(buf, "%d", i);
		write(fail_nth, buf, strlen(buf));
		res = socketpair(AF_LOCAL, SOCK_STREAM, 0, fds);
		err = errno;
		pread(fail_nth, buf, sizeof(buf), 0);
		if (res == 0) {
			close(fds[0]);
			close(fds[1]);
		}
		printf("%d-th fault %c: res=%d/%d\n", i, atoi(buf) ? 'N' : 'Y',
			res, err);
		if (atoi(buf))
			break;
	}
	return 0;
  }

Пример вывода::

	1-th fault Y: res=-1/23
	2-th fault Y: res=-1/23
	3-th fault Y: res=-1/12
	4-th fault Y: res=-1/12
	5-th fault Y: res=-1/23
	6-th fault Y: res=-1/23
	7-th fault Y: res=-1/23
	8-th fault Y: res=-1/12
	9-th fault Y: res=-1/12
	10-th fault Y: res=-1/12
	11-th fault Y: res=-1/12
	12-th fault Y: res=-1/12
	13-th fault Y: res=-1/12
	14-th fault Y: res=-1/12
	15-th fault Y: res=-1/12
	16-th fault N: res=0/12
