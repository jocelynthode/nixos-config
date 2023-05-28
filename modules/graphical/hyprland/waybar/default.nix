{
  pkgs,
  config,
  lib,
  nix-colors,
  ...
}: let
  toRGB = nix-colors.lib.conversions.hexToRGBString ",";
in {
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
            position = "top";
            output = ["DP-2" "DP-4" "eDP-1"];
            modules-left = [
              "wlr/workspaces"
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
            "wlr/workspaces" = {
              on-click = "activate";
              all-outputs = true;
              sort-by-number = true;
            };
            clock = {
              format = "{:<span color=\"#${config.colorScheme.colors.purple}\"> </span>%a, %d %b %Y at %H:%M:%S}";
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
              format-time = "{H} h {m} min";
              format = "{icon} {capacity}%";
            };
            backlight = {
              device = "intel_backlight";
              format-icons = ["󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠"];
              format = "<span color=\"#${config.colorScheme.colors.orange}\">{icon}</span> {percent}%";
            };
            network = {
              interval = 3;
              format = "<span color=\"#${config.colorScheme.colors.teal}\">󰇚 {bandwidthDownBytes}</span> <span color=\"#${config.colorScheme.colors.blue}\">󰕒 {bandwidthUpBytes}</span>";
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
              format-off = "<span color=\"#${config.colorScheme.colors.background03}\">󰂲</span>";
              format-disabled = "<span color=\"#${config.colorScheme.colors.background03}\">󰂲</span>";
              format-connected = "<span color=\"#${config.colorScheme.colors.blue}\"></span> {device_alias}";
              format-connected-battery = "<span color=\"#${config.colorScheme.colors.blue}\"></span> {device_alias} {device_battery_percentage}%";
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
              format = "{icon}";
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
            tray = {
              spacing = 10;
            };
          };
        };
        style = let
          inherit (config.colorscheme) colors;
        in ''
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
              border-radius: 10px;
              transition: none;
              background: rgba(${toRGB colors.background01},0.7);
          }
          #workspaces button#workspaces {
              margin-right: 8px;
              border-radius: 10px;
              transition: none;
              color: #${colors.foreground};
              background: rgba(${toRGB colors.background01},0.7);
          }

          #workspaces button.focused,
          #workspaces button.active {
            border-radius: 10px;
            background-color: #${colors.accent};
            color: #${colors.background};
          }

          #workspaces button:hover {
              transition: none;
              box-shadow: inherit;
              text-shadow: inherit;
              border-radius: inherit;
              color: #${colors.background};
              background: #${colors.foreground03};
          }

          #cpu, #memory, #disk {
            border-radius: 0px;
            padding: 5px 10px 5px 10px;
            background: rgba(${toRGB colors.background01},0.7);
          }

          #cpu {
            padding: 5px 10px 5px 10px;
            border-radius: 10px 0px 0px 10px;
          }
          #disk {
            padding: 5px 10px 5px 10px;
            margin-right: 8px;
            border-radius: 0px 10px 10px 0px;
          }

          #custom-player, #clock {
            border-radius: 10px;
            padding: 5px 10px 5px 10px;
            background: rgba(${toRGB colors.background01},0.7);
          }

          #network, #bluetooth, #custom-gammastep, #custom-gpg-agent, #gamemode, #pulseaudio, #backlight, #battery, #tray {
            border-radius: 0px;
            padding: 5px 10px 5px 10px;
            background: rgba(${toRGB colors.background01},0.7);
          }
          #network {
            border-radius: 10px 0px 0px 10px;
          }
          #tray {
            border-radius: 0px 10px 10px 0px;
          }

          #gamemode {
            color: #${colors.red};
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
