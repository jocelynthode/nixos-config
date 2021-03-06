{ pkgs, ... }: {
  imports = [
    ./direnv.nix
    ./git.nix
    ./htop.nix
    ./kubernetes.nix
    ./ranger.nix
    ./rbw.nix
    ./taskwarrior.nix
    ./taxi.nix
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
