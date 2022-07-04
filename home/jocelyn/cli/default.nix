{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./htop.nix
    ./kubernetes.nix
    ./ranger.nix
    ./rbw.nix
    ./taskwarrior.nix
  ];
  home.packages = with pkgs; [
    fd
    ripgrep
    delta
    rsync
    unzip
    terraform
    libnotify
  ];
}
