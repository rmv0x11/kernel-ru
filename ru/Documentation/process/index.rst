.. raw:: latex

	\renewcommand\thesection*
	\renewcommand\thesubsection*

.. _process_index:

==============================================
Работа с сообществом разработчиков ядра
==============================================

Итак, вы хотите стать разработчиком ядра Linux? Добро пожаловать! Хотя о ядре
в техническом смысле предстоит узнать очень многое, не менее важно узнать и о
том, как работает наше сообщество. Прочтение этих документов значительно
упростит вам слияние ваших изменений с минимумом проблем.

Введение в то, как устроена разработка ядра
-------------------------------------------

Прочтите эти документы в первую очередь: понимание изложенного здесь материала
облегчит ваше вхождение в сообщество ядра.

.. toctree::
   :maxdepth: 1

   howto
   development-process
   submitting-patches
   submit-checklist

Инструменты и технические руководства для разработчиков ядра
------------------------------------------------------------

Это подборка материалов, с которыми должны быть знакомы разработчики ядра.

.. toctree::
   :maxdepth: 1

   changes
   programming-language
   coding-style
   maintainer-pgp-guide
   email-clients
   applying-patches
   backporting
   adding-syscalls
   volatile-considered-harmful
   botching-up-ioctls

Руководства по политикам и заявления разработчиков
--------------------------------------------------

Это правила, по которым мы стараемся жить в сообществе ядра (и за его
пределами).

.. toctree::
   :maxdepth: 1

   license-rules
   code-of-conduct
   code-of-conduct-interpretation
   contribution-maturity-model
   kernel-enforcement-statement
   kernel-driver-statement
   stable-api-nonsense
   stable-kernel-rules
   management-style
   researcher-guidelines
   generated-content
   coding-assistants
   conclave

Работа с ошибками
-----------------

Ошибки — это факт жизни; важно, чтобы мы обрабатывали их правильно. Приведённые
ниже документы дают общие советы по отладке и описывают наши политики в
отношении обработки пары особых классов ошибок: регрессий и проблем
безопасности.

.. toctree::
   :maxdepth: 1

   debugging/index
   handling-regressions
   security-bugs
   cve
   embargoed-hardware-issues

Информация для сопровождающих
-----------------------------

Как найти людей, которые примут ваши патчи.

.. toctree::
   :maxdepth: 1

   maintainer-handbooks
   maintainers

Прочие материалы
----------------

Вот несколько других руководств по сообществу, которые представляют интерес для
большинства разработчиков:

.. toctree::
   :maxdepth: 1

   kernel-docs
   deprecated
