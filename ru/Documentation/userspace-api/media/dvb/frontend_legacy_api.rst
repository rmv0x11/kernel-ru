.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later

.. _frontend_legacy_types:

Устаревшие типы данных Frontend
===============================


.. toctree::
    :maxdepth: 1

    fe-type-t
    fe-bandwidth-t
    dvb-frontend-parameters
    dvb-frontend-event


.. _frontend_legacy_fcalls:

Устаревшие вызовы функций Frontend
==================================

Эти функции определены в версии 3 DVB. Их поддержка сохраняется в ядре
исключительно из соображений совместимости. Их использование настоятельно
не рекомендуется


.. toctree::
    :maxdepth: 1

    fe-read-ber
    fe-read-snr
    fe-read-signal-strength
    fe-read-uncorrected-blocks
    fe-set-frontend
    fe-get-frontend
    fe-get-event
    fe-dishnetwork-send-legacy-cmd
