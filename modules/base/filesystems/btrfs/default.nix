{
  config,
  lib,
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
            postDeviceCommands = lib.mkIf config.aspects.base.persistence.enable (
              lib.mkBefore ''
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
              ''
            );
            supportedFilesystems = [ "btrfs" ];
            luks = lib.mkIf config.aspects.base.fileSystems.btrfs.encrypted {
              gpgSupport = true;
            };
          };
        };
      };
}
