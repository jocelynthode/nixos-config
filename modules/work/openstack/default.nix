{
  config,
  lib,
  ...
}:
{
  options = {
    aspects.work.openstack.enable = lib.mkEnableOption "openstack";
  };

  config = lib.mkIf config.aspects.work.openstack.enable {
    aspects.base.persistence.homePaths = [
      ".config/openstack"
    ];
  };
}
