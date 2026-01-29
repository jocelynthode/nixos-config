{ ... }:
{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  # Machine-specific module settings
  aspects = {
    stateVersion = "25.05";
    base = {
      battery.enable = true;
      bluetooth.enable = true;
      fileSystems.btrfs.encrypted = true;
    };
    development = {
      enable = true;
      opencode.enable = true;
    };
    games.enable = false;
    graphical = {
      enable = true;
      dpi = 120;
      wallpaper = "japan-spring";
      fingerprint.enable = true;
      niri = {
        enable = true;
        workspaces = {
          "01" = {
            name = "browser";
            open-on-output = "DP-4";
          };
          "02" = {
            name = "terminal";
            open-on-output = "DP-4";
          };
          "03" = {
            name = "mail";
            open-on-output = "DP-4";
          };
          "04" = {
            name = "game";
            open-on-output = "DP-4";
          };
          "05" = {
            name = "extra";
            open-on-output = "DP-4";
          };
          "06" = {
            name = "secondary";
            open-on-output = "eDP-1";
          };
          "07" = {
            name = "chat";
            open-on-output = "eDP-1";
          };
          "08" = {
            name = "music";
            open-on-output = "eDP-1";
          };
          "09" = {
            name = "messenger";
            open-on-output = "eDP-1";
          };
        };
      };
      hyprland = {
        enable = false;
        workspace = [
          "1,monitor:DP-4,default:true"
          "2,monitor:DP-4"
          "3,monitor:DP-4"
          "4,monitor:DP-4"
          "5,monitor:DP-4"
          "6,monitor:eDP-1,default:true"
          "7,monitor:eDP-1"
          "8,monitor:eDP-1"
          "9,monitor:eDP-1"
          "10,monitor:eDP-1"
        ];
        monitor = [
          ",highres,auto,1.175"
          "DP-4,highres,auto,1.5"
        ];
      };
      sway.enable = false;
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
                scale = 1.566667;
              }
              {
                criteria = "DP-4";
                position = "0,1504";
                scale = 1.5;
              }
            ];
            exec = [
              "niri msg action move-workspace-to-monitor --reference browser DP-4"
              "niri msg action move-workspace-to-monitor --reference terminal DP-4"
              "niri msg action move-workspace-to-monitor --reference mail DP-4"
              "niri msg action move-workspace-to-monitor --reference game DP-4"
              "niri msg action move-workspace-to-monitor --reference extra DP-4"
              "niri msg action move-workspace-to-monitor --reference secondary eDP-1"
              "niri msg action move-workspace-to-monitor --reference chat eDP-1"
              "niri msg action move-workspace-to-monitor --reference music eDP-1"
              "niri msg action move-workspace-to-monitor --reference messenger eDP-1"
            ];
          };
        }
      ];
    };
    programs.enable = true;
    work.enable = true;
  };
}
