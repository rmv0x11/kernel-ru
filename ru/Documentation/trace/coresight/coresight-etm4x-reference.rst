==========================================================================
Справочник по программированию sysfs-драйвера ETMv4 для Linux.
==========================================================================

    :Author:   Mike Leach <mike.leach@linaro.org>
    :Date:     October 11th, 2019

Дополнение к существующей документации драйвера ETMv4.

Файлы и каталоги sysfs
----------------------

Корень: ``/sys/bus/coresight/devices/etm<N>``


В последующих абзацах описывается связь между файлами sysfs и регистрами
ETMv4, на которые они влияют. Обратите внимание, что имена регистров приводятся
без префикса «TRC».

----

:File:            ``mode`` (rw)
:Trace Registers: {CONFIGR + others}
:Notes:
    Битовый выбор функций трассировки. См. раздел «mode» ниже. Биты
    здесь приводят к эквивалентному программированию конфигурации трассировки
    и других регистров для включения запрошенных функций.

:Syntax & eg:
    ``echo bitfield > mode``

    bitfield — до 32 бит, задающих функции трассировки.

:Example:
    ``$> echo 0x012 > mode``

----

:File:            ``reset`` (wo)
:Trace Registers: All
:Notes:
    Сбросить всё программирование, чтобы не трассировать ничего / не программировать никакой логики.

:Syntax:
    ``echo 1 > reset``

----

:File:            ``enable_source`` (wo)
:Trace Registers: PRGCTLR, All hardware regs.
:Notes:
    - > 0 : Программирует аппаратуру текущими значениями, хранящимися в драйвере,
      и включает трассировку.

    - = 0 : выключить аппаратуру трассировки.

:Syntax:
    ``echo 1 > enable_source``

----

:File:            ``cpu`` (ro)
:Trace Registers: None.
:Notes:
    ID CPU, к которому подключён данный ETM.

:Example:
    ``$> cat cpu``

    ``$> 0``

----

:File:            ``ts_source`` (ro)
:Trace Registers: None.
:Notes:
    Когда реализован FEAT_TRF — значение TRFCR_ELx.TS, используемое для сеанса трассировки. В противном случае -1
    указывает на неизвестный источник времени. Проверьте trcidr0.tssize, чтобы узнать, доступна ли глобальная
    метка времени.

:Example:
    ``$> cat ts_source``

    ``$> 1``

----

:File:            ``addr_idx`` (rw)
:Trace Registers: None.
:Notes:
    Виртуальный регистр для индексации функций компаратора адресов и диапазона
    адресов. Задаёт индекс для первого из пары в диапазоне.

:Syntax:
    ``echo idx > addr_idx``

    Где idx < nr_addr_cmp x 2

----

:File:            ``addr_range`` (rw)
:Trace Registers: ACVR[idx, idx+1], VIIECTLR
:Notes:
    Пара адресов для диапазона, выбранного с помощью addr_idx. Включение
    / исключение согласно необязательному параметру, а если он опущен —
    используется текущая настройка «mode». Выбирает диапазон компаратора в
    управляющем регистре. Ошибка, если индекс имеет нечётное значение.

:Depends: ``mode, addr_idx``
:Syntax:
   ``echo addr1 addr2 [exclude] > addr_range``

   Где addr1 и addr2 задают диапазон, причём addr1 < addr2.

   Необязательное значение exclude:-

   - 0 для включения
   - 1 для исключения.
:Example:
   ``$> echo 0x0000 0x2000 0 > addr_range``

----

:File:            ``addr_single`` (rw)
:Trace Registers: ACVR[idx]
:Notes:
    Установить одиночный компаратор адресов согласно addr_idx. Это
    используется, если компаратор адресов задействован как часть логики
    генерации событий и т.п.

:Depends: ``addr_idx``
:Syntax:
   ``echo addr1 > addr_single``

----

:File:           ``addr_start`` (rw)
:Trace Registers: ACVR[idx], VISSCTLR
:Notes:
    Установить компаратор начального адреса трассировки согласно addr_idx.
    Выбрать компаратор в управляющем регистре.

:Depends: ``addr_idx``
:Syntax:
    ``echo addr1 > addr_start``

----

:File:            ``addr_stop`` (rw)
:Trace Registers: ACVR[idx], VISSCTLR
:Notes:
    Установить компаратор конечного адреса трассировки согласно addr_idx.
    Выбрать компаратор в управляющем регистре.

:Depends: ``addr_idx``
:Syntax:
    ``echo addr1 > addr_stop``

----

