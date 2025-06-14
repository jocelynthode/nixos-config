{config, ...}: {
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
                };
              };
              "${config.networking.hostName}_crypt" = {
                size = "100%";
                label = "${config.networking.hostName}_crypt";
                content = {
                  type = "luks";
                  name = "${config.networking.hostName}_crypt";
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

                      mkdir -p "$MNTPOINT"/@persist/home
                      mkdir -p "$MNTPOINT"/@persist/etc/ssh

                      ssh-keygen -q -t rsa -b 4096 -C "${config.networking.hostName}" -N "" -f "$MNTPOINT"/@persist/etc/ssh/ssh_host_rsa_key
                      ssh-keygen -t ed25519 -f "$MNTPOINT"/@persist/etc/ssh/ssh_host_ed25519_key -N ""

                      cat "$MNTPOINT"/@persist/etc/ssh/ssh_host_ed25519_key.pub
                    '';
                    subvolumes = {
                      "@" = {
                        mountpoint = "/";
                        mountOptions = ["defaults" "noatime" "compress=zstd:1" "discard=async"];
                      };
                      "@blank" = {};
                      "@log" = {
                        mountpoint = "/var/log";
                        mountOptions = ["defaults" "noatime" "compress=zstd:1" "discard=async"];
                      };
                      "@nix" = {
                        mountpoint = "/nix";
                        mountOptions = ["defaults" "noatime" "compress=zstd:1" "discard=async"];
                      };
                      "@persist" = {
                        mountpoint = "/persist";
                        mountOptions = ["defaults" "noatime" "compress=zstd:1" "discard=async"];
                      };
                      "@swap" = {
                        mountpoint = "/swap";
                        swap = {
                          swapfile = {
                            size = "32G";
                            options = ["defaults" "noatime"];
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
