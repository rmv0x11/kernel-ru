.. SPDX-License-Identifier: GPL-2.0

==========================================
Меры защиты, связанные с RSB
==========================================

.. warning::
   Пожалуйста, поддерживайте этот документ в актуальном состоянии, иначе
   именно вам придётся его обновлять и превращать в очень длинный
   комментарий в bugs.c!

С 2018 года появилось множество CVE класса Spectre, связанных с Return Stack
Buffer (RSB) (иногда называемым Return Address Stack (RAS) или Return Address
Predictor (RAP) на AMD).

Информация об этих CVE и о том, как от них защищаться, разбросана по множеству
документов, специфичных для конкретных микроархитектур.

Этот документ — попытка собрать всю относящуюся к делу информацию в одном месте
и прояснить логику, лежащую в основе текущих мер защиты, связанных с RSB. Он
задуман максимально кратким и сфокусированным только на текущих мерах защиты
ядра: каковы связанные с RSB векторы атаки и как от них защищаются в настоящее
время?

Он *не* призван описывать, как работает механизм RSB или как действуют эксплойты.
Подробности об этом можно найти в источниках ниже.

Скорее это, по сути, возвеличенный комментарий, но слишком длинный, чтобы им
действительно быть. Так что, когда появится очередной CVE, разработчик ядра
сможет быстро обратиться к нему, чтобы освежить в памяти, что мы на самом деле
делаем и почему.

На высоком уровне существует два класса атак на RSB: отравление RSB (RSB
poisoning) (Intel и AMD) и переполнение RSB снизу (RSB underflow) (только Intel).
Каждый из них необходимо рассматривать отдельно для каждого вектора атаки
(и микроархитектуры, где это применимо).

----

Отравление RSB (Intel и AMD)
============================

SpectreRSB
~~~~~~~~~~