:File:            ``addr_context`` (rw)
:Trace Registers: ACATR[idx,{6:4}]
:Notes:
    Связать компаратор ID контекста с компаратором адресов addr_idx

:Depends: ``addr_idx``
:Syntax:
    ``echo ctxt_idx > addr_context``

    Где ctxt_idx — индекс связываемого компаратора ID контекста / vmid.

----

:File:            ``addr_ctxtype`` (rw)
:Trace Registers: ACATR[idx,{3:2}]
:Notes:
    Входная строка значения. Установить тип для связанного компаратора ID контекста

:Depends: ``addr_idx``
:Syntax:
    ``echo type > addr_ctxtype``

    Type — одно из {all, vmid, ctxid, none}
:Example:
    ``$> echo ctxid > addr_ctxtype``

----

:File:            ``addr_exlevel_s_ns`` (rw)
:Trace Registers: ACATR[idx,{14:8}]
:Notes:
    Установить биты сопоставления безопасного и небезопасного состояний ELx для
    выбранного компаратора адресов

:Depends: ``addr_idx``
:Syntax:
    ``echo val > addr_exlevel_s_ns``

    val — 7-битное значение уровней исключений для исключения. Входное
    значение сдвигается в нужные биты регистра.
:Example:
    ``$> echo 0x4F > addr_exlevel_s_ns``

----

:File:            ``addr_instdatatype`` (rw)
:Trace Registers: ACATR[idx,{1:0}]
:Notes:
    Установить тип адреса компаратора для сопоставления. Драйвер поддерживает
    только установку типа адреса инструкции.

:Depends: ``addr_idx``

----

:File:            ``addr_cmp_view`` (ro)
:Trace Registers: ACVR[idx, idx+1], ACATR[idx], VIIECTLR
:Notes:
    Прочитать текущий выбранный компаратор адресов. Если он является частью
    диапазона адресов, то отображаются оба адреса.

:Depends: ``addr_idx``
:Syntax:
    ``cat addr_cmp_view``
:Example:
    ``$> cat addr_cmp_view``

   ``addr_cmp[0] range 0x0 0xffffffffffffffff include ctrl(0x4b00)``

----

:File:            ``nr_addr_cmp`` (ro)
:Trace Registers: From IDR4
:Notes:
    Количество пар компараторов адресов

----

:File:            ``sshot_idx`` (rw)
:Trace Registers: None
:Notes:
    Выбрать набор регистров single shot.

----

:File:            ``sshot_ctrl`` (rw)
:Trace Registers: SSCCR[idx]
:Notes:
    Доступ к управляющему регистру компаратора single shot.

:Depends: ``sshot_idx``
:Syntax:
    ``echo val > sshot_ctrl``

    Записывает val в выбранный управляющий регистр.

----

:File:            ``sshot_status`` (ro)
:Trace Registers: SSCSR[idx]
:Notes:
    Прочитать регистр состояния компаратора single shot

:Depends: ``sshot_idx``
:Syntax:
    ``cat sshot_status``

    Прочитать состояние.
:Example:
    ``$> cat sshot_status``

    ``0x1``

----

:File:            ``sshot_pe_ctrl`` (rw)
:Trace Registers: SSPCICR[idx]
:Notes:
    Доступ к управляющему регистру входа компаратора PE single shot.

:Depends: ``sshot_idx``
:Syntax:
    ``echo val > sshot_pe_ctrl``

    Записывает val в выбранный управляющий регистр.

----

:File:            ``ns_exlevel_vinst`` (rw)
:Trace Registers: VICTLR{23:20}
:Notes:
    Запрограммировать фильтры небезопасных уровней исключений. Установить /
    сбросить биты фильтра исключений NS. Установка «1» исключает трассировку с
    данного уровня исключений.

:Syntax:
    ``echo bitfield > ns_exlevel_viinst``

    Где bitfield содержит биты для установки/сброса для EL0 — EL2
:Example:
    ``%> echo 0x4 > ns_exlevel_viinst``

    Исключает трассировку EL2 NS.

----

:File:            ``vinst_pe_cmp_start_stop`` (rw)
:Trace Registers: VIPCSSCTLR
:Notes:
    Доступ к управляющим регистрам входа компаратора start/stop PE

----

:File:            ``bb_ctrl`` (rw)
:Trace Registers: BBCTLR
:Notes:
    Задать диапазоны, в которых будет работать Branch Broadcast.
    По умолчанию (0x0) — все адреса.

:Depends: BB enabled.

----

:File:            ``cyc_threshold`` (rw)
:Trace Registers: CCCTLR
:Notes:
    Установить порог, начиная с которого будут выдаваться счётчики циклов.
    Ошибка при попытке установить значение ниже минимума, определённого в IDR3;
    маскируется по ширине допустимых битов.

