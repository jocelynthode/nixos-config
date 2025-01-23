{...}: {
  imports = [./hardware.nix];

  # Machine-specific module settings
  aspects = {
    stateVersion = "23.11";
    base = {
      battery.enable = true;
      bluetooth.enable = true;
    };
    development.enable = true;
    games.enable = false;
    graphical = {
      enable = true;
      dpi = 120;
      wallpaper = "lavenders";
      fingerprint.enable = true;
      hyprland.enable = true;
      sway.enable = false;
      wayland = {
        kanshi.settings = [
          {
            profile = {
              name = "default";
              outputs = [
                {
                  criteria = "eDP-1";
                  position = "0,0";
                  scale = 1.175;
                }
              ];
            };
          }
          {
            profile = {
              name = "work";
              outputs = [
                {
                  criteria = "eDP-1";
                  position = "0,0";
                  scale = 1.0;
                }
                {
                  criteria = "DP-3";
                  position = "0,1504";
                  scale = 1.5;
                }
              ];
            };
          }
        ];
      };

      i3 = {
        enable = false;
        autorandr.profiles = {
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
    programs.enable = true;
    work.enable = true;
  };
}
