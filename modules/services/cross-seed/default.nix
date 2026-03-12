{ config, lib, ... }:
{
  options.aspects.services.cross-seed.enable = lib.mkEnableOption "cross-seed";

  config = lib.mkIf config.aspects.services.cross-seed.enable {
    aspects.base.persistence.systemPaths = [
      "/var/lib/cross-seed"
    ];

    services.cross-seed = {
      enable = true;
      group = "media";
      useGenConfigDefaults = true;
      settings = {
        linkDirs = [ "/data/cross-seeds" ];
        matchMode = "partial";
        linkType = "reflink";
        duplicateCategories = true;
        outputDir = null;
        maxDataDepth = 3;
      };
      settingsFile = config.sops.secrets.crossSeed.path;
    };

    systemd.services.cross-seed.serviceConfig = {
      # 0002 allows the group to write to files created by cross-seed
      UMask = "0002";
    };

    sops.secrets.crossSeed = {
      sopsFile = ../../../secrets/${config.networking.hostName}/secrets.yaml;
      owner = "cross-seed";
      restartUnits = [
        "cross-seed.service"
      ];
    };
  };
}
