.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: V4L

.. _dmabuf:

*********************************************
Потоковый ввод-вывод (импорт буфера DMA)
*********************************************

Фреймворк DMABUF предоставляет универсальный способ совместного использования
буферов несколькими устройствами. Драйверы устройств, поддерживающие DMABUF, могут
экспортировать буфер DMA в пространство пользователя в виде файлового дескриптора
(это называется ролью экспортёра), импортировать буфер DMA из пространства
пользователя по файловому дескриптору, ранее экспортированному для другого или того
же устройства (это называется ролью импортёра), либо и то, и другое. В этом разделе
описывается API роли импортёра DMABUF в V4L2.

Подробнее об экспорте буферов V4L2 в виде файловых дескрипторов DMABUF см.
:ref:`Экспорт DMABUF <VIDIOC_EXPBUF>`.

Устройства ввода и вывода поддерживают метод потокового ввода-вывода, когда установлен
флаг ``V4L2_CAP_STREAMING`` в поле ``capabilities`` структуры
:c:type:`v4l2_capability`, возвращаемой ioctl
:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>`. Поддерживается ли импорт буферов DMA через
файловые дескрипторы DMABUF, определяется вызовом ioctl
:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` с типом памяти, установленным в
``V4L2_MEMORY_DMABUF``.

Этот метод ввода-вывода предназначен для совместного использования буферов DMA
различными устройствами, которые могут быть устройствами V4L или другими устройствами,
связанными с видео (например, DRM). Буферы (плоскости) выделяются драйвером от имени
приложения. Затем эти буферы экспортируются приложению в виде файловых дескрипторов с
помощью API, специфичного для драйвера-распределителя. Обмениваются только такими
файловыми дескрипторами. Дескрипторы и метаинформация передаются в структуре
:c:type:`v4l2_buffer` (или в структуре :c:type:`v4l2_plane` в случае многоплоскостного
API). Драйвер должен быть переключён в режим ввода-вывода DMABUF вызовом
:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` с нужным типом буфера.

Пример: запуск потокового ввода-вывода с файловыми дескрипторами DMABUF
=======================================================================

.. code-block:: c

    struct v4l2_requestbuffers reqbuf;

    memset(&reqbuf, 0, sizeof (reqbuf));
    reqbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    reqbuf.memory = V4L2_MEMORY_DMABUF;
    reqbuf.count = 1;

    if (ioctl(fd, VIDIOC_REQBUFS, &reqbuf) == -1) {
	if (errno == EINVAL)
	    printf("Video capturing or DMABUF streaming is not supported\\n");
	else
	    perror("VIDIOC_REQBUFS");

	exit(EXIT_FAILURE);
    }

Файловый дескриптор буфера (плоскости) передаётся на лету с помощью ioctl
:ref:`VIDIOC_QBUF <VIDIOC_QBUF>`. В случае многоплоскостных буферов каждая плоскость
может быть связана с отдельным дескриптором DMABUF. Хотя буферы обычно используются
циклически, приложения могут передавать разные дескрипторы DMABUF при каждом вызове
:ref:`VIDIOC_QBUF <VIDIOC_QBUF>`.

Пример: постановка DMABUF в очередь с помощью одноплоскостного API
==================================================================

.. code-block:: c

    int buffer_queue(int v4lfd, int index, int dmafd)
    {
	struct v4l2_buffer buf;

	memset(&buf, 0, sizeof buf);
	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	buf.memory = V4L2_MEMORY_DMABUF;
	buf.index = index;
	buf.m.fd = dmafd;

	if (ioctl(v4lfd, VIDIOC_QBUF, &buf) == -1) {
	    perror("VIDIOC_QBUF");
	    return -1;
	}

	return 0;
    }

Пример 3.6. Постановка DMABUF в очередь с помощью многоплоскостного API
=======================================================================

.. code-block:: c

    int buffer_queue_mp(int v4lfd, int index, int dmafd[], int n_planes)
    {
	struct v4l2_buffer buf;
	struct v4l2_plane planes[VIDEO_MAX_PLANES];
	int i;

	memset(&buf, 0, sizeof buf);
	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
	buf.memory = V4L2_MEMORY_DMABUF;
	buf.index = index;
	buf.m.planes = planes;
	buf.length = n_planes;

	memset(&planes, 0, sizeof planes);

	for (i = 0; i < n_planes; ++i)
	    buf.m.planes[i].m.fd = dmafd[i];

	if (ioctl(v4lfd, VIDIOC_QBUF, &buf) == -1) {
	    perror("VIDIOC_QBUF");
	    return -1;
	}

	return 0;
    }

Захваченные или отображённые буферы извлекаются из очереди с помощью ioctl
:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`. Драйвер может разблокировать буфер в любой момент
между завершением DMA и этим ioctl. Память также разблокируется при вызове
:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`,
:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` или при закрытии устройства.

Для приложений захвата принято ставить в очередь некоторое количество пустых буферов,
запускать захват и входить в цикл чтения. Здесь приложение ждёт, пока можно будет
извлечь заполненный буфер из очереди, и снова ставит буфер в очередь, когда данные
больше не нужны. Приложения вывода заполняют буферы и ставят их в очередь; когда
накопится достаточно буферов, запускается вывод. В цикле записи, когда у приложения
заканчиваются свободные буферы, оно должно подождать, пока можно будет извлечь из
очереди пустой буфер и использовать его повторно. Существует два метода приостановки
выполнения приложения до тех пор, пока не появится возможность извлечь из очереди
один или несколько буферов. По умолчанию :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` блокируется,
когда в исходящей очереди нет ни одного буфера. Если при вызове функции
:c:func:`open()` был задан флаг ``O_NONBLOCK``, то
:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` немедленно возвращается с кодом ошибки ``EAGAIN``,
когда нет доступного буфера. Функции :c:func:`select()` и :c:func:`poll()` доступны
всегда.

Чтобы запустить и остановить захват или отображение, приложения вызывают ioctl
:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` и
:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`.

.. note::

   :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` в качестве побочного эффекта удаляет все
   буферы из обеих очередей и разблокирует все буферы. Поскольку в многозадачной системе
   нет понятия выполнения чего-либо «прямо сейчас», если приложению нужно синхронизироваться
   с другим событием, ему следует проверить поле ``timestamp`` структуры
   :c:type:`v4l2_buffer` захваченных или выведенных буферов.

Драйверы, реализующие ввод-вывод с импортом DMABUF, должны поддерживать ioctl
:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`,
:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`, :ref:`VIDIOC_STREAMON
<VIDIOC_STREAMON>` и :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`, а также функции
:c:func:`select()` и :c:func:`poll()`.
