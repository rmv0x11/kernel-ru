.. _kernel_docs:

Указатель дополнительной документации по ядру
==============================================

Потребность в документе вроде этого стала очевидной в списке рассылки
linux-kernel, поскольку одни и те же вопросы с просьбами указать источники
информации появлялись снова и снова.

К счастью, по мере того как всё больше людей переходит на GNU/Linux, всё больше
из них начинает интересоваться ядром. Но чтения исходного кода не всегда
достаточно. Понять код легко, но при этом можно упустить концепции, философию и
проектные решения, стоящие за этим кодом.

К сожалению, для начинающих доступно не так много документов. И даже если они
существуют, не было «общеизвестного» места, где бы они учитывались. Эти строки
призваны восполнить этот пробел.

ПОЖАЛУЙСТА, если вам известна какая-либо работа, не указанная здесь, или вы
пишете новый документ, добавьте ссылку на него сюда, следуя процессу подачи
патчей в ядро. Любые исправления, идеи или комментарии также приветствуются.

Все документы каталогизированы со следующими полями: «Title» (заголовок
документа), «Author»/s (автор/ы), «URL» (адрес, где их можно найти), некоторые
«Keywords» (ключевые слова), полезные при поиске по конкретным темам, и краткое
«Description» (описание) документа.

.. note::

   Документы в каждом разделе этого документа упорядочены по дате публикации, от
   самых новых к самым старым. Сопровождающий(е) должны периодически выводить из
   обращения ресурсы по мере того, как они устаревают или теряют актуальность;
   за исключением основополагающих книг.

Документация в дереве ядра Linux
--------------------------------

Книги Sphinx следует собирать командой ``make {htmldocs | pdfdocs | epubdocs}``.

    * Name: **linux/Documentation**

      :Author: Many.
      :Location: Documentation/
      :Keywords: text files, Sphinx.
      :Description: Документация, поставляемая вместе с исходным кодом ядра,
        внутри каталога Documentation. Некоторые страницы из этого документа
        (включая сам этот документ) были перемещены туда и могут быть более
        актуальными, чем веб-версия.

Онлайн-документация
-------------------

    * Title: **Linux Kernel Mailing List Glossary**

      :Author: various
      :URL: https://kernelnewbies.org/KernelGlossary
      :Date: rolling version
      :Keywords: glossary, terms, linux-kernel.
      :Description: Из введения: «Этот глоссарий задуман как краткое описание
        некоторых акронимов и терминов, которые вы можете услышать при
        обсуждении ядра Linux».

    * Title: **The Linux Kernel Module Programming Guide**

      :Author: Peter Jay Salzman, Michael Burian, Ori Pomerantz, Bob Mottram,
        Jim Huang.
      :URL: https://sysprog21.github.io/lkmpg/
      :Date: 2021
      :Keywords: modules, GPL book, /proc, ioctls, system calls,
        interrupt handlers .
      :Description: Очень хорошая GPL-книга на тему программирования модулей.
        Множество примеров. В настоящее время новая версия активно
        сопровождается по адресу https://github.com/sysprog21/lkmpg.

