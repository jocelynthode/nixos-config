{...}: {
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  aspects = {
    stateVersion = "25.05";
    allowReboot = true;
    base = {
      bluetooth.enable = false;
      fileSystems.zfs = {
        enable = true;
        hostId = "007f0100";
      };
    };
    programs = {
      htop.enable = true;
      yazi = {
        enable = true;
      };
    };
    services.enable = true;
  };
}
