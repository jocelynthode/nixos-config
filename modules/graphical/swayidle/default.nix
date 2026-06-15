{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.aspects.graphical.enable {
    home-manager.users.jocelyn =
      {
        osConfig,
        config,
        ...
      }:
      {
        services.swayidle = {
          enable = true;
          systemdTargets = [ "graphical-session.target" ];
          events = {
            "before-sleep" = "${lib.getExe config.programs.noctalia.package} msg session lock";
            "lock" = "${lib.getExe config.programs.noctalia.package} msg session lock";
          };
          timeouts = [
            {
              timeout = 600;
              command = "${lib.getExe config.programs.noctalia.package} msg session lock";
            }
            {
              timeout = 610;
              command = "${lib.getExe config.programs.noctalia.package} msg mic-mute";
            }
            {
              timeout = 700;
              command =
                if osConfig.aspects.graphical.hyprland.enable then
                  "hyprctl dispatch dpms off"
                else if osConfig.aspects.graphical.niri.enable then
                  "${lib.getExe config.programs.niri.package} msg dpms-off"
                else
                  "${pkgs.sway}/bin/swaymsg \"output * dpms off\"";
              resumeCommand =
                if osConfig.aspects.graphical.hyprland.enable then
                  "hyprctl dispatch dpms on"
                else if osConfig.aspects.graphical.niri.enable then
                  "${lib.getExe config.programs.niri.package} msg dpms-on"
                else
                  "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
            }
          ];
        };
      };
  };
}
