{...}: {
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  aspects = {
    stateVersion = "23.11";
    allowReboot = true;
    base = {
      bluetooth.enable = false;
      fileSystems.zfs = {
        enable = true;
        hostId = "007f0100";
      };
    };
    development.containers.enable = true;
    programs = {
      htop.enable = true;
      yazi = {
        enable = true;
      };
    };
    services.enable = true;
  };
}
