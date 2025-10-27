{
  config,
  lib,
  ...
}:
{
  options.aspects.development.android.enable = lib.mkEnableOption "android";

  config = lib.mkIf config.aspects.development.android.enable {
    aspects.base.persistence.homePaths = [
      ".android"
    ];

    programs.adb.enable = true;
    users.users.jocelyn.extraGroups = [ "adbusers" ];
  };
}
