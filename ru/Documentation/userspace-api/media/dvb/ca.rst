.. SPDX-License-Identifier: GFDL-1.1-no-invariants-or-later

.. _dvb_ca:

#######################################
Устройство CA цифрового телевидения
#######################################

Устройство CA цифрового телевидения управляет аппаратурой условного доступа
(conditional access). Доступ к нему осуществляется через
``/dev/dvb/adapter?/ca?``. Типы данных и определения ioctl доступны при
включении ``linux/dvb/ca.h`` в вашем приложении.

.. note::

   В этом API есть три ioctl, которые не документированы:
   :ref:`CA_GET_MSG`, :ref:`CA_SEND_MSG` и :ref:`CA_SET_DESCR`.
   Документация по ним приветствуется.

.. toctree::
    :maxdepth: 1

    ca_data_types
    ca_function_calls
    ca_high_level
