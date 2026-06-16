============
Номера ioctl
============

19 October 1999

Michael Elizabeth Chastain
<mec@shout.net>

Если вы добавляете в ядро новые ioctl, следует использовать макросы _IO,
определённые в <linux/ioctl.h>:

    ====== ===========================
    macro  parameters
    ====== ===========================
    _IO    none
    _IOW   write (read from userspace)
    _IOR   read (write to userspace)
    _IOWR  write and read
    ====== ===========================

«Write» и «read» рассматриваются с точки зрения пользователя, точно так же, как
системные вызовы «write» и «read». Например, ioctl SET_FOO будет _IOW, хотя ядро
на самом деле читает данные из пространства пользователя; ioctl GET_FOO будет _IOR,
хотя ядро на самом деле записывает данные в пространство пользователя.

Первый аргумент макросов — это идентифицирующая буква или число из таблицы ниже.
Из-за большого числа драйверов многие драйверы разделяют часть диапазона одной буквы
с другими драйверами.

Если вы пишете драйвер для нового устройства и вам нужна буква, выберите
неиспользуемый блок с достаточным запасом для расширения: 32–256 команд ioctl
должно хватить. Зарегистрировать блок можно, пропатчив этот файл и отправив патч
через :doc:`обычный процесс отправки патчей
</process/submitting-patches>`.

Второй аргумент — это порядковый номер, отличающий ioctl друг от друга. Третий
аргумент (неприменим к _IO) — это тип данных, передаваемых в ядро или возвращаемых
из ядра (например, «int» или «struct foo»).

.. note::
   НЕ используйте sizeof(arg) в качестве третьего аргумента, поскольку из-за этого
   ваш ioctl будет считать, что он передаёт аргумент типа size_t.

Некоторые устройства используют свой старший номер (major) в качестве идентификатора;
это допустимо, пока он уникален. Некоторые устройства нерегулярны и вообще не следуют
никакому соглашению.

Следовать этому соглашению полезно потому, что:

(1) Сохранение глобальной уникальности ioctl помогает при проверке ошибок:
    если программа вызывает ioctl на неправильном устройстве, она получит
    ошибку, а не какое-то неожиданное поведение.

(2) Процедура сборки «strace» автоматически находит номера ioctl,
    определённые с помощью этих макросов.

(3) «strace» может декодировать номера обратно в осмысленные имена, когда
    номера уникальны.

(4) Тем, кто ищет ioctl, проще найти их через grep, когда
    для определения номеров ioctl используется это соглашение.

(5) При следовании соглашению код драйвера может использовать обобщённый
    код для копирования параметров между пространством пользователя и пространством ядра.

В этой таблице перечислены ioctl, видимые из пространства пользователя, за исключением
тех, что относятся к drivers/staging/.

====  =====  ========================================================= ================================================================
Code  Seq#    Include File                                             Comments
      (hex)
====  =====  ========================================================= ================================================================
0x00  00-1F  linux/fs.h                                                конфликт!
0x00  00-1F  scsi/scsi_ioctl.h                                         конфликт!
0x00  00-1F  linux/fb.h                                                конфликт!
0x00  00-1F  linux/wavefront.h                                         конфликт!
0x02  all    linux/fd.h
0x03  all    linux/hdreg.h
0x04  D2-DC  linux/umsdos_fs.h                                         Мертвы с 2.6.11, но не переиспользуйте их.
0x06  all    linux/lp.h
0x07  9F-D0  linux/vmw_vmci_defs.h, uapi/linux/vm_sockets.h
0x09  all    linux/raid/md_u.h
0x10  00-0F  drivers/char/s390/vmcp.h
0x10  10-1F  arch/s390/include/uapi/sclp_ctl.h
0x10  20-2F  arch/s390/include/uapi/asm/hypfs.h
0x12  all    linux/fs.h                                                ioctl BLK*
             linux/blkpg.h
             linux/blkzoned.h
             linux/blk-crypto.h
