{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.development.android.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.development.android.enable {
    programs.adb.enable = true;
    users.users.jocelyn.extraGroups = ["adbusers"];
    services.udev.packages = with pkgs; [
      android-udev-rules
    ];
  };
}
