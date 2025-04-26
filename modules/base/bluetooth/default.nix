{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.base.bluetooth.enable = lib.mkEnableOption "bluetooth";

  config = lib.mkIf config.aspects.base.bluetooth.enable {
    aspects.base.persistence.systemPaths = [
      "/var/lib/bluetooth"
    ];

    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      bluez
      blueberry
    ];
  };
}
