{...}: {
  imports = [./hardware.nix];

  # Machine-specific module settings
  aspects = {
    stateVersion = "22.05";
    theme = "catppuccin-latte";
    allowReboot = true;
    base = {
      bluetooth.enable = true;
    };
    development.containers.enable = true;
    programs = {
      htop.enable = true;
      ranger.enable = true;
    };
    services.enable = true;
  };
}
