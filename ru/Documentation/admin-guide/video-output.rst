Управление переключателем видеовыхода
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

2006 luming.yu@intel.com

Драйвер класса sysfs output предоставляет абстрактный слой видеовывода, который
можно использовать для привязки платформозависимых методов включения/выключения
устройства видеовывода через общий интерфейс sysfs. Например, на моём ноутбуке
IBM ThinkPad T42 драйвер ACPI video зарегистрировал свои устройства видеовывода и
метод чтения/записи для 'state' в классе sysfs output. Пользовательский интерфейс
в sysfs выглядит так::

  linux:/sys/class/video_output # tree .
  .
  |-- CRT0
  |   |-- device -> ../../../devices/pci0000:00/0000:00:01.0
  |   |-- state
  |   |-- subsystem -> ../../../class/video_output
  |   `-- uevent
  |-- DVI0
  |   |-- device -> ../../../devices/pci0000:00/0000:00:01.0
  |   |-- state
  |   |-- subsystem -> ../../../class/video_output
  |   `-- uevent
  |-- LCD0
  |   |-- device -> ../../../devices/pci0000:00/0000:00:01.0
  |   |-- state
  |   |-- subsystem -> ../../../class/video_output
  |   `-- uevent
  `-- TV0
     |-- device -> ../../../devices/pci0000:00/0000:00:01.0
     |-- state
     |-- subsystem -> ../../../class/video_output
     `-- uevent