0x15  all    linux/fs.h                                                ioctl FS_IOC_*
0x1b  all                                                              Подсистема InfiniBand
                                                                       <http://infiniband.sourceforge.net/>
0x20  all    drivers/cdrom/cm206.h
0x22  all    scsi/sg.h
0x3E  00-0F  linux/counter.h                                           <mailto:linux-iio@vger.kernel.org>
'!'   00-1F  uapi/linux/seccomp.h
'#'   00-3F                                                            Подсистема IEEE 1394
                                                                       Блок для всей подсистемы
'$'   00-0F  linux/perf_counter.h, linux/perf_event.h
'%'   00-0F  include/uapi/linux/stm.h                                  Подсистема System Trace Module
                                                                       <mailto:alexander.shishkin@linux.intel.com>
'&'   00-07  drivers/firewire/nosy-user.h
'*'   00-1F  uapi/linux/user_events.h                                  Подсистема User Events
                                                                       <mailto:linux-trace-kernel@vger.kernel.org>
'1'   00-1F  linux/timepps.h                                           PPS kit от Ulrich Windl
                                                                       <ftp://ftp.de.kernel.org/pub/linux/daemons/ntp/PPS/>
'2'   01-04  linux/i2o.h
'3'   00-0F  drivers/s390/char/raw3270.h                               конфликт!
'3'   00-1F  linux/suspend_ioctls.h,                                   конфликт!
             kernel/power/user.c
'8'   all                                                              Продвинутая сетевая карта SNP8023
                                                                       <mailto:mcr@solidum.com>
';'   64-7F  linux/vfio.h
';'   80-FF  linux/iommufd.h
'='   00-3f  uapi/linux/ptp_clock.h                                    <mailto:richardcochran@gmail.com>
'@'   00-0F  linux/radeonfb.h                                          конфликт!
'@'   00-0F  drivers/video/aty/aty128fb.c                              конфликт!
'A'   00-1F  linux/apm_bios.h                                          конфликт!
'A'   00-0F  linux/agpgart.h,                                          конфликт!
             drivers/char/agp/compat_ioctl.h
