.. SPDX-License-Identifier: GPL-2.0

Декодирование ошибок
====================

x86
---

Декодирование ошибок на системах AMD следует выполнять с помощью утилиты rasdaemon:
https://github.com/mchehab/rasdaemon/

Пока демон запущен, он будет автоматически журналировать и декодировать
ошибки. Если демон не запущен, такие ошибки всё равно можно декодировать,
предоставив сведения об оборудовании из ошибки::

        $ rasdaemon -p --status <STATUS> --ipid <IPID> --smca

Кроме того, пользователь может передать конкретные family и model, чтобы
декодировать строку ошибки::

        $ rasdaemon -p --status <STATUS> --ipid <IPID> --smca --family <CPU Family> --model <CPU Model> --bank <BANK_NUM>
