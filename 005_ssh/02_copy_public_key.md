# Что куда переносить

Переносить на сервер нужно только:

```bash
~/.ssh/id_ed25519.pub
```

Не переносить:

```bash
~/.ssh/id_ed25519
```

Самый удобный способ:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@server
```

Если `ssh-copy-id` нет:

1. Показать публичный ключ:

```bash
cat ~/.ssh/id_ed25519.pub
```

2. Скопировать всю строку
3. Подключиться к серверу по паролю: `ssh user@server`
4. На сервере выполнить:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
```

5. Вставить ключ и сохранить файл
6. Выставить права:

```bash
chmod 600 ~/.ssh/authorized_keys
```
