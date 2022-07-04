{
  services.picom = {
    enable = true;
    experimentalBackends = true;
    blur = true;
    vSync = true;
    activeOpacity = "1.0";
    inactiveOpacity = "1.0";
    backend = "glx";
    fade = false;
    opacityRule = [
      "100:fullscreen"
      "100:name *= 'i3lock'"
      "85:class_g = 'Spotify'"
      "85:class_g *?= 'Rofi'"
    ];

    shadow = true;
    shadowOpacity = "0.65";
    shadowExclude = [
      "name = 'Notification'"
    ];
    extraOptions = ''
      blur-method = "dual_kawase";
      blur-strength = 5;
      blur-kern = "3x3box";
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
    '';
  };
}
