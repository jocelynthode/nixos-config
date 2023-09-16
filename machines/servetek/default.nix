{...}: {
  imports = [./hardware.nix];

  # Machine-specific module settings
  aspects = {
    stateVersion = "23.11";
    allowReboot = true;
    base = {
      bluetooth.enable = false;
    };
    development.containers.enable = true;
    programs = {
      htop.enable = true;
      ranger.enable = true;
    };
    services.enable = true;
  };
}
