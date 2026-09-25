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
nc -zv <адрес> <порт>   # порт открыт (open)

