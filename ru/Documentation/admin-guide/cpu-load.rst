===================
Загрузка процессора
===================

Linux экспортирует различную информацию через ``/proc/stat`` и
``/proc/uptime``, которую инструменты пространства пользователя, такие как top(1),
используют для вычисления среднего времени, проведённого системой в определённом
состоянии, например::

    $ iostat
    Linux 2.6.18.3-exp (linmac)     02/20/2007

    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
              10.01    0.00    2.92    5.44    0.00   81.63

    ...

Здесь система считает, что за период выборки по умолчанию она
провела 10.01% времени, выполняя работу в пространстве пользователя, 2.92% в
ядре, и в общей сложности 81.63% времени простаивала.

В большинстве случаев информация из ``/proc/stat``	 довольно точно отражает
реальность, однако из-за особенностей того, как и когда ядро собирает
эти данные, иногда ей вообще нельзя доверять.

Так как же собирается эта информация?  При каждом сигнале таймерного
прерывания ядро смотрит, какого рода задача выполнялась в этот
момент, и инкрементирует счётчик, соответствующий роду/состоянию этой
задачи.  Проблема в том, что система могла многократно
переключаться между различными состояниями между двумя таймерными
прерываниями, а счётчик инкрементируется только для последнего состояния.


Пример
------

Если представить систему с одной задачей, которая периодически жжёт циклы
следующим образом::

     time line between two timer interrupts
    |--------------------------------------|
     ^                                    ^
     |_ something begins working          |
                                          |_ something goes to sleep
                                         (only to be awaken quite soon)

В описанной выше ситуации система будет загружена на 0% согласно
``/proc/stat`` (поскольку таймерное прерывание всегда будет происходить, когда
система выполняет обработчик простоя), но в реальности загрузка
ближе к 99%.

Можно представить ещё много ситуаций, в которых такое поведение ядра
приведёт к весьма беспорядочной информации внутри ``/proc/stat``::


	/* gcc -o hog smallhog.c */
	#include <time.h>
	#include <limits.h>
	#include <signal.h>
	#include <sys/time.h>
	#define HIST 10

	static volatile sig_atomic_t stop;

	static void sighandler(int signr)
	{
		(void) signr;
		stop = 1;
	}

	static unsigned long hog (unsigned long niters)
	{
		stop = 0;
		while (!stop && --niters);
		return niters;
	}

	int main (void)
	{
		int i;
		struct itimerval it = {
			.it_interval = { .tv_sec = 0, .tv_usec = 1 },
			.it_value    = { .tv_sec = 0, .tv_usec = 1 } };
		sigset_t set;
		unsigned long v[HIST];
		double tmp = 0.0;
		unsigned long n;
		signal(SIGALRM, &sighandler);
		setitimer(ITIMER_REAL, &it, NULL);

		hog (ULONG_MAX);
		for (i = 0; i < HIST; ++i) v[i] = ULONG_MAX - hog(ULONG_MAX);
		for (i = 0; i < HIST; ++i) tmp += v[i];
		tmp /= HIST;
		n = tmp - (tmp / 3.0);

		sigemptyset(&set);
		sigaddset(&set, SIGALRM);

		for (;;) {
			hog(n);
			sigwait(&set, &i);
		}
		return 0;
	}


Ссылки
------

- https://lore.kernel.org/r/loom.20070212T063225-663@post.gmane.org
- Documentation/filesystems/proc.rst (1.8)


Благодарности
-------------

Con Kolivas, Pavel Machek
