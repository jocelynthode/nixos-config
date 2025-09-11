{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    aspects.work.vpn.enable = lib.mkEnableOption "vpn";
  };

  config = lib.mkIf config.aspects.work.vpn.enable {
    aspects.base.persistence.homePaths = [
      ".local/share/networkmanagement/certificates"
      ".config/snx-rs"
    ];

    # TODO create systemd service for snx-rs -m command for gui ?
    environment.systemPackages = with pkgs; [
      snx-rs
    ];
  };
}
