{
  pkgs,
  lib,
  config,
  ...
}: let
  sound_script = "${pkgs.dunst-notification-sound}/bin/dunst-notification-sound";
in {
  options.aspects.graphical.notification = {
    enable = lib.mkEnableOption "notification";
  };

  config = lib.mkIf config.aspects.graphical.notification.enable {
    home-manager.users.jocelyn = {
      config,
      osConfig,
      ...
    }: {
      xdg.configFile."dunst" = {
        source = ./files;
        recursive = true;
      };

      services.dunst = {
        enable = true;
        iconTheme = {
          name = "Papirus-Light";
          package = pkgs.papirus-icon-theme;
          size = "48x48";
        };
        settings = {
          global = {
            monitor = 0;
            offset = "10x10";
            font = "${osConfig.aspects.base.fonts.monospace.family} ${toString osConfig.aspects.base.fonts.monospace.size}";
            line_height = 4;
            frame_width = 2;
            padding = 16;
            horizontal_padding = 12;
            corner_radius = 7;
            format = ''<b>%s</b>\n%b'';
            frame_color = "#${config.colorScheme.palette.accent}FF";
            separator_color = "frame";
            dmenu = "${pkgs.wofi}/bin/wofi -d";
          };

          play_sound = {
            summary = "*";
            script = sound_script;
          };

          urgency_low = {
            fullscreen = "delay";
            background = "#${config.colorScheme.palette.background}FF";
            foreground = "#${config.colorScheme.palette.foreground}FF";
          };

          urgency_normal = {
            fullscreen = "delay";
            background = "#${config.colorScheme.palette.background}FF";
            foreground = "#${config.colorScheme.palette.foreground}FF";
          };

          urgency_critical = {
            fullscreen = "show";
            background = "#${config.colorScheme.palette.background}FF";
            foreground = "#${config.colorScheme.palette.foreground}FF";
          };
        };
      };
    };
  };
}
