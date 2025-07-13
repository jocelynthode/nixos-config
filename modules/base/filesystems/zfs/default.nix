{
  config,
  lib,
  ...
}:
{
  options.aspects.base.fileSystems.zfs = {
    enable = lib.mkEnableOption "zfs";

    hostId = lib.mkOption {
      type = lib.types.str;
      description = ''
        System hostId
      '';
    };
  };

  config =
    lib.mkIf (config.aspects.base.fileSystems.enable && config.aspects.base.fileSystems.zfs.enable)
      {
        boot = {
          supportedFilesystems = [ "zfs" ];
          initrd = {
            supportedFilesystems = [ "zfs" ];
          };
          zfs = {
            forceImportRoot = false;
          };
        };

        services.zfs = {
          trim.enable = true;
          autoScrub.enable = true;
        };

        networking.hostId = config.aspects.base.fileSystems.zfs.hostId;
      };
}
