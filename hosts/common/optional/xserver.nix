{ config, pkgs, inputs, ... }: {
  hardware.opengl.enable = true;
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        background = pkgs.wallpapers.cascade-fisher;
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
