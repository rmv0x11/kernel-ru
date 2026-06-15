======
Авторы
======

Первоначальный автор
--------------------

Steve French (smfrench@gmail.com, sfrench@samba.org)

Автор хочет выразить свою признательность и благодарность:
Andrew Tridgell (команда Samba) за его ранние предложения по улучшению
SMB/CIFS VFS. Спасибо IBM за предоставленные мне время и тестовые ресурсы для
работы над этим проектом, Jim McDonough из IBM (и команде Samba) за его помощь,
команде IBM Linux JFS за разъяснение многих эзотерических возможностей файловых
систем Linux. Jeremy Allison из команды Samba проделал неоценимую работу,
добавив серверную часть исходных Unix-расширений CIFS, а также рассмотрев и
реализовав части более новых POSIX-расширений CIFS в файловом сервере Samba 3.
Спасибо Dave Boutcher из IBM Rochester (автору клиента файловой системы smb/cifs
для OS/400) за то, что много лет назад он доказал, что очень хорошие клиенты
smb/cifs могут быть реализованы на Unix-подобных операционных системах.
Volker Lendecke, Andrew Tridgell, Urban Widmark, John Newbigin и другим за их
работу над модулем Linux smbfs. Спасибо остальным участникам CIFS Technical
Workgroup ассоциации Storage Network Industry Association за их работу по
спецификации этого крайне сложного протокола и, наконец, спасибо команде Samba
за их технические советы и поддержку.

Авторы патчей
-------------

- Zwane Mwaikambo
- Andi Kleen
- Amrut Joshi
- Shobhit Dayal
- Sergey Vlasov
- Richard Hughes
- Yury Umanets
- Mark Hamzy (за часть ранней работы над cifs IPv6)
- Domen Puncer
- Jesper Juhl (в частности, за большую работу по очистке пробелов/форматирования)
- Vince Negri и Dave Stahl (за обнаружение важной ошибки кэширования)
- Adrian Bunk (очистки kcalloc)
- Miklos Szeredi
- команда Kazeon за различные исправления, особенно для версии 2.4.
- Asser Ferno (поддержка Change Notify)
- Shaggy (Dave Kleikamp) за бесчисленные мелкие предложения по fs и хорошую очистку
- Gunter Kukkukk (тестирование и предложения по поддержке старых серверов)
- Igor Mammedov (поддержка DFS)
- Jeff Layton (множество, множество исправлений, а также отличная работа над кодом cifs Kerberos)
- Scott Lovenberg
- Pavel Shilovsky (за отличную работу по добавлению поддержки SMB2 и различных возможностей SMB3)
- Aurelien Aptel (за работу над DFS SMB3 и ряд ключевых исправлений ошибок)
- Ronnie Sahlberg (за работу над SMB3 xattr, исправления ошибок и большую отличную работу над compounding)
- Shirish Pargaonkar (за множество патчей ACL за эти годы)
- Sachin Prabhu (множество исправлений ошибок, в том числе для переподключения, copy offload и безопасности)
- Paulo Alcantara (за превосходную работу над DFS и над загрузкой из SMB3)
- Long Li (за отличную работу над RDMA, SMB Direct)


Авторы тестовых случаев и сообщений об ошибках
----------------------------------------------
Спасибо тем в сообществе, кто присылал подробные сообщения об ошибках
и отладку найденных ими проблем: Jochen Dolze, David Blaine,
Rene Scharfe, Martin Josefsson, Alexander Wild, Anthony Liguori,
Lars Muller, Urban Widmark, Massimiliano Ferrero, Howard Owen,
Olaf Kirch, Kieron Briggs, Nick Millington и другим. Отдельно следует
упомянуть Stanford Checker (SWAT), который указал на множество мелких
ошибок в путях обработки ошибок. Ценные предложения также поступали от Al Viro
и Dave Miller.

И спасибо командам тестирования IBM LTC и Power, а также тестировщикам SuSE, Citrix и RedHat за обнаружение множества ошибок в ходе превосходных нагрузочных тестов.
