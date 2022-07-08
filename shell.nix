{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nix
    git
    rage
    ragenix
  ];
}
