{ config, lib, pkgs, ... }: {
  options.aspects.development.qmk.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.development.qmk.enable {
    services.udev.packages = with pkgs; [
      qmk-udev-rules
    ];

    aspects.base.persistence.homePaths = [
      ".config/qmk"
    ];
  };
}
