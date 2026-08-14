# Как переименовывать окна в tmux

Текущее окно можно переименовать так:

```text
Ctrl+b ,
```

После этого введите новое имя окна и нажмите `Enter`.

То же самое через команду:

```bash
tmux rename-window mywindow
```

Или внутри `tmux`:

```text
Ctrl+b :
```

Дальше введите:

```text
rename-window mywindow
```

Если `tmux` сам меняет имя окна, можно отключить авто-переименование:

```tmux
set-option -g allow-rename off
```

Если нужно только для текущего окна:

```tmux
set-option allow-rename off
```
