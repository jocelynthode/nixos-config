{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    security.pam.services = {swaylock = {};};
    home-manager.users.jocelyn = _: {
      services.swayidle = {
        enable = true;
        systemdTarget = "hyprland-session.target";
        events = [
          {
            event = "before-sleep";
            command = "${pkgs.swaylock}/bin/swaylock";
          }
          {
            event = "lock";
            command = "${pkgs.swaylock}/bin/swaylock";
          }
        ];
        timeouts = [
          {
            timeout = 600;
            command = "${pkgs.swaylock}/bin/swaylock -fF";
          }
          {
            timeout = 610;
            command = "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ yes";
          }
          {
            timeout = 660;
            command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
            resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
