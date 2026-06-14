=====================================================
Красно-чёрные деревья (rbtree) в Linux
=====================================================


:Date: January 18, 2007
:Author: Rob Landley <rob@landley.net>

Что такое красно-чёрные деревья и для чего они нужны?
-----------------------------------------------------

Красно-чёрные деревья — это разновидность самобалансирующихся двоичных деревьев
поиска, используемых для хранения сортируемых пар «ключ/значение». Они отличаются
от radix-деревьев (которые применяются для эффективного хранения разреженных
массивов и потому используют длинные целочисленные индексы для
вставки/доступа/удаления узлов) и от хеш-таблиц (которые не поддерживаются в
отсортированном виде для удобного обхода по порядку и должны настраиваться под
конкретный размер и хеш-функцию, тогда как rbtree изящно масштабируются при
хранении произвольных ключей).

Красно-чёрные деревья похожи на AVL-деревья, но обеспечивают более быструю
ограниченную в реальном времени производительность в худшем случае для вставки и
удаления (не более двух и трёх поворотов соответственно для балансировки дерева),
при немного более медленном (но всё ещё O(log n)) времени поиска.

Процитируем Linux Weekly News:

    В ядре используется ряд красно-чёрных деревьев. Планировщики ввода-вывода
    deadline и CFQ применяют rbtree для отслеживания запросов; то же делает и
    пакетный драйвер CD/DVD. Код высокоточных таймеров использует rbtree для
    организации необработанных запросов на таймеры. Файловая система ext3
    отслеживает элементы каталогов в красно-чёрном дереве. Области виртуальной
    памяти (VMA) отслеживаются с помощью красно-чёрных деревьев, как и
    файловые дескрипторы epoll, криптографические ключи и сетевые пакеты в
    планировщике «hierarchical token bucket».

Этот документ охватывает использование реализации rbtree в Linux. Дополнительную
информацию о природе и реализации красно-чёрных деревьев см. в:

  Статья Linux Weekly News о красно-чёрных деревьях
    https://lwn.net/Articles/184495/

  Статья в Wikipedia о красно-чёрных деревьях
    https://en.wikipedia.org/wiki/Red-black_tree

Реализация красно-чёрных деревьев в Linux
-----------------------------------------

Реализация rbtree в Linux расположена в файле "lib/rbtree.c". Чтобы её
использовать, выполните "#include <linux/rbtree.h>".

Реализация rbtree в Linux оптимизирована по скорости и потому имеет на один
уровень косвенности меньше (и лучшую локальность кэша), чем более традиционные
реализации деревьев. Вместо использования указателей на отдельные структуры
rb_node и структуры данных, каждый экземпляр struct rb_node встраивается в ту
структуру данных, которую он организует. И вместо использования указателя на
функцию обратного вызова сравнения от пользователей ожидается, что они напишут
собственные функции поиска и вставки в дерево, которые вызывают предоставляемые
функции rbtree. Блокировка также оставляется на усмотрение пользователя кода
rbtree.

Создание нового rbtree
----------------------

Узлы данных в дереве rbtree — это структуры, содержащие член struct rb_node::

  struct mytype {
  	struct rb_node node;
  	char *keystring;
  };

При работе с указателем на встроенную struct rb_node к содержащей её структуре
данных можно обратиться с помощью стандартного макроса container_of(). Кроме
того, к отдельным членам можно обращаться напрямую через
rb_entry(node, type, member).

В корне каждого rbtree находится структура rb_root, которая инициализируется как
пустая следующим образом:

  struct rb_root mytree = RB_ROOT;

Поиск значения в rbtree
-----------------------

Написать функцию поиска для вашего дерева довольно просто: начните с корня,
сравнивайте каждое значение и переходите по левой или правой ветви по мере
необходимости.

Пример::

  struct mytype *my_search(struct rb_root *root, char *string)
  {
  	struct rb_node *node = root->rb_node;

  	while (node) {
  		struct mytype *data = container_of(node, struct mytype, node);
		int result;

		result = strcmp(string, data->keystring);

		if (result < 0)
  			node = node->rb_left;
		else if (result > 0)
  			node = node->rb_right;
		else
  			return data;
	}
	return NULL;
  }

Вставка данных в rbtree
-----------------------

