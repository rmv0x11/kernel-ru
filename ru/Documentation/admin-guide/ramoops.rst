Ramoops — логгер oops/panic
===========================

Sergiu Iordache <sergiu@chromium.org>

Обновлено: 10 февраля 2021

Введение
--------

Ramoops — это логгер oops/panic, который записывает свои логи в RAM до того, как
система аварийно завершит работу. Он работает, записывая oops'ы и panic'и в
кольцевой буфер. Ramoops требует системы с постоянной (persistent) RAM, чтобы
содержимое этой области могло сохраниться после перезапуска.

Концепции Ramoops
-----------------

Ramoops использует заранее заданную область памяти для хранения дампа. Начало,
размер и тип этой области памяти задаются с помощью трёх переменных:

  * ``mem_address`` — для начала.
  * ``mem_size`` — для размера. Размер памяти будет округлён вниз до степени двойки.
  * ``mem_type`` — чтобы указать тип памяти (по умолчанию pgprot_writecombine).
  * ``mem_name`` — чтобы указать область памяти, определённую параметром командной
    строки ``reserve_mem``.

Обычно следует использовать значение по умолчанию ``mem_type=0``, поскольку оно
устанавливает отображение pstore в pgprot_writecombine. Установка ``mem_type=1``
приводит к попытке использовать ``pgprot_noncached``, что работает лишь на
некоторых платформах. Это связано с тем, что pstore зависит от атомарных
операций. По крайней мере на ARM, pgprot_noncached приводит к тому, что память
отображается как strongly ordered, а атомарные операции над strongly ordered
памятью определяются реализацией и не будут работать на многих ARM, таких как
omap'ы. Установка ``mem_type=2`` приводит к попытке трактовать область памяти как
обычную память, что включает для неё полное кэширование. Это может улучшить
производительность.

Область памяти делится на фрагменты размера ``record_size`` (также округлённого
вниз до степени двойки), и каждый дамп kmesg записывает фрагмент информации
размера ``record_size``.

Ограничение того, какие виды дампов kmsg сохраняются, можно контролировать через
значение ``max_reason``, как определено в ``enum kmsg_dump_reason`` из
include/linux/kmsg_dump.h. Например, чтобы сохранять и Oops'ы, и Panic'и,
``max_reason`` следует установить в 2 (KMSG_DUMP_OOPS); чтобы сохранять только
Panic'и, ``max_reason`` следует установить в 1 (KMSG_DUMP_PANIC). Установка этого
значения в 0 (KMSG_DUMP_UNDEF) означает, что фильтрация по причине будет
контролироваться загрузочным параметром ``printk.always_kmsg_dump``: если он не
задан, это будет KMSG_DUMP_OOPS, иначе — KMSG_DUMP_MAX.

Модуль использует счётчик для записи нескольких дампов, но счётчик сбрасывается
при перезапуске (т. е. новые дампы после перезапуска будут перезаписывать
старые).

Ramoops также поддерживает программную ECC-защиту областей постоянной памяти.
Это может быть полезно, когда для возвращения машины к жизни использовался
аппаратный сброс (т. е. сработал watchdog). В таких случаях RAM может быть в
некоторой степени повреждена, но обычно она восстановима.

Установка параметров
--------------------