'A'   00-7F  sound/asound.h                                            конфликт!
'B'   00-1F  linux/cciss_ioctl.h                                       конфликт!
'B'   00-0F  include/linux/pmu.h                                       конфликт!
'B'   C0-FF  advanced bbus                                             <mailto:maassen@uni-freiburg.de>
'B'   00-0F  xen/xenbus_dev.h                                          конфликт!
'C'   all    linux/soundcard.h                                         конфликт!
'C'   01-2F  linux/capi.h                                              конфликт!
'C'   F0-FF  drivers/net/wan/cosa.h                                    конфликт!
'D'   all    arch/s390/include/asm/dasd.h
'D'   40-5F  drivers/scsi/dpt/dtpi_ioctl.h                             Мёртв с 2022
'D'   05     drivers/scsi/pmcraid.h
'E'   all    linux/input.h                                             конфликт!
'E'   00-0F  xen/evtchn.h                                              конфликт!
'F'   all    linux/fb.h                                                конфликт!
'F'   01-02  drivers/scsi/pmcraid.h                                    конфликт!
'F'   20     drivers/video/fsl-diu-fb.h                                конфликт!
'F'   20     linux/ivtvfb.h                                            конфликт!
'F'   20     linux/matroxfb.h                                          конфликт!
'F'   20     drivers/video/aty/atyfb_base.c                            конфликт!
'F'   00-0F  video/da8xx-fb.h                                          конфликт!
'F'   80-8F  linux/arcfb.h                                             конфликт!
'F'   DD     video/sstfb.h                                             конфликт!
'G'   00-3F  drivers/misc/sgi-gru/grulib.h                             конфликт!
'G'   00-0F  xen/gntalloc.h, xen/gntdev.h                              конфликт!
'H'   00-7F  linux/hiddev.h                                            конфликт!
'H'   00-0F  linux/hidraw.h                                            конфликт!
'H'   01     linux/mei.h                                               конфликт!
'H'   02     linux/mei.h                                               конфликт!
'H'   03     linux/mei.h                                               конфликт!
'H'   00-0F  sound/asound.h                                            конфликт!
'H'   20-40  sound/asound_fm.h                                         конфликт!
'H'   80-8F  sound/sfnt_info.h                                         конфликт!
'H'   10-8F  sound/emu10k1.h                                           конфликт!
'H'   10-1F  sound/sb16_csp.h                                          конфликт!
'H'   10-1F  sound/hda_hwdep.h                                         конфликт!
'H'   40-4F  sound/hdspm.h                                             конфликт!
'H'   40-4F  sound/hdsp.h                                              конфликт!
'H'   90     sound/usb/usx2y/usb_stream.h
'H'   00-0F  uapi/misc/habanalabs.h                                    конфликт!
'H'   A0     uapi/linux/usb/cdc-wdm.h
'H'   C0-F0  net/bluetooth/hci.h                                       конфликт!
'H'   C0-DF  net/bluetooth/hidp/hidp.h                                 конфликт!
'H'   C0-DF  net/bluetooth/cmtp/cmtp.h                                 конфликт!
'H'   C0-DF  net/bluetooth/bnep/bnep.h                                 конфликт!
'H'   F1     linux/hid-roccat.h                                        <mailto:erazor_de@users.sourceforge.net>
'H'   F8-FA  sound/firewire.h
'I'   all    linux/isdn.h                                              конфликт!
'I'   00-0F  drivers/isdn/divert/isdn_divert.h                         конфликт!
'I'   40-4F  linux/mISDNif.h                                           конфликт!
'K'   all    linux/kd.h
'L'   00-1F  linux/loop.h                                              конфликт!
'L'   10-1F  drivers/scsi/mpt3sas/mpt3sas_ctl.h                        конфликт!
'L'   E0-FF  linux/ppdd.h                                              драйвер шифрованного дискового устройства
                                                                       <http://linux01.gwdg.de/~alatham/ppdd.html>
'M'   all    linux/soundcard.h                                         конфликт!
'M'   01-16  mtd/mtd-abi.h                                             конфликт!
      and    drivers/mtd/mtdchar.c
'M'   01-03  drivers/scsi/megaraid/megaraid_sas.h
'M'   00-0F  drivers/video/fsl-diu-fb.h                                конфликт!
'N'   00-1F  drivers/usb/scanner.h
'N'   40-7F  drivers/block/nvme.c
'N'   80-8F  uapi/linux/ntsync.h                                       Примитивы синхронизации NT
                                                                       <mailto:wine-devel@winehq.org>
