.. SPDX-License-Identifier: GPL-2.0-only

=================
Проверка UAPI
=================

Проверка UAPI (``scripts/check-uapi.sh``) — это shell-скрипт, который
проверяет заголовочные файлы UAPI на обратную совместимость с пространством
пользователя (userspace) по всему дереву git.

Опции
=====

В этом разделе описываются опции, с которыми может быть запущен
``check-uapi.sh``.

Использование::

    check-uapi.sh [-b BASE_REF] [-p PAST_REF] [-j N] [-l ERROR_LOG] [-i] [-q] [-v]

Доступные опции::

    -b BASE_REF    Base git reference to use for comparison. If unspecified or empty,
                   will use any dirty changes in tree to UAPI files. If there are no
                   dirty changes, HEAD will be used.
    -p PAST_REF    Compare BASE_REF to PAST_REF (e.g. -p v6.1). If unspecified or empty,
                   will use BASE_REF^1. Must be an ancestor of BASE_REF. Only headers
                   that exist on PAST_REF will be checked for compatibility.
    -j JOBS        Number of checks to run in parallel (default: number of CPU cores).
    -l ERROR_LOG   Write error log to file (default: no error log is generated).
    -i             Ignore ambiguous changes that may or may not break UAPI compatibility.
    -q             Quiet operation.
    -v             Verbose operation (print more information about each header being checked).

Аргументы окружения::

    ABIDIFF  Custom path to abidiff binary
    CC       C compiler (default is "gcc")
    ARCH     Target architecture of C compiler (default is host arch)

Коды завершения::

    0) Success
    1) ABI difference detected
    2) Prerequisite not met

Примеры
=======

Базовое использование
----------------------

Сначала попробуем внести в заголовочный файл UAPI изменение, которое
очевидно не сломает пространство пользователя::

    cat << 'EOF' | patch -l -p1
    --- a/include/uapi/linux/acct.h
    +++ b/include/uapi/linux/acct.h
    @@ -21,7 +21,9 @@
     #include <asm/param.h>
     #include <asm/byteorder.h>

    -/*
    +#define FOO
    +
    +/*
      *  comp_t is a 16-bit "floating" point number with a 3-bit base 8
      *  exponent and a 13-bit fraction.
      *  comp2_t is 24-bit with 5-bit base 2 exponent and 20 bit fraction
    diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
    EOF

Теперь воспользуемся скриптом для проверки::

    % ./scripts/check-uapi.sh
    Installing user-facing UAPI headers from dirty tree... OK
    Installing user-facing UAPI headers from HEAD... OK
    Checking changes to UAPI headers between HEAD and dirty tree...
    All 912 UAPI headers compatible with x86 appear to be backwards compatible

Добавим ещё одно изменение, которое *может* сломать пространство пользователя::

    cat << 'EOF' | patch -l -p1
    --- a/include/uapi/linux/bpf.h
    +++ b/include/uapi/linux/bpf.h
    @@ -74,7 +74,7 @@ struct bpf_insn {
            __u8    dst_reg:4;      /* dest register */
            __u8    src_reg:4;      /* source register */
            __s16   off;            /* signed offset */
    -       __s32   imm;            /* signed immediate constant */
    +       __u32   imm;            /* unsigned immediate constant */
     };

     /* Key of an a BPF_MAP_TYPE_LPM_TRIE entry */
    EOF

Скрипт обнаружит это::

    % ./scripts/check-uapi.sh
    Installing user-facing UAPI headers from dirty tree... OK
    Installing user-facing UAPI headers from HEAD... OK
    Checking changes to UAPI headers between HEAD and dirty tree...
    ==== ABI differences detected in include/linux/bpf.h from HEAD -> dirty tree ====
        [C] 'struct bpf_insn' changed:
          type size hasn't changed
          1 data member change:
            type of '__s32 imm' changed:
              typedef name changed from __s32 to __u32 at int-ll64.h:27:1
              underlying type 'int' changed:
                type name changed from 'int' to 'unsigned int'
                type size hasn't changed
    ==================================================================================

    error - 1/912 UAPI headers compatible with x86 appear _not_ to be backwards compatible

