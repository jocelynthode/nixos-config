{
  config,
  lib,
  ...
}:
{
  options = {
    aspects.work.tailscale.enable = lib.mkEnableOption "tailscale";
  };

  config = lib.mkIf config.aspects.work.tailscale.enable {
    services.tailscale = {
      enable = true;
    };

    aspects.base.persistence.systemPaths = [
      "/var/lib/tailscale"
    ];

    # Disable tailscale autostart
    systemd.services.tailscaled.wantedBy = lib.mkForce [ ];

  };
}
