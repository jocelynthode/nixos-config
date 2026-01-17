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
      ollama.enable = false;
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
      niri.enable = true;
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
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 1 DP-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 2 DP-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 3 DP-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 4 DP-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 5 DP-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 6 HDMI-A-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 7 HDMI-A-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 8 HDMI-A-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 9 HDMI-A-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 10 HDMI-A-1"
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