Вставка данных в дерево включает сначала поиск места для вставки нового узла,
затем вставку узла и перебалансировку («перекраску») дерева.

Поиск для вставки отличается от предыдущего поиска тем, что находит расположение
указателя, на который следует привить новый узел. Новому узлу также нужна ссылка
на его родительский узел для целей перебалансировки.

Пример::

  int my_insert(struct rb_root *root, struct mytype *data)
  {
  	struct rb_node **new = &(root->rb_node), *parent = NULL;

  	/* Figure out where to put new node */
  	while (*new) {
  		struct mytype *this = container_of(*new, struct mytype, node);
  		int result = strcmp(data->keystring, this->keystring);

		parent = *new;
  		if (result < 0)
  			new = &((*new)->rb_left);
  		else if (result > 0)
  			new = &((*new)->rb_right);
  		else
  			return FALSE;
  	}

  	/* Add new node and rebalance tree. */
  	rb_link_node(&data->node, parent, new);
  	rb_insert_color(&data->node, root);

	return TRUE;
  }

Удаление или замена существующих данных в rbtree
------------------------------------------------

Чтобы удалить существующий узел из дерева, вызовите::

  void rb_erase(struct rb_node *victim, struct rb_root *tree);

Пример::

  struct mytype *data = mysearch(&mytree, "walrus");

  if (data) {
  	rb_erase(&data->node, &mytree);
  	myfree(data);
  }

Чтобы заменить существующий узел в дереве новым с тем же ключом, вызовите::

  void rb_replace_node(struct rb_node *old, struct rb_node *new,
  			struct rb_root *tree);

Замена узла таким способом не пересортировывает дерево: если новый узел не имеет
того же ключа, что и старый узел, rbtree, вероятно, будет повреждено.

Перебор элементов, хранящихся в rbtree (в порядке сортировки)
-------------------------------------------------------------

Для перебора содержимого rbtree в отсортированном порядке предоставляются четыре
функции. Они работают с произвольными деревьями, и их не должно требоваться
изменять или оборачивать (за исключением целей блокировки)::

  struct rb_node *rb_first(struct rb_root *tree);
  struct rb_node *rb_last(struct rb_root *tree);
  struct rb_node *rb_next(struct rb_node *node);
  struct rb_node *rb_prev(struct rb_node *node);

Чтобы начать перебор, вызовите rb_first() или rb_last() с указателем на корень
дерева, что вернёт указатель на структуру узла, содержащуюся в первом или
последнем элементе дерева. Чтобы продолжить, получите следующий или предыдущий
узел, вызвав rb_next() или rb_prev() на текущем узле. Это вернёт NULL, когда
больше не останется узлов.

Функции-итераторы возвращают указатель на встроенную struct rb_node, из которой
к содержащей структуре данных можно обратиться с помощью макроса container_of(),
а к отдельным членам можно обращаться напрямую через
rb_entry(node, type, member).

Пример::

  struct rb_node *node;
  for (node = rb_first(&mytree); node; node = rb_next(node))
	printk("key=%s\n", rb_entry(node, struct mytype, node)->keystring);

Кэшированные rbtree
-------------------

Вычисление самого левого (наименьшего) узла — довольно распространённая задача
для двоичных деревьев поиска, например для обходов или для пользователей, чья
собственная логика опирается на определённый порядок. Для этого пользователи
могут использовать 'struct rb_root_cached', чтобы оптимизировать вызовы
rb_first() сложности O(logN) до простого извлечения указателя, избегая
потенциально дорогостоящих обходов дерева. Это достигается с пренебрежимо малыми
накладными расходами времени выполнения на сопровождение, хотя и за счёт
большего объёма используемой памяти.

Аналогично структуре rb_root, кэшированные rbtree инициализируются как пустые
следующим образом::

  struct rb_root_cached mytree = RB_ROOT_CACHED;

Кэшированное rbtree — это просто обычное rb_root с дополнительным указателем для
кэширования самого левого узла. Это позволяет rb_root_cached существовать везде,
где существует rb_root, что делает возможной поддержку расширенных деревьев, а
также всего нескольких дополнительных интерфейсов::

  struct rb_node *rb_first_cached(struct rb_root_cached *tree);
  void rb_insert_color_cached(struct rb_node *, struct rb_root_cached *, bool);
  void rb_erase_cached(struct rb_node *node, struct rb_root_cached *);

