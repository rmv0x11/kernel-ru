.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later
.. c:namespace:: DTV.dmx

.. _DMX_EXPBUF:

****************
ioctl DMX_EXPBUF
****************

Имя
===

DMX_EXPBUF - Экспортировать буфер в виде файлового дескриптора DMABUF.

.. warning:: данный API всё ещё является экспериментальным

Обзор
=====

.. c:macro:: DMX_EXPBUF

``int ioctl(int fd, DMX_EXPBUF, struct dmx_exportbuffer *argp)``

Аргументы
=========

``fd``
    Файловый дескриптор, возвращённый :c:func:`open()`.

``argp``
    Указатель на struct :c:type:`dmx_exportbuffer`.

Описание
========

Этот ioctl является расширением метода ввода-вывода с отображением памяти.
Он может использоваться для экспорта буфера в виде файла DMABUF в любой момент
после того, как буферы были выделены с помощью ioctl :ref:`DMX_REQBUFS`.

Чтобы экспортировать буфер, приложения заполняют struct :c:type:`dmx_exportbuffer`.
Приложения должны установить поле ``index``. Допустимые значения индекса лежат
в диапазоне от нуля до числа буферов, выделенных с помощью :ref:`DMX_REQBUFS`
(struct :c:type:`dmx_requestbuffers` ``count``), минус один.
В поле ``flags`` могут быть переданы дополнительные флаги. Подробности см. в
руководстве по open(). В настоящее время поддерживаются только O_CLOEXEC,
O_RDONLY, O_WRONLY и O_RDWR.
Все остальные поля должны быть установлены в ноль. В случае
многоплоскостного (multi-planar) API каждая плоскость экспортируется отдельно
несколькими вызовами :ref:`DMX_EXPBUF`.

После вызова :ref:`DMX_EXPBUF` в случае успеха поле ``fd`` будет установлено
драйвером. Это файловый дескриптор DMABUF. Приложение может передать его
другим устройствам, поддерживающим DMABUF. Рекомендуется закрывать файл DMABUF,
когда он больше не используется, чтобы связанную с ним память можно было освободить.

Примеры
=======

.. code-block:: c

    int buffer_export(int v4lfd, enum dmx_buf_type bt, int index, int *dmafd)
    {
	struct dmx_exportbuffer expbuf;

	memset(&expbuf, 0, sizeof(expbuf));
	expbuf.type = bt;
	expbuf.index = index;
	if (ioctl(v4lfd, DMX_EXPBUF, &expbuf) == -1) {
	    perror("DMX_EXPBUF");
	    return -1;
	}

	*dmafd = expbuf.fd;

	return 0;
    }

Возвращаемое значение
=====================

В случае успеха возвращается 0, в случае ошибки -1, и переменная ``errno``
устанавливается соответствующим образом. Общие коды ошибок описаны в главе
:ref:`Generic Error Codes <gen-errors>`.

EINVAL
    Очередь не находится в режиме MMAP, либо экспорт DMABUF не поддерживается,
    либо недопустимы поля ``flags`` или ``index``.
