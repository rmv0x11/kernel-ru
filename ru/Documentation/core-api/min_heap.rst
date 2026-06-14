.. SPDX-License-Identifier: GPL-2.0

===================================
API Min Heap (API минимальной кучи)
===================================

:Author: Kuan-Wei Chiu <visitorckw@gmail.com>

Введение
========

API Min Heap предоставляет набор функций и макросов для управления
минимальными кучами (min-heap) в ядре Linux. Минимальная куча — это структура
двоичного дерева, в которой значение каждого узла меньше либо равно значениям
его потомков, что гарантирует, что наименьший элемент всегда находится в корне.

Этот документ представляет собой руководство по API Min Heap, в котором подробно
описывается, как определять и использовать минимальные кучи. Пользователям не
следует напрямую вызывать функции с префиксами **__min_heap_*()**, вместо этого
нужно использовать предоставленные макрос-обёртки.

Помимо стандартной версии функций, API также включает набор inline-версий для
сценариев, критичных к производительности. Эти inline-функции имеют те же имена,
что и их не-inline-аналоги, но содержат суффикс **_inline**. Например,
**__min_heap_init_inline** и соответствующая ей макрос-обёртка
**min_heap_init_inline**. Inline-версии позволяют вызывать пользовательские
функции сравнения и обмена напрямую, а не через косвенные вызовы функций. Это
может существенно снизить накладные расходы, особенно когда включён
CONFIG_MITIGATION_RETPOLINE, так как косвенные вызовы функций становятся более
затратными. Как и в случае с не-inline-версиями, для inline-функций важно
использовать макрос-обёртки, а не вызывать сами функции напрямую.

Структуры данных
================

Определение минимальной кучи
----------------------------

Базовая структура данных для представления минимальной кучи определяется с
помощью макросов **MIN_HEAP_PREALLOCATED** и **DEFINE_MIN_HEAP**. Эти макросы
позволяют определить минимальную кучу с предварительно выделенным буфером или с
динамически выделенной памятью.

Пример:

.. code-block:: c

    #define MIN_HEAP_PREALLOCATED(_type, _name, _nr)
    struct _name {
        size_t nr;         /* Number of elements in the heap */
        size_t size;       /* Maximum number of elements that can be held */
        _type *data;    /* Pointer to the heap data */
        _type preallocated[_nr];  /* Static preallocated array */
    }

    #define DEFINE_MIN_HEAP(_type, _name) MIN_HEAP_PREALLOCATED(_type, _name, 0)

Типичная структура кучи включает счётчик количества элементов (`nr`),
максимальную ёмкость кучи (`size`) и указатель на массив элементов (`data`). При
необходимости можно указать статический массив для предварительно выделенного
хранилища кучи с помощью **MIN_HEAP_PREALLOCATED**.

Колбэки минимальной кучи
------------------------

**struct min_heap_callbacks** предоставляет возможности настройки для
упорядочивания элементов в куче и их обмена. Она содержит два указателя на
функции:

.. code-block:: c

    struct min_heap_callbacks {
        bool (*less)(const void *lhs, const void *rhs, void *args);
        void (*swp)(void *lhs, void *rhs, void *args);
    };

- **less** — это функция сравнения, используемая для установления порядка
  элементов.
- **swp** — это функция для обмена элементов в куче. Если swp установлен в
  NULL, будет использована функция обмена по умолчанию, которая меняет элементы
  местами в зависимости от их размера

Макрос-обёртки
==============

Следующие макрос-обёртки предоставляются для удобного взаимодействия с кучей.
Каждый макрос соответствует функции, оперирующей с кучей, и они скрывают прямые
вызовы внутренних функций.

Каждый макрос принимает различные параметры, которые подробно описаны ниже.

Инициализация кучи
------------------

.. code-block:: c

    min_heap_init(heap, data, size);

- **heap**: Указатель на структуру минимальной кучи, которую нужно
  инициализировать.
- **data**: Указатель на буфер, в котором будут храниться элементы кучи. Если
  `NULL`, будет использован предварительно выделенный буфер внутри структуры
  кучи.
- **size**: Максимальное количество элементов, которое может содержать куча.

Этот макрос инициализирует кучу, устанавливая её начальное состояние. Если
`data` равен `NULL`, для хранения будет использована предварительно выделенная
память внутри структуры кучи. В противном случае используется буфер,
предоставленный пользователем. Сложность операции — **O(1)**.

**Inline-версия:** min_heap_init_inline(heap, data, size)

Доступ к верхнему элементу
--------------------------

.. code-block:: c

    element = min_heap_peek(heap);

- **heap**: Указатель на минимальную кучу, из которой нужно получить наименьший
  элемент.

Этот макрос возвращает указатель на наименьший элемент (корень) кучи или `NULL`,
если куча пуста. Сложность операции — **O(1)**.

**Inline-версия:** min_heap_peek_inline(heap)

Вставка в кучу
--------------

.. code-block:: c

    success = min_heap_push(heap, element, callbacks, args);

- **heap**: Указатель на минимальную кучу, в которую нужно вставить элемент.
- **element**: Указатель на элемент, который нужно вставить в кучу.
- **callbacks**: Указатель на `struct min_heap_callbacks`, предоставляющий
  функции `less` и `swp`.
- **args**: Необязательные аргументы, передаваемые функциям `less` и `swp`.

Этот макрос вставляет элемент в кучу. Он возвращает `true`, если вставка прошла
успешно, и `false`, если куча заполнена. Сложность операции — **O(log n)**.

**Inline-версия:** min_heap_push_inline(heap, element, callbacks, args)

Удаление из кучи
----------------

.. code-block:: c

    success = min_heap_pop(heap, callbacks, args);

