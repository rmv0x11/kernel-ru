.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later

.. c:type:: dvb_frontend_parameters

***********************
параметры фронтенда
***********************

Тип параметров, передаваемых устройству фронтенда для настройки, зависит
от того, какое оборудование вы используете.

Структура ``dvb_frontend_parameters`` использует объединение (union) с
параметрами, специфичными для конкретной системы. Однако, поскольку более
новым системам доставки требовалось больше данных, размера структуры стало
недостаточно, а простое увеличение её размера сломало бы существующие
приложения. Поэтому эти параметры были заменены использованием
ioctl'ов :ref:`FE_GET_PROPERTY/FE_SET_PROPERTY <FE_GET_PROPERTY>`.
Новый API достаточно гибок, чтобы добавлять новые параметры к существующим
системам доставки, а также добавлять новые системы доставки.

Поэтому более новым приложениям следует использовать вместо этого
:ref:`FE_GET_PROPERTY/FE_SET_PROPERTY <FE_GET_PROPERTY>`,
чтобы иметь возможность поддерживать более новые системы доставки, такие как
DVB-S2, DVB-T2, DVB-C2, ISDB и т. д.

Все виды параметров объединены в виде union в структуре
``dvb_frontend_parameters``:


.. code-block:: c

    struct dvb_frontend_parameters {
	uint32_t frequency;     /* (absolute) frequency in Hz for QAM/OFDM */
		    /* intermediate frequency in kHz for QPSK */
	fe_spectral_inversion_t inversion;
	union {
	    struct dvb_qpsk_parameters qpsk;
	    struct dvb_qam_parameters  qam;
	    struct dvb_ofdm_parameters ofdm;
	    struct dvb_vsb_parameters  vsb;
	} u;
    };

В случае фронтендов QPSK поле ``frequency`` задаёт промежуточную частоту,
то есть смещение, которое фактически добавляется к частоте местного
гетеродина (LOF) у LNB. Промежуточная частота должна задаваться в единицах
кГц. Для фронтендов QAM и OFDM поле ``frequency`` задаёт абсолютную частоту
и указывается в Гц.


.. c:type:: dvb_qpsk_parameters

Параметры QPSK
==============

Для спутниковых фронтендов QPSK необходимо использовать структуру
``dvb_qpsk_parameters``:


.. code-block:: c

     struct dvb_qpsk_parameters {
	 uint32_t        symbol_rate;  /* symbol rate in Symbols per second */
	 fe_code_rate_t  fec_inner;    /* forward error correction (see above) */
     };


.. c:type:: dvb_qam_parameters

Параметры QAM
=============

для кабельного фронтенда QAM используется структура ``dvb_qam_parameters``:


.. code-block:: c

     struct dvb_qam_parameters {
	 uint32_t         symbol_rate; /* symbol rate in Symbols per second */
	 fe_code_rate_t   fec_inner;   /* forward error correction (see above) */
	 fe_modulation_t  modulation;  /* modulation type (see above) */
     };


.. c:type:: dvb_vsb_parameters

Параметры VSB
=============

Фронтенды ATSC поддерживаются структурой ``dvb_vsb_parameters``:


.. code-block:: c

    struct dvb_vsb_parameters {
	fe_modulation_t modulation; /* modulation type (see above) */
    };


.. c:type:: dvb_ofdm_parameters

Параметры OFDM
==============

Фронтенды DVB-T поддерживаются структурой ``dvb_ofdm_parameters``:


.. code-block:: c

     struct dvb_ofdm_parameters {
	 fe_bandwidth_t      bandwidth;
	 fe_code_rate_t      code_rate_HP;  /* high priority stream code rate */
	 fe_code_rate_t      code_rate_LP;  /* low priority stream code rate */
	 fe_modulation_t     constellation; /* modulation type (see above) */
	 fe_transmit_mode_t  transmission_mode;
	 fe_guard_interval_t guard_interval;
	 fe_hierarchy_t      hierarchy_information;
     };
