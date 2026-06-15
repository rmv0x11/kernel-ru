.. SPDX-License-Identifier: GPL-2.0

==================================================================================
Блок мониторинга производительности (PMU) пропускной способности DDR в SoC Amlogic
==================================================================================

SoC Amlogic Meson G12 содержит монитор пропускной способности внутри контроллера
DRAM. Монитор включает 4 канала. Каждый канал может подсчитывать запросы,
обращающиеся к DRAM. Канал может подсчитывать одновременно до 3 портов AXI. Это
может быть полезно, чтобы показать, является ли узким местом производительности
пропускная способность DDR.

В настоящее время этот драйвер поддерживает следующие 5 событий perf:

+ meson_ddr_bw/total_rw_bytes/
+ meson_ddr_bw/chan_1_rw_bytes/
+ meson_ddr_bw/chan_2_rw_bytes/
+ meson_ddr_bw/chan_3_rw_bytes/
+ meson_ddr_bw/chan_4_rw_bytes/

События meson_ddr_bw/chan_{1,2,3,4}_rw_bytes/ — это события, специфичные для
конкретного канала. Каждый канал поддерживает фильтрацию, которая позволяет каналу
отслеживать отдельный IP-модуль в SoC.

Ниже приведены ключевые слова фильтра событий запросов доступа к DDR:

+ arm             - от CPU
+ vpu_read1       - от чтения OSD + VPP
+ gpu             - от 3D GPU
+ pcie            - от контроллера PCIe
+ hdcp            - от контроллера HDCP
+ hevc_front      - от входной части кодека HEVC
+ usb3_0          - от контроллера USB3.0
+ hevc_back       - от выходной части кодека HEVC
+ h265enc         - от кодировщика HEVC
+ vpu_read2       - от чтения DI
+ vpu_write1      - от записи VDIN
+ vpu_write2      - от записи di
+ vdec            - от устаревшего видеодекодера-кодека
+ hcodec          - от кодировщика H264
+ ge2d            - от ge2d
+ spicc1          - от контроллера SPI 1
+ usb0            - от контроллера USB2.0 0
+ dma             - от системного контроллера DMA 1
+ arb0            - от arb0
+ sd_emmc_b       - от контроллера SD eMMC b
+ usb1            - от контроллера USB2.0 1
+ audio           - от модуля Audio
+ sd_emmc_c       - от контроллера SD eMMC c
+ spicc2          - от контроллера SPI 2
+ ethernet        - от контроллера Ethernet


Примеры:

  + Показать суммарную пропускную способность DDR в секунду:

    .. code-block:: bash

       perf stat -a -e meson_ddr_bw/total_rw_bytes/ -I 1000 sleep 10


  + Показать отдельные пропускные способности DDR от CPU и GPU соответственно, а также
    их сумму:

    .. code-block:: bash

       perf stat -a -e meson_ddr_bw/chan_1_rw_bytes,arm=1/ -I 1000 sleep 10
       perf stat -a -e meson_ddr_bw/chan_2_rw_bytes,gpu=1/ -I 1000 sleep 10
       perf stat -a -e meson_ddr_bw/chan_3_rw_bytes,arm=1,gpu=1/ -I 1000 sleep 10