Отравление RSB — это техника, используемая SpectreRSB [#spectre-rsb]_, при которой
атакующий отравляет запись RSB, заставляя инструкцию возврата в жертве спекулятивно
перейти на адрес, контролируемый атакующим. Это может произойти, когда после
переключения контекста или VMEXIT остаются несбалансированные CALL/RET.

* Все векторы атаки потенциально могут быть нейтрализованы вытеснением любых
  отравленных записей RSB с помощью последовательности заполнения RSB
  [#intel-rsb-filling]_ [#amd-rsb-filling]_ при переходе между недоверенными
  и доверенными доменами. Но это влияет на производительность, и этого следует
  избегать, когда это возможно.

  .. DANGER::
     **FIXME**: В настоящее время мы вытесняем 32 записи. Однако у некоторых
     моделей CPU записей больше 32. Для них необходимо увеличить число итераций
     цикла. Требуется более подробная информация о размерах RSB.

* При переключении контекста защита user->user требует обеспечить заполнение или
  очистку RSB всякий раз, когда во время переключения контекста записывается IBPB
  [#cond-ibpb]_:

  * AMD:
	На Zen 4+ IBPB (или SBPB [#amd-sbpb]_, если используется) очищает RSB.
	Об этом сигнализирует IBPB_RET в CPUID [#amd-ibpb-rsb]_.

	На Zen < 4 последовательность заполнения RSB [#amd-rsb-filling]_ всегда
	должна выполняться в дополнение к IBPB [#amd-ibpb-no-rsb]_. Об этом
	сигнализирует X86_BUG_IBPB_NO_RET.

  * Intel:
	IBPB всегда очищает RSB:

	"Программное обеспечение, выполнявшееся до команды IBPB, не может
	контролировать предсказанные цели косвенных переходов, выполняемых после
	этой команды на том же логическом процессоре. Термин «косвенный переход»
	в этом контексте включает инструкции ближнего возврата (near return), так
	что эти предсказанные цели могут поступать из RSB." [#intel-ibpb-rsb]_

* При переключении контекста атаки user->kernel предотвращаются SMEP.
  Пространство пользователя может вставлять в RSB только адреса пространства
  пользователя. Даже неканонические адреса не могут быть вставлены из-за разрыва
  страниц в конце канонического адресного пространства пользователя,
  зарезервированного TASK_SIZE_MAX. SMEP #PF при выборке инструкции не позволяет
  ядру спекулятивно выполнять код пространства пользователя.

  * AMD:
	"Наконец, переходы, предсказанные как инструкции 'ret', получают свои
	предсказанные цели из Return Address Predictor (RAP). AMD рекомендует
	программному обеспечению использовать последовательность набивки RAP (RAP
	stuffing sequence) (мера защиты V2-3 в [2]) и/или Supervisor Mode Execution
	Protection (SMEP), чтобы гарантировать безопасность адресов в RAP для
	спекуляции. В совокупности мы называем эти меры защиты «RAP Protection»."
	[#amd-smep-rsb]_

  * Intel:
	"На процессорах с enhanced IBRS последовательности перезаписи RSB может быть
	недостаточно, чтобы предотвратить использование предсказанной целью ближнего
	возврата записи RSB, созданной в менее привилегированном режиме предсказателя.
	Программное обеспечение может предотвратить это, включив SMEP (для переходов
	из пользовательского режима в супервизорный) и установив
	IA32_SPEC_CTRL.IBRS во время выходов из VM (VM exit)." [#intel-smep-rsb]_

* При VMEXIT атаки guest->host нейтрализуются с помощью eIBRS (и меры защиты
  PBRSB, если требуется):

  * AMD:
	"Когда включён Automatic IBRS, внутренний стек адресов возврата,
	используемый для предсказаний адресов возврата, очищается при VMEXIT."
	[#amd-eibrs-vmexit]_

  * Intel:
	"На процессорах с enhanced IBRS последовательности перезаписи RSB может быть
	недостаточно, чтобы предотвратить использование предсказанной целью ближнего
	возврата записи RSB, созданной в менее привилегированном режиме предсказателя.
	Программное обеспечение может предотвратить это, включив SMEP (для переходов
	из пользовательского режима в супервизорный) и установив
	IA32_SPEC_CTRL.IBRS во время выходов из VM. Процессоры с enhanced IBRS
	по-прежнему поддерживают модель использования, при которой IBRS
	устанавливается только в ОС/VMM для ОС, включающих SMEP. Для этого такие
	процессоры гарантируют, что поведение гостя не сможет контролировать RSB
	после выхода из VM, как только IBRS установлен, даже если IBRS не был
	установлен в момент выхода из VM." [#intel-eibrs-vmexit]_

    Обратите внимание, что некоторые CPU Intel подвержены Post-barrier Return
    Stack Buffer Predictions (PBRSB) [#intel-pbrsb]_, при котором последний
    CALL из гостя может использоваться для предсказания первого
    несбалансированного RET. В этом случае в дополнение к eIBRS требуется мера
    защиты PBRSB.

AMD RETBleed / SRSO / Branch Type Confusion
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

На AMD отравленные записи RSB также могут создаваться вариантом AMD RETBleed
[#retbleed-paper]_ [#amd-btc]_ или Speculative Return Stack Overflow [#amd-srso]_
(Inception [#inception-paper]_). Ядро защищает себя, заменяя каждый RET в ядре
переходом на единственный безопасный RET.

----

Переполнение RSB снизу (только Intel)
=====================================

RSB Alternate (RSBA) («Intel Retbleed»)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Некоторые CPU Intel поколения Skylake подвержены варианту RETBleed от Intel
[#retbleed-paper]_ (Return Stack Buffer Underflow [#intel-rsbu]_). Если RET
выполняется, когда буфер RSB пуст из-за несовпадающих CALL/RET или возврата из
глубокого стека вызовов, предсказатель переходов может прибегнуть к использованию
Branch Target Buffer (BTB). Если пользователь вызовет коллизию в BTB, то RET
может спекулятивно перейти на адрес, контролируемый пользователем.

* Обратите внимание, что заполнение RSB не нейтрализует эту проблему полностью.
  Если несбалансированных RET достаточно много, RSB всё равно может переполниться
  снизу и прибегнуть к использованию отравленной записи BTB.

* При переключении контекста атаки переполнения снизу user->user нейтрализуются
  условным IBPB [#cond-ibpb]_ при переключении контекста, который фактически
  очищает BTB:

  * "Барьер предсказателя косвенных переходов (indirect branch predictor barrier,
    IBPB) — это механизм управления косвенными переходами, устанавливающий
    барьер, который не позволяет программному обеспечению, выполнявшемуся до
    барьера, контролировать предсказанные цели косвенных переходов, выполняемых
    после барьера на том же логическом процессоре." [#intel-ibpb-btb]_

* При переключении контекста и VMEXIT переполнения RSB снизу user->kernel и
  guest->host нейтрализуются с помощью IBRS или eIBRS:

  * "Включение IBRS (в том числе enhanced IBRS) нейтрализует атаку «RSBU»,
    продемонстрированную исследователями. Как было задокументировано ранее, Intel
    рекомендует использовать enhanced IBRS там, где он поддерживается. Это
    относится к любому процессору, который перечисляет RRSBA, но не RRSBA_DIS_S."
    [#intel-rsbu]_

  Однако обратите внимание, что eIBRS и IBRS не нейтрализуют внутрирежимные
  (intra-mode) атаки. Как и RRSBA ниже, это нейтрализуется очисткой BHB при входе
  в ядро.

  В качестве альтернативы классическому IBRS можно использовать отслеживание
  глубины вызовов (call depth tracking) (в сочетании с retpoline) для отслеживания
  возвратов в ядро и заполнения RSB, когда он близок к опустошению.

Restricted RSB Alternate (RRSBA)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Некоторые более новые CPU Intel имеют поведение Restricted RSB Alternate (RRSBA),
которое, подобно описанному выше RSBA, также прибегает к использованию BTB при
переполнении RSB снизу. Единственное отличие в том, что предсказанные цели
ограничены текущим доменом, когда включён eIBRS:

* "Поведение Restricted RSB Alternate (RRSBA) позволяет альтернативным
  предсказателям переходов использоваться инструкциями ближнего RET, когда RSB
  пуст. Когда включён eIBRS, предсказанные цели этих альтернативных
  предсказателей ограничены теми, которые принадлежат записям предсказателя
  косвенных переходов текущего домена предсказания.
  [#intel-eibrs-rrsba]_

Когда CPU с RRSBA уязвим к Branch History Injection [#bhi-paper]_ [#intel-bhi]_,
переполнение RSB снизу может быть использовано для внутрирежимной (intra-mode)
атаки BTI. Это нейтрализуется очисткой BHB при входе в ядро.

Однако если ядро использует retpoline вместо eIBRS, ему необходимо отключить
RRSBA:

* "Там, где программное обеспечение использует retpoline в качестве меры защиты
  от BHI или внутрирежимного (intra-mode) BTI, и процессор перечисляет как RRSBA,
  так и средства управления RRSBA_DIS, оно должно отключить это поведение."
  [#intel-retpoline-rrsba]_

----

Источники
=========

.. [#spectre-rsb] `Spectre Returns! Speculation Attacks using the Return Stack Buffer <https://arxiv.org/pdf/1807.07940.pdf>`_

.. [#intel-rsb-filling] "Empty RSB Mitigation on Skylake-generation" in `Retpoline: A Branch Target Injection Mitigation <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/retpoline-branch-target-injection-mitigation.html#inpage-nav-5-1>`_

.. [#amd-rsb-filling] "Mitigation V2-3" in `Software Techniques for Managing Speculation <https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/software-techniques-for-managing-speculation.pdf>`_

.. [#cond-ibpb] Whether IBPB is written depends on whether the prev and/or next task is protected from Spectre attacks.  It typically requires opting in per task or system-wide.  For more details see the documentation for the ``spectre_v2_user`` cmdline option in Documentation/admin-guide/kernel-parameters.txt.

.. [#amd-sbpb] IBPB without flushing of branch type predictions.  Only exists for AMD.

.. [#amd-ibpb-rsb] "Function 8000_0008h -- Processor Capacity Parameters and Extended Feature Identification" in `AMD64 Architecture Programmer's Manual Volume 3: General-Purpose and System Instructions <https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24594.pdf>`_.  SBPB behaves the same way according to `this email <https://lore.kernel.org/5175b163a3736ca5fd01cedf406735636c99a>`_.

.. [#amd-ibpb-no-rsb] `Spectre Attacks: Exploiting Speculative Execution <https://comsec.ethz.ch/wp-content/files/ibpb_sp25.pdf>`_

.. [#intel-ibpb-rsb] "Introduction" in `Post-barrier Return Stack Buffer Predictions / CVE-2022-26373 / INTEL-SA-00706 <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html>`_

.. [#amd-smep-rsb] "Existing Mitigations" in `Technical Guidance for Mitigating Branch Type Confusion <https://www.amd.com/content/dam/amd/en/documents/resources/technical-guidance-for-mitigating-branch-type-confusion.pdf>`_

.. [#intel-smep-rsb] "Enhanced IBRS" in `Indirect Branch Restricted Speculation <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/indirect-branch-restricted-speculation.html>`_

.. [#amd-eibrs-vmexit] "Extended Feature Enable Register (EFER)" in `AMD64 Architecture Programmer's Manual Volume 2: System Programming <https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24593.pdf>`_

.. [#intel-eibrs-vmexit] "Enhanced IBRS" in `Indirect Branch Restricted Speculation <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/indirect-branch-restricted-speculation.html>`_

.. [#intel-pbrsb] `Post-barrier Return Stack Buffer Predictions / CVE-2022-26373 / INTEL-SA-00706 <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html>`_

.. [#retbleed-paper] `RETBleed: Arbitrary Speculative Code Execution with Return Instruction <https://comsec.ethz.ch/wp-content/files/retbleed_sec22.pdf>`_

.. [#amd-btc] `Technical Guidance for Mitigating Branch Type Confusion <https://www.amd.com/content/dam/amd/en/documents/resources/technical-guidance-for-mitigating-branch-type-confusion.pdf>`_

.. [#amd-srso] `Technical Update Regarding Speculative Return Stack Overflow <https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf>`_

.. [#inception-paper] `Inception: Exposing New Attack Surfaces with Training in Transient Execution <https://comsec.ethz.ch/wp-content/files/inception_sec23.pdf>`_

.. [#intel-rsbu] `Return Stack Buffer Underflow / Return Stack Buffer Underflow / CVE-2022-29901, CVE-2022-28693 / INTEL-SA-00702 <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/return-stack-buffer-underflow.html>`_

.. [#intel-ibpb-btb] `Indirect Branch Predictor Barrier' <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/indirect-branch-predictor-barrier.html>`_

.. [#intel-eibrs-rrsba] "Guidance for RSBU" in `Return Stack Buffer Underflow / Return Stack Buffer Underflow / CVE-2022-29901, CVE-2022-28693 / INTEL-SA-00702 <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/return-stack-buffer-underflow.html>`_

.. [#bhi-paper] `Branch History Injection: On the Effectiveness of Hardware Mitigations Against Cross-Privilege Spectre-v2 Attacks <http://download.vusec.net/papers/bhi-spectre-bhb_sec22.pdf>`_

.. [#intel-bhi] `Branch History Injection and Intra-mode Branch Target Injection / CVE-2022-0001, CVE-2022-0002 / INTEL-SA-00598 <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html>`_

.. [#intel-retpoline-rrsba] "Retpoline" in `Branch History Injection and Intra-mode Branch Target Injection / CVE-2022-0001, CVE-2022-0002 / INTEL-SA-00598 <https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html>`_
