==================================================================
Добавление счётчиков ссылок (krefs) к объектам ядра
==================================================================

:Author: Corey Minyard <minyard@acm.org>
:Author: Thomas Hellström <thomas.hellstrom@linux.intel.com>

Большая часть этого материала позаимствована из статьи и доклада Greg
Kroah-Hartman о krefs, представленных на OLS 2004, которые можно найти по адресам:

  - http://www.kroah.com/linux/talks/ols_2004_kref_paper/Reprint-Kroah-Hartman-OLS2004.pdf
  - http://www.kroah.com/linux/talks/ols_2004_kref_talk/

Введение
========

krefs позволяют добавлять счётчики ссылок к вашим объектам. Если у вас есть
объекты, которые используются в нескольких местах и передаются между ними, и
при этом у вас нет счётчиков ссылок, то ваш код почти наверняка содержит
ошибку. Если вам нужны счётчики ссылок, krefs — это то, что нужно.

Чтобы воспользоваться kref, добавьте его в свои структуры данных следующим
образом::

    struct my_data
    {
	.
	.
	struct kref refcount;
	.
	.
    };

Поле kref может располагаться в любом месте структуры данных.

Инициализация
=============

После выделения kref его необходимо инициализировать. Для этого вызовите
kref_init так::

     struct my_data *data;

     data = kmalloc(sizeof(*data), GFP_KERNEL);
     if (!data)
            return -ENOMEM;
     kref_init(&data->refcount);

Это устанавливает счётчик ссылок в kref равным 1.

Правила работы с kref
=====================

Получив инициализированный kref, вы обязаны следовать перечисленным ниже
правилам:

1) Если вы делаете невременную копию указателя, особенно если она может быть
   передана в другой поток выполнения, вы обязаны увеличить счётчик ссылок с
   помощью kref_get() перед тем, как передавать его::

       kref_get(&data->refcount);

   Если у вас уже есть действительный указатель на структуру с kref (счётчик
   ссылок не может обнулиться), вы можете сделать это без блокировки.

2) Когда вы закончили работу с указателем, вы обязаны вызвать kref_put()::

       kref_put(&data->refcount, data_release);

   Если это была последняя ссылка на указатель, будет вызвана процедура
   освобождения. Если код никогда не пытается получить действительный
   указатель на структуру с kref, не удерживая уже действительный указатель,
   то делать это без блокировки безопасно.

3) Если код пытается получить ссылку на структуру с kref, не удерживая при этом
   уже действительный указатель, он обязан сериализовать доступ так, чтобы
   kref_put() не мог произойти во время kref_get(), и при этом структура должна
   оставаться действительной во время kref_get().

Например, если вы выделяете некоторые данные, а затем передаёте их на обработку
в другой поток::

    void data_release(struct kref *ref)
    {
	struct my_data *data = container_of(ref, struct my_data, refcount);
	kfree(data);
    }

    void more_data_handling(void *cb_data)
    {
	struct my_data *data = cb_data;
	.
	. do stuff with data here
	.
	kref_put(&data->refcount, data_release);
    }

    int my_data_handler(void)
    {
	int rv = 0;
	struct my_data *data;
	struct task_struct *task;
	data = kmalloc(sizeof(*data), GFP_KERNEL);
	if (!data)
		return -ENOMEM;
	kref_init(&data->refcount);

	kref_get(&data->refcount);
	task = kthread_run(more_data_handling, data, "more_data_handling");
	if (task == ERR_PTR(-ENOMEM)) {
		rv = -ENOMEM;
	        kref_put(&data->refcount, data_release);
		goto out;
	}

	.
	. do stuff with data here
	.
    out:
	kref_put(&data->refcount, data_release);
	return rv;
    }

Таким образом, неважно, в каком порядке два потока обработают данные:
kref_put() сам определяет, когда данные больше не имеют ссылок, и освобождает
их. kref_get() не требует блокировки, поскольку у нас уже есть действительный
указатель, для которого мы владеем счётчиком ссылок. put не требует блокировки,
поскольку никто не пытается получить данные, не удерживая уже указатель.

В приведённом выше примере kref_put() будет вызван 2 раза как при успешном
завершении, так и в путях обработки ошибок. Это необходимо, поскольку счётчик
ссылок был увеличен 2 раза вызовами kref_init() и kref_get().

Обратите внимание, что слово «перед» в правиле 1 крайне важно. Никогда не
делайте чего-либо подобного::

	task = kthread_run(more_data_handling, data, "more_data_handling");
	if (task == ERR_PTR(-ENOMEM)) {
		rv = -ENOMEM;
		goto out;
	} else
		/* BAD BAD BAD - get is after the handoff */
		kref_get(&data->refcount);

Не считайте, что вы знаете, что делаете, и не используйте приведённую выше
конструкцию. Во-первых, вы можете не знать, что делаете. Во-вторых, вы можете
знать, что делаете (есть ситуации, связанные с блокировками, где приведённое
выше может быть допустимо), но кто-то другой, кто не знает, что делает, может
изменить код или скопировать его. Это плохой стиль. Не делайте так.

Есть ситуации, в которых можно оптимизировать get'ы и put'ы. Например, если вы
закончили работу с объектом и помещаете его в очередь для чего-то ещё или
передаёте его чему-то ещё, нет причин делать get, а затем put::

	/* Silly extra get and put */
	kref_get(&obj->ref);
	enqueue(obj);
	kref_put(&obj->ref, obj_cleanup);

