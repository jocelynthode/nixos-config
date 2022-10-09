{ pkgs, ... }: {
  imports = [ ./hardware.nix ];

  # Machine-specific module settings
  aspects = {
    stateVersion = "22.05";
    base = {
      battery.enable = true;
      bluetooth.enable = true;
    };
    development.enable = true;
    games.enable = true;
    graphical = {
      enable = true;
      wallpaper = "palms-tropics";
      fingerprint.enable = true;
    };
    programs.enable = true;
    work.enable = true;
  };
}


