{pkgs, ...}: {
  imports = [./hardware.nix];

  # Machine-specific module settings
  aspects = {
    stateVersion = "23.11";
    base = {
      bluetooth.enable = true;
    };
    development = {
      enable = true;
      ollama.enable = true;
    };
    games = {
      enable = true;
      ryujinx.enable = false;
    };
    graphical = {
      enable = true;
      sound.guitar.enable = true;
      wallpaper = "lavenders";
      printer.enable = true;
      sway.enable = false;
      hyprland.enable = true;
      wayland = {
        kanshi.settings = [
          {
            profile = {
              name = "default";
              outputs = [
                {
                  criteria = "DP-1";
                  position = "1920,0";
                }
                {
                  criteria = "HDMI-A-1";
                  position = "0,0";
                }
              ];
              exec = [
                "${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --primary --mode 2560x1440 --pos 1920x0 --right-of HDMI-A-1"
              ];
            };
          }
        ];
      };
      i3 = {
        enable = false;
        autorandr.profiles = {
          "desktop" = {
            fingerprint = {
              DP-1 = "00ffffffffffff001e6d7f5bbb300800091d0104b53c22789f8cb5af4f43ab260e5054254b007140818081c0a9c0b300d1c08100d1cf28de0050a0a038500830080455502100001a000000fd003090e6e63c010a202020202020000000fc003237474c3835300a2020202020000000ff003930394e54435a46533736330a01ee02031a7123090607e305c000e606050160592846100403011f13565e00a0a0a029503020350055502100001a909b0050a0a046500820880c555021000000b8bc0050a0a055500838f80c55502100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a";
              HDMI-1 = "00ffffffffffff0009d1327f455400001018010380351e782e9de1a654549f260d5054a56b80d1c0317c4568457c6168617c953c3168023a801871382d40582c4500132a2100001e000000ff004a34453034383136534c300a20000000fd0018780f8711000a202020202020000000fc0042656e5120584c323431315a0a0171020323f15090050403020111121314060715161f202309070765030c00100083010000023a801871382d40582c4500132a2100001f011d8018711c1620582c2500132a2100009f011d007251d01e206e285500132a2100001f8c0ad08a20e02d10103e9600132a210000190000000000000000000000000000000000000000c7";
            };
            config = {
              DP-1 = {
                enable = true;
                crtc = 0;
                primary = true;
                position = "1920x0";
                mode = "2560x1440";
                gamma = "1.075:1.0:0.909";
                rate = "144.00";
              };
              HDMI-1 = {
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
        };
      };
    };
    programs = {
      enable = true;
      lact.enable = true;
      logseq.enable = true;
      solaar.enable = true;
      obs-studio.enable = true;
    };
    work.enable = true;
  };
}