'O'   00-06  mtd/ubi-user.h                                            UBI
'P'   all    linux/soundcard.h                                         конфликт!
'P'   60-6F  sound/sscape_ioctl.h                                      конфликт!
'P'   00-0F  drivers/usb/class/usblp.c                                 конфликт!
'P'   01-09  drivers/misc/pci_endpoint_test.c                          конфликт!
'P'   00-0F  xen/privcmd.h                                             конфликт!
'P'   00-05  linux/tps6594_pfsm.h                                      конфликт!
'Q'   all    linux/soundcard.h
'R'   00-1F  linux/random.h                                            конфликт!
'R'   01     linux/rfkill.h                                            конфликт!
'R'   20-2F  linux/trace_mmap.h
'R'   C0-DF  net/bluetooth/rfcomm.h
'R'   E0     uapi/linux/fsl_mc.h
'S'   all    linux/cdrom.h                                             конфликт!
'S'   80-81  scsi/scsi_ioctl.h                                         конфликт!
'S'   82-FF  scsi/scsi.h                                               конфликт!
'S'   00-7F  sound/asequencer.h                                        конфликт!
'T'   all    linux/soundcard.h                                         конфликт!
'T'   00-AF  sound/asound.h                                            конфликт!
'T'   all    arch/x86/include/asm/ioctls.h                             конфликт!
'T'   C0-DF  linux/if_tun.h                                            конфликт!
'U'   all    sound/asound.h                                            конфликт!
'U'   00-CF  linux/uinput.h                                            конфликт!
'U'   00-EF  linux/usbdevice_fs.h
'U'   C0-CF  drivers/bluetooth/hci_uart.h
'V'   all    linux/vt.h                                                конфликт!
'V'   all    linux/videodev2.h                                         конфликт!
'V'   C0     linux/ivtvfb.h                                            конфликт!
'V'   C0     linux/ivtv.h                                              конфликт!
'V'   C0     media/si4713.h                                            конфликт!
'W'   00-1F  linux/watchdog.h                                          конфликт!
'W'   00-1F  linux/wanrouter.h                                         конфликт! (до 3.9)
'W'   00-3F  sound/asound.h                                            конфликт!
'W'   40-5F  drivers/pci/switch/switchtec.c
'W'   60-61  linux/watch_queue.h
'X'   all    fs/xfs/xfs_fs.h,                                          конфликт!
             fs/xfs/linux-2.6/xfs_ioctl32.h,
             include/linux/falloc.h,
             linux/fs.h,
'X'   all    fs/ocfs2/ocfs_fs.h                                        конфликт!
'Z'   14-15  drivers/message/fusion/mptctl.h
'['   00-3F  linux/usb/tmc.h                                           USB-устройства для тестирования и измерений
                                                                       <mailto:gregkh@linuxfoundation.org>
'a'   all    linux/atm*.h, linux/sonet.h                               ATM в linux
                                                                       <http://lrcwww.epfl.ch/>
'a'   00-0F  drivers/crypto/qat/qat_common/adf_cfg_common.h            конфликт! драйвер qat
'b'   00-FF                                                            конфликт! мост bit3 vme host bridge
                                                                       <mailto:natalia@nikhefk.nikhef.nl>
'b'   00-0F  linux/dma-buf.h                                           конфликт!
'c'   00-7F  linux/comstats.h                                          конфликт!
'c'   00-7F  linux/coda.h                                              конфликт!
'c'   00-1F  linux/chio.h                                              конфликт!
'c'   80-9F  arch/s390/include/asm/chsc.h                              конфликт!
'c'   A0-AF  arch/x86/include/asm/msr.h конфликт!
'd'   00-FF  linux/char/drm/drm.h                                      конфликт!
'd'   02-40  pcmcia/ds.h                                               конфликт!
'd'   F0-FF  linux/digi1.h
'e'   all    linux/digi1.h                                             конфликт!
'f'   00-1F  linux/ext2_fs.h                                           конфликт!
'f'   00-1F  linux/ext3_fs.h                                           конфликт!
'f'   00-0F  fs/jfs/jfs_dinode.h                                       конфликт!
'f'   00-0F  fs/ext4/ext4.h                                            конфликт!
'f'   00-0F  linux/fs.h                                                конфликт!
'f'   00-0F  fs/ocfs2/ocfs2_fs.h                                       конфликт!
'f'   13-27  linux/fscrypt.h
'f'   81-8F  linux/fsverity.h
'g'   00-0F  linux/usb/gadgetfs.h
'g'   20-2F  linux/usb/g_printer.h
'h'   00-7F                                                            конфликт! файловая система Charon
                                                                       <mailto:zapman@interlan.net>
