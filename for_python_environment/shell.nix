{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [ pkgs.python39Full pkgs.python39Packages.invoke pkgs.python39Packages.pip pkgs.python39Packages.pipx pkgs.docker-compose pkgs.docker pkgs.vscodium-fhs];
    shellHook = ''
        pipx install copier 
        pipx install pre-commit
        pipx ensurepath
    '';
}
