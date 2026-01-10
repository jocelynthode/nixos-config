{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.development.android.enable = lib.mkEnableOption "android";

  config = lib.mkIf config.aspects.development.android.enable {
    aspects.base.persistence.homePaths = [
      ".android"
    ];

    environment.systemPackages = with pkgs; [
      android-tools
    ];
    users.users.jocelyn.extraGroups = [ "adbusers" ];
  };
}
