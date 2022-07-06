{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nix
    git
    age
    ssh-to-pgp
    ssh-to-age
    gnupg
    sops
  ];
}
