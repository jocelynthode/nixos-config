{ config, pkgs, ... }:

let
  base = {
    home.packages = with pkgs; [
      cachix
      fd
      ripgrep
      delta
      rsync
      unzip
    ];

    programs = {
      bat = {
        enable = true;
        config.theme = "base16";
      };
      fzf = {
        enable = true;
      };
      lsd = {
        enable = true;
        settings = {
          symlink-arrow = "⇒";
        };
      };
    };
  };
in
{
  home-manager.users.jocelyn = { ... }: base;
  home-manager.users.root = { ... }: base;
}
