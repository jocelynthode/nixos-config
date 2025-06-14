{
  config,
  lib,
  ...
}: {
  options.aspects.base.fileSystems.zfs = {
    enable = lib.mkEnableOption "zfs";

    hostId = lib.mkOption {
      type = lib.types.str;
      description = ''
        System hostId
      '';
    };
  };

  config = lib.mkIf config.aspects.base.fileSystems.zfs.enable {
    boot = {
      supportedFilesystems = ["zfs"];
      initrd = {
        supportedFilesystems = ["zfs"];
      };
      zfs = {
        # extraPools = ["tank"];
      };
    };

    services.zfs = {
      trim.enable = true;
      autoScrub.enable = true;
    };

    networking.hostId = config.aspects.base.fileSystems.zfs.hostId;

    fileSystems = {
      "${config.aspects.base.persistence.persistPrefix}" = {
        device = "tank/persist";
        fsType = "zfs"; #TODO use legacy mountpoint or just let zfs do its magic. Not sure yet
        neededForBoot = true;
      };
    };
  };
}