Установку параметров ramoops можно выполнить несколькими различными способами:

 A. Использовать параметры модуля (которые имеют имена переменных, описанных
 ранее). Для быстрой отладки вы также можете зарезервировать части памяти во
 время загрузки и затем использовать зарезервированную память для ramoops.
 Например, предполагая машину с > 128 МБ памяти, следующая командная строка ядра
 укажет ядру использовать только первые 128 МБ памяти и разместить
 ECC-защищённую область ramoops на границе 128 МБ::

	mem=128M ramoops.mem_address=0x8000000 ramoops.ecc=1

 B. Использовать привязки (binding) Device Tree, как описано в
 ``Documentation/devicetree/bindings/reserved-memory/ramoops.yaml``.
 Например::

	reserved-memory {
		#address-cells = <2>;
		#size-cells = <2>;
		ranges;

		ramoops@8f000000 {
			compatible = "ramoops";
			reg = <0 0x8f000000 0 0x100000>;
			record-size = <0x4000>;
			console-size = <0x4000>;
		};
	};

 C. Использовать платформенное устройство и задать платформенные данные. Затем
 параметры можно установить через эти платформенные данные. Пример того, как это
 сделать:

 .. code-block:: c

  #include <linux/pstore_ram.h>
  [...]

  static struct ramoops_platform_data ramoops_data = {
        .mem_size               = <...>,
        .mem_address            = <...>,
        .mem_type               = <...>,
        .record_size            = <...>,
        .max_reason             = <...>,
        .ecc                    = <...>,
  };

  static struct platform_device ramoops_dev = {
        .name = "ramoops",
        .dev = {
                .platform_data = &ramoops_data,
        },
  };

  [... inside a function ...]
  int ret;

  ret = platform_device_register(&ramoops_dev);
  if (ret) {
	printk(KERN_ERR "unable to register platform device\n");
	return ret;
  }

 D. Использовать область памяти, зарезервированную через параметр командной
    строки ``reserve_mem``. Адрес и размер будут определены параметром
    ``reserve_mem``. Обратите внимание, что ``reserve_mem`` не всегда может
    выделять память в одном и том же месте, и на него нельзя полагаться.
    Потребуется провести тестирование, и это может работать не на каждой машине
    и не с каждым ядром. Считайте это подходом «по мере возможности» (best
    effort). Опция ``reserve_mem`` принимает в качестве аргументов размер,
    выравнивание и имя. Имя используется для отображения памяти в метку, которую
    может получить ramoops.

	reserve_mem=2M:4096:oops  ramoops.mem_name=oops

Вы можете указать либо RAM-память, либо память периферийных устройств. Однако при
указании RAM обязательно зарезервируйте память вызовом memblock_reserve() очень
рано в коде архитектуры, например::

	#include <linux/memblock.h>

	memblock_reserve(ramoops_data.mem_address, ramoops_data.mem_size);

Формат дампа
------------

Дамп данных начинается с заголовка, в настоящее время определённого как ``====``,
за которым следует временна́я метка и символ новой строки. Затем дамп продолжается
собственно данными.

Чтение данных
-------------

Данные дампа можно прочитать из файловой системы pstore. Формат для этих файлов —
``dmesg-ramoops-N``, где N — номер записи в памяти. Чтобы удалить сохранённую
запись из RAM, просто удалите (unlink) соответствующий файл pstore.

Постоянная трассировка функций
------------------------------

Постоянная трассировка функций может быть полезна для отладки зависаний,
связанных с программным или аппаратным обеспечением. Лог цепочки вызовов функций
хранится в файле ``ftrace-ramoops``. Вот пример использования::

 # mount -t debugfs debugfs /sys/kernel/debug/
 # echo 1 > /sys/kernel/debug/pstore/record_ftrace
 # reboot -f
 [...]
 # mount -t pstore pstore /mnt/
 # tail /mnt/ftrace-ramoops
 0 ffffffff8101ea64  ffffffff8101bcda  native_apic_mem_read <- disconnect_bsp_APIC+0x6a/0xc0
 0 ffffffff8101ea44  ffffffff8101bcf6  native_apic_mem_write <- disconnect_bsp_APIC+0x86/0xc0
 0 ffffffff81020084  ffffffff8101a4b5  hpet_disable <- native_machine_shutdown+0x75/0x90
 0 ffffffff81005f94  ffffffff8101a4bb  iommu_shutdown_noop <- native_machine_shutdown+0x7b/0x90
 0 ffffffff8101a6a1  ffffffff8101a437  native_machine_emergency_restart <- native_machine_restart+0x37/0x40
 0 ffffffff811f9876  ffffffff8101a73a  acpi_reboot <- native_machine_emergency_restart+0xaa/0x1e0
 0 ffffffff8101a514  ffffffff8101a772  mach_reboot_fixups <- native_machine_emergency_restart+0xe2/0x1e0
 0 ffffffff811d9c54  ffffffff8101a7a0  __const_udelay <- native_machine_emergency_restart+0x110/0x1e0
 0 ffffffff811d9c34  ffffffff811d9c80  __delay <- __const_udelay+0x30/0x40
 0 ffffffff811d9d14  ffffffff811d9c3f  delay_tsc <- __delay+0xf/0x20