Изданные книги
--------------

    * Title: **The Linux Memory Manager**

      :Author: Lorenzo Stoakes
      :Publisher: No Starch Press
      :Date: February 2025
      :Pages: 1300
      :ISBN: 978-1718504462
      :Notes: Управление памятью. Полный черновик доступен в раннем доступе для
              предзаказа, полный выпуск запланирован на осень 2025 года. См.
              https://nostarch.com/linux-memory-manager для получения
              дополнительной информации.

    * Title: **Practical Linux System Administration: A Guide to Installation, Configuration, and Management, 1st Edition**

      :Author: Kenneth Hess
      :Publisher: O'Reilly Media
      :Date: May, 2023
      :Pages: 246
      :ISBN: 978-1098109035
      :Notes: Системное администрирование

    * Title: **Linux Kernel Debugging: Leverage proven tools and advanced techniques to effectively debug Linux kernels and kernel modules**

      :Author: Kaiwan N Billimoria
      :Publisher: Packt Publishing Ltd
      :Date: August, 2022
      :Pages: 638
      :ISBN: 978-1801075039
      :Notes: Книга по отладке

    * Title: **Linux Kernel Programming: A Comprehensive Guide to Kernel Internals, Writing Kernel Modules, and Kernel Synchronization**

      :Author: Kaiwan N Billimoria
      :Publisher: Packt Publishing Ltd
      :Date: March, 2021 (Second Edition published in 2024)
      :Pages: 754
      :ISBN: 978-1789953435 (Second Edition ISBN is 978-1803232225)

    * Title: **Linux Kernel Programming Part 2 - Char Device Drivers and Kernel Synchronization: Create user-kernel interfaces, work with peripheral I/O, and handle hardware interrupts**

      :Author: Kaiwan N Billimoria
      :Publisher: Packt Publishing Ltd
      :Date: March, 2021
      :Pages: 452
      :ISBN: 978-1801079518

    * Title: **Linux System Programming: Talking Directly to the Kernel and C Library**

      :Author: Robert Love
      :Publisher: O'Reilly Media
      :Date: June, 2013
      :Pages: 456
      :ISBN: 978-1449339531
      :Notes: Основополагающая книга

    * Title: **Linux Kernel Development, 3rd Edition**

      :Author: Robert Love
      :Publisher: Addison-Wesley
      :Date: July, 2010
      :Pages: 440
      :ISBN: 978-0672329463
      :Notes: Основополагающая книга

.. _ldd3_published:

    * Title: **Linux Device Drivers, 3rd Edition**

      :Authors: Jonathan Corbet, Alessandro Rubini, and Greg Kroah-Hartman
      :Publisher: O'Reilly & Associates
      :Date: 2005
      :Pages: 636
      :ISBN: 0-596-00590-3
      :Notes: Основополагающая книга. Дополнительная информация по адресу
        http://www.oreilly.com/catalog/linuxdrive3/
        В формате PDF, URL: https://lwn.net/Kernel/LDD3/

    * Title: **The Design of the UNIX Operating System**

      :Author: Maurice J. Bach
      :Publisher: Prentice Hall
      :Date: 1986
      :Pages: 471
      :ISBN: 0-13-201757-1
      :Notes: Основополагающая книга

Прочее
------

    * Name: **Cross-Referencing Linux**

      :URL: https://elixir.bootlin.com/
      :Keywords: Browsing source code.
      :Description: Ещё один веб-обозреватель исходного кода ядра Linux.
        Множество перекрёстных ссылок на переменные и функции. Вы можете видеть,
        где они определены и где используются.

    * Name: **Linux Weekly News**

      :URL: https://lwn.net
      :Keywords: latest kernel news.
      :Description: Название говорит само за себя. Здесь есть постоянный раздел о
        ядре, в котором резюмируются работа разработчиков, исправления ошибок,
        новые возможности и версии, выпущенные за неделю.

    * Name: **The home page of Linux-MM**

      :Author: The Linux-MM team.
      :URL: https://linux-mm.org/
      :Keywords: memory management, Linux-MM, mm patches, TODO, docs,
        mailing list.
      :Description: Сайт, посвящённый разработке управления памятью в Linux.
        Связанные с памятью патчи, руководства HOWTO, ссылки, разработчики mm...
        Не пропустите его, если вас интересует разработка управления памятью!

    * Name: **Kernel Newbies IRC Channel and Website**

      :URL: https://www.kernelnewbies.org
      :Keywords: IRC, newbies, channel, asking doubts.
      :Description: #kernelnewbies на irc.oftc.net.
        #kernelnewbies — это IRC-сеть, посвящённая «начинающим» (newbie)
        разработчикам ядра. Аудитория в основном состоит из людей, которые
        изучают ядро, работают над проектами, связанными с ядром, или
        профессиональных разработчиков ядра, желающих помочь менее опытным
        людям, работающим с ядром.
        #kernelnewbies находится в IRC-сети OFTC.
        Попробуйте irc.oftc.net в качестве вашего сервера, а затем
        /join #kernelnewbies.
        На сайте kernelnewbies также размещаются статьи, документы, FAQ...

    * Name: **linux-kernel mailing list archives and search engines**

      :URL: https://subspace.kernel.org
      :URL: https://lore.kernel.org
      :Keywords: linux-kernel, archives, search.
      :Description: Некоторые из архиваторов списка рассылки linux-kernel. Если у
        вас есть лучший/другой, пожалуйста, сообщите мне.

    * Name: **The Linux Foundation YouTube channel**

      :URL: https://www.youtube.com/user/thelinuxfoundation
      :Keywords: linux, videos, linux-foundation, youtube.
      :Description: The Linux Foundation выкладывает видеозаписи своих совместных
        мероприятий, конференций по Linux, включая LinuxCon, а также другие
        оригинальные исследования и материалы, связанные с Linux и разработкой
        программного обеспечения.

