.. SPDX-License-Identifier: GPL-2.0
.. Copyright © 2025 Microsoft Corporation

==============================================
Landlock: управление в масштабе всей системы
==============================================

:Author: Mickaël Salaün
:Date: January 2026

Landlock может использовать инфраструктуру аудита для журналирования событий.

Документацию для пространства пользователя можно найти здесь:
Documentation/userspace-api/landlock.rst.

Аудит
=====

Отклонённые запросы на доступ по умолчанию журналируются для программы,
выполняемой в песочнице, если включён `audit`.  Это поведение по умолчанию
можно изменить с помощью флагов sys_landlock_restrict_self() (см.
Documentation/userspace-api/landlock.rst).  Журналы Landlock также можно
маскировать с помощью правил аудита.  Landlock может генерировать 2 типа
записей аудита.

Типы записей
------------

AUDIT_LANDLOCK_ACCESS
    Этот тип записи идентифицирует отклонённый запрос на доступ к ресурсу ядра.
    Поле ``domain`` указывает ID домена, заблокировавшего запрос.  Поле
    ``blockers`` указывает причину (или причины) этого отказа (разделённые
    запятой), а следующие поля идентифицируют объект ядра (аналогично SELinux).
    На одно событие аудита может приходиться более одной записи этого типа.

    Пример с запросом на создание ссылки на файл, который порождает две записи
    в рамках одного события::

        domain=195ba459b blockers=fs.refer path="/usr/bin" dev="vda2" ino=351
        domain=195ba459b blockers=fs.make_reg,fs.refer path="/usr/local" dev="vda2" ino=365


    Поле ``blockers`` использует префиксы, разделённые точками, чтобы указать
    тип ограничения, который вызвал отказ:

    **fs.*** - Права доступа к файловой системе (ABI 1+):
        - fs.execute, fs.write_file, fs.read_file, fs.read_dir
        - fs.remove_dir, fs.remove_file
        - fs.make_char, fs.make_dir, fs.make_reg, fs.make_sock
        - fs.make_fifo, fs.make_block, fs.make_sym
        - fs.refer (ABI 2+)
        - fs.truncate (ABI 3+)
        - fs.ioctl_dev (ABI 5+)

    **net.*** - Права сетевого доступа (ABI 4+):
        - net.bind_tcp - привязка к TCP-порту была отклонена
        - net.connect_tcp - TCP-соединение было отклонено

    **scope.*** - Ограничения области видимости IPC (ABI 6+):
        - scope.abstract_unix_socket - соединение через абстрактный UNIX-сокет отклонено
        - scope.signal - отправка сигнала отклонена

    В одном событии может появляться несколько блокировщиков (разделённых
    запятыми), когда отсутствует сразу несколько прав доступа. Например,
    создание обычного файла в каталоге, у которого нет прав ``make_reg`` и
    ``refer``, отобразило бы ``blockers=fs.make_reg,fs.refer``.

    Поля идентификации объекта (path, dev, ino для файловой системы; opid,
    ocomm для сигналов) зависят от типа блокируемого доступа и предоставляют
    контекст о том, какой ресурс был задействован в отказе.


AUDIT_LANDLOCK_DOMAIN
    Этот тип записи описывает состояние домена Landlock.  Поле ``status`` может
    иметь значение ``allocated`` либо ``deallocated``.

    Статус ``allocated`` является частью того же события аудита и следует за
    первой журналируемой записью ``AUDIT_LANDLOCK_ACCESS`` домена.  Он
    идентифицирует информацию о домене Landlock на момент вызова
    sys_landlock_restrict_self() со следующими полями:

    - ID домена (``domain``)
    - режим принуждения (``mode``)
    - ``pid`` создателя домена
    - ``uid`` создателя домена
    - путь к исполняемому файлу создателя домена (``exe``)
    - командная строка создателя домена (``comm``)

    Пример::

        domain=195ba459b status=allocated mode=enforcing pid=300 uid=0 exe="/root/sandboxer" comm="sandboxer"

    Статус ``deallocated`` представляет собой отдельное событие и идентифицирует
    освобождение домена Landlock.  После такого события гарантируется, что
    соответствующий ID домена никогда не будет переиспользован в течение всего
    времени работы системы.  Поле ``domain`` указывает ID освобождаемого домена,
    а поле ``denials`` указывает общее число отклонённых запросов на доступ,
    которые могли не журналироваться в соответствии с правилами аудита и флагами
    sys_landlock_restrict_self().

    Пример::

        domain=195ba459b status=deallocated denials=3


Примеры событий
----------------

Ниже приведены два примера событий журнала (см. серийные номера).

В этом примере выполняемая в песочнице программа (``kill``) пытается отправить
сигнал процессу init, что отклоняется из-за ограничения области видимости
сигналов (``LL_SCOPED=s``)::

  $ LL_FS_RO=/ LL_FS_RW=/ LL_SCOPED=s LL_FORCE_LOG=1 ./sandboxer kill 1

