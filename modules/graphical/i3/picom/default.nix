{ lib, config, ... }: {
  config = lib.mkIf config.aspects.graphical.i3.enable {
    home-manager.users.jocelyn = { ... }: {
      services.picom = {
        enable = true;
        experimentalBackends = true;
        settings = {
          blur = {
            method = "dual_kawase";
            strength = 5;
            kern = "3x3box";
          };
          vsync = true;
          active-opacity = "1.0";
          inactive-opacity = "1.0";
          backend = "glx";
          fade = false;
          opacity-rule = [
            "100:fullscreen"
            "100:name *= 'i3lock'"
            "85:class_g = 'Spotify'"
            "85:class_g *?= 'Rofi'"
          ];
          shadow = true;
          shadow-opacity = "0.65";
          shadow-exclude = [
            "name = 'Notification'"
          ];
          mark-wmwin-focused = true;
          mark-ovredir-focused = true;
          detect-rounded-corners = true;
          detect-client-opacity = true;
          wintypes = {
            popup_menu = { opacity = "0.85"; };
            dropdown_menu = { opacity = "0.85"; };
            dock = { shadow = false; clip-shadow-above = true; };
            dnd = { shadow = false; };
          };
          unredir-if-possible = false;
        };
      };
    };
  };
}
