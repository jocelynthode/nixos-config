{...}: {
  imports = [./hardware.nix];

  aspects = {
    stateVersion = "23.11";
    allowReboot = true;
    base = {
      bluetooth.enable = false;
      fileSystems = {
        btrfs.enable = true;
        zfs = {
          enable = true;
          hostId = "007f0100";
        };
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