:Depends: CC enabled.

----

:File:            ``syncfreq`` (rw)
:Trace Registers: SYNCPR
:Notes:
    Установить период синхронизации трассировки. Значение — степень 2, 0 (выкл.)
    либо 8-20. Драйвер по умолчанию использует 12 (каждые 4096 байт).

----

:File:            ``cntr_idx`` (rw)
:Trace Registers: none
:Notes:
    Выбрать счётчик для доступа

:Syntax:
    ``echo idx > cntr_idx``

    Где idx < nr_cntr

----

:File:            ``cntr_ctrl`` (rw)
:Trace Registers: CNTCTLR[idx]
:Notes:
    Установить управляющее значение счётчика.

:Depends: ``cntr_idx``
:Syntax:
    ``echo val > cntr_ctrl``

    Где val — согласно спецификации ETMv4.

----

:File:            ``cntrldvr`` (rw)
:Trace Registers: CNTRLDVR[idx]
:Notes:
    Установить значение перезагрузки счётчика.

:Depends: ``cntr_idx``
:Syntax:
    ``echo val > cntrldvr``

    Где val — согласно спецификации ETMv4.

----

:File:            ``nr_cntr`` (ro)
:Trace Registers: From IDR5

:Notes:
    Количество реализованных счётчиков.

----

:File:            ``ctxid_idx`` (rw)
:Trace Registers: None
:Notes:
    Выбрать компаратор ID контекста для доступа

:Syntax:
    ``echo idx > ctxid_idx``

    Где idx < numcidc

----

:File:            ``ctxid_pid`` (rw)
:Trace Registers: CIDCVR[idx]
:Notes:
   Установить значение компаратора ID контекста

:Depends: ``ctxid_idx``

----

:File: ``ctxid_masks`` (rw)
:Trace Registers: CIDCCTLR0, CIDCCTLR1, CIDCVR<0-7>
:Notes:
    Пара значений для установки байтовых масок для 1-8 компараторов ID
    контекста. Автоматически сбрасывает маскированные байты в 0 в регистрах
    значений CID.

:Syntax:
    ``echo m3m2m1m0 [m7m6m5m4] > ctxid_masks``

    32-битные значения, составленные из байтов масок, где mN представляет
    байтовое значение маски для компаратора ID контекста N.

    Второе значение не требуется на системах, имеющих менее 4
    компараторов ID контекста

----

:File:            ``numcidc`` (ro)
:Trace Registers: From IDR4
:Notes:
    Количество компараторов ID контекста

----

:File:            ``vmid_idx`` (rw)
:Trace Registers: None
:Notes:
    Выбрать компаратор VM ID для доступа.

:Syntax:
    ``echo idx > vmid_idx``

    Где idx <  numvmidc

----

:File:            ``vmid_val`` (rw)
:Trace Registers: VMIDCVR[idx]
:Notes:
    Установить значение компаратора VM ID

:Depends: ``vmid_idx``

----

:File:            ``vmid_masks`` (rw)
:Trace Registers: VMIDCCTLR0, VMIDCCTLR1, VMIDCVR<0-7>
:Notes:
    Пара значений для установки байтовых масок для 1-8 компараторов VM ID.
    Автоматически сбрасывает маскированные байты в 0 в регистрах значений VMID.

:Syntax:
    ``echo m3m2m1m0 [m7m6m5m4] > vmid_masks``

    Где mN представляет байтовое значение маски для компаратора VMID N.
    Второе значение не требуется на системах, имеющих менее 4
    компараторов VMID.

----

:File:            ``numvmidc`` (ro)
:Trace Registers: From IDR4
:Notes:
    Количество компараторов VMID

----

:File:            ``res_idx`` (rw)
:Trace Registers: None.
:Notes:
    Выбрать селектор управления ресурсами для доступа. Должен быть 2 или
    больше, так как селекторы 0 и 1 жёстко заданы.

:Syntax:
    ``echo idx > res_idx``

    Где 2 <= idx < nr_resource x 2

----

:File:            ``res_ctrl`` (rw)
:Trace Registers: RSCTLR[idx]
:Notes:
    Установить управляющее значение селектора ресурсов. Значение согласно спецификации ETMv4.

:Depends: ``res_idx``
:Syntax:
    ``echo val > res_cntr``

    Где val — согласно спецификации ETMv4.

----

:File:            ``nr_resource`` (ro)
:Trace Registers: From IDR4
:Notes:
    Количество пар селекторов ресурсов

----

