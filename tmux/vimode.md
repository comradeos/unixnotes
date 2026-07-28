# tmux + Vim Copy Mode

Небольшая шпаргалка по настройке и использованию **Vim-режима** в `tmux`.

---

# Настройка

Открой файл конфигурации:

```bash
vim ~/.tmux.conf
```

Добавь следующие строки:

```tmux
# Use Vim keybindings in copy mode
setw -g mode-keys vi

# Enable mouse support
set -g mouse on

# Start selection with v
bind-key -T copy-mode-vi v send-keys -X begin-selection

# Copy selection with y
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

# (Optional) Copy whole line with Enter
bind-key -T copy-mode-vi Enter send-keys -X copy-selection-and-cancel
```

---

# Перезагрузка конфигурации

После сохранения файла выполните:

```bash
tmux source-file ~/.tmux.conf
```

или внутри tmux:

```
Ctrl+b :
```

затем

```
source-file ~/.tmux.conf
```

---

# Copy Mode

Войти в режим копирования:

```
Ctrl+b [
```

После этого доступны привычные команды Vim.

---

# Навигация

| Клавиша | Действие |
|----------|----------|
| `h` | Влево |
| `j` | Вниз |
| `k` | Вверх |
| `l` | Вправо |
| `w` | Следующее слово |
| `b` | Предыдущее слово |
| `0` | Начало строки |
| `$` | Конец строки |
| `gg` | Начало буфера |
| `G` | Конец буфера |
| `Ctrl+u` | Вверх на полстраницы |
| `Ctrl+d` | Вниз на полстраницы |
| `/текст` | Поиск |
| `n` | Следующее совпадение |
| `N` | Предыдущее совпадение |

---

# Копирование текста

1. Войти в Copy Mode

```
Ctrl+b [
```

2. Начать выделение

```
v
```

3. Перемещаться клавишами

```
h j k l
```

или любыми другими командами Vim.

4. Скопировать выделение

```
y
```

---

# Вставка

В активной панели tmux:

```
Ctrl+b ]
```

---

# Быстрый пример

```
Ctrl+b [
```

↓

```
v
```

↓

Выделить текст

↓

```
y
```

↓

Перейти в другую панель

↓

```
Ctrl+b ]
```

---

# Полезные советы

## Включение мыши

```tmux
set -g mouse on
```

Позволяет:

- выделять текст мышью;
- прокручивать историю колесиком;
- переключаться между панелями мышью.

---

## Использование Vim-клавиш

```tmux
setw -g mode-keys vi
```

После этого режим копирования становится максимально похожим на Vim.

---

# Минимальная рекомендуемая конфигурация

```tmux
# Vim keys
setw -g mode-keys vi

# Mouse support
set -g mouse on

# Selection
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
```

