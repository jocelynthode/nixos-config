{
  config,
  lib,
  ...
}: {
  options.aspects.base.btrfs = {
    enable = lib.mkEnableOption "btrfs";

    encrypted = lib.mkEnableOption "encrypted";
  };

  config = lib.mkIf config.aspects.base.btrfs.enable {
    services = {
      fstrim.enable = false;
      btrfs.autoScrub = {
        enable = true;
        fileSystems = ["/"]; # Scrub works on filesystem so no need to scrub all subvolumes of same fs
      };
    };

    boot = {
      supportedFilesystems = ["btrfs"];
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
      initrd = {
        postDeviceCommands = lib.mkBefore ''
          mkdir -p /mnt
          btrfs device scan
          mount -o subvol=/ /dev/disk/by-label/${config.networking.hostName} /mnt
          echo "Cleaning subvolume"
          btrfs subvolume list -o /mnt/@ | cut -f9 -d ' ' |
          while read subvolume; do
            btrfs subvolume delete "/mnt/$subvolume"
          done && btrfs subvolume delete /mnt/@
          echo "Restoring blank subvolume"
          btrfs subvolume snapshot /mnt/@blank /mnt/@
          umount /mnt
        '';
        supportedFilesystems = ["btrfs"];
        luks = lib.mkIf config.aspects.base.btrfs.encrypted {
          devices."${config.networking.hostName}" = {
            device = "/dev/disk/by-label/${config.networking.hostName}_crypt";
            preLVM = true;
            allowDiscards = true;
          };
        };
      };
      resumeDevice = "/dev/disk/by-label/${config.networking.hostName}";
      kernel.sysctl = {
        "vm.swappiness" = 10;
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/${config.networking.hostName}";
        fsType = "btrfs";
        options = ["defaults" "noatime" "compress=zstd:1" "discard=async" "subvol=@"];
      };

      "/var/log" = {
        device = "/dev/disk/by-label/${config.networking.hostName}";
        fsType = "btrfs";
        options = ["defaults" "noatime" "compress=zstd:1" "discard=async" "subvol=@log"];
        neededForBoot = true;
      };

      "/nix" = {
        device = "/dev/disk/by-label/${config.networking.hostName}";
        fsType = "btrfs";
        options = ["defaults" "noatime" "compress=zstd:1" "discard=async" "subvol=@nix"];
      };

      "${config.aspects.base.persistence.persistPrefix}" = {
        device = "/dev/disk/by-label/${config.networking.hostName}";
        fsType = "btrfs";
        options = ["defaults" "noatime" "compress=zstd:1" "discard=async" "subvol=@persist"];
        neededForBoot = true;
      };

      "${config.aspects.base.persistence.persistPrefix}/.snapshots" = {
        device = "/dev/disk/by-label/${config.networking.hostName}";
        fsType = "btrfs";
        options = ["defaults" "noatime" "compress=zstd:1" "discard=async" "subvol=@snapshots"];
        neededForBoot = true;
      };

      "/swap" = {
        device = "/dev/disk/by-label/${config.networking.hostName}";
        fsType = "btrfs";
        options = ["defaults" "noatime" "compress=zstd:1" "discard=async" "subvol=@swap"];
      };

      "/boot/efi" = {
        device = "/dev/disk/by-label/EFI";
        fsType = "vfat";
        options = ["defaults" "noatime"];
      };
    };
  };
}
