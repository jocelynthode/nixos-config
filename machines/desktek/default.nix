{ pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  # Machine-specific module settings
  aspects = {
    stateVersion = "25.05";
    base = {
      bluetooth.enable = true;
    };
    development = {
      enable = true;
      ollama.enable = true;
      opencode.enable = true;
    };
    games = {
      enable = true;
      sunshine.enable = true;
    };
    graphical = {
      enable = true;
      sound.guitar.enable = true;
      wallpaper = "japan-spring";
      printer.enable = true;
      sway.enable = false;
      niri = {
        enable = true;
        workspaces = {
          "01" = {
            name = "browser";
            open-on-output = "DP-1";
          };
          "02" = {
            name = "terminal";
            open-on-output = "DP-1";
          };
          "03" = {
            name = "mail";
            open-on-output = "DP-1";
          };
          "04" = {
            name = "game";
            open-on-output = "DP-1";
          };
          "05" = {
            name = "extra";
            open-on-output = "DP-1";
          };
          "06" = {
            name = "secondary";
            open-on-output = "HDMI-A-1";
          };
          "07" = {
            name = "chat";
            open-on-output = "HDMI-A-1";
          };
          "08" = {
            name = "music";
            open-on-output = "HDMI-A-1";
          };
          "09" = {
            name = "messenger";
            open-on-output = "HDMI-A-1";
          };
        };
      };
      hyprland = {
        enable = false;
        monitor = [
          "HDMI-A-1,highres,0x0,auto"
          "DP-1,highres,1920x0,auto"
        ];
        workspace = [
          "1,monitor:DP-1,default:true"
          "2,monitor:DP-1"
          "3,monitor:DP-1"
          "4,monitor:DP-1"
          "5,monitor:DP-1"
          "6,monitor:HDMI-A-1,default:true"
          "7,monitor:HDMI-A-1"
          "8,monitor:HDMI-A-1"
          "9,monitor:HDMI-A-1"
          "10,monitor:HDMI-A-1"
        ];
      };
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
              "niri msg action move-workspace-to-monitor --reference browser DP-1"
              "niri msg action move-workspace-to-monitor --reference terminal DP-1"
              "niri msg action move-workspace-to-monitor --reference mail DP-1"
              "niri msg action move-workspace-to-monitor --reference game DP-1"
              "niri msg action move-workspace-to-monitor --reference extra DP-1"
              "niri msg action move-workspace-to-monitor --reference secondary HDMI-A-1"
              "niri msg action move-workspace-to-monitor --reference chat HDMI-A-1"
              "niri msg action move-workspace-to-monitor --reference music HDMI-A-1"
              "niri msg action move-workspace-to-monitor --reference messenger HDMI-A-1"
            ];
          };
        }
      ];
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
