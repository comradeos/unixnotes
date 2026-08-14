# Как подключаться по SSH-ключу

Обычное подключение:

```bash
ssh user@server
```

Если нужен явный путь к ключу:

```bash
ssh -i ~/.ssh/id_ed25519 user@server
```

Если нестандартный порт:

```bash
ssh -p 2222 -i ~/.ssh/id_ed25519 user@server
```

Пример:

```bash
ssh -p 2222 -i ~/.ssh/id_ed25519 ubuntu@203.0.113.15
```

Удобный вариант через `~/.ssh/config`:

```sshconfig
Host myserver
    HostName 203.0.113.15
    User ubuntu
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
```

После этого можно подключаться так:

```bash
ssh myserver
```

Если не работает, проверьте:

- ключ добавлен в `~/.ssh/authorized_keys` нужного пользователя
- права на сервере: `700` для `~/.ssh`
- права на сервере: `600` для `~/.ssh/authorized_keys`
