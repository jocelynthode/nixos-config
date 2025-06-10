{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.aspects.graphical.enable {
    home-manager.users.jocelyn = {
      catppuccin.wlogout = {
        enable = true;
        iconStyle = "wleave";
      };
      programs.wlogout = {
        enable = true;
        package = pkgs.wleave;
        layout =
          [
            {
              label = "lock";
              action = "loginctl lock-session";
              text = "Lock";
              keybind = "l";
            }
            {
              label = "logout";
              action = "loginctl terminate-user $USER";
              text = "Logout";
              keybind = "e";
            }
            {
              label = "shutdown";
              action = "systemctl poweroff";
              text = "Shutdown";
              keybind = "s";
            }
            {
              label = "suspend";
              action = "systemctl suspend";
              text = "Suspend";
              keybind = "u";
            }
            {
              label = "reboot";
              action = "systemctl reboot";
              text = "Reboot";
              keybind = "r";
            }
          ]
          ++ lib.optional (builtins.length config.swapDevices > 0)
          {
            label = "hibernate";
            action = "systemctl hibernate";
            text = "Hibernate";
            keybind = "h";
          };
      };
    };
  };
}
