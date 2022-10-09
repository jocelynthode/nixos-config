{ pkgs, ... }: {
  imports = [ ./hardware.nix ];

  # Machine-specific module settings
  aspects = {
    stateVersion = "22.05";
    base = {
      bluetooth.enable = true;
    };
    programs = {
      htop.enable = true;
      ranger.enable = true;
    };
    services.enable = true;
  };
}

