{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    security.pam.services = {swaylock = {};};
    home-manager.users.jocelyn = {
      config,
      osConfig,
      ...
    }: {
      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        settings = {
          effect-blur = "20x3";
          effect-vignette = "0.5:0.5";
          screenshots = true;
          clock = true;

          font = osConfig.aspects.base.fonts.monospace.family;

          line-uses-inside = true;
          disable-caps-lock-text = true;
          indicator-caps-lock = true;
          indicator-radius = 100;
          indicator-thickness = 7;
          indicator-idle-visible = true;

          ring-color = "#${config.colorScheme.colors.foreground}";
          inside-wrong-color = "#${config.colorScheme.colors.red}";
          ring-wrong-color = "#${config.colorScheme.colors.red}";
          key-hl-color = "#${config.colorScheme.colors.teal}";
          bs-hl-color = "#${config.colorScheme.colors.red}";
          ring-ver-color = "#${config.colorScheme.colors.orange}";
          inside-ver-color = "#${config.colorScheme.colors.orange}";
          inside-color = "#${config.colorScheme.colors.background01}";
          text-color = "#${config.colorScheme.colors.foreground03}";
          text-clear-color = "#${config.colorScheme.colors.background01}";
          text-ver-color = "#${config.colorScheme.colors.background01}";
          text-wrong-color = "#${config.colorScheme.colors.background01}";
          text-caps-lock-color = "#${config.colorScheme.colors.foreground03}";
          inside-clear-color = "#${config.colorScheme.colors.blue}";
          ring-clear-color = "#${config.colorScheme.colors.blue}";
          inside-caps-lock-color = "#${config.colorScheme.colors.orange}";
          ring-caps-lock-color = "#${config.colorScheme.colors.background02}";
          separator-color = "#${config.colorScheme.colors.background02}";
        };
      };

      services.swayidle = {
        enable = true;
        systemdTarget = "hyprland-session.target";
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
            command = "${config.programs.swaylock.package}/bin/swaylock -fF";
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
