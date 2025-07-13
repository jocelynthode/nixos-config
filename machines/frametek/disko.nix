{ config, ... }:
{
  disko = {
    enableConfig = true;
    devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                type = "EF00";
                priority = 1;
                size = "512M";
                label = "EFI";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot/efi";
                  mountOptions = [
                    "defaults"
                    "noatime"
                    "umask=0077"
                  ];
                };
              };
              "${config.networking.hostName}_crypt" = {
                size = "100%";
                label = "${config.networking.hostName}_crypt";
                content = {
                  type = "luks";
                  name = "${config.networking.hostName}"; # Because current setup was not done through disko
                  settings = {
                    gpgCard = {
                      gracePeriod = 10; # needs some time to connect
                      encryptedPass = ./gpg/luks-passphrase.asc;
                      publicKey = ./gpg/public-keys.asc;
                    };
                    bypassWorkqueues = true; # May improve SSD performance
                    device = "/dev/disk/by-label/${config.networking.hostName}_crypt";
                    preLVM = true;
                    allowDiscards = true;
                  };
                  content = {
                    type = "btrfs";
                    extraArgs = [
                      "--label ${config.networking.hostName}"
                      "--force"
                    ];
                    postCreateHook = ''
                      MNTPOINT=$(mktemp -d)
                      mount "/dev/mapper/${config.networking.hostName}_crypt" "$MNTPOINT" -o subvol=/
                      trap 'umount "$MNTPOINT"; rm -rf "$MNTPOINT"' EXIT
                      mkdir -p "$MNTPOINT"/@blank/boot/efi
                      mkdir -p "$MNTPOINT"/@blank/mnt
                      mkdir -p "$MNTPOINT"/@blank/etc
                      systemd-machine-id-setup --root "$MNTPOINT"/@blank/
                      btrfs property set -ts "$MNTPOINT"/@blank ro true
                    '';
                    subvolumes = {
                      "@" = {
                        mountpoint = "/";
                        mountOptions = [
                          "defaults"
                          "noatime"
                          "compress=zstd:1"
                          "discard=async"
                        ];
                      };
                      "@blank" = { };
                      "@log" = {
                        mountpoint = "/var/log";
                        mountOptions = [
                          "defaults"
                          "noatime"
                          "compress=zstd:1"
                          "discard=async"
                        ];
                      };
                      "@nix" = {
                        mountpoint = "/nix";
                        mountOptions = [
                          "defaults"
                          "noatime"
                          "compress=zstd:1"
                          "discard=async"
                        ];
                      };
                      "@persist" = {
                        mountpoint = "/persist";
                        mountOptions = [
                          "defaults"
                          "noatime"
                          "compress=zstd:1"
                          "discard=async"
                        ];
                      };
                      "@swap" = {
                        mountpoint = "/swap";
                        mountOptions = [
                          "defaults"
                          "noatime"
                          "compress=zstd:1"
                          "discard=async"
                        ];
                        swap = {
                          swapfile = {
                            size = "32G";
                            options = [
                              "defaults"
                              "noatime"
                            ];
                          };
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
