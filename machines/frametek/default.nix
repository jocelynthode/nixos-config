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
      hyprland.enable = true;
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
