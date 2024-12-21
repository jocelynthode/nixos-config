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
    home-manager.users.jocelyn = {osConfig, ...}: {
      xdg.configFile."dunst" = {
        source = ./files;
        recursive = true;
      };

      catppuccin.dunst.enable = true;
      services.dunst = {
        enable = true;
        iconTheme = {
          name = "Papirus-Light";
          package = pkgs.papirus-icon-theme;
          size = "48x48";
        };
        settings = {
          global = {
            monitor = 1;
            offset = "10x10";
            font = "${osConfig.aspects.base.fonts.monospace.family} ${toString osConfig.aspects.base.fonts.monospace.size}";
            line_height = 4;
            frame_width = 2;
            padding = 16;
            horizontal_padding = 12;
            corner_radius = 7;
            format = ''<b>%s</b>\n%b'';
            dmenu = "${pkgs.wofi}/bin/wofi -d";
          };

          play_sound = {
            summary = "*";
            script = sound_script;
          };
        };
      };
    };
  };
}
