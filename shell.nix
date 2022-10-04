{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nix
    git
    sops
    ssh-to-age
  ];
}
