{
  config,
  lib,
  ...
}:
{
  imports = [
    ./btrfs
    ./zfs
  ];

  options.aspects.base.fileSystems = {
    enable = lib.mkEnableOption "fileSystems";
  };

  config = lib.mkIf config.aspects.base.fileSystems.enable {
    boot = {
      tmp = {
        useTmpfs = true;
        tmpfsSize = "20%";
      };
      loader = {
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

      kernel.sysctl = lib.optionalAttrs (builtins.length config.swapDevices > 0) {
        "vm.swappiness" = 10;
      };
    };
  };
}
