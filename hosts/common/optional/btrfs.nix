{ lib, hostname, ... }: {

  boot = {
    initrd = {
      postDeviceCommands = lib.mkBefore ''
        mkdir -p /mnt
        mount -o subvol=/ /dev/disk/by-label/${hostname} /mnt
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
    };
    resumeDevice = "/dev/disk/by-label/${hostname}";
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd:1" "subvol=@" ];
    };

    "/var/log" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd:1" "subvol=@log" ];
      neededForBoot = true;
    };

    "/nix" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd:1" "subvol=@nix" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd:1" "subvol=@persist" ];
      neededForBoot = true;
    };

    "/.snapshots" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd:1" "subvol=@snapshots" ];
      neededForBoot = true;
    };

    "/swap" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd:1" "subvol=@swap" ];
    };

    "/boot/efi" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = [ "defaults" "noatime" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 32);
  }];
}
