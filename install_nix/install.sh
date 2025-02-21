#!/bin/bash

set -e  # Sai imediatamente se um comando falhar

# Verifica se está rodando como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script deve ser executado como root!" >&2
    exit 1
fi

echo "Criando grupo 'nixbld' se não existir..."
groupadd nixbld || true

echo "Criando usuários para 'nixbld'..."
for i in {1..10}; do
    useradd -m -s /usr/sbin/nologin -g nixbld nixbld$i || true
done

echo "Criando diretório /nix e ajustando permissões..."
mkdir -p /nix
chown root:nixbld /nix
chmod 0755 /nix

echo "Baixando e instalando o Nix..."
curl -L https://nixos.org/nix/install | sh

echo "Instalação do Nix concluída!"
echo "Execute 'source /root/.nix-profile/etc/profile.d/nix.sh' para ativar o ambiente Nix imediatamente."