- **heap**: Указатель на минимальную кучу, из которой нужно удалить наименьший элемент.
- **callbacks**: Указатель на `struct min_heap_callbacks`, предоставляющий
  функции `less` и `swp`.
- **args**: Необязательные аргументы, передаваемые функциям `less` и `swp`.

Этот макрос удаляет наименьший элемент (корень) из кучи. Он возвращает `true`,
если элемент был успешно удалён, или `false`, если куча пуста. Сложность
операции — **O(log n)**.

**Inline-версия:** min_heap_pop_inline(heap, callbacks, args)

Обслуживание кучи
-----------------

Для поддержания структуры кучи можно использовать следующие макросы:

.. code-block:: c

    min_heap_sift_down(heap, pos, callbacks, args);

- **heap**: Указатель на минимальную кучу.
- **pos**: Индекс, с которого начинается просеивание вниз.
- **callbacks**: Указатель на `struct min_heap_callbacks`, предоставляющий
  функции `less` и `swp`.
- **args**: Необязательные аргументы, передаваемые функциям `less` и `swp`.

Этот макрос восстанавливает свойство кучи, перемещая элемент с указанным
индексом (`pos`) вниз по куче, пока он не окажется в правильной позиции.
Сложность операции — **O(log n)**.

**Inline-версия:** min_heap_sift_down_inline(heap, pos, callbacks, args)

.. code-block:: c

    min_heap_sift_up(heap, idx, callbacks, args);

- **heap**: Указатель на минимальную кучу.
- **idx**: Индекс элемента, который нужно просеять вверх.
- **callbacks**: Указатель на `struct min_heap_callbacks`, предоставляющий
  функции `less` и `swp`.
- **args**: Необязательные аргументы, передаваемые функциям `less` и `swp`.

Этот макрос восстанавливает свойство кучи, перемещая элемент с указанным
индексом (`idx`) вверх по куче. Сложность операции — **O(log n)**.

**Inline-версия:** min_heap_sift_up_inline(heap, idx, callbacks, args)

.. code-block:: c

    min_heapify_all(heap, callbacks, args);

- **heap**: Указатель на минимальную кучу.
- **callbacks**: Указатель на `struct min_heap_callbacks`, предоставляющий
  функции `less` и `swp`.
- **args**: Необязательные аргументы, передаваемые функциям `less` и `swp`.

Этот макрос гарантирует, что вся куча удовлетворяет свойству кучи. Он вызывается,
когда куча строится с нуля или после множества изменений. Сложность операции —
**O(n)**.

**Inline-версия:** min_heapify_all_inline(heap, callbacks, args)

Удаление конкретных элементов
-----------------------------

.. code-block:: c

    success = min_heap_del(heap, idx, callbacks, args);

- **heap**: Указатель на минимальную кучу.
- **idx**: Индекс элемента, который нужно удалить.
- **callbacks**: Указатель на `struct min_heap_callbacks`, предоставляющий
  функции `less` и `swp`.
- **args**: Необязательные аргументы, передаваемые функциям `less` и `swp`.

Этот макрос удаляет элемент с указанным индексом (`idx`) из кучи и
восстанавливает свойство кучи. Сложность операции — **O(log n)**.

**Inline-версия:** min_heap_del_inline(heap, idx, callbacks, args)

Прочие утилиты
==============

- **min_heap_full(heap)**: Проверяет, заполнена ли куча.
  Сложность: **O(1)**.

.. code-block:: c

    bool full = min_heap_full(heap);

- `heap`: Указатель на минимальную кучу, которую нужно проверить.

Этот макрос возвращает `true`, если куча заполнена, в противном случае `false`.

**Inline-версия:** min_heap_full_inline(heap)

- **min_heap_empty(heap)**: Проверяет, пуста ли куча.
  Сложность: **O(1)**.

.. code-block:: c

    bool empty = min_heap_empty(heap);

- `heap`: Указатель на минимальную кучу, которую нужно проверить.

Этот макрос возвращает `true`, если куча пуста, в противном случае `false`.

**Inline-версия:** min_heap_empty_inline(heap)

Пример использования
====================

Пример использования API минимальной кучи включает определение структуры кучи,
её инициализацию, а также вставку и удаление элементов по мере необходимости.

.. code-block:: c

    #include <linux/min_heap.h>

    int my_less_function(const void *lhs, const void *rhs, void *args) {
        return (*(int *)lhs < *(int *)rhs);
    }

    struct min_heap_callbacks heap_cb = {
        .less = my_less_function,    /* Comparison function for heap order */
        .swp  = NULL,                /* Use default swap function */
    };

    void example_usage(void) {
        /* Pre-populate the buffer with elements */
        int buffer[5] = {5, 2, 8, 1, 3};
        /* Declare a min-heap */
        DEFINE_MIN_HEAP(int, my_heap);

        /* Initialize the heap with preallocated buffer and size */
        min_heap_init(&my_heap, buffer, 5);

        /* Build the heap using min_heapify_all */
        my_heap.nr = 5;  /* Set the number of elements in the heap */
        min_heapify_all(&my_heap, &heap_cb, NULL);

        /* Peek at the top element (should be 1 in this case) */
        int *top = min_heap_peek(&my_heap);
        pr_info("Top element: %d\n", *top);

        /* Pop the top element (1) and get the new top (2) */
        min_heap_pop(&my_heap, &heap_cb, NULL);
        top = min_heap_peek(&my_heap);
        pr_info("New top element: %d\n", *top);

        /* Insert a new element (0) and recheck the top */
        int new_element = 0;
        min_heap_push(&my_heap, &new_element, &heap_cb, NULL);
        top = min_heap_peek(&my_heap);
        pr_info("Top element after insertion: %d\n", *top);
    }
