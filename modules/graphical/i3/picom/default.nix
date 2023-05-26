{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.aspects.graphical.i3.enable {
    home-manager.users.jocelyn = _: {
      services.picom = {
        enable = true;
        settings = {
          blur = {
            method = "dual_kawase";
            strength = 5;
            kern = "3x3box";
            background = false;
            background-frame = false;
          };
          blur-background-exclude = [
            "window_type = 'dock'"
            "window_type = 'desktop'"
            "class_g = 'Polybar'"
            "_GTK_FRAME_EXTENTS@:c"
          ];
          active-opacity = "1.0";
          inactive-opacity = "1.0";
          backend = "glx";
          fade = false;
          opacity-rule = [
            "100:fullscreen"
            "100:name *= 'i3lock'"
            "85:class_g = 'Spotify'"
            "85:class_g *?= 'Rofi'"
            "85:class_g *?= 'kitty'"
          ];
          shadow = false;
          shadow-opacity = "0.65";
          shadow-exclude = [
            "name = 'Notification'"
          ];
          mark-wmwin-focused = true;
          mark-ovredir-focused = true;
          corner-radius = 7;
          detect-rounded-corners = true;
          detect-client-opacity = true;
          wintypes = {
            popup_menu = {
              opacity = "0.85";
              shadow = false;
            };
            dropdown_menu = {
              opacity = "0.85";
              shadow = false;
            };
            utility = {
              shadow = false;
            };
            dock = {
              shadow = false;
              clip-shadow-above = true;
            };
            dnd = {
              shadow = false;
            };
          };
          unredir-if-possible = false;
        };
      };
    };
  };
}
