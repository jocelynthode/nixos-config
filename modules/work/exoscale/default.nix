{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    aspects.work.exoscale.enable = lib.mkEnableOption "exoscale";
  };

  config = lib.mkIf config.aspects.work.openstack.enable {
    aspects.base.persistence.homePaths = [
      ".config/exoscale"
    ];

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        exoscale-cli
      ];
    };
  };
}