В этом случае скрипт сообщает об изменении типа, потому что оно может
сломать программу из пространства пользователя, которая передаёт отрицательное
число. Теперь предположим, что вы знаете: ни одна программа из пространства
пользователя не может использовать отрицательное значение в ``imm``, поэтому
смена типа на беззнаковый здесь ничего не нарушит. Вы можете передать скрипту
флаг ``-i``, чтобы игнорировать изменения, в которых обратная совместимость
с пространством пользователя неоднозначна::

    % ./scripts/check-uapi.sh -i
    Installing user-facing UAPI headers from dirty tree... OK
    Installing user-facing UAPI headers from HEAD... OK
    Checking changes to UAPI headers between HEAD and dirty tree...
    All 912 UAPI headers compatible with x86 appear to be backwards compatible

Теперь внесём похожее изменение, которое *сломает* пространство пользователя::

    cat << 'EOF' | patch -l -p1
    --- a/include/uapi/linux/bpf.h
    +++ b/include/uapi/linux/bpf.h
    @@ -71,8 +71,8 @@ enum {

     struct bpf_insn {
            __u8    code;           /* opcode */
    -       __u8    dst_reg:4;      /* dest register */
            __u8    src_reg:4;      /* source register */
    +       __u8    dst_reg:4;      /* dest register */
            __s16   off;            /* signed offset */
            __s32   imm;            /* signed immediate constant */
     };
    EOF

Поскольку мы переупорядочиваем существующий член структуры, здесь нет
неоднозначности, и скрипт сообщит о поломке, даже если передать ``-i``::

    % ./scripts/check-uapi.sh -i
    Installing user-facing UAPI headers from dirty tree... OK
    Installing user-facing UAPI headers from HEAD... OK
    Checking changes to UAPI headers between HEAD and dirty tree...
    ==== ABI differences detected in include/linux/bpf.h from HEAD -> dirty tree ====
        [C] 'struct bpf_insn' changed:
          type size hasn't changed
          2 data member changes:
            '__u8 dst_reg' offset changed from 8 to 12 (in bits) (by +4 bits)
            '__u8 src_reg' offset changed from 12 to 8 (in bits) (by -4 bits)
    ==================================================================================

    error - 1/912 UAPI headers compatible with x86 appear _not_ to be backwards compatible

Закоммитим ломающее изменение, а затем закоммитим безобидное изменение::

    % git commit -m 'Breaking UAPI change' include/uapi/linux/bpf.h
    [detached HEAD f758e574663a] Breaking UAPI change
     1 file changed, 1 insertion(+), 1 deletion(-)
    % git commit -m 'Innocuous UAPI change' include/uapi/linux/acct.h
    [detached HEAD 2e87df769081] Innocuous UAPI change
     1 file changed, 3 insertions(+), 1 deletion(-)

Теперь запустим скрипт снова без аргументов::

    % ./scripts/check-uapi.sh
    Installing user-facing UAPI headers from HEAD... OK
    Installing user-facing UAPI headers from HEAD^1... OK
    Checking changes to UAPI headers between HEAD^1 and HEAD...
    All 912 UAPI headers compatible with x86 appear to be backwards compatible

Он не обнаруживает ни одного ломающего изменения, потому что по умолчанию
сравнивает только ``HEAD`` с ``HEAD^1``. Ломающее изменение было закоммичено
на ``HEAD~2``. Если бы мы хотели расширить область поиска дальше в прошлое,
нам пришлось бы воспользоваться опцией ``-p``, чтобы передать другую прошлую
ссылку. В этом случае передадим скрипту ``-p HEAD~2``, чтобы он проверил
изменения UAPI между ``HEAD~2`` и ``HEAD``::

    % ./scripts/check-uapi.sh -p HEAD~2
    Installing user-facing UAPI headers from HEAD... OK
    Installing user-facing UAPI headers from HEAD~2... OK
    Checking changes to UAPI headers between HEAD~2 and HEAD...
    ==== ABI differences detected in include/linux/bpf.h from HEAD~2 -> HEAD ====
        [C] 'struct bpf_insn' changed:
          type size hasn't changed
          2 data member changes:
            '__u8 dst_reg' offset changed from 8 to 12 (in bits) (by +4 bits)
            '__u8 src_reg' offset changed from 12 to 8 (in bits) (by -4 bits)
    ==============================================================================

    error - 1/912 UAPI headers compatible with x86 appear _not_ to be backwards compatible

В качестве альтернативы мы также могли бы запустить с ``-b HEAD~``. Это
установило бы базовую ссылку в ``HEAD~``, и тогда скрипт сравнивал бы её
с ``HEAD~^1``.

Заголовки, специфичные для архитектуры
--------------------------------------

Рассмотрим это изменение::

    cat << 'EOF' | patch -l -p1
    --- a/arch/arm64/include/uapi/asm/sigcontext.h
    +++ b/arch/arm64/include/uapi/asm/sigcontext.h
    @@ -70,6 +70,7 @@ struct sigcontext {
     struct _aarch64_ctx {
            __u32 magic;
            __u32 size;
    +       __u32 new_var;
     };

     #define FPSIMD_MAGIC   0x46508001
    EOF

Это изменение заголовочного файла UAPI, специфичного для arm64. В этом примере
я запускаю скрипт на машине x86 с компилятором x86, поэтому по умолчанию
скрипт проверяет только заголовочные файлы UAPI, совместимые с x86::

    % ./scripts/check-uapi.sh
    Installing user-facing UAPI headers from dirty tree... OK
    Installing user-facing UAPI headers from HEAD... OK
    No changes to UAPI headers were applied between HEAD and dirty tree

С компилятором x86 мы не можем проверить заголовочные файлы в ``arch/arm64``,
поэтому скрипт даже не пытается этого делать.

Если мы хотим проверить этот заголовочный файл, нам придётся воспользоваться
компилятором arm64 и соответствующим образом задать ``ARCH``::

    % CC=aarch64-linux-gnu-gcc ARCH=arm64 ./scripts/check-uapi.sh
    Installing user-facing UAPI headers from dirty tree... OK
    Installing user-facing UAPI headers from HEAD... OK
    Checking changes to UAPI headers between HEAD and dirty tree...
    ==== ABI differences detected in include/asm/sigcontext.h from HEAD -> dirty tree ====
        [C] 'struct _aarch64_ctx' changed:
          type size changed from 64 to 96 (in bits)
          1 data member insertion:
            '__u32 new_var', at offset 64 (in bits) at sigcontext.h:73:1
        -- snip --
        [C] 'struct zt_context' changed:
          type size changed from 128 to 160 (in bits)
          2 data member changes (1 filtered):
            '__u16 nregs' offset changed from 64 to 96 (in bits) (by +32 bits)
            '__u16 __reserved[3]' offset changed from 80 to 112 (in bits) (by +32 bits)
    =======================================================================================

    error - 1/884 UAPI headers compatible with arm64 appear _not_ to be backwards compatible

Мы видим, что при правильно заданных для этого файла ``ARCH`` и ``CC`` изменение
ABI сообщается корректно. Обратите также внимание, что общее число
заголовочных файлов UAPI, проверяемых скриптом, меняется. Это связано с тем,
что число заголовков, устанавливаемых для платформ arm64, отличается от x86.

Поломки из-за перекрёстных зависимостей
---------------------------------------

Рассмотрим это изменение::

    cat << 'EOF' | patch -l -p1
    --- a/include/uapi/linux/types.h
    +++ b/include/uapi/linux/types.h
    @@ -52,7 +52,7 @@ typedef __u32 __bitwise __wsum;
     #define __aligned_be64 __be64 __attribute__((aligned(8)))
     #define __aligned_le64 __le64 __attribute__((aligned(8)))

    -typedef unsigned __bitwise __poll_t;
    +typedef unsigned short __bitwise __poll_t;

     #endif /*  __ASSEMBLY__ */
     #endif /* _UAPI_LINUX_TYPES_H */
    EOF

Здесь мы меняем ``typedef`` в ``types.h``. Это не ломает UAPI в самом
``types.h``, но из-за этого изменения могут сломаться другие UAPI в дереве::

    % ./scripts/check-uapi.sh
    Installing user-facing UAPI headers from dirty tree... OK
    Installing user-facing UAPI headers from HEAD... OK
    Checking changes to UAPI headers between HEAD and dirty tree...
    ==== ABI differences detected in include/linux/eventpoll.h from HEAD -> dirty tree ====
        [C] 'struct epoll_event' changed:
          type size changed from 96 to 80 (in bits)
          2 data member changes:
            type of '__poll_t events' changed:
              underlying type 'unsigned int' changed:
                type name changed from 'unsigned int' to 'unsigned short int'
                type size changed from 32 to 16 (in bits)
            '__u64 data' offset changed from 32 to 16 (in bits) (by -16 bits)
    ========================================================================================
    include/linux/eventpoll.h did not change between HEAD and dirty tree...
    It's possible a change to one of the headers it includes caused this error:
    #include <linux/fcntl.h>
    #include <linux/types.h>

Обратите внимание, что скрипт заметил: упавший заголовочный файл не менялся,
поэтому он предполагает, что поломку вызвал один из включаемых им заголовков.
Действительно, мы видим, что ``linux/types.h`` используется из ``eventpoll.h``.

Удаление заголовков UAPI
------------------------

Рассмотрим это изменение::

    cat << 'EOF' | patch -l -p1
    diff --git a/include/uapi/asm-generic/Kbuild b/include/uapi/asm-generic/Kbuild
    index ebb180aac74e..a9c88b0a8b3b 100644
    --- a/include/uapi/asm-generic/Kbuild
    +++ b/include/uapi/asm-generic/Kbuild
    @@ -31,6 +31,6 @@ mandatory-y += stat.h
     mandatory-y += statfs.h
     mandatory-y += swab.h
     mandatory-y += termbits.h
    -mandatory-y += termios.h
    +#mandatory-y += termios.h
     mandatory-y += types.h
     mandatory-y += unistd.h
    EOF

Этот скрипт удаляет заголовочный файл UAPI из списка установки. Запустим
скрипт::

    % ./scripts/check-uapi.sh
    Installing user-facing UAPI headers from dirty tree... OK
    Installing user-facing UAPI headers from HEAD... OK
    Checking changes to UAPI headers between HEAD and dirty tree...
    ==== UAPI header include/asm/termios.h was removed between HEAD and dirty tree ====

    error - 1/912 UAPI headers compatible with x86 appear _not_ to be backwards compatible

Удаление заголовка UAPI считается ломающим изменением, и скрипт пометит его
как таковое.

Проверка исторической совместимости UAPI
----------------------------------------

Вы можете использовать опции ``-b`` и ``-p`` для исследования различных
участков вашего дерева git. Например, чтобы проверить все изменённые
заголовочные файлы UAPI между тегами v6.0 и v6.1, вы бы запустили::

    % ./scripts/check-uapi.sh -b v6.1 -p v6.0
    Installing user-facing UAPI headers from v6.1... OK
    Installing user-facing UAPI headers from v6.0... OK
    Checking changes to UAPI headers between v6.0 and v6.1...

    --- snip ---
    error - 37/907 UAPI headers compatible with x86 appear _not_ to be backwards compatible

Примечание: до версии v5.3 отсутствует заголовочный файл, необходимый
скрипту, поэтому скрипт не может проверять изменения раньше этого момента.

Вы заметите, что скрипт обнаружил множество изменений UAPI, которые не
являются обратно совместимыми. Учитывая, что UAPI ядра должны быть стабильны
вечно, это тревожный результат. Это подводит нас к следующему разделу:
оговорки.

Оговорки
========

Проверка UAPI не делает никаких предположений о намерениях автора, поэтому
некоторые типы изменений могут быть помечены, даже если они намеренно
ломают UAPI.

Удаления при рефакторинге или устаревании
-----------------------------------------

Иногда драйверы для очень старого оборудования удаляют, как в этом примере::

    % ./scripts/check-uapi.sh -b ba47652ba655
    Installing user-facing UAPI headers from ba47652ba655... OK
    Installing user-facing UAPI headers from ba47652ba655^1... OK
    Checking changes to UAPI headers between ba47652ba655^1 and ba47652ba655...
    ==== UAPI header include/linux/meye.h was removed between ba47652ba655^1 and ba47652ba655 ====

    error - 1/910 UAPI headers compatible with x86 appear _not_ to be backwards compatible

Скрипт всегда будет помечать удаления (даже если они намеренные).

Расширения структур
--------------------

В зависимости от того, как структура обрабатывается в пространстве ядра,
изменение, расширяющее структуру, может не быть ломающим.

Если структура используется в качестве аргумента ioctl, то драйвер ядра
должен уметь обрабатывать команды ioctl любого размера. Помимо этого, нужно
быть внимательным при копировании данных от пользователя. Скажем, например,
что ``struct foo`` изменена так::

    struct foo {
        __u64 a; /* added in version 1 */
    +   __u32 b; /* added in version 2 */
    +   __u32 c; /* added in version 2 */
    }

По умолчанию скрипт пометит такой тип изменения для дальнейшего рассмотрения::

    [C] 'struct foo' changed:
      type size changed from 64 to 128 (in bits)
      2 data member insertions:
        '__u32 b', at offset 64 (in bits)
        '__u32 c', at offset 96 (in bits)

Однако возможно, что это изменение было сделано безопасно.

Если программа из пространства пользователя была собрана с версией 1, она будет
считать, что ``sizeof(struct foo)`` равен 8. Этот размер будет закодирован
в значении ioctl, которое отправляется ядру. Если ядро собрано с версией 2,
оно будет считать, что ``sizeof(struct foo)`` равен 16.

Ядро может использовать макрос ``_IOC_SIZE`` для получения размера,
закодированного в коде ioctl, который передал пользователь, а затем
использовать ``copy_struct_from_user()`` для безопасного копирования
значения::

    int handle_ioctl(unsigned long cmd, unsigned long arg)
    {
        switch _IOC_NR(cmd) {
        0x01: {
            struct foo my_cmd;  /* size 16 in the kernel */

            ret = copy_struct_from_user(&my_cmd, arg, sizeof(struct foo), _IOC_SIZE(cmd));
            ...

``copy_struct_from_user`` обнулит структуру в ядре, а затем скопирует только
байты, переданные пользователем (оставляя новые члены обнулёнными). Если
пользователь передал структуру большего размера, лишние члены игнорируются.

Если вы знаете, что эта ситуация учтена в коде ядра, вы можете передать
скрипту ``-i``, и такие расширения структур будут игнорироваться.

Миграция на flex-массивы
------------------------

Хотя скрипт обрабатывает расширение в существующий flex-массив, он всё же
помечает первоначальную миграцию на flex-массивы из поддельных flex-массивов
из 1 элемента. Например::

    struct foo {
          __u32 x;
    -     __u32 flex[1]; /* fake flex */
    +     __u32 flex[];  /* real flex */
    };

Это изменение будет помечено скриптом::

    [C] 'struct foo' changed:
      type size changed from 64 to 32 (in bits)
      1 data member change:
        type of '__u32 flex[1]' changed:
          type name changed from '__u32[1]' to '__u32[]'
          array type size changed from 32 to 'unknown'
          array type subrange 1 changed length from 1 to 'unknown'

На данный момент нет способа отфильтровать такие типы изменений, поэтому
имейте в виду этот возможный ложный срабатывание.

Заключение
----------

Хотя многие типы ложных срабатываний отфильтровываются скриптом, возможны
некоторые случаи, когда скрипт помечает изменение, которое не ломает UAPI.
Также возможно, что изменение, которое *действительно* ломает пространство
пользователя, не будет помечено этим скриптом. Хотя скрипт был прогнан на
значительной части истории ядра, всё ещё могут существовать пограничные
случаи, которые не учтены.

Замысел в том, чтобы этот скрипт использовался как быстрая проверка для
сопровождающих (maintainers) или автоматизированных инструментов, а не как
окончательный авторитет в вопросе совместимости патчей. Лучше помнить:
полагайтесь на своё лучшее суждение (и, в идеале, на модульный тест в
пространстве пользователя), чтобы убедиться, что ваши изменения UAPI
обратно совместимы!