:File:            ``event`` (rw)
:Trace Registers: EVENTCTRL0R
:Notes:
    Настроить до 4 реализованных полей событий.

:Syntax:
    ``echo ev3ev2ev1ev0 > event``

    Где evN — 8-битное поле события. До 4 полей событий составляют
    32-битное входное значение. Количество допустимых полей зависит от
    реализации и определяется в IDR0.

----

:File: ``event_instren`` (rw)
:Trace Registers: EVENTCTRL1R
:Notes:
    Выбрать события, которые вставляют пакеты событий в поток трассировки.

:Depends: EVENTCTRL0R
:Syntax:
    ``echo bitfield > event_instren``

    Где bitfield — до 4 бит в соответствии с количеством полей событий.

----

:File:            ``event_ts`` (rw)
:Trace Registers: TSCTLR
:Notes:
    Установить событие, которое будет генерировать запросы меток времени.

:Depends: ``TS activated``
:Syntax:
    ``echo evfield > event_ts``

    Где evfield — 8-битный селектор события.

----

:File:            ``seq_idx`` (rw)
:Trace Registers: None
:Notes:
    Выбор регистра события секвенсора - от 0 до 2

----

:File:            ``seq_state`` (rw)
:Trace Registers: SEQSTR
:Notes:
    Текущее состояние секвенсора - от 0 до 3.

----

:File:            ``seq_event`` (rw)
:Trace Registers: SEQEVR[idx]
:Notes:
    Регистры событий перехода между состояниями

:Depends: ``seq_idx``
:Syntax:
    ``echo evBevF > seq_event``

    Где evBevF — 16-битное значение, составленное из двух селекторов событий,

    - evB : назад
    - evF : вперёд.

----

:File:            ``seq_reset_event`` (rw)
:Trace Registers: SEQRSTEVR
:Notes:
    Событие сброса секвенсора

:Syntax:
    ``echo evfield > seq_reset_event``

    Где evfield — 8-битный селектор события.

----

:File:            ``nrseqstate`` (ro)
:Trace Registers: From IDR5
:Notes:
    Количество состояний секвенсора (0 или 4)

----

:File:            ``nr_pe_cmp`` (ro)
:Trace Registers: From IDR4
:Notes:
    Количество входов компаратора PE

----

:File:            ``nr_ext_inp`` (ro)
:Trace Registers: From IDR5
:Notes:
    Количество внешних входов

----

:File:            ``nr_ss_cmp`` (ro)
:Trace Registers: From IDR4
:Notes:
    Количество управляющих регистров Single Shot

----

*Примечание:* При программировании любого компаратора адресов драйвер помечает
компаратор используемым типом — т.е. RANGE, SINGLE, START, STOP. Когда эта
метка установлена, значения можно менять только через тот же файл sysfs / тип,
который использовался для его программирования.

Таким образом::

  % echo 0 > addr_idx		; select address comparator 0
  % echo 0x1000 0x5000 0 > addr_range ; set address range on comparators 0, 1.
  % echo 0x2000 > addr_start    ; error as comparator 0 is a range comparator
  % echo 2 > addr_idx		; select address comparator 2
  % echo 0x2000 > addr_start	; this is OK as comparator 2 is unused.
  % echo 0x3000 > addr_stop	; error as comparator 2 set as start address.
  % echo 2 > addr_idx		; select address comparator 3
  % echo 0x3000 > addr_stop	; this is OK

Чтобы удалить программирование на всех компараторах (и всей остальной
аппаратуре), используйте параметр reset::

  % echo 1 > reset



Параметр sysfs «mode».
----------------------

Это параметр выбора в виде битового поля, который задаёт общий режим
трассировки для ETM. В таблице ниже описываются биты с использованием
определений из файла исходного кода драйвера, а также описание функции,
которую они представляют. Многие функции необязательны и потому зависят от
реализации в аппаратуре.

Назначение битов показано ниже:-

----

**bit (0):**
    ETM_MODE_EXCLUDE

**description:**
    Это значение по умолчанию для функции include / exclude при
    задании диапазонов адресов. Установите 1 для исключения диапазона. Когда
    задаётся параметр mode, это значение применяется к текущему индексированному
    диапазону адресов.

.. _coresight-branch-broadcast:

**bit (4):**
    ETM_MODE_BB

