{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.aspects.graphical.enable {
    home-manager.users.jocelyn =
      {
        config,
        osConfig,
        ...
      }:
      {
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
            ++ lib.optional (builtins.length osConfig.swapDevices > 0) {
              label = "hibernate";
              action = "systemctl hibernate";
              text = "Hibernate";
              keybind = "h";
              icon = "${pkgs.wleave}/share/wleave/icons/hibernate.svg";
            };
          };
          style = ''
            * {
              background-image: none;
              box-shadow: none;
            }

            window {
              background-color: rgba(30, 30, 46, 0.90);
            }

            button {
              border-radius: 0;
              border-color: #${config.colorScheme.palette.accent};
              text-decoration-color: #${config.colorScheme.palette.foreground};
              color: #${config.colorScheme.palette.foreground};
              background-color: #${config.colorScheme.palette.background};
              border-style: solid;
              border-width: 1px;
              background-repeat: no-repeat;
              background-position: center;
              background-size: 25%;
            }

            button:hover,
            button:active,
            button:focus {
              color: #${config.colorScheme.palette.accent};
              background-color: #${config.colorScheme.palette.background};
            }
          '';
        };
      };
  };
}
