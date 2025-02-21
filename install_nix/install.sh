#!/bin/bash

set -e  # Sai imediatamente se um comando falhar

# Verifica se está rodando como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script deve ser executado como root!" >&2
    exit 1
fi

echo "Criando grupo 'nixbld' se não existir..."
if ! getent group nixbld >/dev/null; then
    groupadd nixbld
fi

echo "Criando usuários para 'nixbld'..."
for i in {1..10}; do
    if ! id "nixbld$i" &>/dev/null; then
        useradd -m -s /usr/sbin/nologin -g nixbld "nixbld$i"
    fi
done

echo "Garantindo permissões corretas..."
chown root:nixbld /nix
chmod 0755 /nix
for i in {1..10}; do
    usermod -aG nixbld "nixbld$i"
done

echo "Baixando e instalando o Nix em modo multiusuário..."
sh <(curl -L https://nixos.org/nix/install) --daemon

echo "Instalação do Nix concluída!"
echo "Execute 'source /etc/profile' para ativar o ambiente Nix imediatamente."
