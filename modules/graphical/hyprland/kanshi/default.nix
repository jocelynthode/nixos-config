{ pkgs, config, lib, ... }: {
  options.aspects.graphical.hyprland.kanshi.profiles = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "services.kanshi.profiles setup";
    example = ''
      {
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
      }
    '';
  };

  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    home-manager.users.jocelyn = { osConfig, ... }: {
      services.kanshi = {
        enable = true;
        systemdTarget = "hyprland-session.target";
        profiles = osConfig.aspects.graphical.hyprland.kanshi.profiles;
      };
    };
  };
}
