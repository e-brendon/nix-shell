# Criando um Ambiente de Desenvolvimento com Nix e Python

## 📌 Introdução
Esse `shell.nix` configura um ambiente de desenvolvimento temporário para Python e Docker, garantindo compatibilidade e evitando a instalação permanente de pacotes no sistema.

---

## 🛠 Como Usar

### 1️⃣ Criar o arquivo `shell.nix`
Crie um arquivo chamado `shell.nix` e adicione o seguinte código:

```nix
{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # Ferramentas necessárias no ambiente
    nativeBuildInputs = [
      pkgs.python39Full
      pkgs.python39Packages.invoke
      pkgs.python39Packages.pip
      pkgs.python39Packages.pipx
      pkgs.docker-compose
      pkgs.docker
      pkgs.vscodium-fhs
    ];
    
    shellHook = ''
        pipx install copier 
        pipx install pre-commit
        pipx ensurepath
    '';
}
```

### 2️⃣ Entrar no ambiente Nix
Dentro do diretório onde o `shell.nix` foi salvo, execute:
```bash
nix-shell
```
Isso ativará o ambiente temporário e instalará todas as ferramentas especificadas.

### 3️⃣ Testar o ambiente
Dentro do `nix-shell`, execute:
```bash
python --version
pip --version
```
Se tudo estiver certo, o ambiente foi configurado corretamente.

---

## Como Usar Diferentes Versões do Python
Se precisar de uma versão diferente do Python, basta substituir `python39Full` por outra versão, como:

| Versão do Python | Pacote Nix |
|-----------------|------------|
| Python 3.8      | `pkgs.python38Full` |
| Python 3.10     | `pkgs.python310Full` |
| Python 3.11     | `pkgs.python311Full` |

### Exemplo com Python 3.10:
```nix
{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.python310Full
      pkgs.python310Packages.pip
      pkgs.python310Packages.virtualenv
    ];
}
```

---

## Como Adicionar o Django
Para incluir o Django no ambiente:
```nix
{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.python39Full
      pkgs.python39Packages.pip
      pkgs.python39Packages.virtualenv
    ];
    
    shellHook = ''
        pip install django
    '';
}
```

Depois de entrar no ambiente `nix-shell`, verifique a instalação do Django:
```bash
django-admin --version
```

---

## Resumo
1️⃣ **Criar o `shell.nix`** com as ferramentas necessárias.
2️⃣ **Rodar `nix-shell`** para entrar no ambiente isolado.
3️⃣ **Modificar a versão do Python** conforme a necessidade.
4️⃣ **Adicionar pacotes extras como Django** editando o `shell.nix`.

Isso garante um ambiente de desenvolvimento flexível e isolado!

