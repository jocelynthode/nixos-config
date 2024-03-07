{pkgs, ...}: {
  imports = [./hardware.nix];

  # Machine-specific module settings
  aspects = {
    stateVersion = "23.11";
    base = {
      battery.enable = true;
      bluetooth.enable = true;
    };
    development.enable = true;
    games.enable = true;
    graphical = {
      enable = true;
      dpi = 120;
      wallpaper = "lavenders";
      fingerprint.enable = true;
      hyprland.enable = true;
      wayland = {
        kanshi.profiles = {
          laptop = {
            outputs = [
              {
                criteria = "eDP-1";
                scale = 1.33333;
              }
            ];
            exec = [
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 1,monitor:eDP-1,default:true"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 2,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 3,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 4,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 5,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 6,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 7,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 8,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 9,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 10,monitor:eDP-1"

              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"1 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"2 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"3 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"4 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"5 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"6 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"7 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"8 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"9 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"10 eDP-1\""
            ];
          };
          work = {
            outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
                scale = 1.3;
              }
              {
                criteria = "DP-4";
                position = "0,1956";
                scale = 1.5;
              }
            ];
            exec = [
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 1,monitor:DP-4,default:true"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 2,monitor:DP-4"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 3,monitor:DP-4"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 4,monitor:DP-4"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 5,monitor:DP-4"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 6,monitor:eDP-1,default:true"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 7,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 8,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 9,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 10,monitor:eDP-1"

              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"1 DP-4\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"2 DP-4\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"3 DP-4\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"4 DP-4\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"5 DP-4\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"6 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"7 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"8 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"9 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"10 eDP-1\""
            ];
          };
          work2 = {
            outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
                scale = 1.3;
              }
              {
                criteria = "DP-3";
                position = "0,1440";
                scale = 1.5;
              }
            ];
            exec = [
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 1,monitor:DP-3,default:true"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 2,monitor:DP-3"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 3,monitor:DP-3"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 4,monitor:DP-3"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 5,monitor:DP-3"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 6,monitor:eDP-1,default:true"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 7,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 8,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 9,monitor:eDP-1"
              "${pkgs.hyprland}/bin/hyprctl keyword workspace 10,monitor:eDP-1"

              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"1 DP-3\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"2 DP-3\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"3 DP-3\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"4 DP-3\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"5 DP-3\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"6 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"7 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"8 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"9 eDP-1\""
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor \"10 eDP-1\""
            ];
          };
        };
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
