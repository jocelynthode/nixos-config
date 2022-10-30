{ pkgs, config, lib, ... }: {
  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    home-manager.users.jocelyn = { config, osConfig, ... }:
      let

        # Dependencies
        jq = "${pkgs.jq}/bin/jq";
        systemctl = "${pkgs.systemd}/bin/systemctl";
        journalctl = "${pkgs.systemd}/bin/journalctl";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
        blueberry = "${pkgs.blueberry}/bin/blueberry";
        rofi-pulse = "${pkgs.rofi-pulse}/bin/rofi-pulse";
        polybar-bluetooth = pkgs.callPackage ../../i3/polybar/polybar-bluetooth { config = config; };
        polybar-gammastep = pkgs.callPackage ../../i3/polybar/polybar-gammastep { config = config; };
        polybar-mic = pkgs.callPackage ../../i3/polybar/polybar-mic { config = config; };
        # Function to simplify making waybar outputs
        jsonOutput = name: { pre ? "", text ? "", tooltip ? "", alt ? "", class ? "", percentage ? "" }: "${pkgs.writeShellScriptBin "waybar-${name}" ''
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
        programs.waybar = {
          enable = true;
          systemd.enable = true;
          settings = {
            primary = {
              layer = "top";
              height = 36;
              # width = 100;
              margin = "0";
              position = "top";
              output = [ "DP-2" "eDP-1" ];
              modules-left = [
                "wlr/workspaces"
                "custom/sep"
                "cpu"
                "memory"
                "disk"
              ];
              modules-center = [
                "clock"
              ];
              modules-right = [
                "network"
                "bluetooth"
                "custom/sep"
                "custom/gammastep"
                "custom/gpg-agent"
                "gamemode"
                "custom/sep"
                "pulseaudio"
                "battery"
                "custom/sep"
                "tray"
              ];
              "wlr/workspaces" = {
                on-click = "activate";
                all-outputs = true;
              };
              clock = {
                format = "{:<span color=\"#${config.colorScheme.colors.base0E}\"> </span> %a, %d %b %Y at %H:%M:%S}";
                interval = 1;
              };
              cpu = {
                format = "<span color=\"#${config.colorScheme.colors.base0A}\"></span>  {usage}%";
              };
              memory = {
                format = "<span color=\"#${config.colorScheme.colors.base0D}\"></span> {}%";
                interval = 5;
              };
              disk = {
                interval = 30;
                path = "/";
                format = "<span color=\"#${config.colorScheme.colors.base0C}\"></span>  {free}";
              };
              pulseaudio = {
                format = "{icon}  {volume}%";
                on-click-right = "${rofi-pulse} sink";
                format-muted = "   0%";
                format-icons = {
                  headphone = "";
                  headset = "";
                  portable = "";
                  default = [ "" "" "" ];
                };
              };
              battery = {
                bat = "BAT1";
                full-at = 85;
                interval = 10;
                format-icons = [ "" "" "" "" "" "" "" "" "" "" ];
                format = "{icon} {capacity}% {time}";
                format-charging = " {capacity}% {time}";
                format-full = "{icon} {capacity}%";
              };
              network = {
                interval = 3;
                format = "<span color=\"#${config.colorScheme.colors.base0C}\">  {bandwidthDownBytes}</span>  <span color=\"#${config.colorScheme.colors.base0D}\">祝 {bandwidthUpBytes}</span>";
                format-disconnected = "";
                tooltip-format = ''
                  {ifname}
                  {ipaddr}/{cidr}
                  Up: {bandwidthUpBits}
                  Down: {bandwidthDownBits}'';
              };
              gamemode = {
                format = "{glyph}";
                format-alt = "{glyph}";
                glyph = "";
                use-icon = false;
                tooltip = false;
              };
              bluetooth = {
                interval = 1;
                format = " {status}";
                format-connected = " {device_alias}";
                format-connected-battery = " {device_alias} {device_battery_percentage}%";
                on-click-left = "${pkgs.toggle-bluetooth}/bin/toggle_bluetooth";
                on-click-right = "${blueberry} &";
              };
              "custom/sep" = {
                format = "⏽";
              };
              "custom/gpg-agent" = {
                interval = 2;
                return-type = "json";
                exec =
                  jsonOutput "gpg-agent" {
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
                format = "{icon}";
                format-icons = {
                  "activating" = " ";
                  "deactivating" = " ";
                  "inactive" = " ";
                  "active (Night)" = " ";
                  "active (Nighttime)" = " ";
                  "active (Transition (Night)" = " ";
                  "active (Transition (Nighttime)" = " ";
                  "active (Day)" = " ";
                  "active (Daytime)" = " ";
                  "active (Transition (Day)" = " ";
                  "active (Transition (Daytime)" = " ";
                };
                on-click = "${systemctl} --user is-active gammastep && ${systemctl} --user stop gammastep || ${systemctl} --user start gammastep";
              };
            };
          };
          style =
            let inherit (config.colorscheme) colors; in
            ''
              * {
                font-family: ${osConfig.aspects.base.fonts.regular.family}, ${osConfig.aspects.base.fonts.monospace.family};
                font-size: 12pt;
                padding: 0 8px;
              }
              .modules-right {
                margin-right: -15px;
              }
              .modules-left {
                margin-left: -15px;
              }
              window#waybar.top {
                color: #${colors.base05};
                opacity: 0.85;
                background-color: #${colors.base00};
                border: 0px;
                padding: 0px;
                border-radius: 0px;
              }
              #workspaces button {
                margin: 0px;
                padding: 0px;
                border-radius: 0px;
                border-bottom: 5px solid #${colors.base00};
                color: #${colors.base07};
              }
              #workspaces button.hidden {
                background-color: #${colors.base00};
                color: #${colors.base04};
              }
              #workspaces button.focused,
              #workspaces button.active {
                background-color: #${colors.base01};
                border-bottom: 5px solid #${colors.base0C};
              }
              #workspaces button.urgent {
                border-bottom: 5px solid #${colors.base08};
              }
              #gamemode {
                color: #${colors.base08};
                margin: 0px;
                padding: 0px;
              }
              #custom-sep {
                color: #${colors.base03};
                margin: 0px;
                padding: 3px;
              }
              #custom-gammastep {
                color: #${colors.base0A};
                margin: 0px;
                padding: 0px;
              }
              #cpu, #memory, #disk, #custom-gpg-agent,#pulseaudio, #clock {
                color: #${colors.base07};
                margin: 0px;
                padding: 0px;
              }
            '';
        };
      };
  };
}