'h'   00-1F  linux/hpet.h                                              конфликт!
'h'   80-8F  fs/hfsplus/ioctl.c
'i'   00-3F  linux/i2o-dev.h                                           конфликт!
'i'   0B-1F  linux/ipmi.h                                              конфликт!
'i'   80-8F  linux/i8k.h
'i'   90-9F  `linux/iio/*.h`                                           IIO
'j'   00-3F  linux/joystick.h
'k'   00-0F  linux/spi/spidev.h                                        конфликт!
'k'   00-05  video/kyro.h                                              конфликт!
'k'   10-17  linux/hsi/hsi_char.h                                      символьное устройство HSI
'l'   00-3F  linux/tcfs_fs.h                                           прозрачная криптографическая файловая система
                                                                       <http://web.archive.org/web/%2A/http://mikonos.dia.unisa.it/tcfs>
'l'   40-7F  linux/udf_fs_i.h                                          в разработке:
                                                                       <https://github.com/pali/udftools>
'm'   00-09  linux/mmtimer.h                                           конфликт!
'm'   all    linux/mtio.h                                              конфликт!
'm'   all    linux/soundcard.h                                         конфликт!
'm'   all    linux/synclink.h                                          конфликт!
'm'   00-19  drivers/message/fusion/mptctl.h                           конфликт!
'm'   00     drivers/scsi/megaraid/megaraid_ioctl.h                    конфликт!
'n'   00-7F  linux/ncp_fs.h and fs/ncpfs/ioctl.c
'n'   80-8F  uapi/linux/nilfs2_api.h                                   NILFS2
'n'   E0-FF  linux/matroxfb.h                                          matroxfb
'o'   00-1F  fs/ocfs2/ocfs2_fs.h                                       OCFS2
'o'   00-03  mtd/ubi-user.h                                            конфликт! (перекрытие OCFS2 и UBI)
'o'   40-41  mtd/ubi-user.h                                            UBI
'o'   01-A1  `linux/dvb/*.h`                                           DVB
'p'   00-0F  linux/phantom.h                                           конфликт! (это нужно OpenHaptics)
'p'   00-1F  linux/rtc.h                                               конфликт!
'p'   40-7F  linux/nvram.h
'p'   80-9F  linux/ppdev.h                                             parport из пространства пользователя
                                                                       <mailto:tim@cyberelk.net>
'p'   A1-A5  linux/pps.h                                               LinuxPPS
'p'   B1-B3  linux/pps_gen.h                                           LinuxPPS
                                                                       <mailto:giometti@linux.it>
'q'   00-1F  linux/serio.h
'q'   80-FF  linux/telephony.h                                         Internet PhoneJACK, Internet LineJACK
             linux/ixjuser.h                                           <http://web.archive.org/web/%2A/http://www.quicknet.net>
'r'   00-1F  linux/msdos_fs.h and fs/fat/dir.c
's'   all    linux/cdk.h
't'   00-7F  linux/ppp-ioctl.h
't'   80-8F  linux/isdn_ppp.h
't'   90-91  linux/toshiba.h                                           SMM для toshiba и toshiba_acpi
'u'   00-1F  linux/smb_fs.h                                            удалено
'u'   00-2F  linux/ublk_cmd.h                                          конфликт!
'u'   20-3F  linux/uvcvideo.h                                          хост-драйвер класса USB video
'u'   40-4f  linux/udmabuf.h                                           вспомогательное устройство dma-buf в пространстве пользователя
'v'   00-1F  linux/ext2_fs.h                                           конфликт!
'v'   00-1F  linux/fs.h                                                конфликт!
'v'   00-0F  linux/sonypi.h                                            конфликт!
'v'   00-0F  media/v4l2-subdev.h                                       конфликт!
'v'   20-27  arch/powerpc/include/uapi/asm/vas-api.h                   VAS API
'v'   C0-FF  linux/meye.h                                              конфликт!
'w'   all                                                              драйвер CERN SCI
'y'   00-1F                                                            пакетные коммуникации на уровне пользователя
                                                                       <mailto:zapman@interlan.net>
'z'   00-3F                                                            плата шины CAN, конфликт!
                                                                       <mailto:hdstich@connectu.ulm.circular.de>
'z'   40-7F                                                            плата шины CAN, конфликт!
                                                                       <mailto:oe@port.de>
