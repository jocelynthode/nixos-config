{pkgs, ...}: {
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
    development.enable = true;
    games.enable = false;
    graphical = {
      enable = true;
      dpi = 120;
      wallpaper = "water";
      fingerprint.enable = true;
      hyprland = {
        enable = true;
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
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 1 DP-4"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 2 DP-4"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 3 DP-4"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 4 DP-4"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 5 DP-4"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 6 eDP-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 7 eDP-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 8 eDP-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 9 eDP-1"
              "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 10 eDP-1"
            ];
          };
        }
      ];
    };
    programs.enable = true;
    work.enable = true;
  };
}
