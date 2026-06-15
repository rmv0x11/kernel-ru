=====
dm-io
=====

Dm-io предоставляет синхронные и асинхронные службы ввода-вывода (I/O). Доступны три
типа служб ввода-вывода, и каждый тип имеет синхронную и асинхронную
версию.

Пользователь должен настроить структуру io_region, описывающую желаемое расположение
ввода-вывода. Каждая io_region указывает блочное устройство, а также начальный
сектор и размер области::

   struct io_region {
      struct block_device *bdev;
      sector_t sector;
      sector_t count;
   };

Dm-io может читать из одной io_region или записывать в одну или несколько io_regions. Записи
в несколько областей задаются массивом структур io_region.

Первый тип службы ввода-вывода принимает список страниц памяти в качестве буфера данных для
ввода-вывода, а также смещение в пределах первой страницы::

   struct page_list {
      struct page_list *next;
      struct page *page;
   };

   int dm_io_sync(unsigned int num_regions, struct io_region *where, int rw,
                  struct page_list *pl, unsigned int offset,
                  unsigned long *error_bits);
   int dm_io_async(unsigned int num_regions, struct io_region *where, int rw,
                   struct page_list *pl, unsigned int offset,
                   io_notify_fn fn, void *context);

Второй тип службы ввода-вывода принимает массив векторов bio в качестве буфера данных
для ввода-вывода. Эта служба может быть удобна, если вызывающая сторона имеет заранее собранный bio,
но хочет направить разные части bio на разные устройства::

   int dm_io_sync_bvec(unsigned int num_regions, struct io_region *where,
                       int rw, struct bio_vec *bvec,
                       unsigned long *error_bits);
   int dm_io_async_bvec(unsigned int num_regions, struct io_region *where,
                        int rw, struct bio_vec *bvec,
                        io_notify_fn fn, void *context);

Третий тип службы ввода-вывода принимает указатель на буфер памяти, выделенный через vmalloc,
в качестве буфера данных для ввода-вывода. Эта служба может быть удобна, если вызывающей стороне нужно выполнять
ввод-вывод в большую область, но она не хочет выделять большое число отдельных
страниц памяти::

   int dm_io_sync_vm(unsigned int num_regions, struct io_region *where, int rw,
                     void *data, unsigned long *error_bits);
   int dm_io_async_vm(unsigned int num_regions, struct io_region *where, int rw,
                      void *data, io_notify_fn fn, void *context);

Вызывающие стороны асинхронных служб ввода-вывода должны указывать имя процедуры
обратного вызова завершения и указатель на некоторые контекстные данные для ввода-вывода::

   typedef void (*io_notify_fn)(unsigned long error, void *context);

Параметр «error» в этом обратном вызове, как и параметр `*error` во
всех синхронных версиях, является битовым набором (а не простым значением ошибки).
В случае ввода-вывода записи в несколько областей этот битовый набор позволяет dm-io
сигнализировать об успехе или неудаче для каждой отдельной области.

Перед использованием любой из служб dm-io пользователь должен вызвать dm_io_get()
и указать число страниц, для которых он рассчитывает выполнять ввод-вывод одновременно.
Dm-io попытается изменить размер своего mempool, чтобы гарантировать, что достаточное число страниц
всегда доступно, во избежание ненужного ожидания при выполнении ввода-вывода.

Когда пользователь заканчивает использовать службы dm-io, он должен вызвать
dm_io_put() и указать то же число страниц, которое было передано в вызове
dm_io_get().
