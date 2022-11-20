{
  pkgs,
  lib,
  config,
  ...
}: let
  sound_script = "${pkgs.dunst-notification-sound}/bin/dunst-notification-sound";
in {
  config = lib.mkIf config.aspects.graphical.i3.enable {
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
          name = "Papirus";
          package = pkgs.papirus-icon-theme;
          size = "48x48";
        };
        settings = {
          global = {
            monitor = 0;
            geometry = "0x0-50+65";
            font = "${osConfig.aspects.base.fonts.monospace.family} ${toString osConfig.aspects.base.fonts.monospace.size}";
            line_height = 4;
            frame_width = 2;
            padding = 16;
            horizontal_padding = 12;
            format = ''<b>%s</b>\n%b'';
            frame_color = "#${config.colorScheme.colors.base0C}FF";
            separator_color = "frame";
          };

          play_sound = {
            summary = "*";
            script = sound_script;
          };

          urgency_low = {
            fullscreen = "delay";
            background = "#${config.colorScheme.colors.base01}CC";
            foreground = "#${config.colorScheme.colors.base06}CC";
          };

          urgency_normal = {
            fullscreen = "delay";
            background = "#${config.colorScheme.colors.base01}CC";
            foreground = "#${config.colorScheme.colors.base06}CC";
          };

          urgency_critical = {
            fullscreen = "show";
            background = "#${config.colorScheme.colors.base01}DD";
            foreground = "#${config.colorScheme.colors.base06}DD";
          };
        };
      };
    };
  };
}
