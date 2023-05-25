{
  pkgs,
  config,
  lib,
  ...
}: {
  # TODO: Have bar on one screen and variabilize output
  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    home-manager.users.jocelyn = {
      config,
      osConfig,
      ...
    }: let
      # Dependencies
      jq = "${pkgs.jq}/bin/jq";
      systemctl = "${pkgs.systemd}/bin/systemctl";
      journalctl = "${pkgs.systemd}/bin/journalctl";
      playerctl = "${pkgs.playerctl}/bin/playerctl";
      blueberry = "${pkgs.blueberry}/bin/blueberry";
      # Function to simplify making waybar outputs
      jsonOutput = name: {
        pre ? "",
        text ? "",
        tooltip ? "",
        alt ? "",
        class ? "",
        percentage ? "",
      }: "${pkgs.writeShellScriptBin "waybar-${name}" ''
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
    in {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = {
          primary = {
            layer = "top";
            height = 36;
            # width = 100;
            spacing = 3;
            margin = "0";
            position = "top";
            output = ["DP-4" "eDP-1"];
            modules-left = [
              "wlr/workspaces"
              "cpu"
              "memory"
              "disk"
            ];
            modules-center = [
              "custom/player"
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
            "wlr/workspaces" = {
              on-click = "activate";
              all-outputs = true;
              sort-by-number = true;
            };
            clock = {
              format = "{:<span color=\"#${config.colorScheme.colors.purple}\"> </span> %a, %d %b %Y at %H:%M:%S}";
              interval = 1;
            };
            cpu = {
              format = "<span color=\"#${config.colorScheme.colors.yellow}\"></span> {usage}%";
            };
            memory = {
              format = "<span color=\"#${config.colorScheme.colors.blue}\"></span> {}%";
              interval = 5;
            };
            disk = {
              interval = 30;
              path = "/";
              format = "<span color=\"#${config.colorScheme.colors.teal}\"></span> {free}";
            };
            pulseaudio = {
              format = "{format_source} {icon} {volume}%";
              on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
              format-source = " {volume}%";
              format-source-muted = "<span color=\"#${config.colorScheme.colors.red}\"></span> 0%";
              format-muted = "<span color=\"#${config.colorScheme.colors.red}\"></span>   0%";
              format-icons = {
                headphone = "";
                headset = "󰋎";
                portable = "";
                default = ["" "" ""];
              };
            };
            battery = {
              bat = "BAT1";
              full-at = 85;
              interval = 10;
              format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
              states = {
                warning = 30;
                critical = 20;
              };
              format = "{icon} {capacity}%";
              format-discharging = "{icon} {capacity}%";
              format-charging = "{icon} {capacity}% {time}";
              format-full = "{icon} ";
            };
            backlight = {
              device = "intel_backlight";
              format-icons = ["󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠"];
              format = "<span color=\"#${config.colorScheme.colors.orange}\">{icon}</span> {percent}%";
            };
            network = {
              interval = 3;
              format = "<span color=\"#${config.colorScheme.colors.teal}\">󰇚 {bandwidthDownBytes}</span>  <span color=\"#${config.colorScheme.colors.blue}\">󰕒 {bandwidthUpBytes}</span>";
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
              format = " {status} ";
              format-on = " ";
              format-off = "<span color=\"#${config.colorScheme.colors.background03}\">󰂲</span> ";
              format-disabled = "<span color=\"#${config.colorScheme.colors.background03}\">󰂲</span> ";
              format-connected = "<span color=\"#${config.colorScheme.colors.blue}\"></span> {device_alias} ";
              format-connected-battery = "<span color=\"#${config.colorScheme.colors.blue}\"></span> {device_alias} {device_battery_percentage}% ";
              # TODO FIX toggle bluetooth not working
              on-click-left = "${pkgs.toggle-bluetooth}/bin/toggle_bluetooth";
              on-click-right = "${blueberry} &";
            };
            "custom/player" = {
              interval = 1;
              return-type = "json";
              exec = jsonOutput "player" {
                pre = ''
                  status=$(${playerctl} --player spotify status);
                  if [ $status == "Playing" ]; then
                    song=$(${playerctl} --player spotify metadata --format '{{artist}} - {{title}}')
                  else
                    song=""
                  fi
                '';
                alt = "$status";
                text = "$song";
                tooltip = "Spotify is $status";
              };
              # exec = " '";
              format = "<span color=\"#${config.colorScheme.colors.green}\">{icon}</span> {}";
              format-icons = {
                "Playing" = "󰓇 ";
              };
            };
            "custom/sep" = {
              format = "⏽";
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
                "unlocked" = "";
              };
            };
            "custom/gammastep" = {
              interval = 5;
              return-type = "json";
              exec = jsonOutput "gammastep" {
                pre = ''
                  if unit_status="$(${systemctl} --user is-active gammastep)"; then
                    status="$unit_status ($(${journalctl} --user -u gammastep.service -g 'Period: ' | ${pkgs.coreutils}/bin/tail -1 | ${pkgs.coreutils}/bin/cut -d ':' -f6 | ${pkgs.findutils}/bin/xargs))"
                  else
                    status="$unit_status"
                  fi
                '';
                alt = "\${status:-inactive}";
                tooltip = "Gammastep is $status";
              };
              format = "{icon} ";
              format-icons = {
                "activating" = "󱧢";
                "deactivating" = "󱧡";
                "inactive" = "󱠃";
                "active (Night)" = "󱠂";
                "active (Nighttime)" = "󱠂";
                "active (Transition (Night)" = "󱠂";
                "active (Transition (Nighttime)" = "󱠂";
                "active (Day)" = "󱠂";
                "active (Daytime)" = "󱠂";
                "active (Transition (Day)" = "󱠂";
                "active (Transition (Daytime)" = "󱠂";
              };
              on-click = "${systemctl} --user is-active gammastep && ${systemctl} --user stop gammastep || ${systemctl} --user start gammastep";
            };
          };
        };
        style = let
          inherit (config.colorscheme) colors;
        in ''
          * {
            font-family: ${osConfig.aspects.base.fonts.monospace.family}, ${osConfig.aspects.base.fonts.regular.family};
            font-size: ${toString osConfig.aspects.base.fonts.monospace.size}pt;
            padding: 0 8px;
            margin: 3px;
          }
          .modules-right {
            margin-right: -15px;
          }
          .modules-left {
            margin-left: -15px;
          }
          window#waybar.primary {
            color: #${colors.foreground};
            opacity: 0.85;
            background-color: #${colors.background};
            border: 0px;
            padding: 0px;
            border-radius: 0px;
          }
          #workspaces button {
            margin: 0px;
            padding: 0px;
            border-radius: 0px;
            border-bottom: 5px solid #${colors.background};
            color: #${colors.foreground03};
          }
          #workspaces button.hidden {
            background-color: #${colors.background};
            color: #${colors.foreground01};
          }
          #workspaces button.focused,
          #workspaces button.active {
            background-color: #${colors.background01};
            border-bottom: 5px solid #${colors.pink};
          }
          #workspaces button.urgent {
            border-bottom: 5px solid #${colors.red};
          }
          #gamemode {
            color: #${colors.red};
          }
          #custom-sep {
            color: #${colors.background03};
          }
          #custom-gammastep {
            color: #${colors.yellow};
          }
          #battery.full {
            color: #${colors.blue};
          }
          #battery.charging {
            color: #${colors.green};
          }
          #battery.discharging.warning {
            color: #${colors.yellow};
          }
          #battery.discharging.critical {
            color: #${colors.red};
          }
          #cpu, #memory, #disk, #battery, #custom-gpg-agent,#pulseaudio, #clock, #custom-player, #bluetooth, #backlight {
            color: #${colors.foreground};
          }
        '';
      };
    };
  };
}
