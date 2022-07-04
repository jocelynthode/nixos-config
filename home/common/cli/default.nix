{ pkgs, ... }: {
  imports = [
    ./nvim
    ./bat.nix
    ./fish.nix
    ./fzf.nix
    ./lsd.nix
  ];
}
