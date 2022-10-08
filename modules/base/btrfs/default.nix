{ config, lib, ... }: {
  options.aspects.base.btrfs = {
    encrypted = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = {
    aspects.persistPrefix = lib.mkDefault "/persist";

    boot = {
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
      initrd = {
        postDeviceCommands = lib.mkBefore ''
          mkdir -p /mnt
          mount -o subvol=/ /dev/disk/by-label/${config.aspects.base.network.hostname} /mnt
          echo "Cleaning subvolume"
          btrfs subvolume list -o /mnt/@ | cut -f9 -d ' ' |
          while read subvolume; do
            btrfs subvolume delete "/mnt/$subvolume"
          done && btrfs subvolume delete /mnt/@
          echo "Restoring blank subvolume"
          btrfs subvolume snapshot /mnt/@blank /mnt/@
          umount /mnt
        '';
        supportedFilesystems = [ "btrfs" ];
        luks = lib.mkIf config.aspects.base.btrfs.encrypted {
          devices."${config.aspects.base.network.hostname}" = {
            device = "/dev/disk/by-label/${config.aspects.base.network.hostname}_crypt";
            preLVM = true;
            allowDiscards = true;
          };
        };
      };
      resumeDevice = "/dev/disk/by-label/${config.aspects.base.network.hostname}";
      kernel.sysctl = {
        "vm.swappiness" = 10;
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/${config.aspects.base.network.hostname}";
        fsType = "btrfs";
        options = [ "defaults" "noatime" "compress=zstd:1" "subvol=@" ];
      };

      "/var/log" = {
        device = "/dev/disk/by-label/${config.aspects.base.network.hostname}";
        fsType = "btrfs";
        options = [ "defaults" "noatime" "compress=zstd:1" "subvol=@log" ];
        neededForBoot = true;
      };

      "/nix" = {
        device = "/dev/disk/by-label/${config.aspects.base.network.hostname}";
        fsType = "btrfs";
        options = [ "defaults" "noatime" "compress=zstd:1" "subvol=@nix" ];
      };

      "${config.aspects.persistPrefix}" = {
        device = "/dev/disk/by-label/${config.aspects.base.network.hostname}";
        fsType = "btrfs";
        options = [ "defaults" "noatime" "compress=zstd:1" "subvol=@persist" ];
        neededForBoot = true;
      };

      "${config.aspects.persistPrefix}/.snapshots" = {
        device = "/dev/disk/by-label/${config.aspects.base.network.hostname}";
        fsType = "btrfs";
        options = [ "defaults" "noatime" "compress=zstd:1" "subvol=@snapshots" ];
        neededForBoot = true;
      };

      "/swap" = {
        device = "/dev/disk/by-label/${config.aspects.base.network.hostname}";
        fsType = "btrfs";
        options = [ "defaults" "noatime" "compress=zstd:1" "subvol=@swap" ];
      };

      "/boot/efi" = {
        device = "/dev/disk/by-label/EFI";
        fsType = "vfat";
        options = [ "defaults" "noatime" ];
      };
    };

    environment.persistence."${config.aspects.persistPrefix}".hideMounts = true;
  };
}