Эта команда генерирует два события, каждое из которых идентифицируется
уникальным серийным номером, следующим за меткой времени
(``msg=audit(1729738800.268:30)``).  Первое событие (серийный номер ``30``)
содержит 4 записи.  Первая запись (``type=LANDLOCK_ACCESS``) показывает доступ,
отклонённый доменом `1a6fdc66f`.  Причина этого отказа — ограничение области
видимости сигналов (``blockers=scope.signal``).  Процесс, который должен был бы
получить этот сигнал, — это процесс init (``opid=1 ocomm="systemd"``).

Вторая запись (``type=LANDLOCK_DOMAIN``) описывает (``status=allocated``) домен
`1a6fdc66f`.  Этот домен был создан процессом ``286``, исполняющим программу
``/root/sandboxer``, запущенную пользователем root.

Третья запись (``type=SYSCALL``) описывает системный вызов, переданные ему
аргументы, его результат (``success=no exit=-1``) и процесс, который его вызвал.

Четвёртая запись (``type=PROCTITLE``) показывает имя команды в виде
шестнадцатеричного значения.  Его можно расшифровать с помощью ``python -c
'print(bytes.fromhex("6B696C6C0031"))'``.

Наконец, последняя запись (``type=LANDLOCK_DOMAIN``) также является единственной
во втором событии (серийный номер ``31``).  Она не связана с прямым действием
пространства пользователя, а с асинхронным действием по освобождению ресурсов,
связанных с доменом Landlock (``status=deallocated``).  Это может быть полезно,
чтобы знать, что последующие журналы больше не будут касаться домена
``1a6fdc66f``.  Эта запись также подытоживает число запросов, отклонённых этим
доменом (``denials=1``), независимо от того, были они занесены в журнал или нет.

.. code-block::

  type=LANDLOCK_ACCESS msg=audit(1729738800.268:30): domain=1a6fdc66f blockers=scope.signal opid=1 ocomm="systemd"
  type=LANDLOCK_DOMAIN msg=audit(1729738800.268:30): domain=1a6fdc66f status=allocated mode=enforcing pid=286 uid=0 exe="/root/sandboxer" comm="sandboxer"
  type=SYSCALL msg=audit(1729738800.268:30): arch=c000003e syscall=62 success=no exit=-1 [..] ppid=272 pid=286 auid=0 uid=0 gid=0 [...] comm="kill" [...]
  type=PROCTITLE msg=audit(1729738800.268:30): proctitle=6B696C6C0031
  type=LANDLOCK_DOMAIN msg=audit(1729738800.324:31): domain=1a6fdc66f status=deallocated denials=1

Ниже приведён ещё один пример, демонстрирующий контроль доступа к файловой
системе::

  $ LL_FS_RO=/ LL_FS_RW=/tmp LL_FORCE_LOG=1 ./sandboxer sh -c "echo > /etc/passwd"

Соответствующие журналы аудита содержат 8 записей из 3 разных событий (серийные
номера 33, 34 и 35), созданных одним и тем же доменом `1a6fdc679`::

  type=LANDLOCK_ACCESS msg=audit(1729738800.221:33): domain=1a6fdc679 blockers=fs.write_file path="/dev/tty" dev="devtmpfs" ino=9
  type=LANDLOCK_DOMAIN msg=audit(1729738800.221:33): domain=1a6fdc679 status=allocated mode=enforcing pid=289 uid=0 exe="/root/sandboxer" comm="sandboxer"
  type=SYSCALL msg=audit(1729738800.221:33): arch=c000003e syscall=257 success=no exit=-13 [...] ppid=272 pid=289 auid=0 uid=0 gid=0 [...] comm="sh" [...]
  type=PROCTITLE msg=audit(1729738800.221:33): proctitle=7368002D63006563686F203E202F6574632F706173737764
  type=LANDLOCK_ACCESS msg=audit(1729738800.221:34): domain=1a6fdc679 blockers=fs.write_file path="/etc/passwd" dev="vda2" ino=143821
  type=SYSCALL msg=audit(1729738800.221:34): arch=c000003e syscall=257 success=no exit=-13 [...] ppid=272 pid=289 auid=0 uid=0 gid=0 [...] comm="sh" [...]
  type=PROCTITLE msg=audit(1729738800.221:34): proctitle=7368002D63006563686F203E202F6574632F706173737764
  type=LANDLOCK_DOMAIN msg=audit(1729738800.261:35): domain=1a6fdc679 status=deallocated denials=2


Фильтрация событий
------------------

Если вы засыпаны журналами аудита, относящимися к Landlock, это либо попытка
атаки, либо ошибка в политике безопасности.  Мы можем установить некоторые
фильтры, чтобы ограничить шум, двумя взаимодополняющими способами:

- с помощью флагов sys_landlock_restrict_self(), если мы можем исправить
  программы, выполняемые в песочнице,
- либо с помощью правил аудита (см. :manpage:`auditctl(8)`).

Дополнительная документация
===========================

* `Linux Audit Documentation`_
* Documentation/userspace-api/landlock.rst
* Documentation/security/landlock.rst
* https://landlock.io

.. Links
.. _Linux Audit Documentation:
   https://github.com/linux-audit/audit-documentation/wiki
