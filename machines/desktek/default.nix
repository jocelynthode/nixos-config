{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  # Machine-specific module settings
  aspects = {
    stateVersion = "22.05";
    base = {
      bluetooth.enable = true;
    };
    development.enable = true;
    games.enable = true;
    graphical = {
      enable = true;
      wallpaper = "palms-tropics";
      printer.enable = true;
    };
    programs = {
      enable = true;
      solaar.enable = true;
    };
    work.enable = true;
  };
}

