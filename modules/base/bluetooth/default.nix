{ config, lib, pkgs, ... }: {
  options.aspects.base.bluetooth.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.base.bluetooth.enable {

    environment.persistence."${config.aspects.persistPrefix}".directories = [
      "/var/lib/bluetooth"
    ];

    hardware.bluetooth.enable = true;

    environment.systemPackages = with pkgs; [
      bluez
      blueberry
    ];
  };
}
