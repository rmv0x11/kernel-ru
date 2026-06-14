Создание pull request'ов
========================

В этой главе описывается, как сопровождающие (maintainers) могут создавать и
отправлять pull request'ы другим сопровождающим. Это полезно для переноса
изменений из дерева одного сопровождающего в дерево другого сопровождающего.

Этот документ был написан Tobin C. Harding (который на тот момент не был
опытным сопровождающим) — преимущественно на основе комментариев, сделанных
Greg Kroah-Hartman и Linus Torvalds в LKML. Предложения и исправления внесли
Jonathan Corbet и Mauro Carvalho Chehab.  Искажения были непреднамеренными, но
неизбежными; направляйте упрёки на Tobin C. Harding <me@tobin.cc>.

Исходная цепочка писем::

	https://lore.kernel.org/r/20171114110500.GA21175@kroah.com


Создание ветки
--------------

Для начала вам потребуется собрать все изменения, которые вы хотите включить в
pull request, в отдельной ветке. Обычно вы будете базировать эту ветку на ветке
из дерева того разработчика, которому вы намерены отправить pull request.

Чтобы создать pull request, вы сначала должны пометить тегом ветку, которую
только что создали. Рекомендуется выбрать осмысленное имя тега — такое, чтобы и
вы, и другие могли понять его даже спустя некоторое время.  Хорошей практикой
является включение в имя указания на подсистему-источник и целевую версию ядра.

Greg предлагает следующее. Pull request с разнообразными изменениями для
drivers/char, предназначенный для применения к версии ядра 4.15-rc1, можно было
бы назвать ``char-misc-4.15-rc1``. Если такой тег нужно было бы создать из ветки
с именем ``char-misc-next``, вы использовали бы следующую команду::

        git tag -s char-misc-4.15-rc1 char-misc-next

она создаст подписанный тег с именем ``char-misc-4.15-rc1`` на основе последнего
коммита в ветке ``char-misc-next`` и подпишет его вашим gpg-ключом
(см. Documentation/maintainer/configure-git.rst).

Linus принимает только pull request'ы, основанные на подписанном теге. У других
сопровождающих может быть иначе.

Когда вы выполните приведённую выше команду, ``git`` откроет редактор и
попросит вас описать тег.  В данном случае вы описываете pull request, поэтому
изложите, что в нём содержится, почему его следует принять (merge) и какое
тестирование, если оно проводилось, было выполнено.  Вся эта информация в итоге
окажется в самом теге, а затем и в merge-коммите, который сопровождающий создаёт
в случае, если он принимает pull request. Так что напишите её хорошо, поскольку
она навсегда останется в дереве ядра.

Как сказал Linus::

	Anyway, at least to me, the important part is the *message*. I want
	to understand what I'm pulling, and why I should pull it. I also
	want to use that message as the message for the merge, so it should
	not just make sense to me, but make sense as a historical record
	too.

	Note that if there is something odd about the pull request, that
	should very much be in the explanation. If you're touching files
	that you don't maintain, explain _why_. I will see it in the
	diffstat anyway, and if you didn't mention it, I'll just be extra
	suspicious.  And when you send me new stuff after the merge window
	(or even bug-fixes, but ones that look scary), explain not just
	what they do and why they do it, but explain the _timing_. What
	happened that this didn't go through the merge window..

	I will take both what you write in the email pull request _and_ in
	the signed tag, so depending on your workflow, you can either
	describe your work in the signed tag (which will also automatically
	make it into the pull request email), or you can make the signed
	tag just a placeholder with nothing interesting in it, and describe
	the work later when you actually send me the pull request.

	And yes, I will edit the message. Partly because I tend to do just
	trivial formatting (the whole indentation and quoting etc), but
	partly because part of the message may make sense for me at pull
	time (describing the conflicts and your personal issues for sending
	it right now), but may not make sense in the context of a merge
	commit message, so I will try to make it all make sense. I will
	also fix any speeling mistaeks and bad grammar I notice,
	particularly for non-native speakers (but also for native ones
	;^). But I may miss some, or even add some.

			Linus

Greg приводит в качестве примера pull request::

	Char/Misc patches for 4.15-rc1

	Here is the big char/misc patch set for the 4.15-rc1 merge window.
	Contained in here is the normal set of new functions added to all
	of these crazy drivers, as well as the following brand new
	subsystems:
		- time_travel_controller: Finally a set of drivers for the
		  latest time travel bus architecture that provides i/o to
		  the CPU before it asked for it, allowing uninterrupted
		  processing
		- relativity_shifters: due to the affect that the
		  time_travel_controllers have on the overall system, there
		  was a need for a new set of relativity shifter drivers to
		  accommodate the newly formed black holes that would
		  threaten to suck CPUs into them.  This subsystem handles
		  this in a way to successfully neutralize the problems.
		  There is a Kconfig option to force these to be enabled
		  when needed, so problems should not occur.

	All of these patches have been successfully tested in the latest
	linux-next releases, and the original problems that it found have
	all been resolved (apologies to anyone living near Canberra for the
	lack of the Kconfig options in the earlier versions of the
	linux-next tree creations.)

	Signed-off-by: Your-name-here <your_email@domain>


Формат сообщения тега точно такой же, как у git-коммита.  Одна строка наверху
для «краткой темы» (summary subject), и обязательно поставьте sign-off внизу.

Теперь, когда у вас есть локальный подписанный тег, вам нужно отправить (push)
его туда, откуда его можно будет получить::

	git push origin char-misc-4.15-rc1


Создание pull request'а
-----------------------

Последнее, что нужно сделать, — это создать сообщение pull request'а.  ``git``
любезно сделает это за вас с помощью команды ``git request-pull``, но ему нужна
небольшая помощь в определении того, что именно вы хотите запросить к слиянию
(pull) и относительно чего основывать сравнение (чтобы показать корректные
изменения для слияния и diffstat). Следующая команда (или команды) сгенерирует
pull request::

	git request-pull master git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ char-misc-4.15-rc1

Цитата из Greg::

	This is asking git to compare the difference from the
	'char-misc-4.15-rc1' tag location, to the head of the 'master'
	branch (which in my case points to the last location in Linus's
	tree that I diverged from, usually a -rc release) and to use the
	git:// protocol to pull from.  If you wish to use https://, that
	can be used here instead as well (but note that some people behind
	firewalls will have problems with https git pulls).

	If the char-misc-4.15-rc1 tag is not present in the repo that I am
	asking to be pulled from, git will complain saying it is not there,
	a handy way to remember to actually push it to a public location.

	The output of 'git request-pull' will contain the location of the
	git tree and specific tag to pull from, and the full text
	description of that tag (which is why you need to provide good
	information in that tag).  It will also create a diffstat of the
	pull request, and a shortlog of the individual commits that the
	pull request will provide.

Linus ответил, что он, как правило, предпочитает протокол ``git://``. У других
сопровождающих могут быть иные предпочтения. Также учтите, что если вы создаёте
pull request'ы без подписанного тега, то ``https://`` может оказаться более
подходящим выбором. Полное обсуждение см. в исходной цепочке писем.


Отправка pull request'а
-----------------------

Pull request отправляется так же, как обычный патч. Отправьте его как письмо с
текстом в теле (inline email) сопровождающему и поставьте в CC LKML, а также
любые специфичные для подсистемы списки рассылки, если это требуется. Pull
request'ы к Linus обычно имеют строку темы примерно такого вида::

	[GIT PULL] <subsystem> changes for v4.15-rc1
