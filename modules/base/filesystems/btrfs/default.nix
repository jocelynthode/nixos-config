{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.base.fileSystems.btrfs = {
    enable = lib.mkEnableOption "btrfs";

    encrypted = lib.mkEnableOption "encrypted";
  };

  config =
    lib.mkIf (config.aspects.base.fileSystems.enable && config.aspects.base.fileSystems.btrfs.enable)
      {
        services = {
          fstrim.enable = true;
          btrfs.autoScrub = {
            enable = true;
            fileSystems = [ "/" ]; # Scrub works on filesystem so no need to scrub all subvolumes of same fs
          };
        };

        boot = {
          supportedFilesystems = [ "btrfs" ];
          initrd = {
            systemd.extraBin = lib.mkIf config.aspects.base.persistence.enable {
              "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
              "cut" = "${pkgs.coreutils}/bin/cut";
            };
            systemd.services.restore-root = lib.mkIf config.aspects.base.persistence.enable {
              description = "Rollback BTRFS root subvolume to a pristine state";
              wantedBy = [ "initrd.target" ];
              before = [ "sysroot.mount" ];
              requires = [ "initrd-root-device.target" ];
              after = [ "initrd-root-device.target" ];
              unitConfig.DefaultDependencies = "no";
              serviceConfig.Type = "oneshot";
              script = ''
                mkdir -p /mnt
                btrfs device scan
                mount -t btrfs -o subvol=/ /dev/disk/by-label/${config.networking.hostName} /mnt
                trap 'umount /mnt' EXIT
                echo "Cleaning subvolume"
                btrfs subvolume list -o /mnt/@ | cut -f9- -d ' ' |
                while read subvolume; do
                  btrfs subvolume delete "/mnt/$subvolume"
                done && btrfs subvolume delete /mnt/@
                echo "Restoring blank subvolume"
                btrfs subvolume snapshot /mnt/@blank /mnt/@
              '';
            };
            supportedFilesystems = [ "btrfs" ];
          };
        };
      };
}
