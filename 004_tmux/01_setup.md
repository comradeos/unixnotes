# Настройка Vim-режима в tmux

Откройте конфиг:

```bash
vim ~/.tmux.conf
```

Добавьте:

```tmux
setw -g mode-keys vi
set -g mouse on

bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
bind-key -T copy-mode-vi Enter send-keys -X copy-selection-and-cancel
```

Смысл:

- `mode-keys vi` включает привычные клавиши Vim
- `mouse on` включает мышь
- `v` начинает выделение
- `y` копирует выделение
- `Enter` тоже может завершать копирование

После сохранения перечитайте конфиг:

```bash
tmux source-file ~/.tmux.conf
```

Или внутри `tmux`:

```text
Ctrl+b :
```

Дальше введите:

```text
source-file ~/.tmux.conf
```
