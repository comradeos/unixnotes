#!/usr/bin/env bash
set -e

echo "[*] Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "[*] Adding Microsoft repository for .NET 9..."
wget -q https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
sudo dpkg -i /tmp/packages-microsoft-prod.deb
sudo apt update -y

echo "[*] Installing tools..."
sudo apt install -y \
    git \
    vim \
    nano \
    mc \
    btop \
    htop \
    gcc \
    g++ \
    make \
    python3 python3-pip \
    default-jdk default-jre \
    php-cli php-common php-mbstring php-xml php-curl \
    golang \
    nodejs npm \
    erlang-base erlang-dev erlang-tools \
    nginx \
    bat \
    tmux \
    rustc cargo \
    docker.io docker-compose \
    dotnet-sdk-9.0

# Docker without sudo
echo "[*] Configuring Docker group..."
sudo groupadd docker || true
sudo usermod -aG docker "$USER"

# Versions check
echo "[*] Installed versions:"
echo -n "git: "; git --version
echo -n "vim: "; vim --version | head -n 1
echo -n "nano: "; nano --version | head -n 1
echo -n "mc: "; mc --version | head -n 1
echo -n "btop: "; btop --version
echo -n "htop: "; htop --version
echo -n "gcc: "; gcc --version | head -n 1
echo -n "g++: "; g++ --version | head -n 1
echo -n "make: "; make --version | head -n 1
echo -n "python3: "; python3 --version
echo -n "pip3: "; pip3 --version
echo -n "java: "; java -version 2>&1 | head -n 1
echo -n "php: "; php --version | head -n 1
echo -n "go: "; go version
echo -n "node: "; node -v
echo -n "npm: "; npm -v
echo -n "erlang: "; erl -version 2>&1
echo -n "nginx: "; nginx -v 2>&1
echo -n "bat: "; batcat --version
echo -n "tmux: "; tmux -V
echo -n "rustc: "; rustc --version
echo -n "cargo: "; cargo --version
echo -n "docker: "; docker --version
echo -n "docker-compose: "; docker-compose --version
echo -n "dotnet: "; dotnet --version

echo
echo "[*] Installation completed."
echo "[*] Re-login or run 'newgrp docker' to use Docker without sudo."
