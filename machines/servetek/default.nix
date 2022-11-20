{...}: {
  imports = [./hardware.nix];

  # Machine-specific module settings
  aspects = {
    stateVersion = "22.05";
    allowReboot = true;
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