Как вызовы вставки, так и вызовы удаления имеют свои соответствующие аналоги для
расширенных деревьев::

  void rb_insert_augmented_cached(struct rb_node *node, struct rb_root_cached *,
				  bool, struct rb_augment_callbacks *);
  void rb_erase_augmented_cached(struct rb_node *, struct rb_root_cached *,
				 struct rb_augment_callbacks *);


Поддержка расширенных rbtree
----------------------------

Расширенное rbtree — это rbtree с «некоторыми» дополнительными данными,
хранящимися в каждом узле, где дополнительные данные для узла N должны быть
функцией содержимого всех узлов в поддереве с корнем в N. Эти данные могут
использоваться для дополнения rbtree некоторой новой функциональностью.
Расширенное rbtree — это необязательная возможность, построенная поверх базовой
инфраструктуры rbtree. Пользователь rbtree, которому нужна эта возможность,
должен вызывать функции дополнения с предоставленным пользователем обратным
вызовом дополнения при вставке и удалении узлов.

Файлы на C, реализующие манипуляции с расширенным rbtree, должны включать
<linux/rbtree_augmented.h> вместо <linux/rbtree.h>. Обратите внимание, что
linux/rbtree_augmented.h раскрывает некоторые детали реализации rbtree, на
которые вам не следует полагаться; пожалуйста, придерживайтесь
задокументированных там API и не включайте <linux/rbtree_augmented.h> также и из
заголовочных файлов, чтобы минимизировать вероятность того, что ваши пользователи
случайно начнут полагаться на такие детали реализации.

При вставке пользователь должен обновить дополненную информацию на пути,
ведущем к вставляемому узлу, затем вызвать rb_link_node() как обычно и
rb_augment_inserted() вместо обычного вызова rb_insert_color(). Если
rb_augment_inserted() перебалансирует rbtree, оно вызовет предоставленную
пользователем функцию для обновления дополненной информации в затронутых
поддеревьях.

При удалении узла пользователь должен вызвать rb_erase_augmented() вместо
rb_erase(). rb_erase_augmented() вызывает предоставленные пользователем функции
для обновления дополненной информации в затронутых поддеревьях.

В обоих случаях обратные вызовы предоставляются через
struct rb_augment_callbacks. Должны быть определены 3 обратных вызова:

- Обратный вызов распространения (propagation), который обновляет дополненное
  значение для данного узла и его предков вплоть до заданной точки остановки
  (или NULL для обновления вплоть до самого корня).

- Обратный вызов копирования (copy), который копирует дополненное значение для
  данного поддерева в новый назначенный корень поддерева.

- Обратный вызов поворота дерева (tree rotation), который копирует дополненное
  значение для данного поддерева в новый назначенный корень поддерева И заново
  вычисляет дополненную информацию для прежнего корня поддерева.

Скомпилированный код для rb_erase_augmented() может инлайнить обратные вызовы
распространения и копирования, что приводит к большой функции, поэтому каждый
пользователь расширенного rbtree должен иметь единственное место вызова
rb_erase_augmented(), чтобы ограничить размер скомпилированного кода.


Пример использования
^^^^^^^^^^^^^^^^^^^^^

Дерево интервалов — это пример расширенного rb-дерева. Источник —
«Introduction to Algorithms» (Cormen, Leiserson, Rivest и Stein). Подробнее о
деревьях интервалов:

Классическое rbtree имеет единственный ключ, и его нельзя напрямую использовать
для хранения интервальных диапазонов вида [lo:hi] и быстрого поиска любого
перекрытия с новым lo:hi или для выяснения того, существует ли точное совпадение
с новым lo:hi.

Однако rbtree можно дополнить для хранения таких интервальных диапазонов
структурированным образом, что делает возможным эффективный поиск и поиск
точного совпадения.

