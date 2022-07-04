{ config, pkgs, inputs, ... }: {
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    layout = "us";
    xkbVariant = "altgr-intl";
    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        background = "/home/jocelyn/Pictures/gruvbox/cascade.jpg";
        greeters.gtk = {
          enable = true;
          theme = {
            package = pkgs.qogir-theme;
            name = "Qogir-Dark";
          };
          iconTheme = {
            package = pkgs.papirus-icon-theme;
            name = "Papirus";
          };
          cursorTheme = {
            package = pkgs.gnome.adwaita-icon-theme;
            name = "Adwaita";
          };
        };
      };
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --off
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --primary --mode 2560x1440 --pos 1920x0 --right-of HDMI-0 
      '';
    };
    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dex
      ];
    };
  };
}
