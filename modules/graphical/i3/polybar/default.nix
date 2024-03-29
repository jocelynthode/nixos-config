{
  pkgs,
  lib,
  config,
  ...
}: let
  # Dependencies
  systemctl = "${pkgs.systemd}/bin/systemctl";
  gamemoded = "${pkgs.gamemode}/bin/gamemoded";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  blueberry = "${pkgs.blueberry}/bin/blueberry";
  rofi-pulse = "${pkgs.rofi-pulse}/bin/rofi-pulse";
  gpg-agent-isUnlocked = "${pkgs.procps}/bin/pgrep 'gpg-agent' &> /dev/null && ${pkgs.gnupg}/bin/gpg-connect-agent 'scd getinfo card_list' /bye | ${pkgs.gnugrep}/bin/grep SERIALNO -q";
in {
  config = lib.mkIf config.aspects.graphical.i3.enable {
    home-manager.users.jocelyn = {
      config,
      osConfig,
      ...
    }: let
      polybar-bluetooth = pkgs.callPackage ./polybar-bluetooth {inherit config;};
      polybar-gammastep = pkgs.callPackage ./polybar-gammastep {inherit config;};
      polybar-mic = pkgs.callPackage ./polybar-mic {inherit config;};
    in {
      services.polybar = {
        enable = true;
        package = pkgs.polybar.override {
          i3Support = true;
          pulseSupport = true;
        };
        settings = {
          colors = {
            background = "#${config.colorScheme.palette.background}";
            background01 = "#${config.colorScheme.palette.background01}";
            background02 = "#${config.colorScheme.palette.background02}";
            background03 = "#${config.colorScheme.palette.background03}";
            foreground01 = "#${config.colorScheme.palette.foreground01}";
            foreground = "#${config.colorScheme.palette.foreground}";
            foreground02 = "#${config.colorScheme.palette.foreground02}";
            foreground03 = "#${config.colorScheme.palette.foreground03}";
            red = "#${config.colorScheme.palette.red}";
            orange = "#${config.colorScheme.palette.orange}";
            yellow = "#${config.colorScheme.palette.yellow}";
            green = "#${config.colorScheme.palette.green}";
            teal = "#${config.colorScheme.palette.teal}";
            blue = "#${config.colorScheme.palette.blue}";
            purple = "#${config.colorScheme.palette.purple}";
            brown = "#${config.colorScheme.palette.brown}";
            accent = "#${config.colorScheme.palette.accent}";

            transparent-background = "#DD${config.colorScheme.palette.background}";
          };

          "bar/main" = {
            width = "100%";
            height = "2.5%";
            radius = 10;
            background = ''''${colors.transparent-background}'';
            foreground = ''''${colors.foreground}'';
            padding = 2;
            line = {
              size = 3;
              color = ''''${colors.background}'';
            };
            border-size = 10;
            border-color = "#00000000";
            border.right = {
              size = 0;
            };
            border.bottom = {
              size = 5;
            };

            module.margin = {
              left = 1;
              right = 1;
            };

            modules = {
              left = "xworkspaces sep cpu memory fs";
              center = "player date";
              right = "eth wifi bluetooth sep gammastep gpg-agent gamemode sep mic volume brightness battery sep";
            };
            separator = "";
            dim-value = "1.0";
            tray = {
              position = "right";
              offset-x = "-10";
            };
            font = ["${osConfig.aspects.base.fonts.monospace.family}:size=${toString osConfig.aspects.base.fonts.monospace.size};4" "feather:size=12;3"];
            enable-ipc = true;
          };

          settings = {
            screenchange.reload = true;
            pseudo-transparency = true;
          };

          "module/date" = {
            type = "internal/date";
            internal = 5;
            date = "%a, %d %b %Y";
            time = "%H:%M:%S";
            label = "%date% at %time%";
            format = {
              text = "<label>";
              prefix = {
                text = " ";
                foreground = ''''${colors.purple}'';
              };
            };
          };

          "module/xworkspaces" = {
            type = "internal/xworkspaces";

            label = {
              active = {
                text = "%name%";
                background = ''''${colors.background01}'';
                underline = ''''${colors.accent}'';
                padding = 1;
              };
              occupied = {
                text = "%name%";
                padding = 1;
              };
              urgent = {
                text = "%name%";
                background = ''''${colors.background}'';
                underline = ''''${colors.red}'';
                padding = 1;
              };
              empty = {
                text = "%name%";
                padding = 1;
              };
            };
          };

          "module/volume" = {
            type = "internal/pulseaudio";
            interval = 1;
            click-right = "${rofi-pulse} sink";
            format = {
              volume = "<ramp-volume> <label-volume>";
              muted = {
                text = "<label-muted>";
                prefix = {
                  text = "";
                  foreground = ''''${colors.red}'';
                };
              };
            };

            label = {
              volume = "%percentage%%";
              muted = {
                text = " Muted";
                foreground = ''''${colors.background03}'';
              };
            };

            ramp = {
              volume = {
                text = ["" "" ""];
                foreground = ''''${colors.blue}'';
              };
              headphones = [""];
            };
          };

          "module/fs" = {
            type = "internal/fs";
            interval = 30;
            mount = ["/"];
            fixed.values = true;

            format = {
              mounted = {
                text = "<label-mounted>";
                prefix = {
                  text = "";
                  foreground = ''''${colors.teal}'';
                };
              };

              unmounted = {
                text = "<label-unmounted>";
                prefix = {
                  text = "";
                  foreground = ''''${colors.red}'';
                };
              };
            };
            label = {
              mounted = " %free%";
              unmounted = " %mountpoint%: NA";
            };
          };

          "module/memory" = {
            type = "internal/memory";
            interval = 25;
            format = {
              text = "<label>";
              prefix = {
                text = "";
                foreground = ''''${colors.blue}'';
              };
            };
            label = "%percentage_used:2%%";
          };

          "module/cpu" = {
            type = "internal/cpu";
            interval = 2;

            format = {
              text = "<label>";
              prefix = {
                text = "";
                foreground = ''''${colors.yellow}'';
              };
            };

            label = " %percentage%%";
          };

          "network-base" = {
            type = "internal/network";
            interval = 2;
            format = {
              connected = "<label-connected>";
              disconnected = "<label-disconnected>";
            };
            label.disconnected = "";
          };

          "module/eth" = {
            "inherit" = "network-base";
            interface.type = "wired";
            label.connected = {
              text = "%{F#${config.colorScheme.palette.teal}}󰇚 %downspeed%%{F-} %{F#${config.colorScheme.palette.blue}}󰕒 %upspeed%%{F-}";
              foreground = ''''${colors.green}'';
            };
          };

          "module/wifi" = {
            "inherit" = "network-base";
            interface.type = "wireless";
            label.connected = {
              text = "%{F#${config.colorScheme.palette.teal}}󰇚 %downspeed%%{F-} %{F#${config.colorScheme.palette.blue}}󰕒 %upspeed%%{F-}";
              foreground = ''''${colors.green}'';
            };
          };

          "module/bluetooth" = {
            type = "custom/script";
            exec = "${polybar-bluetooth}/bin/polybar-bluetooth";
            interval = 1;
            click-left = "${pkgs.toggle-bluetooth}/bin/toggle_bluetooth";
            click-right = "${blueberry} &";
          };

          "module/sep" = {
            type = "custom/text";
            content = {
              text = "|";
              foreground = ''''${colors.background03}'';
            };
          };

          "module/mic" = {
            type = "custom/script";
            exec = "${polybar-mic}/bin/polybar-mic --listen";
            tail = true;
            click-left = "${polybar-mic}/bin/polybar-mic --toggle &";
            click-right = "${rofi-pulse} source";
          };

          "module/player" = {
            type = "custom/script";
            interval = 1;
            format.prefix = {
              text = "󰓇 ";
              foreground = ''''${colors.green}'';
            };
            exec = {
              text = "${playerctl} --player spotify metadata --format '{{artist}} - {{title}}  %{F#${config.colorScheme.palette.background03}}|%{F-}'";
              "if" = ''[[ "$(${playerctl} --player spotify status)" = "Playing" ]]'';
            };
          };
          "module/battery" = {
            type = "internal/battery";
            full-at = 85;
            low-at = 20;
            poll-interval = 2;
            battery = "BAT1";
            adapter = "ACAD";
            time-format = "%H:%M";
            ramp.capacity = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            animation.charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
            format = {
              charging = {
                text = "<animation-charging> <label-charging>";
                foreground = ''''${colors.teal}'';
              };
              discharging = {
                text = "<ramp-capacity> <label-discharging>";
                foreground = ''''${colors.yellow}'';
              };
              full = {
                text = "<ramp-capacity> <label-full>";
                foreground = ''''${colors.blue}'';
              };
              low = {
                text = "<ramp-capacity> <label-low>";
                foreground = ''''${colors.red}'';
              };
            };
            label = {
              charging = "%percentage%% %time%";
              discharging = {
                text = "%percentage%% %time%";
                foreground = ''''${colors.foreground03}'';
              };
              low = "%percentage%% %time%";
              full = "Full";
            };
          };

          "module/brightness" = {
            type = "internal/backlight";
            card = "intel_backlight";
            format = "<ramp> <label>";
            label = "%percentage%%";
            ramp = {
              text = ["󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠"];
              foreground = ''''${colors.orange}'';
            };
          };

          "module/gammastep" = {
            type = "custom/script";
            interval = 4;
            exec = "${polybar-gammastep}/bin/polybar-gammastep";
            click-left = "${systemctl} --user is-active gammastep && ${systemctl} --user stop gammastep || ${systemctl} --user start gammastep";
          };

          "module/gamemode" = {
            type = "custom/script";
            interval = 2;
            format.foreground = ''''${colors.red}'';
            exec-if = "${gamemoded} --status | ${pkgs.gnugrep}/bin/grep 'is active' -q";
            exec = "${pkgs.coreutils-full}/bin/echo ''";
          };
          "module/gpg-agent" = {
            type = "custom/script";
            interval = 2;
            exec = "${gpg-agent-isUnlocked} && echo '' || echo ''";
          };
        };
        script = "polybar main &";
      };
    };
  };
}
