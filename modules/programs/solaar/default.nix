{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.programs.solaar.enable = lib.mkEnableOption "solaar";

  config = lib.mkIf config.aspects.programs.solaar.enable {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    home-manager.users.jocelyn = _: {
      systemd.user.services.solaar = {
        Unit = {
          Description = "Solaar Logitech status applet";
          After = [
            "graphical-session.target"
            "tray.target"
          ];
          PartOf = [ "graphical-session.target" ];
          Requires = [
            "tray.target"
            "waybar.service"
          ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.solaar}/bin/solaar --window=hide --battery-icons symbolic";
          KillMode = "process";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
