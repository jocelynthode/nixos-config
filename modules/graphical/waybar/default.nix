{
  pkgs,
  config,
  lib,
  ...
}:
{
  # TODO: Have bar on one screen and variabilize output
  config = lib.mkIf config.aspects.graphical.enable {
    home-manager.users.jocelyn =
      {
        config,
        osConfig,
        ...
      }:
      let
        # Dependencies
        jq = "${pkgs.jq}/bin/jq";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
        blueberry = "${pkgs.blueberry}/bin/blueberry";
        # Function to simplify making waybar outputs
        jsonOutput =
          name:
          {
            pre ? "",
            text ? "",
            tooltip ? "",
            alt ? "",
            class ? "",
            percentage ? "",
          }:
          "${pkgs.writeShellScriptBin "waybar-${name}" ''
            set -euo pipefail
            ${pre}
            ${jq} --unbuffered -cn \
              --arg text "${text}" \
              --arg tooltip "${tooltip}" \
              --arg alt "${alt}" \
              --arg class "${class}" \
              --arg percentage "${percentage}" \
              '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
          ''}/bin/waybar-${name}";
        gpg-agent-isUnlocked = "${pkgs.procps}/bin/pgrep 'gpg-agent' &> /dev/null && ${pkgs.gnupg}/bin/gpg-connect-agent 'scd getinfo card_list' /bye | ${pkgs.gnugrep}/bin/grep SERIALNO -q";
      in
      {
        catppuccin.waybar = {
          enable = true;
          mode = "prependImport";
        };
        programs.waybar = {
          enable = true;
          systemd = {
            enable = true;
            target = "tray.target";
          };
          settings = {
            primary = {
              layer = "top";
              position = "top";
              output = [
                "DP-1"
                "DP-4"
                "DP-3"
                "eDP-1"
                "SUNSHINE"
              ];
              modules-left = [
                "hyprland/workspaces"
                "cpu"
                "memory"
                "disk"
                "custom/player"
              ];
              modules-center = [
                "clock"
              ];
              modules-right = [
                "network"
                "bluetooth"
                "custom/gammastep"
                "custom/gpg-agent"
                "gamemode"
                "pulseaudio"
                "backlight"
                "battery"
                "tray"
              ];
              "hyprland/workspaces" = {
                on-click = "activate";
                all-outputs = true;
                sort-by-number = true;
              };
              clock = {
                format = "<span color=\"#${config.colorScheme.palette.purple}\"> </span>{:%a, %d %b %Y at %H:%M:%S}";
                interval = 1;
              };
              cpu = {
                format = "<span color=\"#${config.colorScheme.palette.yellow}\"></span> {usage}%";
              };
              memory = {
                format = "<span color=\"#${config.colorScheme.palette.blue}\"></span> {}%";
                interval = 5;
              };
              disk = {
                interval = 30;
                path = "/";
                format = "<span color=\"#${config.colorScheme.palette.teal}\"></span> {free}";
              };
              pulseaudio = {
                format = "{format_source} {icon} {volume}%";
                on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
                format-source = " {volume}%";
                format-source-muted = "<span color=\"#${config.colorScheme.palette.red}\"></span> 0%";
                format-muted = "<span color=\"#${config.colorScheme.palette.red}\"></span>   0%";
                format-icons = {
                  headphone = "";
                  headset = "󰋎";
                  portable = "";
                  default = [
                    ""
                    ""
                    ""
                  ];
                };
              };
              battery = {
                bat = "BAT1";
                full-at = 85;
                interval = 10;
                format-icons = [
                  "󰁺"
                  "󰁻"
                  "󰁼"
                  "󰁽"
                  "󰁾"
                  "󰁿"
                  "󰂀"
                  "󰂁"
                  "󰂂"
                  "󰁹"
                ];
                states = {
                  warning = 30;
                  critical = 20;
                };
                format-time = "{H} h {m} min";
                format = "{icon} {capacity}%";
              };
              backlight = {
                device = "intel_backlight";
                format-icons = [
                  "󰃚"
                  "󰃛"
                  "󰃜"
                  "󰃝"
                  "󰃞"
                  "󰃟"
                  "󰃠"
                ];
                format = "<span color=\"#${config.colorScheme.palette.orange}\">{icon}</span> {percent}%";
              };
              network = {
                interval = 3;
                format = "<span color=\"#${config.colorScheme.palette.teal}\">󰇚 {bandwidthDownBytes}</span> <span color=\"#${config.colorScheme.palette.blue}\">󰕒 {bandwidthUpBytes}</span>";
                format-disconnected = "";
                tooltip-format = ''
                  {ifname}
                  {ipaddr}/{cidr}
                  {essid} {signalStrength}
                '';
              };
              gamemode = {
                format = "{glyph} ";
                format-alt = "{glyph}";
                glyph = "";
                use-icon = false;
                tooltip = false;
              };
              bluetooth = {
                interval = 2;
                format = "{status}";
                format-on = "";
                format-off = "<span color=\"#${config.colorScheme.palette.background03}\">󰂲</span>";
                format-disabled = "<span color=\"#${config.colorScheme.palette.background03}\">󰂲</span>";
                format-connected = "<span color=\"#${config.colorScheme.palette.blue}\"></span> {device_alias}";
                format-connected-battery = "<span color=\"#${config.colorScheme.palette.blue}\"></span> {device_alias} {device_battery_percentage}%";
                on-click = "${pkgs.toggle-bluetooth}/bin/toggle_bluetooth";
                on-click-right = "${blueberry} &";
              };
              "custom/player" = {
                interval = 1;
                return-type = "json";
                exec-if = "${pkgs.procps}/bin/pgrep spotify";
                exec = jsonOutput "player" {
                  pre = ''
                    status=$(${playerctl} --player spotify status);
                    if [ $status == "Playing" ]; then
                      song=$(${playerctl} --player spotify metadata --format '{{artist}} - {{title}}')
                    else
                      song="Paused"
                    fi
                  '';
                  alt = "$status";
                  text = "$song";
                  tooltip = "Spotify is $status";
                };
                # exec = " '";
                format = "<span color=\"#${config.colorScheme.palette.green}\">󰓇</span> {}";
              };
              "custom/gpg-agent" = {
                interval = 2;
                return-type = "json";
                exec = jsonOutput "gpg-agent" {
                  pre = ''status=$(${gpg-agent-isUnlocked} && echo "unlocked" || echo "locked")'';
                  alt = "$status";
                  tooltip = "GPG is $status";
                };
                format = "{icon}";
                format-icons = {
                  "locked" = "";
                  "unlocked" = "";
                };
              };
              tray = {
                spacing = 10;
              };
            };
          };
          style = ''
            * {
              font-family: ${osConfig.aspects.base.fonts.monospace.family}, ${osConfig.aspects.base.fonts.regular.family};
              font-size: 11pt;
              border: 0;
              min-height: 0;
            }
            window#waybar {
              background: transparent;
            }
            window#waybar:first-child > box {
              margin: 8px 8px 0px 8px;
            }
            #workspaces {
              margin-right: 8px;
              padding: 5px 10px 5px 10px;
              border-radius: 0px;
              transition: none;
              background: @base;
              color: @text;
            }
            #workspaces button {
              margin-right: 8px;
              border-radius: 0px;
              transition: none;
              color: @text;
              background: @base;
            }

            #workspaces button.focused,
            #workspaces button.active {
              border-radius: 0px;
              background-color: @pink;
              color: @base;
            }

            #workspaces button:hover {
              transition: none;
              box-shadow: inherit;
              text-shadow: inherit;
              border-radius: inherit;
              color: @base;
              background: @lavender;
            }

            #cpu, #memory, #disk {
              border-radius: 0px;
              padding: 5px 10px 5px 10px;
              background: @base;
              color: @text;
            }

            #cpu {
              padding: 5px 10px 5px 10px;
              border-radius: 0px 0px 0px 0px;
            }
            #disk {
              padding: 5px 10px 5px 10px;
              margin-right: 8px;
              border-radius: 0px 0px 0px 0px;
            }

            #custom-player, #clock {
              border-radius: 0px;
              padding: 5px 10px 5px 10px;
              background: @base;
              color: @text;
            }

            #network, #bluetooth, #custom-gammastep, #custom-gpg-agent, #gamemode, #pulseaudio, #backlight, #battery, #tray {
              border-radius: 0px;
              padding: 5px 10px 5px 10px;
              background: @base;
              color: @text;
            }
            #network {
              border-radius: 0px 0px 0px 0px;
            }
            #tray {
              border-radius: 0px 0px 0px 0px;
            }

            #gamemode {
              color: @red;
            }
            #custom-gammastep {
              color: @yellow;
            }
            #battery.full {
              color: @blue;
            }
            #battery.charging {
              color: @green;
            }
            #battery.discharging.warning {
              color: @yellow;
            }
            #battery.discharging.critical {
              color: @red;
              animation-name: blink;
              animation-duration: 0.5s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
            }
          '';
        };
      };
  };
}
