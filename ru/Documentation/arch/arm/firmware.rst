==============================================================================
Интерфейс для регистрации и вызова специфичных для прошивки операций для ARM
==============================================================================

Написано Tomasz Figa <t.figa@samsung.com>

Некоторые платы работают с защищённой прошивкой (firmware), исполняемой в
защищённом мире TrustZone, что меняет способ инициализации некоторых вещей.
Это порождает необходимость предоставить таким платформам интерфейс для указания
доступных операций прошивки и их вызова по мере надобности.

Операции прошивки могут быть заданы заполнением структуры struct firmware_ops
соответствующими обратными вызовами (callbacks) с последующей её регистрацией
функцией register_firmware_ops()::

	void register_firmware_ops(const struct firmware_ops *ops)

Указатель ops должен быть ненулевым. Дополнительную информацию о struct firmware_ops
и её полях можно найти в заголовочном файле arch/arm/include/asm/firmware.h.

Предоставляется набор операций по умолчанию (пустой), поэтому ничего задавать не нужно,
если платформа не требует операций прошивки.

Для вызова операции прошивки предоставляется вспомогательный макрос::

	#define call_firmware_op(op, ...)				\
		((firmware_ops->op) ? firmware_ops->op(__VA_ARGS__) : (-ENOSYS))

этот макрос проверяет, предоставлена ли операция, и вызывает её, либо в противном случае
возвращает -ENOSYS, чтобы сигнализировать, что данная операция недоступна (например,
чтобы позволить откат (fallback) к устаревшей операции).

Пример регистрации операций прошивки::

	/* board file */

	static int platformX_do_idle(void)
	{
		/* tell platformX firmware to enter idle */
		return 0;
	}

	static int platformX_cpu_boot(int i)
	{
		/* tell platformX firmware to boot CPU i */
		return 0;
	}

	static const struct firmware_ops platformX_firmware_ops = {
		.do_idle        = exynos_do_idle,
		.cpu_boot       = exynos_cpu_boot,
		/* other operations not available on platformX */
	};

	/* init_early callback of machine descriptor */
	static void __init board_init_early(void)
	{
		register_firmware_ops(&platformX_firmware_ops);
	}

Пример использования операции прошивки::

	/* some platform code, e.g. SMP initialization */

	__raw_writel(__pa_symbol(exynos4_secondary_startup),
		CPU1_BOOT_REG);

	/* Call Exynos specific smc call */
	if (call_firmware_op(cpu_boot, cpu) == -ENOSYS)
		cpu_boot_legacy(...); /* Try legacy way */

	gic_raise_softirq(cpumask_of(cpu), 1);
