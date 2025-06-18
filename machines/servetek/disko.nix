{config, ...}: {
  disko = {
    enableConfig = true;
    devices = {
      disk = {
        nvme = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                type = "EF00";
                size = "512M";
                label = "EFI";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot/efi";
                  mountOptions = ["umask=0077"];
                };
              };
              root = {
                size = "100%";
                label = "${config.networking.hostName}";
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "--label ${config.networking.hostName}"
                    "--force"
                  ];
                  postCreateHook = ''
                    MNTPOINT=$(mktemp -d)
                    mount "/dev/disk/by-partlabel/${config.networking.hostName}" "$MNTPOINT" -o subvol=/
                    trap 'umount "$MNTPOINT"; rm -rf "$MNTPOINT"' EXIT
                    mkdir -p "$MNTPOINT"/@blank/boot/efi
                    mkdir -p "$MNTPOINT"/@blank/mnt
                    mkdir -p "$MNTPOINT"/@blank/etc
                    systemd-machine-id-setup --root "$MNTPOINT"/@blank/
                    cp /etc/machine-id "$MNTPOINT"/@blank/etc/
                    btrfs property set -ts "$MNTPOINT"/@blank ro true
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
                  };
                };
              };
            };
          };
        };
        hdd1 = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                label = "hdd1";
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
        hdd3 = {
          type = "disk";
          device = "/dev/sdb";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                label = "hdd3";
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
        hdd5 = {
          type = "disk";
          device = "/dev/sdc";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                label = "hdd5";
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
        hdd7 = {
          type = "disk";
          device = "/dev/sdd";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                label = "hdd7";
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };
      zpool = {
        tank = {
          mode = "raidz1";
          mountpoint = null;
          options = {
            ashift = "12";
            autotrim = "on";
          };
          rootFsOptions = {
            compression = "lz4";
            acltype = "posixacl";
            atime = "off";
            xattr = "sa";
            dnodesize = "auto";
            normalization = "formD";
            mountpoint = "none";
          };
          datasets = {
            media = {
              type = "zfs_fs";
              mountpoint = "/srv/media";
              options = {
                mountpoint = "legacy";
                exec = "off";
                recordsize = "1M";
              };
            };
            downloads = {
              type = "zfs_fs";
              mountpoint = "/srv/downloads";
              options = {
                mountpoint = "legacy";
                exec = "off";
                recordsize = "1M";
                sync = "disabled";
              };
            };
            persist = {
              type = "zfs_fs";
              options = {
                mountpoint = "legacy";
              };
              mountpoint = "/persist";
            };
            backup = {
              type = "zfs_fs";
              options = {
                mountpoint = "legacy";
                exec = "off";
                compression = "zstd:3";
              };
              mountpoint = "/srv/backup";
            };
            reserved = {
              type = "zfs_fs";
              options = {
                refreservation = "3.8T";
              };
            };
          };
        };
      };
    };
  };
}
