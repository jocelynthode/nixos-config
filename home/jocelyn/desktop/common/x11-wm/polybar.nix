{ config, pkgs, ... }:

let
  inherit (config.colorscheme) colors;

  # Dependencies
  systemctl = "${pkgs.systemd}/bin/systemctl";
  gamemoded = "${pkgs.gamemode}/bin/gamemoded";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  blueberry = "${pkgs.blueberry}/bin/blueberry";
  rofi-pulse = "${pkgs.rofi-pulse}/bin/rofi-pulse";
  home-pkgs = (import ../../../pkgs { inherit pkgs config; });
in
{
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      pulseSupport = true;
    };
    settings = {
      colors = {
        base00 = "#${colors.base00}";
        base01 = "#${colors.base01}";
        base02 = "#${colors.base02}";
        base03 = "#${colors.base03}";
        base04 = "#${colors.base04}";
        base05 = "#${colors.base05}";
        base06 = "#${colors.base06}";
        base07 = "#${colors.base07}";
        base08 = "#${colors.base08}";
        base09 = "#${colors.base09}";
        base0A = "#${colors.base0A}";
        base0B = "#${colors.base0B}";
        base0C = "#${colors.base0C}";
        base0D = "#${colors.base0D}";
        base0E = "#${colors.base0E}";
        base0F = "#${colors.base0F}";

        transparent-base00 = "#DD${colors.base00}";
      };

      bar = {
        fill = "⏽";
        empty = "⏽";
        indicator = "";
      };

      "bar/main" = {
        width = "100%";
        height = "2.5%";
        radius = 0;
        background = ''''${colors.transparent-base00}'';
        foreground = ''''${colors.base07}'';
        padding = 2;
        line = {
          size = 3;
          color = ''''${colors.base00}'';
        };
        border.bottom = {
          size = 0;
          color = ''''${colors.base07}'';
        };

        module.margin = {
          left = 1;
          right = 1;
        };

        modules = {
          left = "xworkspaces sep cpu memory fs";
          center = "player date";
          right = "eth wifi bluetooth sep gammastep gamemode sep mic volume brightness battery sep";
        };
        separator = "";
        dim-value = "1.0";
        tray = {
          position = "right";
        };
        font = [ "${config.fontProfiles.monospace.family}:size=11;4" "feather:size=12;3" ];
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
            foreground = ''''${colors.base0E}'';
          };
        };
      };

      "module/xworkspaces" = {
        type = "internal/xworkspaces";

        label = {
          active = {
            text = "%name%";
            background = ''''${colors.base01}'';
            underline = ''''${colors.base0C}'';
            padding = 1;
          };
          occupied = {
            text = "%name%";
            padding = 1;
          };
          urgent = {
            text = "%name%";
            background = ''''${colors.base00}'';
            underline = ''''${colors.base08}'';
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
          volume = "<ramp-volume> <bar-volume>";
          muted = {
            text = "<label-muted>";
            prefix = {
              text = "";
              foreground = ''''${colors.base08}'';
            };
          };
        };

        label = {
          volume = "%percentage%%";
          muted = {
            text = " Muted";
            foreground = ''''${colors.base03}'';
          };
        };

        ramp = {
          volume = {
            text = [ "" "" "" ];
            foreground = ''''${colors.base0D}'';
          };
          headphones = [ "" ];
        };

        bar.volume = {
          format = "%fill%%indicator%%empty%";
          width = 11;
          gradient = false;
          foreground = [ ''''${colors.base0B}'' ''''${colors.base0B}'' ''''${colors.base09}'' ''''${colors.base09}'' ''''${colors.base08}'' ];

          indicator = {
            text = ''''${bar.indicator}'';
            foreground = ''''${colors.base07}'';
          };

          fill = {
            text = ''''${bar.fill}'';
          };

          empty = {
            text = ''''${bar.empty}'';
            foreground = ''''${colors.base03}'';
          };
        };
      };

      "module/fs" = {
        type = "internal/fs";
        interval = 30;
        mount = [ "/" ];
        fixed.values = true;

        format = {
          mounted = {
            text = "<label-mounted>";
            prefix = {
              text = "";
              foreground = ''''${colors.base0C}'';
            };
          };

          unmounted = {
            text = "<label-unmounted>";
            prefix = {
              text = "";
              foreground = ''''${colors.base08}'';
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
            foreground = ''''${colors.base0D}'';
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
            foreground = ''''${colors.base0A}'';
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
          text = "%{F#${colors.base0C}} %downspeed%%{F-} %{F#${colors.base0D}}祝 %upspeed%%{F-}";
          foreground = ''''${colors.base0B}'';
        };
      };

      "module/wifi" = {
        "inherit" = "network-base";
        interface.type = "wireless";
        label.connected = {
          text = "%{F#${colors.base0C}} %downspeed%%{F-} %{F#${colors.base0D}}祝 %upspeed%%{F-}";
          foreground = ''''${colors.base0B}'';
        };
      };

      "module/bluetooth" = {
        type = "custom/script";
        exec = "${home-pkgs.polybar-bluetooth}/bin/polybar-bluetooth";
        interval = 1;
        click-left = "${pkgs.toggle-bluetooth}/bin/toggle_bluetooth";
        click-right = "${blueberry} &";
      };

      "module/sep" = {
        type = "custom/text";
        content = {
          text = "|";
          foreground = ''''${colors.base03}'';
        };
      };

      "module/mic" = {
        type = "custom/script";
        exec = "${home-pkgs.polybar-mic}/bin/polybar-mic --listen";
        tail = true;
        click-left = "${home-pkgs.polybar-mic}/bin/polybar-mic --toggle &";
        click-right = "${rofi-pulse} source";
      };

      "module/player" = {
        type = "custom/script";
        interval = 1;
        format.prefix = {
          text = "阮 ";
          foreground = ''''${colors.base0B}'';
        };
        exec = {
          text = "${playerctl} --player spotify metadata --format '{{artist}} - {{title}}  %{F#${colors.base03}}|%{F-}'";
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
        ramp.capacity = [ "" "" "" "" "" "" "" "" "" "" ];
        animation.charging = [ "" "" "" "" "" "" "" "" "" "" ];
        format = {
          charging = {
            text = "<animation-charging> <label-charging>";
            foreground = ''''${colors.base0C}'';
          };
          discharging = {
            text = "<ramp-capacity> <label-discharging>";
            foreground = ''''${colors.base0A}'';
          };
          full = {
            text = "<ramp-capacity> <label-full>";
            foreground = ''''${colors.base0D}'';
          };
          low = {
            text = "<ramp-capacity> <label-low>";
            foreground = ''''${colors.base08}'';
          };
        };
        label = {
          charging = "%percentage%% %time%";
          discharging = {
            text = "%percentage%% %time%";
            foreground = ''''${colors.base07}'';
          };
          low = "%percentage%% %time%";
          full = "Full";
        };
      };

      "module/brightness" = {
        type = "internal/backlight";
        card = "intel_backlight";
        format = "<ramp> <bar>";
        label = "%percentage%%";
        ramp = {
          text = [ "" "" "" "" "" "" "" "" "" ];
          foreground = ''''${colors.base0E}'';
        };
        bar = {
          width = 11;
          gradient = false;
          foreground = [ ''''${colors.base0B}'' ''''${colors.base0B}'' ''''${colors.base09}'' ''''${colors.base09}'' ''''${colors.base08}'' ];
          indicator = {
            text = ''''${bar.indicator}'';
            foreground = ''''${colors.base0C}'';
          };
          format = "%fill%%indicator%%empty%";
          fill = ''''${bar.fill}'';
          empty = {
            text = ''''${bar.empty}'';
            foreground = ''''${colors.base03}'';
          };
        };
      };

      "module/gammastep" = {
        type = "custom/script";
        interval = 4;
        exec = "${home-pkgs.polybar-gammastep}/bin/polybar-gammastep";
        click-left = "${systemctl} --user is-active gammastep && ${systemctl} --user stop gammastep || ${systemctl} --user start gammastep";
      };

      "module/gamemode" = {
        type = "custom/script";
        interval = 2;
        format.foreground = ''''${colors.base08}'';
        exec-if = "${gamemoded} --status | ${pkgs.gnugrep}/bin/grep 'is active' -q";
        exec = "${pkgs.coreutils-full}/bin/echo ''";
      };
    };
    script = "polybar main &";
  };
} 
