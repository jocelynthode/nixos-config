{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.aspects.graphical.enable {
    home-manager.users.jocelyn = {
      programs.wleave = {
        enable = true;
        settings = {
          close-on-lost-focus = true;
          show-keybinds = true;
          no-version-info = true;
          buttons = [
            {
              label = "lock";
              action = "loginctl lock-session";
              text = "Lock";
              keybind = "l";
              icon = "${pkgs.wleave}/share/wleave/icons/lock.svg";
            }
            {
              label = "logout";
              action = "loginctl terminate-user $USER";
              text = "Logout";
              keybind = "e";
              icon = "${pkgs.wleave}/share/wleave/icons/logout.svg";
            }
            {
              label = "shutdown";
              action = "systemctl poweroff";
              text = "Shutdown";
              keybind = "s";
              icon = "${pkgs.wleave}/share/wleave/icons/shutdown.svg";
            }
            {
              label = "suspend";
              action = "systemctl suspend";
              text = "Suspend";
              keybind = "u";
              icon = "${pkgs.wleave}/share/wleave/icons/suspend.svg";
            }
            {
              label = "reboot";
              action = "systemctl reboot";
              text = "Reboot";
              keybind = "r";
              icon = "${pkgs.wleave}/share/wleave/icons/reboot.svg";
            }
          ]
          ++ lib.optional (builtins.length config.swapDevices > 0) {
            label = "hibernate";
            action = "systemctl hibernate";
            text = "Hibernate";
            keybind = "h";
            icon = "${pkgs.wleave}/share/wleave/icons/hibernate.svg";
          };
        };
      };
    };
  };
}
