{ pkgs, hostname, config, inputs, lib, home-manager, colorscheme, wallpaper, ... }: {

  imports = [
    ../common/rice
    ../common/cli

    ./cli
    ./desktop/i3
  ] ++ builtins.filter builtins.pathExists ([ ./desktop/${hostname} ]);

  systemd.user.startServices = "sd-switch";
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = "jocelyn";
    stateVersion = "22.11";
    homeDirectory = "/home/jocelyn";
    pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 16;
      x11.enable = true;
    };
  };
} 
