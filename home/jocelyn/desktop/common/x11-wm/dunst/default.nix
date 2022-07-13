{ config, pkgs, ... }:

let
  inherit (config.colorscheme) colors;
  sound_script = "${pkgs.dunst-notification-sound}/bin/dunst-notification-sound";
in
{
  xdg.configFile."dunst" = {
    source = ./files;
    recursive = true;
  };

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
      size = "32x32";
    };
    settings = {
      global = {
        monitor = 0;
        geometry = "0x0-50+65";
        font = "${config.fontProfiles.monospace.family} 10";
        line_height = 4;
        frame_width = 2;
        padding = 16;
        horizontal_padding = 12;
        format = ''<b>%s</b>\n%b'';
        frame_color = "#${colors.base0C}FF";
        separator_color = "frame";
      };

      play_sound = {
        summary = "*";
        script = sound_script;
      };

      urgency_low = {
        fullscreen = "delay";
        background = "#${colors.base01}CC";
        foreground = "#${colors.base06}CC";
      };

      urgency_normal = {
        fullscreen = "delay";
        background = "#${colors.base01}CC";
        foreground = "#${colors.base06}CC";
      };

      urgency_critical = {
        fullscreen = "show";
        background = "#${colors.base01}DD";
        foreground = "#${colors.base06}DD";
      };
    };
  };
}