Просто выполните enqueue. Комментарий по этому поводу всегда приветствуется::

	enqueue(obj);
	/* We are done with obj, so we pass our refcount off
	   to the queue.  DON'T TOUCH obj AFTER HERE! */

Последнее правило (правило 3) — самое неприятное в обработке. Допустим,
например, что у вас есть список элементов, каждый из которых снабжён kref, и вы
хотите получить первый из них. Вы не можете просто взять первый элемент из
списка и сделать ему kref_get(). Это нарушает правило 3, поскольку вы ещё не
удерживаете действительный указатель. Вы должны добавить mutex (или какую-то
другую блокировку). Например::

	static DEFINE_MUTEX(mutex);
	static LIST_HEAD(q);
	struct my_data
	{
		struct kref      refcount;
		struct list_head link;
	};

	static struct my_data *get_entry()
	{
		struct my_data *entry = NULL;
		mutex_lock(&mutex);
		if (!list_empty(&q)) {
			entry = container_of(q.next, struct my_data, link);
			kref_get(&entry->refcount);
		}
		mutex_unlock(&mutex);
		return entry;
	}

	static void release_entry(struct kref *ref)
	{
		struct my_data *entry = container_of(ref, struct my_data, refcount);

		list_del(&entry->link);
		kfree(entry);
	}

	static void put_entry(struct my_data *entry)
	{
		mutex_lock(&mutex);
		kref_put(&entry->refcount, release_entry);
		mutex_unlock(&mutex);
	}

Возвращаемое значение kref_put() полезно, если вы не хотите удерживать
блокировку в течение всей операции освобождения. Допустим, в приведённом выше
примере вы не хотели вызывать kfree() с удерживаемой блокировкой (поскольку это
довольно бессмысленно). Вы могли бы использовать kref_put() следующим образом::

	static void release_entry(struct kref *ref)
	{
		/* All work is done after the return from kref_put(). */
	}

	static void put_entry(struct my_data *entry)
	{
		mutex_lock(&mutex);
		if (kref_put(&entry->refcount, release_entry)) {
			list_del(&entry->link);
			mutex_unlock(&mutex);
			kfree(entry);
		} else
			mutex_unlock(&mutex);
	}

Это действительно более полезно, если в рамках операций освобождения вам
приходится вызывать другие процедуры, которые могут занимать много времени или
могут пытаться захватить ту же блокировку. Обратите внимание, что выполнение
всего в процедуре освобождения всё же предпочтительнее, поскольку это несколько
аккуратнее.

Приведённый выше пример также можно оптимизировать, используя
kref_get_unless_zero() следующим образом::

	static struct my_data *get_entry()
	{
		struct my_data *entry = NULL;
		mutex_lock(&mutex);
		if (!list_empty(&q)) {
			entry = container_of(q.next, struct my_data, link);
			if (!kref_get_unless_zero(&entry->refcount))
				entry = NULL;
		}
		mutex_unlock(&mutex);
		return entry;
	}

	static void release_entry(struct kref *ref)
	{
		struct my_data *entry = container_of(ref, struct my_data, refcount);

		mutex_lock(&mutex);
		list_del(&entry->link);
		mutex_unlock(&mutex);
		kfree(entry);
	}

	static void put_entry(struct my_data *entry)
	{
		kref_put(&entry->refcount, release_entry);
	}

Это полезно для того, чтобы убрать блокировку mutex вокруг kref_put() в
put_entry(), но важно, чтобы kref_get_unless_zero был заключён в ту же
критическую секцию, в которой элемент находится в таблице поиска, иначе
kref_get_unless_zero может обратиться к уже освобождённой памяти. Обратите
внимание, что использовать kref_get_unless_zero без проверки его возвращаемого
значения недопустимо. Если вы уверены (благодаря тому, что у вас уже есть
действительный указатель), что kref_get_unless_zero() вернёт true, то
используйте вместо него kref_get().

Krefs и RCU
===========

Функция kref_get_unless_zero также делает возможным использование блокировки
rcu для поиска в приведённом выше примере::

	struct my_data
	{
		struct rcu_head rhead;
		.
		struct kref refcount;
		.
		.
	};

	static struct my_data *get_entry_rcu()
	{
		struct my_data *entry = NULL;
		rcu_read_lock();
		if (!list_empty(&q)) {
			entry = container_of(q.next, struct my_data, link);
			if (!kref_get_unless_zero(&entry->refcount))
				entry = NULL;
		}
		rcu_read_unlock();
		return entry;
	}

	static void release_entry_rcu(struct kref *ref)
	{
		struct my_data *entry = container_of(ref, struct my_data, refcount);

		mutex_lock(&mutex);
		list_del_rcu(&entry->link);
		mutex_unlock(&mutex);
		kfree_rcu(entry, rhead);
	}

	static void put_entry(struct my_data *entry)
	{
		kref_put(&entry->refcount, release_entry_rcu);
	}

Но обратите внимание, что элемент struct kref должен оставаться в действительной
памяти в течение льготного периода rcu (grace period) после вызова
release_entry_rcu. Этого можно добиться, используя kfree_rcu(entry, rhead), как
сделано выше, или вызвав synchronize_rcu() перед использованием kfree, но
учтите, что synchronize_rcu() может усыплять на значительное время.

Функции и структуры
===================

.. kernel-doc:: include/linux/kref.h
