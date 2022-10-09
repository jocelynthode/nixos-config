{ pkgs, lib, config, ... }: {
  config = lib.mkIf config.aspects.graphical.i3.enable {
    home-manager.users.jocelyn = { config, osConfig, ... }: {
      programs.autorandr = {
        enable = true;
        hooks = {
          postswitch = {
            "notify-change" = "${pkgs.libnotify}/bin/notify-send -i display 'Display profile' -t 1000 \"$AUTORANDR_CURRENT_PROFILE\"";
            "change-background" = "${pkgs.feh}/bin/feh --bg-fill  ${pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper}}";
            "generate-lockscreen" = "betterlockscreen -u ${pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper}}";
          };
        };
        profiles = {
          # TODO use aspects to pas this info
          "desktop" = {
            fingerprint = {
              DP-2 = "00ffffffffffff001e6d7f5bbb300800091d0104b53c22789f8cb5af4f43ab260e5054254b007140818081c0a9c0b300d1c08100d1cf28de0050a0a038500830080455502100001a000000fd003090e6e63c010a202020202020000000fc003237474c3835300a2020202020000000ff003930394e54435a46533736330a01ee02031a7123090607e305c000e606050160592846100403011f13565e00a0a0a029503020350055502100001a909b0050a0a046500820880c555021000000b8bc0050a0a055500838f80c55502100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a";
              HDMI-0 = "00ffffffffffff0009d1327f455400001018010380351e782e9de1a654549f260d5054a56b80d1c0317c4568457c6168617c953c3168023a801871382d40582c4500132a2100001e000000ff004a34453034383136534c300a20000000fd0018780f8711000a202020202020000000fc0042656e5120584c323431315a0a0171020323f15090050403020111121314060715161f202309070765030c00100083010000023a801871382d40582c4500132a2100001f011d8018711c1620582c2500132a2100009f011d007251d01e206e285500132a2100001f8c0ad08a20e02d10103e9600132a210000190000000000000000000000000000000000000000c7";
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
          "laptop" = {
            fingerprint = {
              eDP-1 = "00ffffffffffff0009e55f0900000000171d0104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a00fb";
            };
            config = {
              eDP-1 = {
                enable = true;
                crtc = 0;
                primary = true;
                position = "0x0";
                mode = "2256x1504";
                gamma = "1.0:1.0:0.909";
                rate = "60.00";
              };
            };
          };
          "work" = {
            fingerprint = {
              eDP-1 = "00ffffffffffff0009e55f0900000000171d0104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a00fb";
              DP-4 = "00ffffffffffff0010ac23f14c373141181f0104a53c22783a5015a8544fa5270e5054a54b00714f8180a9c0d1c001010101010101014dd000a0f0703e803020350055502100001a000000ff00345334584746330a2020202020000000fc0044454c4c205032373231510a20000000fd0018560f873c000a20202020202001d702031eb15661605f5e5d101f222120041312110302010514061516e2006b08e80030f2705a80b0588a0055502100001c565e00a0a0a029503020350055502100001c023a801871382d40582c450055502100001e114400a0800025503020360055502100001c0000000000000000000000000000000000000000000000000065";
            };
            config = {
              DP-4 = {
                enable = true;
                crtc = 0;
                primary = true;
                position = "0x0";
                mode = "3840x2160";
                gamma = "1.0:1.0:0.909";
                rate = "60.00";
              };
              eDP-1 = {
                enable = true;
                crtc = 1;
                primary = false;
                position = "0x2160";
                mode = "2256x1504";
                gamma = "1.0:1.0:0.909";
                rate = "60.00";
              };
            };
          };
        };
      };
    };
  };
}
