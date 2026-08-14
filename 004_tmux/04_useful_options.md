# Полезные опции

Включение мыши:

```tmux
set -g mouse on
```

Это позволяет:

- выделять текст мышью
- прокручивать историю колесиком
- переключаться между панелями мышью

Включение Vim-клавиш:

```tmux
setw -g mode-keys vi
```

После этого Copy Mode становится ближе к обычному Vim.

Минимальная рекомендуемая конфигурация:

```tmux
setw -g mode-keys vi
set -g mouse on

bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
```