'z'   10-4F  drivers/s390/crypto/zcrypt_api.h                          конфликт!
'|'   00-7F  linux/media.h
'|'   80-9F  samples/                                                  Любые образцовые и демонстрационные драйверы
0x80  00-1F  linux/fb.h
0x81  00-1F  linux/vduse.h
0x89  00-06  arch/x86/include/asm/sockios.h
0x89  0B-DF  linux/sockios.h
0x89  E0-EF  linux/sockios.h                                           диапазон SIOCPROTOPRIVATE
0x89  F0-FF  linux/sockios.h                                           диапазон SIOCDEVPRIVATE
0x8A  00-1F  linux/eventpoll.h
0x8B  all    linux/wireless.h
0x8C  00-3F                                                            драйвер WiNRADiO
                                                                       <http://www.winradio.com.au/>
0x90  00     drivers/cdrom/sbpcd.h
0x92  00-0F  drivers/usb/mon/mon_bin.c
0x93  60-7F  linux/auto_fs.h
0x94  all    fs/btrfs/ioctl.h                                          файловая система Btrfs
             and linux/fs.h                                            часть вынесена в vfs/generic
0x97  00-7F  fs/ceph/ioctl.h                                           файловая система Ceph
0x99  00-0F                                                            драйвер 537-Addinboard
                                                                       <mailto:buk@buks.ipn.de>
0x9A  00-0F  include/uapi/fwctl/fwctl.h
0xA0  all    linux/sdp/sdp.h                                           Industrial Device Project
                                                                       <mailto:kenji@bitgate.com>
0xA1  0      linux/vtpm_proxy.h                                        Драйвер TPM Emulator Proxy
0xA2  all    uapi/linux/acrn.h                                         гипервизор ACRN
0xA3  80-8F                                                            Port ACL, в разработке:
                                                                       <mailto:tlewis@mindspring.com>
0xA3  90-9F  linux/dtlk.h
0xA4  00-1F  uapi/linux/tee.h                                          Обобщённая подсистема TEE
0xA4  00-1F  uapi/asm/sgx.h                                            <mailto:linux-sgx@vger.kernel.org>
0xA5  01-05  linux/surface_aggregator/cdev.h                           Microsoft Surface Platform System Aggregator
                                                                       <mailto:luzmaximilian@gmail.com>
0xA5  20-2F  linux/surface_aggregator/dtx.h                            Драйвер Microsoft Surface DTX
                                                                       <mailto:luzmaximilian@gmail.com>
0xAA  00-3F  linux/uapi/linux/userfaultfd.h
0xAB  00-1F  linux/nbd.h
0xAC  00-1F  linux/raw.h
0xAD  00                                                               Устройство Netfilter, в разработке:
                                                                       <mailto:rusty@rustcorp.com.au>
0xAE  00-1F  linux/kvm.h                                               Виртуальная машина на основе ядра (KVM)
                                                                       <mailto:kvm@vger.kernel.org>
0xAE  40-FF  linux/kvm.h                                               Виртуальная машина на основе ядра (KVM)
                                                                       <mailto:kvm@vger.kernel.org>
0xAE  20-3F  linux/nitro_enclaves.h                                    Nitro Enclaves
0xAF  00-1F  linux/fsl_hypervisor.h                                    гипервизор Freescale
0xB0  all                                                              устройства RATIO, в разработке:
                                                                       <mailto:vgo@ratio.de>
0xB1  00-1F                                                            PPPoX
                                                                       <mailto:mostrows@styx.uwaterloo.ca>
0xB2  00     arch/powerpc/include/uapi/asm/papr-vpd.h                  powerpc/pseries VPD API
                                                                       <mailto:linuxppc-dev@lists.ozlabs.org>
0xB2  01-02  arch/powerpc/include/uapi/asm/papr-sysparm.h              powerpc/pseries system parameter API
                                                                       <mailto:linuxppc-dev@lists.ozlabs.org>
