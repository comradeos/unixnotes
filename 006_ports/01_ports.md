# Проверка порта на сервере
sudo iptables -L INPUT -n | grep <порт>
sudo ufw status | grep <порт>

# Открыли порт
sudo iptables -I INPUT -p tcp --dport <порт> -j ACCEPT
sudo iptables-save | sudo tee /etc/iptables/rules.v4
sudo ufw allow <порт>/tcp
sudo ufw reload

# Проверка что сервер запущен
ss -tlnp | grep <порт>          # сервер слушает на <порт>
ps aux | grep <название процеса>   # процесс запущен от root

# Проверка доступности порта снаружи
nc -zv <адрес> <порт>         # порт открыт (open)
nc -zv -w2 <адрес> <порт>     # с таймаутом 2 сек (не висит если роутер не отвечает)

# -z  — только проверить порт, не отправлять данные
# -v  — verbose, показать результат (succeeded / refused)
# -w2 — timeout 2 секунды

# Проверить несколько портов сразу
for port in 3010 3020 3030 4010; do
  result=$(nc -zv -w2 <адрес> $port 2>&1)
  echo "port $port: $result"
done

# Результаты:
# succeeded!           — порт открыт и доступен
# Connection refused   — сервер слушает, но порт закрыт firewall'ом
# timed out / зависает — роутер не пробросил порт (firewall роутера)

# Сохранение правил iptables (чтобы не слетали после перезагрузки)
sudo mkdir -p /etc/iptables
sudo iptables -I INPUT -p tcp --dport <порт> -j ACCEPT
sudo iptables-save | sudo tee /etc/iptables/rules.v4

# Установить автовосстановление правил при загрузке (Debian/Ubuntu)
sudo apt install iptables-persistent -y
# При установке спросит сохранить текущие правила — ответить Yes

# Проверить локальный IP на macOS
ipconfig getifaddr en0

# Проверить все интерфейсы
ifconfig | grep "inet " | grep -v 127.0.0.1

