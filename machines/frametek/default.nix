{...}: {
  imports = [./hardware.nix];

  # Machine-specific module settings
  aspects = {
    stateVersion = "23.11";
    base = {
      battery.enable = true;
      bluetooth.enable = true;
    };
    development.enable = true;
    games.enable = false;
    graphical = {
      enable = true;
      dpi = 120;
      wallpaper = "water";
      fingerprint.enable = true;
      hyprland = {
        enable = true;
        workspace = [
          "1,monitor:eDP-1,default:true"
          "2,monitor:eDP-1"
          "3,monitor:eDP-1"
          "4,monitor:eDP-1"
          "5,monitor:eDP-1"
          "6,monitor:eDP-1"
          "7,monitor:eDP-1"
          "8,monitor:eDP-1"
          "9,monitor:eDP-1"
          "10,monitor:eDP-1"
        ];
        monitor = [
          ",highres,auto,1.175"
        ];
      };
      sway.enable = false;
      kanshi.settings = [
        {
          profile = {
            name = "default";
            outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
                scale = 1.175;
              }
            ];
          };
        }
        {
          profile = {
            name = "work";
            outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
                scale = 1.0;
              }
              {
                criteria = "DP-3";
                position = "0,1504";
                scale = 1.5;
              }
            ];
          };
        }
      ];
    };
    programs.enable = true;
    work.enable = true;
  };
}
