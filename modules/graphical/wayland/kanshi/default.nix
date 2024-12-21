{
  pkgs,
  config,
  lib,
  ...
}: {
  options.aspects.graphical.wayland.kanshi.settings = lib.mkOption {
    type = lib.types.listOf lib.types.attrs;
    default = {};
    description = "services.kanshi.settings setup";
    example = ''
      [
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
            }
          ];
          exec = [
            ${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor "1 1"
          ]";
        };
        docked = {
          outputs = [
            {
              criteria = "eDP-1";
            }
            {
              criteria = "Some Company ASDF 4242";
              transform = "90";
            }
          ];
        };
      ]
    '';
  };

  config = lib.mkIf config.aspects.graphical.wayland.enable {
    home-manager.users.jocelyn = {osConfig, ...}: {
      services.kanshi = {
        enable = true;
        systemdTarget = "graphical-session.target";
        inherit (osConfig.aspects.graphical.wayland.kanshi) settings;
      };
    };
  };
}
