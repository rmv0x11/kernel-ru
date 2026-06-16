.. SPDX-License-Identifier: GPL-2.0

Высокоуровневый CI API
======================

.. note::

   Эта документация устарела.

Этот документ описывает высокоуровневый CI API в соответствии с
Linux DVB API.


При подходе High Level CI любую новую карту практически с любой
произвольной архитектурой можно реализовать в этом стиле; определения
внутри оператора switch легко адаптируются под любую карту, тем самым
устраняя необходимость в каких-либо дополнительных ioctl'ах.

Недостаток в том, что всё остальное должны брать на себя драйвер/оборудование.
Для прикладного программиста это так же просто, как отправка/получение
массива в/из CI ioctl'ов, определённых в Linux DVB API. Никаких изменений
в API для поддержки этой возможности внесено не было.


Зачем нужен ещё один CI-интерфейс?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Это один из самых часто задаваемых вопросов. Что ж, хороший вопрос.
Строго говоря, это не новый интерфейс.

CI-интерфейс определён в DVB API в ca.h следующим образом:

.. code-block:: c

	typedef struct ca_slot_info {
		int num;               /* slot number */

		int type;              /* CA interface this slot supports */
	#define CA_CI            1     /* CI high level interface */
	#define CA_CI_LINK       2     /* CI link layer level interface */
	#define CA_CI_PHYS       4     /* CI physical layer level interface */
	#define CA_DESCR         8     /* built-in descrambler */
	#define CA_SC          128     /* simple smart card interface */

		unsigned int flags;
	#define CA_CI_MODULE_PRESENT 1 /* module (or card) inserted */
	#define CA_CI_MODULE_READY   2
	} ca_slot_info_t;

Этот CI-интерфейс следует высокоуровневому CI-интерфейсу, который не
реализован в большинстве приложений. Поэтому к этой области возвращаемся снова.

Этот CI-интерфейс довольно сильно отличается тем, что он пытается
охватить все остальные устройства на базе CI, относящиеся к другим категориям.

Это означает, что данный CI-интерфейс обрабатывает теги в стиле EN50221
только на прикладном уровне (Application layer), и приложение не занимается
управлением сессиями. Всем этим займутся драйвер/оборудование.

Этот интерфейс является чисто EN50221-интерфейсом, обменивающимся APDU.
Это означает, что в данном случае при взаимодействии приложения с драйвером
не существует ни управления сессиями, ни канального уровня, ни транспортного
уровня. Всё настолько просто. Этим должны заниматься драйвер/оборудование.

С этим высокоуровневым CI-интерфейсом интерфейс может быть определён
с помощью обычных ioctl'ов.

Все эти ioctl'ы также действительны для высокоуровневого CI-интерфейса

#define CA_RESET          _IO('o', 128)
#define CA_GET_CAP        _IOR('o', 129, ca_caps_t)
#define CA_GET_SLOT_INFO  _IOR('o', 130, ca_slot_info_t)
#define CA_GET_DESCR_INFO _IOR('o', 131, ca_descr_info_t)
#define CA_GET_MSG        _IOR('o', 132, ca_msg_t)
#define CA_SEND_MSG       _IOW('o', 133, ca_msg_t)
#define CA_SET_DESCR      _IOW('o', 134, ca_descr_t)


При опросе устройства устройство выдаёт информацию следующим образом:

.. code-block:: none

	CA_GET_SLOT_INFO
	----------------------------
	Command = [info]
	APP: Number=[1]
	APP: Type=[1]
	APP: flags=[1]
	APP: CI High level interface
	APP: CA/CI Module Present

	CA_GET_CAP
	----------------------------
	Command = [caps]
	APP: Slots=[1]
	APP: Type=[1]
	APP: Descrambler keys=[16]
	APP: Type=[1]

	CA_SEND_MSG
	----------------------------
	Descriptors(Program Level)=[ 09 06 06 04 05 50 ff f1]
	Found CA descriptor @ program level

	(20) ES type=[2] ES pid=[201]  ES length =[0 (0x0)]
	(25) ES type=[4] ES pid=[301]  ES length =[0 (0x0)]
	ca_message length is 25 (0x19) bytes
	EN50221 CA MSG=[ 9f 80 32 19 03 01 2d d1 f0 08 01 09 06 06 04 05 50 ff f1 02 e0 c9 00 00 04 e1 2d 00 00]


Не все ioctl'ы из API реализованы в драйвере; остальные
возможности оборудования, которые не могут быть реализованы через API,
достигаются с помощью ioctl'ов CA_GET_MSG и CA_SEND_MSG. Для обмена
данными используется обёртка в стиле EN50221, чтобы сохранить совместимость
с другим оборудованием.

.. code-block:: c

	/* a message to/from a CI-CAM */
	typedef struct ca_msg {
		unsigned int index;
		unsigned int type;
		unsigned int length;
		unsigned char msg[256];
	} ca_msg_t;


Поток данных можно описать следующим образом,

.. code-block:: none

	App (User)
	-----
	parse
	  |
	  |
	  v
	en50221 APDU (package)
   --------------------------------------
   |	  |				| High Level CI driver
   |	  |				|
   |	  v				|
   |	en50221 APDU (unpackage)	|
   |	  |				|
   |	  |				|
   |	  v				|
   |	sanity checks			|
   |	  |				|
   |	  |				|
   |	  v				|
   |	do (H/W dep)			|
   --------------------------------------
	  |    Hardware
	  |
	  v

Высокоуровневый CI-интерфейс использует DVB-стандарт EN50221; следование
стандарту обеспечивает готовность к будущему.
