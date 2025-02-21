#!/bin/bash

set -e  # Sai imediatamente se um comando falhar

# Verifica se está rodando como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script deve ser executado como root!" >&2
    exit 1
fi

echo "Verificando se o grupo 'nixbld' existe..."
if getent group nixbld >/dev/null; then
    NIX_BUILD_GROUP_ID=$(getent group nixbld | cut -d: -f3)
    echo "Grupo 'nixbld' já existe com GID $NIX_BUILD_GROUP_ID"
else
    echo "Criando grupo 'nixbld'..."
    groupadd nixbld
    NIX_BUILD_GROUP_ID=$(getent group nixbld | cut -d: -f3)
fi

echo "Verificando usuários 'nixbldX' existentes..."
EXISTING_UID=$(id -u nixbld1 2>/dev/null || echo "not_found")

if [[ "$EXISTING_UID" != "not_found" ]]; then
    echo "Usuário 'nixbld1' já existe com UID $EXISTING_UID"
    NIX_FIRST_BUILD_UID=$EXISTING_UID
else
    echo "Criando usuários para 'nixbld'..."
    NIX_FIRST_BUILD_UID=30000  # Define um UID inicial válido
    for i in {1..10}; do
        if ! id "nixbld$i" &>/dev/null; then
            useradd -m -s /usr/sbin/nologin -u $((NIX_FIRST_BUILD_UID + i - 1)) -g nixbld "nixbld$i"
        fi
    done
fi

echo "Garantindo permissões corretas..."
chown root:nixbld /nix
chmod 0755 /nix
for i in {1..10}; do
    usermod -aG nixbld "nixbld$i" || true
done

echo "Exportando variáveis para compatibilidade..."
export NIX_BUILD_GROUP_ID=$NIX_BUILD_GROUP_ID
export NIX_FIRST_BUILD_UID=$NIX_FIRST_BUILD_UID

echo "Baixando e instalando o Nix em modo multiusuário..."
sh <(curl -L https://nixos.org/nix/install) --daemon

echo "Instalação do Nix concluída!"
echo "Carregando ambiente Nix..."
source /etc/profile

echo "Entrando no shell do Nix com o pacote 'hello'..."
exec nix-shell -p hello
