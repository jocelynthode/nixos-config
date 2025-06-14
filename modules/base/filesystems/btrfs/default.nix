{
  config,
  lib,
  ...
}: {
  options.aspects.base.fileSystems.btrfs = {
    enable = lib.mkEnableOption "btrfs";

    encrypted = lib.mkEnableOption "encrypted";
  };

  config = lib.mkIf config.aspects.base.fileSystems.btrfs.enable {
    services = {
      fstrim.enable = false;
      btrfs.autoScrub = {
        enable = true;
        fileSystems = ["/"]; # Scrub works on filesystem so no need to scrub all subvolumes of same fs
      };
    };

    boot =
      {
        supportedFilesystems = ["btrfs"];
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
          # name luks as hostname and label as hostname_crypt
          # Label btrfs partition as hostname
          luks = lib.mkIf config.aspects.base.fileSystems.btrfs.encrypted {
            gpgSupport = true;
            devices."${config.networking.hostName}" = {
              gpgCard = {
                gracePeriod = 10; # needs some time to connect
                encryptedPass = ../../../../machines/${config.networking.hostName}/gpg/luks-passphrase.asc;
                publicKey = ../../../../machines/${config.networking.hostName}/gpg/public-keys.asc;
              };
              bypassWorkqueues = true; # May improve SSD performance
              device = "/dev/disk/by-label/${config.networking.hostName}_crypt";
              preLVM = true;
              allowDiscards = true;
            };
          };
        };
        kernel.sysctl = lib.optionalAttrs (builtins.length config.swapDevices > 0) {
          "vm.swappiness" = 10;
        };
      }
      // lib.optionalAttrs (builtins.length config.swapDevices > 0) {
        resumeDevice = "/dev/disk/by-label/${config.networking.hostName}";
      };

    fileSystems =
      {
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
      }
      // lib.optionalAttrs (!config.aspects.base.fileSystems.zfs.enable) {
        "${config.aspects.base.persistence.persistPrefix}" = {
          device = "/dev/disk/by-label/${config.networking.hostName}";
          fsType = "btrfs";
          options = ["defaults" "noatime" "compress=zstd:1" "discard=async" "subvol=@persist"];
          neededForBoot = true;
        };
      }
      // lib.optionalAttrs (builtins.length config.swapDevices > 0) {
        "/swap" = {
          device = "/dev/disk/by-label/${config.networking.hostName}";
          fsType = "btrfs";
          options = ["defaults" "noatime" "compress=zstd:1" "discard=async" "subvol=@swap"];
        };
      };
  };
}
