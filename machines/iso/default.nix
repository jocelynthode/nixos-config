{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  # Machine-specific module settings
  aspects = {
    stateVersion = "22.05";
    base = {
      bluetooth.enable = true;
      network = {
        hostname = "servetek";
      };
    };
  };
}


