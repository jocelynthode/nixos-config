{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    systemd-boot = {
      enable = true;
      configurationLimit = 5; # Limit the amount of configurations
    };
    timeout = 5; # Grub auto select time
  };
}
