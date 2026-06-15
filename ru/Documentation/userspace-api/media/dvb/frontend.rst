.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later

.. _dvb_frontend:

#########################################################
API фронтенда цифрового телевидения (Digital TV Frontend)
#########################################################

API фронтенда цифрового телевидения была разработана для
поддержки трёх групп систем доставки: наземных (Terrestrial), кабельных (cable) и
спутниковых (Satellite). На данный момент поддерживаются следующие системы доставки:

-  Наземные системы: DVB-T, DVB-T2, ATSC, ATSC M/H, ISDB-T, DVB-H,
   DTMB, CMMB

-  Кабельные системы: DVB-C Annex A/C, ClearQAM (DVB-C Annex B)

-  Спутниковые системы: DVB-S, DVB-S2, DVB Turbo, ISDB-S, DSS

Фронтенд цифрового телевидения управляет несколькими подустройствами, в том числе:

-  Тюнером (Tuner)

-  Демодулятором цифрового телевидения

-  Малошумящим усилителем (LNA)

-  Управлением спутниковым оборудованием (Satellite Equipment Control, SEC) [#f1]_.

Доступ к фронтенду осуществляется через ``/dev/dvb/adapter?/frontend?``.
Доступ к определениям типов данных и ioctl можно получить, включив в ваше приложение
``linux/dvb/frontend.h``.

.. note::

   Передача через интернет (DVB-IP) и MMT (MPEG Media Transport)
   пока не обрабатывается этим API, но в будущем возможно соответствующее расширение.

.. [#f1]

   В спутниковых системах поддержка управления спутниковым оборудованием
   (Satellite Equipment Control, SEC) в API позволяет управлять питанием и
   передавать/принимать сигналы для управления подсистемой антенны, выбирая
   поляризацию и выбирая промежуточную частоту (Intermediate Frequency, IF)
   облучателя малошумящего блока-конвертера (Low Noise Block Converter Feed
   Horn, LNBf). Поддерживаются протоколы DiSEqC и V-SEC. Спецификация DiSEqC
   (digital SEC) доступна на сайте
   `Eutelsat <http://www.eutelsat.com/satellites/4_5_5.html>`__.


.. toctree::
    :maxdepth: 1

    query-dvb-frontend-info
    dvb-fe-read-status
    dvbproperty
    frontend_fcalls
