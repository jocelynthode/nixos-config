{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.graphical.protonvpn.enable = lib.mkEnableOption "protonvpn";

  config = lib.mkIf config.aspects.graphical.printer.enable {
    aspects.base.persistence.homePaths = [
      ".config/Proton"
    ];

    home-manager.users.jocelyn = {
      home.packages = with pkgs; [
        proton-vpn
      ];
    };
  };
}
