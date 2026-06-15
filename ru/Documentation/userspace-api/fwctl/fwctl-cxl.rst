.. SPDX-License-Identifier: GPL-2.0

=================
Драйвер fwctl cxl
=================

:Author: Dave Jiang

Обзор
=====

Спецификация CXL определяет набор команд, которые могут быть выданы в почтовый
ящик (mailbox) устройства или коммутатора CXL. Также в ней оставлено место для
выдачи в почтовый ящик команд, специфичных для конкретного производителя
(vendor specific). fwctl предоставляет путь для выдачи набора разрешённых команд
почтового ящика из пространства пользователя устройству под контролем драйвера
ядра.

Следующие 3 команды будут использоваться для поддержки CXL Features:
CXL spec r3.1 8.2.9.6.1 Get Supported Features (Opcode 0500h)
CXL spec r3.1 8.2.9.6.2 Get Feature (Opcode 0501h)
CXL spec r3.1 8.2.9.6.3 Set Feature (Opcode 0502h)

Возвращаемые данные «Get Supported Features» могут быть отфильтрованы драйвером
ядра, чтобы отбросить любые функции (features), которые запрещены ядром или
используются ядром эксклюзивно. Драйвер установит «Set Feature Size» в «Get
Supported Features Supported Feature Entry» в 0, чтобы указать, что функцию
нельзя изменять. Команда «Get Supported Features» и «Get Features» подпадают под
политику fwctl FWCTL_RPC_CONFIGURATION.

Для команды «Set Feature» политика доступа в настоящее время делится на две
категории в зависимости от эффектов Set Feature, о которых сообщает устройство.
Если Set Feature приведёт к немедленному изменению устройства, политика доступа
fwctl должна быть FWCTL_RPC_DEBUG_WRITE_FULL. Эффекты для этого уровня — это
«immediate config change», «immediate data change», «immediate policy change»
или «immediate log change» в маске set effects. Если же эффекты — это «config
change with cold reset» или «config change with conventional reset», то политика
доступа fwctl должна быть FWCTL_RPC_DEBUG_WRITE или выше.

Пользовательский API fwctl cxl
==============================

.. kernel-doc:: include/uapi/fwctl/cxl.h

1. Запрос информации о драйвере
-------------------------------

Первый шаг для приложения — выдать ioctl(FWCTL_CMD_INFO). Успешный вызов этого
ioctl означает, что возможность Features работоспособна, и возвращает полностью
нулевую 32-битную полезную нагрузку. Необходимо заполнить ``struct fwctl_info``,
установив ``fwctl_info.out_device_type`` в ``FWCTL_DEVICE_TYPE_CXL``.
Возвращаемые данные должны быть ``struct fwctl_info_cxl``, который содержит
зарезервированное 32-битное поле, которое должно быть полностью нулевым.

2. Отправка аппаратных команд
-----------------------------

Следующий шаг — отправить драйверу команду «Get Supported Features» из
пространства пользователя через ioctl(FWCTL_RPC). На ``struct fwctl_rpc_cxl``
указывает ``fwctl_rpc.in``. ``struct fwctl_rpc_cxl.in_payload`` указывает на
входную аппаратную структуру, которая определена спецификацией CXL.
``fwctl_rpc.out`` указывает на буфер, содержащий ``struct fwctl_rpc_cxl_out``,
который включает в себя выходные аппаратные данные, встроенные как
``fwctl_rpc_cxl_out.payload``. Эта команда вызывается дважды. Первый раз — для
получения количества поддерживаемых функций. Второй раз — для получения
конкретных сведений о функции в качестве выходных данных.

После получения конкретных сведений о функции можно соответствующим образом
сформировать и отправить команду Get/Set Feature. Для команды «Set Feature»
полученная информация о функции содержит поле effects, которое подробно
описывает, что будет инициировать результирующая команда «Set Feature». Это
сообщит пользователю, настроена ли система на разрешение команды «Set Feature»
или нет.

Пример кода для Get Feature
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: c

        static int cxl_fwctl_rpc_get_test_feature(int fd, struct test_feature *feat_ctx,
                                                  const uint32_t expected_data)
        {
                struct cxl_mbox_get_feat_in *feat_in;
                struct fwctl_rpc_cxl_out *out;
                struct fwctl_rpc rpc = {0};
                struct fwctl_rpc_cxl *in;
                size_t out_size, in_size;
                uint32_t val;
                void *data;
                int rc;

                in_size = sizeof(*in) + sizeof(*feat_in);
                rc = posix_memalign((void **)&in, 16, in_size);
                if (rc)
                        return -ENOMEM;
                memset(in, 0, in_size);
                feat_in = &in->get_feat_in;

                uuid_copy(feat_in->uuid, feat_ctx->uuid);
                feat_in->count = feat_ctx->get_size;

                out_size = sizeof(*out) + feat_ctx->get_size;
                rc = posix_memalign((void **)&out, 16, out_size);
                if (rc)
                        goto free_in;
                memset(out, 0, out_size);

                in->opcode = CXL_MBOX_OPCODE_GET_FEATURE;
                in->op_size = sizeof(*feat_in);

                rpc.size = sizeof(rpc);
                rpc.scope = FWCTL_RPC_CONFIGURATION;
                rpc.in_len = in_size;
                rpc.out_len = out_size;
                rpc.in = (uint64_t)(uint64_t *)in;
                rpc.out = (uint64_t)(uint64_t *)out;

                rc = send_command(fd, &rpc, out);
                if (rc)
                        goto free_all;

                data = out->payload;
                val = le32toh(*(__le32 *)data);
                if (memcmp(&val, &expected_data, sizeof(val)) != 0) {
                        rc = -ENXIO;
                        goto free_all;
                }

        free_all:
                free(out);
        free_in:
                free(in);
                return rc;
        }

Подробный пользовательский код с примерами того, как задействовать этот путь,
смотрите в каталоге тестов CXL CLI
<https://github.com/pmem/ndctl/tree/main/test/fwctl.c>.


API ядра для fwctl cxl
======================

.. kernel-doc:: drivers/cxl/core/features.c
   :export:
.. kernel-doc:: include/cxl/features.h