Rust
----

    * Title: **Rust for Linux**

      :Author: various
      :URL: https://rust-for-linux.com/
      :Date: rolling version
      :Keywords: glossary, terms, linux-kernel, rust.
      :Description: С веб-сайта: «Rust for Linux — это проект, добавляющий
        поддержку языка Rust в ядро Linux. Этот веб-сайт задуман как центр
        ссылок, документации и ресурсов, связанных с проектом».

    * Title: **Learn Rust the Dangerous Way**

      :Author: Cliff L. Biffle
      :URL: https://cliffle.com/p/dangerust/
      :Date: Accessed Sep 11 2024
      :Keywords: rust, blog.
      :Description: С веб-сайта: «LRtDW — это серия статей, помещающих
        возможности Rust в контекст для низкоуровневых программистов на C,
        которые, возможно, не имеют формального образования в области
        информатики — для людей, работающих над прошивками, игровыми движками,
        ядрами ОС и тому подобным. По сути, таких людей, как я». В нём
        иллюстрируется построчное преобразование из C в Rust.

    * Title: **The Rust Book**

      :Author: Steve Klabnik and Carol Nichols, with contributions from the
        Rust community
      :URL: https://doc.rust-lang.org/book/
      :Date: Accessed Sep 11 2024
      :Keywords: rust, book.
      :Description: С веб-сайта: «Эта книга в полной мере раскрывает потенциал
        Rust для расширения возможностей своих пользователей. Это дружелюбный и
        доступный текст, призванный помочь вам повысить уровень не только ваших
        знаний о Rust, но и вашего кругозора и уверенности как программиста в
        целом. Так что окунитесь в неё, приготовьтесь учиться — и добро
        пожаловать в сообщество Rust!».

    * Title: **Rust for the Polyglot Programmer**

      :Author: Ian Jackson
      :URL: https://www.chiark.greenend.org.uk/~ianmdlvl/rust-polyglot/index.html
      :Date: December 2022
      :Keywords: rust, blog, tooling.
      :Description: С веб-сайта: «Существует множество руководств и введений в
        Rust. Это руководство — нечто иное: оно предназначено для опытного
        программиста, который уже знает множество других языков
        программирования. Я стараюсь быть достаточно полным, чтобы оно стало
        отправной точкой для любой области Rust, но избегаю чрезмерных
        подробностей, кроме тех случаев, где что-то работает не так, как вы могли
        бы ожидать. Кроме того, это руководство не вполне свободно от мнений,
        включая рекомендации по библиотекам (крейтам), инструментарию и т.д.».

    * Title: **Fasterthanli.me**

      :Author: Amos Wenger
      :URL: https://fasterthanli.me/
      :Date: Accessed Sep 11 2024
      :Keywords: rust, blog, news.
      :Description: С веб-сайта: «Я создаю статьи и видео о том, как работают
        компьютеры. Мой контент — длинного формата, дидактический и
        исследовательский — и часто это повод поучить Rust!».

    * Title: **Comprehensive Rust**

      :Author: Android team at Google
      :URL: https://google.github.io/comprehensive-rust/
      :Date: Accessed Sep 13 2024
      :Keywords: rust, blog.
      :Description: С веб-сайта: «Курс охватывает весь спектр Rust, от базового
        синтаксиса до продвинутых тем, таких как обобщения (generics) и
        обработка ошибок».

    * Title: **The Embedded Rust Book**

      :Author: Multiple contributors, mostly Jorge Aparicio
      :URL: https://docs.rust-embedded.org/book/
      :Date: Accessed Sep 13 2024
      :Keywords: rust, blog.
      :Description: С веб-сайта: «Вводная книга об использовании языка
        программирования Rust во встраиваемых системах «голого железа» (Bare
        Metal), таких как микроконтроллеры».

   * Title: **Experiment: Improving the Rust Book**

      :Author: Cognitive Engineering Lab at Brown University
      :URL: https://rust-book.cs.brown.edu/
      :Date: Accessed Sep 22 2024
      :Keywords: rust, blog.
      :Description: С веб-сайта: «Цель этого эксперимента — оценить и улучшить
        содержание Rust Book, чтобы помочь людям эффективнее изучать Rust».

   * Title: **New Rustacean** (podcast)

      :Author: Chris Krycho
      :URL: https://newrustacean.com/
      :Date: Accessed Sep 22 2024
      :Keywords: rust, podcast.
      :Description: С веб-сайта: «Это подкаст об изучении языка программирования
        Rust — с нуля! Помимо этой нарядной стартовой страницы, весь контент
        сайта создан с помощью собственных инструментов документирования Rust».

   * Title: **Opsem-team** (repository)

      :Author: Operational semantics team
      :URL: https://github.com/rust-lang/opsem-team/tree/main
      :Date: Accessed Sep 22 2024
      :Keywords: rust, repository.
      :Description: Из README: «Команда opsem — преемник рабочей группы
        unsafe-code-guidelines, отвечающая за ответы на многие сложные вопросы о
        семантике небезопасного (unsafe) Rust».

    * Title: **You Can't Spell Trust Without Rust**

      :Author: Alexis Beingessner
      :URL: https://repository.library.carleton.ca/downloads/1j92g820w?locale=en
      :Date: 2015
      :Keywords: rust, master, thesis.
      :Description: Эта диссертация посвящена системе владения (ownership) в
        Rust, которая обеспечивает безопасность работы с памятью, управляя
        манипуляцией данными и временем их жизни, а также освещает её
        ограничения и сравнивает её с похожими системами в Cyclone и C++.

    * Name: **Linux Plumbers (LPC) 2024 Rust presentations**

      :Title: Rust microconference
      :URL: https://lpc.events/event/18/sessions/186/#20240918
      :Title: Rust for Linux
      :URL: https://lpc.events/event/18/contributions/1912/
      :Title: Journey of a C kernel engineer starting a Rust driver project
      :URL: https://lpc.events/event/18/contributions/1911/
      :Title: Crafting a Linux kernel scheduler that runs in user-space
        using Rust
      :URL: https://lpc.events/event/18/contributions/1723/
      :Title: openHCL: A Linux and Rust based paravisor
      :URL: https://lpc.events/event/18/contributions/1956/
      :Keywords: rust, lpc, presentations.
      :Description: Ряд докладов LPC, связанных с Rust.

    * Name: **The Rustacean Station Podcast**

      :URL: https://rustacean-station.org/
      :Keywords: rust, podcasts.
      :Description: Проект сообщества по созданию контента подкастов для языка
        программирования Rust.

-------

Этот документ изначально был основан на:

 https://www.dit.upm.es/~jmseyas/linux/kernel/hackers-docs.html

и написан Juan-Mariano de Goyeneche
