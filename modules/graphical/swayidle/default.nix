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
        ...
      }:
      {
        services.swayidle = {
          enable = true;
          systemdTarget =
            if osConfig.aspects.graphical.hyprland.enable then
              "hyprland-session.target"
            else
              "sway-session.target";
          events = [
            {
              event = "before-sleep";
              command = "loginctl lock-session";
            }
            {
              event = "lock";
              command = "loginctl lock-session";
            }
          ];
          timeouts = [
            {
              timeout = 600;
              command = "loginctl lock-session";
            }
            {
              timeout = 610;
              command = "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ yes";
            }
            {
              timeout = 660;
              command =
                if osConfig.aspects.graphical.hyprland.enable then
                  "hyprctl dispatch dpms off"
                else
                  "${pkgs.sway}/bin/swaymsg \"output * dpms off\"";
              resumeCommand =
                if osConfig.aspects.graphical.hyprland.enable then
                  "hyprctl dispatch dpms on"
                else
                  "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
            }
          ];
        };
      };
  };
}
