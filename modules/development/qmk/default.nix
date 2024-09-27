{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.development.qmk.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.development.qmk.enable {
    services.udev = {
      packages = with pkgs; [
        qmk-udev-rules
      ];
      # extraRules = let
      #   rp-udev =
      #     pkgs.stdenv.writeShellScriptBin "rp-udev"
      #     ''
      #       ${pkgs.udisks}/bin/udisksctl mount -b /dev/disk/by-label/RPI-RP2
      #     '';
      # in ''
      #   ACTION=="add", ATTRS{idVendor}=="04d9", ATTRS{idProduct}=="2013", RUN+="${rp-udev}/bin/rp-udev", OWNER="jocelyn"
      # '';
    };
    aspects.base.persistence.homePaths = [
      ".config/qmk"
    ];
  };
}
