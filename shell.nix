{ pkgs ? import <nixpkgs> {} }:
let
  lib = import <nixpkgs/lib>;
in pkgs.mkShell {
  packages = with pkgs; [
    (python3.withPackages (ps: with ps; with python3Packages; [
      virtualenv
    ]))

    (writeShellScriptBin "fix-python-venv" ''
      nix shell github:GuillaumeDesforges/fix-python --command fix-python --venv .venv
    '')
  ];
  shellHook = ''
    test -d .venv || python3 -m venv .venv --copies
    test -f .venv/.gitignore || echo '*' > .venv/.gitignore
    source .venv/bin/activate
   
    touch requirements.txt
    test -f requirements.txt || python3 -m pip install -r requirements.txt
  '';
}


