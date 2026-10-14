# Wi-Fi через nmcli: автоподключение и приоритет сети

`nmcli` — консольная утилита для управления NetworkManager в Linux.
Команды ниже выполняются на Linux-компьютере, где NetworkManager управляет Wi-Fi.

## Пример: подключаться к Elvatech-public при запуске

Задача: при включении компьютера автоматически подключаться к `Elvatech-public`,
а автоматическое подключение к `TP-Link_9C2B_5G` и `TP-Link_9C2B` отключить.
Профиль `Elvatech-public` уже сохранён вместе с данными для подключения.

### 1. Посмотреть доступные сети и сохранённые профили

```bash
# Доступные Wi-Fi сети; звёздочка * обозначает текущее подключение
nmcli device wifi list

# Сохранённые профили подключений
nmcli -f NAME,UUID,TYPE connection show
```

SSID — название Wi-Fi сети, а `NAME` — имя сохранённого профиля NetworkManager.
Они могут отличаться. В командах `connection modify` и `connection up` нужно
указывать имя профиля из столбца `NAME`.

В этом примере имена профилей совпадают с SSID:

```text
NAME              TYPE
Elvatech-public   wifi
TP-Link_9C2B      wifi
TP-Link_9C2B_5G   wifi
```

### 2. Настроить автоматическое подключение

```bash
sudo nmcli connection modify "Elvatech-public" connection.autoconnect yes connection.autoconnect-priority 999
sudo nmcli connection modify "TP-Link_9C2B_5G" connection.autoconnect no
sudo nmcli connection modify "TP-Link_9C2B" connection.autoconnect no
```

Если работаешь от `root` (например, приглашение `root@som:~#`), выполняй команды
без `sudo`.

Что означают параметры:

| Параметр | Значение | Действие |
| --- | --- | --- |
| `connection.autoconnect` | `yes` | Разрешить автоматическое подключение к этому профилю |
| `connection.autoconnect` | `no` | Отключить автоматическое подключение; ручное подключение остаётся доступным |
| `connection.autoconnect-priority` | `999` | Задать максимальный приоритет среди профилей, доступных для автоподключения |

Приоритет задаётся в диапазоне от `-999` до `999`, по умолчанию — `0`.
Чем выше число, тем предпочтительнее профиль. При одинаковом приоритете
NetworkManager выбирает профиль, использованный последним.

Настройки сохраняются в профилях и действуют после перезагрузки.
Перезапускать NetworkManager для этих изменений не нужно.

### 3. Подключиться прямо сейчас

```bash
sudo nmcli connection up "Elvatech-public"
```

Изменение приоритета само по себе не переключает уже активное подключение.
Команда `connection up` активирует нужный профиль сразу. Если управляешь
компьютером через SSH по Wi-Fi, при переключении сетей SSH-соединение может оборваться.

### 4. Проверить результат

```bash
# Настройки желаемого профиля
nmcli -f connection.id,connection.autoconnect,connection.autoconnect-priority connection show "Elvatech-public"

# Автоподключение ко всем сохранённым профилям
nmcli -f NAME,UUID,AUTOCONNECT connection show

# Текущие активные подключения
nmcli connection show --active
```

Для `Elvatech-public` должны быть `connection.autoconnect: yes` и
`connection.autoconnect-priority: 999`. Для обоих профилей TP-Link в столбце
`AUTOCONNECT` должно быть `no`.

Автоподключение к `Elvatech-public` возможно, когда сеть доступна и сохранённые
данные позволяют подключиться. Если её нет, эти два профиля TP-Link автоматически
не подключатся. Другие сохранённые Wi-Fi профили с `autoconnect yes` остаются
кандидатами на автоподключение.

## Вариант: оставить TP-Link как резервную сеть

Если нужен автоматический переход на TP-Link при недоступности `Elvatech-public`,
разреши автоподключение к TP-Link с меньшим приоритетом:

```bash
sudo nmcli connection modify "TP-Link_9C2B_5G" connection.autoconnect yes connection.autoconnect-priority 0
sudo nmcli connection modify "TP-Link_9C2B" connection.autoconnect yes connection.autoconnect-priority -10
```

Приоритет `Elvatech-public` остаётся `999`. NetworkManager предпочитает её при
выборе подключения, если она доступна. Если компьютер уже подключился к TP-Link,
появление `Elvatech-public` не вызовет автоматического переключения — для этого
можно выполнить `nmcli connection up "Elvatech-public"`.

## Если имя профиля отличается или встречается несколько раз

Возьми UUID нужного профиля из `nmcli -f NAME,UUID,TYPE connection show` и используй
его вместо имени. Пример с UUID профиля `Elvatech-public` из исходного списка:

```bash
sudo nmcli connection modify uuid 72e89425-8cfa-4989-9208-6df1bd8e018b connection.autoconnect yes connection.autoconnect-priority 999
sudo nmcli connection up uuid 72e89425-8cfa-4989-9208-6df1bd8e018b
```

На другом компьютере или после пересоздания профиля UUID будет другим.
Несколько строк с одинаковым SSID в `nmcli device wifi list` могут обозначать
разные точки доступа одной сети; это не обязательно несколько сохранённых профилей.

## Документация

- [NetworkManager: autoconnect и autoconnect-priority](https://www.networkmanager.dev/docs/api/latest/settings-connection.html)
- Локальная справка: `man nmcli` и `man nm-settings-nmcli`.
