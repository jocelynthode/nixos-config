{pkgs, ...}: {
  imports = [./hardware.nix];

  # Machine-specific module settings
  aspects = {
    stateVersion = "23.11";
    base = {
      bluetooth.enable = true;
    };
    development = {
      enable = true;
      ollama.enable = true;
    };
    games = {
      enable = true;
      ryujinx.enable = false;
    };
    graphical = {
      enable = true;
      sound.guitar.enable = true;
      wallpaper = "water";
      printer.enable = true;
      sway.enable = false;
      hyprland.enable = true;
      kanshi.settings = [
        {
          profile = {
            name = "default";
            outputs = [
              {
                criteria = "DP-1";
                position = "1920,0";
              }
              {
                criteria = "HDMI-A-1";
                position = "0,0";
              }
            ];
            exec = [
              "${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --primary --mode 2560x1440 --pos 1920x0 --right-of HDMI-A-1"
            ];
          };
        }
      ];
    };
    programs = {
      enable = true;
      lact.enable = true;
      logseq.enable = true;
      solaar.enable = true;
      obs-studio.enable = true;
    };
    work.enable = true;
  };
}
