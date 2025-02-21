# Guia de Instalação do Nix

Este documento explica o funcionamento do script `install.sh`, que instala o **Nix** no modo multiusuário, corrige problemas de UID/GID e inicia um shell interativo com o pacote `hello`.

## O que este script faz?

1. **Verifica e cria o grupo `nixbld`** se não existir.
2. **Identifica se os usuários `nixbld1` a `nixbld10` já existem** e ajusta os UID/GID corretamente.
3. **Ajusta permissões no diretório `/nix`** para evitar conflitos.
4. **Baixa e instala o Nix** no modo multiusuário.
5. **Fonteia `/etc/profile`** automaticamente após a instalação.
6. **Entra automaticamente no shell Nix** (`nix-shell -p hello`).

**Após a instalação**, o terminal abrirá automaticamente o shell do Nix. Digite:
   ```bash
   hello
   ```
   Para ver a mensagem **"Hello, world!"**

## Explicação Técnica

- O script **verifica e cria** o grupo `nixbld`.
- Ele **adapta os UIDs** existentes dos usuários `nixbldX` para evitar conflitos.
- Usa `source /etc/profile` para ativar o ambiente após a instalação.
- **Finaliza executando `nix-shell -p hello`**, garantindo que o usuário já inicie no ambiente correto.

Agora seu sistema está pronto para usar o **Nix** sem erros!