Эта «дополнительная информация», хранящаяся в каждом узле, — максимальное
значение hi (max_hi) среди всех узлов, являющихся его потомками. Эту информацию
можно поддерживать в каждом узле просто путём рассмотрения самого узла и его
непосредственных потомков. И она будет использоваться при поиске за O(log n)
наименьшего совпадения (наименьшего начального адреса среди всех возможных
совпадений) примерно так::

  struct interval_tree_node *
  interval_tree_first_match(struct rb_root *root,
			    unsigned long start, unsigned long last)
  {
	struct interval_tree_node *node;

	if (!root->rb_node)
		return NULL;
	node = rb_entry(root->rb_node, struct interval_tree_node, rb);

	while (true) {
		if (node->rb.rb_left) {
			struct interval_tree_node *left =
				rb_entry(node->rb.rb_left,
					 struct interval_tree_node, rb);
			if (left->__subtree_last >= start) {
				/*
				 * Some nodes in left subtree satisfy Cond2.
				 * Iterate to find the leftmost such node N.
				 * If it also satisfies Cond1, that's the match
				 * we are looking for. Otherwise, there is no
				 * matching interval as nodes to the right of N
				 * can't satisfy Cond1 either.
				 */
				node = left;
				continue;
			}
		}
		if (node->start <= last) {		/* Cond1 */
			if (node->last >= start)	/* Cond2 */
				return node;	/* node is leftmost match */
			if (node->rb.rb_right) {
				node = rb_entry(node->rb.rb_right,
					struct interval_tree_node, rb);
				if (node->__subtree_last >= start)
					continue;
			}
		}
		return NULL;	/* No match */
	}
  }

Вставка/удаление определяются с использованием следующих обратных вызовов
дополнения::

  static inline unsigned long
  compute_subtree_last(struct interval_tree_node *node)
  {
	unsigned long max = node->last, subtree_last;
	if (node->rb.rb_left) {
		subtree_last = rb_entry(node->rb.rb_left,
			struct interval_tree_node, rb)->__subtree_last;
		if (max < subtree_last)
			max = subtree_last;
	}
	if (node->rb.rb_right) {
		subtree_last = rb_entry(node->rb.rb_right,
			struct interval_tree_node, rb)->__subtree_last;
		if (max < subtree_last)
			max = subtree_last;
	}
	return max;
  }

  static void augment_propagate(struct rb_node *rb, struct rb_node *stop)
  {
	while (rb != stop) {
		struct interval_tree_node *node =
			rb_entry(rb, struct interval_tree_node, rb);
		unsigned long subtree_last = compute_subtree_last(node);
		if (node->__subtree_last == subtree_last)
			break;
		node->__subtree_last = subtree_last;
		rb = rb_parent(&node->rb);
	}
  }

  static void augment_copy(struct rb_node *rb_old, struct rb_node *rb_new)
  {
	struct interval_tree_node *old =
		rb_entry(rb_old, struct interval_tree_node, rb);
	struct interval_tree_node *new =
		rb_entry(rb_new, struct interval_tree_node, rb);

	new->__subtree_last = old->__subtree_last;
  }

  static void augment_rotate(struct rb_node *rb_old, struct rb_node *rb_new)
  {
	struct interval_tree_node *old =
		rb_entry(rb_old, struct interval_tree_node, rb);
	struct interval_tree_node *new =
		rb_entry(rb_new, struct interval_tree_node, rb);

	new->__subtree_last = old->__subtree_last;
	old->__subtree_last = compute_subtree_last(old);
  }

  static const struct rb_augment_callbacks augment_callbacks = {
	augment_propagate, augment_copy, augment_rotate
  };

  void interval_tree_insert(struct interval_tree_node *node,
			    struct rb_root *root)
  {
	struct rb_node **link = &root->rb_node, *rb_parent = NULL;
	unsigned long start = node->start, last = node->last;
	struct interval_tree_node *parent;

	while (*link) {
		rb_parent = *link;
		parent = rb_entry(rb_parent, struct interval_tree_node, rb);
		if (parent->__subtree_last < last)
			parent->__subtree_last = last;
		if (start < parent->start)
			link = &parent->rb.rb_left;
		else
			link = &parent->rb.rb_right;
	}

	node->__subtree_last = last;
	rb_link_node(&node->rb, rb_parent, link);
	rb_insert_augmented(&node->rb, root, &augment_callbacks);
  }

  void interval_tree_remove(struct interval_tree_node *node,
			    struct rb_root *root)
  {
	rb_erase_augmented(&node->rb, root, &augment_callbacks);
  }