**description:**
    Установите для включения branch broadcast, если поддерживается аппаратурой [IDR0]. Основное применение этой функции —
    когда код патчится динамически во время выполнения и полный поток программы не может быть
    восстановлен с использованием только условных переходов.

    В настоящее время в Perf нет поддержки передачи изменённых бинарных файлов декодеру, поэтому эта
    функция предназначена для использования только в целях отладки или со сторонним инструментом.

    Выбор этой опции приведёт к значительному увеличению объёма генерируемой трассировки —
    возможна опасность переполнений или меньшего покрытия инструкций. Обратите внимание, что эта опция также
    переопределяет любую настройку :ref:`ETM_MODE_RETURNSTACK <coresight-return-stack>`, поэтому там, где диапазон branch
    broadcast перекрывается с диапазоном return stack, return stack для этого диапазона будет недоступен.

.. _coresight-cycle-accurate:

**bit (5):**
    ETMv4_MODE_CYCACC

**description:**
    Установите для включения точной по циклам трассировки, если поддерживается [IDR0].


**bit (6):**
    ETMv4_MODE_CTXID

**description:**
    Установите для включения трассировки ID контекста, если поддерживается аппаратурой [IDR2].


**bit (7):**
    ETM_MODE_VMID

**description:**
    Установите для включения трассировки ID виртуальной машины, если поддерживается аппаратурой [IDR2].

.. _coresight-timestamp:

**bit (11):**
    ETMv4_MODE_TIMESTAMP

**description:**
    Установите для включения генерации меток времени, если поддерживается [IDR0].

.. _coresight-return-stack:

**bit (12):**
    ETM_MODE_RETURNSTACK
**description:**
    Установите для включения использования return stack трассировки, если поддерживается [IDR0].


**bit (13-14):**
    ETM_MODE_QELEM(val)

**description:**
    «val» определяет уровень поддержки Q-элементов, включаемой если
    реализована в ETM [IDR0]


**bit (19):**
    ETM_MODE_ATB_TRIGGER

**description:**
    Установите для включения бита ATBTRIGGER в управляющем регистре событий
    [EVENTCTLR1], если поддерживается [IDR5].


**bit (20):**
    ETM_MODE_LPOVERRIDE

**description:**
    Установите для включения бита LPOVERRIDE в управляющем регистре событий
    [EVENTCTLR1], если поддерживается [IDR5].


**bit (21):**
    ETM_MODE_ISTALL_EN

**description:**
    Установите для включения бита ISTALL в управляющем регистре stall
    [STALLCTLR]


**bit (23):**
    ETM_MODE_INSTPRIO

**description:**
	      Установите для включения бита INSTPRIORITY в управляющем регистре stall
	      [STALLCTLR], если поддерживается [IDR0].


**bit (24):**
    ETM_MODE_NOOVERFLOW

**description:**
    Установите для включения бита NOOVERFLOW в управляющем регистре stall
    [STALLCTLR], если поддерживается [IDR3].


**bit (25):**
    ETM_MODE_TRACE_RESET

**description:**
    Установите для включения бита TRCRESET в управляющем регистре viewinst
    [VICTLR], если поддерживается [IDR3].


**bit (26):**
    ETM_MODE_TRACE_ERR

**description:**
    Установите для включения бита TRCCTRL в управляющем регистре viewinst
    [VICTLR].


**bit (27):**
    ETM_MODE_VIEWINST_STARTSTOP

**description:**
    Установить начальное значение состояния логики start / stop ViewInst
    в управляющем регистре viewinst [VICTLR]


**bit (30):**
    ETM_MODE_EXCL_KERN

**description:**
    Задать настройку трассировки по умолчанию для исключения трассировки режима ядра (см. примечание a)


**bit (31):**
    ETM_MODE_EXCL_USER

**description:**
    Задать настройку трассировки по умолчанию для исключения трассировки пространства пользователя (см. примечание a)

----

*Примечание a)* При запуске ETM программируется на трассировку всего адресного
пространства с использованием компаратора диапазона адресов 0. Биты 30 / 31
параметра «mode» изменяют эту настройку, устанавливая биты исключения EL для
состояния NS либо в пространстве пользователя (EL0), либо в пространстве ядра
(EL1) в компараторе диапазона адресов. (настройка по умолчанию исключает все
безопасные EL и NS EL2)

После того как был использован параметр reset и/или было реализовано
пользовательское программирование — использование этих битов приведёт к тому,
что биты EL для компаратора адресов 0 будут установлены таким же образом.

*Примечание b)* Биты 2-3, 8-10, 15-16, 18, 22 управляют функциями, которые
работают только с трассировкой данных. Поскольку трассировка данных
A-profile архитектурно запрещена в ETMv4, они здесь опущены. Возможным
применением могло бы быть, когда ядро имеет поддержку управления
инфраструктурой профиля R или M в составе гетерогенной системы.

Биты 17, 28-29 не используются.
