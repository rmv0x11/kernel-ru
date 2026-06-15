======
TOMOYO
======

Что такое TOMOYO?
=================

TOMOYO — это расширение MAC на основе имён (модуль LSM) для ядра Linux.

Учебные материалы на основе LiveCD доступны по адресам

https://tomoyo.sourceforge.net/1.8/ubuntu12.04-live.html
https://tomoyo.sourceforge.net/1.8/centos6-live.html

Хотя в этих учебных материалах используется не-LSM версия TOMOYO, они полезны
для понимания того, что такое TOMOYO.

Как включить TOMOYO?
====================

Соберите ядро с ``CONFIG_SECURITY_TOMOYO=y`` и передайте ``security=tomoyo`` в
командной строке ядра.

Подробности см. на https://tomoyo.sourceforge.net/2.6/ .

Где находится документация?
===========================

Документация по интерфейсу взаимодействия пользователя и ядра (User <-> Kernel)
доступна на https://tomoyo.sourceforge.net/2.6/policy-specification/index.html .

Материалы, которые мы подготовили для семинаров и симпозиумов, доступны на
https://sourceforge.net/projects/tomoyo/files/docs/ .
Перечисленные ниже материалы выбраны исходя из трёх аспектов.

Что такое TOMOYO?
  TOMOYO Linux Overview
    https://sourceforge.net/projects/tomoyo/files/docs/lca2009-takeda.pdf
  TOMOYO Linux: pragmatic and manageable security for Linux
    https://sourceforge.net/projects/tomoyo/files/docs/freedomhectaipei-tomoyo.pdf
  TOMOYO Linux: A Practical Method to Understand and Protect Your Own Linux Box
    https://sourceforge.net/projects/tomoyo/files/docs/PacSec2007-en-no-demo.pdf

Что умеет TOMOYO?
  Deep inside TOMOYO Linux
    https://sourceforge.net/projects/tomoyo/files/docs/lca2009-kumaneko.pdf
  The role of "pathname based access control" in security.
    https://sourceforge.net/projects/tomoyo/files/docs/lfj2008-bof.pdf

История TOMOYO?
  Realities of Mainlining
    https://sourceforge.net/projects/tomoyo/files/docs/lfj2008.pdf