0xB2  03-05  arch/powerpc/include/uapi/asm/papr-indices.h              powerpc/pseries indices API
                                                                       <mailto:linuxppc-dev@lists.ozlabs.org>
0xB2  06-07  arch/powerpc/include/uapi/asm/papr-platform-dump.h        powerpc/pseries Platform Dump API
                                                                       <mailto:linuxppc-dev@lists.ozlabs.org>
0xB2  08     arch/powerpc/include/uapi/asm/papr-physical-attestation.h powerpc/pseries Physical Attestation API
                                                                       <mailto:linuxppc-dev@lists.ozlabs.org>
0xB2  09     arch/powerpc/include/uapi/asm/papr-hvpipe.h               powerpc/pseries HVPIPE API
                                                                       <mailto:linuxppc-dev@lists.ozlabs.org>
0xB3  00     linux/mmc/ioctl.h
0xB4  00-0F  linux/gpio.h                                              <mailto:linux-gpio@vger.kernel.org>
0xB5  00-0F  uapi/linux/rpmsg.h                                        <mailto:linux-remoteproc@vger.kernel.org>
0xB6  all    linux/fpga-dfl.h
0xB7  all    uapi/linux/remoteproc_cdev.h                              <mailto:linux-remoteproc@vger.kernel.org>
0xB7  all    uapi/linux/nsfs.h                                         <mailto:Andrei Vagin <avagin@openvz.org>>
0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                                Драйвер Marvell CN10K DPI
0xB8  all    uapi/linux/mshv.h                                         Драйвер Microsoft Hyper-V /dev/mshv
                                                                       <mailto:linux-hyperv@vger.kernel.org>
0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
                                                                       <mailto:pasha.tatashin@soleen.com>
0xC0  00-0F  linux/usb/iowarrior.h
0xCA  00-0F  uapi/misc/cxl.h                                           Мертвы с 6.15
0xCA  10-2F  uapi/misc/ocxl.h
0xCA  80-BF  uapi/scsi/cxlflash_ioctl.h                                Мертвы с 6.15
0xCB  00-1F                                                            последовательная шина CBM serial IEC, в разработке:
                                                                       <mailto:michael.klein@puffin.lb.shuttle.de>
0xCC  00-0F  drivers/misc/ibmvmc.h                                     драйвер pseries VMC
0xCD  01     linux/reiserfs_fs.h                                       Мёртв с 6.13
0xCE  01-02  uapi/linux/cxl_mem.h                                      устройства памяти Compute Express Link
0xCF  02     fs/smb/client/cifs_ioctl.h
0xDD  00-3F                                                            драйвер устройства ZFCP, см. drivers/s390/scsi/
                                                                       <mailto:aherrman@de.ibm.com>
0xE5  00-3F  linux/fuse.h
0xEC  00-01  drivers/platform/chrome/cros_ec_dev.h                     драйвер ChromeOS EC
0xEE  00-09  uapi/linux/pfrut.h                                        Platform Firmware Runtime Update and Telemetry
0xF3  00-3F  drivers/usb/misc/sisusbvga/sisusb.h                       sisfb (в разработке)
                                                                       <mailto:thomas@winischhofer.net>
0xF6  all                                                              LTTng Linux Trace Toolkit Next Generation
                                                                       <mailto:mathieu.desnoyers@efficios.com>
0xF8  all    arch/x86/include/uapi/asm/amd_hsmp.h                      Драйвер интерфейса управления системой AMD HSMP EPYC
                                                                       <mailto:nchatrad@amd.com>
0xF9  00-0F  uapi/misc/amd-apml.h                                      Драйвер интерфейса бокового управления системой AMD
                                                                       <mailto:naveenkrishna.chatradhi@amd.com>
0xFD  all    linux/dm-ioctl.h
0xFE  all    linux/isst_if.h
====  =====  ========================================================= ================================================================
