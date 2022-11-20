{
  pkgs,
  lib,
  config,
  ...
}: {
  options.aspects.graphical.i3.autorandr.profiles = lib.mkOption {
    type = lib.types.attrs;
    default = {};
    description = "programs.autorandr.profiles setup";
    example = ''
      {
        "desktop" = {
          fingerprint = {
            DP-2 = "XYZ";
            HDMI-0 = "XYZA";
          };
          config = {
            DP-2 = {
              enable = true;
              crtc = 0;
              primary = true;
              position = "1920x0";
              mode = "2560x1440";
              gamma = "1.075:1.0:0.909";
              rate = "144.00";
            };
            HDMI-0 = {
              enable = true;
              crtc = 1;
              primary = false;
              position = "0x0";
              mode = "1920x1080";
              gamma = "1.075:1.0:0.909";
              rate = "60.00";
            };
          };
        };
      }
    '';
  };

  config = lib.mkIf config.aspects.graphical.i3.enable {
    home-manager.users.jocelyn = {osConfig, ...}: {
      programs.autorandr = {
        enable = true;
        hooks = {
          postswitch = {
            "notify-change" = "${pkgs.libnotify}/bin/notify-send -i display 'Display profile' -t 1000 \"$AUTORANDR_CURRENT_PROFILE\"";
            "change-background" = "${pkgs.feh}/bin/feh --bg-fill  ${pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper}}";
            "generate-lockscreen" = "betterlockscreen -u ${pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper}} &";
          };
        };
        inherit (osConfig.aspects.graphical.i3.autorandr) profiles;
      };
    };
  };
}
