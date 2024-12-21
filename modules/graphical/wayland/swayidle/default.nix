{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.aspects.graphical.wayland.enable {
    security.pam.services = {swaylock = {};};
    home-manager.users.jocelyn = {
      config,
      osConfig,
      ...
    }: {
      catppuccin.swaylock.enable = true;
      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        settings = {
          effect-blur = "20x3";
          effect-vignette = "0.5:0.5";
          screenshots = true;
          clock = true;
          daemonize = true;
          show-failed-attempts = true;

          font = osConfig.aspects.base.fonts.monospace.family;

          line-uses-inside = true;
          disable-caps-lock-text = true;
          indicator-caps-lock = true;
          indicator-radius = 100;
          indicator-thickness = 7;
          indicator-idle-visible = true;
        };
      };

      services.swayidle = {
        enable = true;
        systemdTarget =
          if osConfig.aspects.graphical.hyprland.enable
          then "hyprland-session.target"
          else "sway-session.target";
        events = [
          {
            event = "before-sleep";
            command = "${config.programs.swaylock.package}/bin/swaylock";
          }
          {
            event = "lock";
            command = "${config.programs.swaylock.package}/bin/swaylock";
          }
        ];
        timeouts = [
          {
            timeout = 600;
            command = "${config.programs.swaylock.package}/bin/swaylock";
          }
          {
            timeout = 610;
            command = "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ yes";
          }
          {
            timeout = 660;
            command =
              if osConfig.aspects.graphical.hyprland.enable
              then "hyprctl dispatch dpms off"
              else "${pkgs.sway}/bin/swaymsg \"output * dpms off\"";
            resumeCommand =
              if osConfig.aspects.graphical.hyprland.enable
              then "hyprctl dispatch dpms on"
              else "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
          }
        ];
      };
    };
  };
}
