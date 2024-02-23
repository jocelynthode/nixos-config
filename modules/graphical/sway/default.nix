{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../wayland
  ];

  options.aspects.graphical.sway = {
    enable = lib.mkEnableOption "sway";
  };

  config = lib.mkIf config.aspects.graphical.sway.enable {
    aspects.graphical.wayland.enable = true;

    programs.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
      qt5.qtwayland
      qt6.qtwayland
      xwaylandvideobridge
    ];

    environment.sessionVariables = {
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      CLUTTER_BACKEND = "wayland";
      LIBSEAT_BACKEND = "logind";
      NIXOS_OZONE_WL = "1";
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd ${pkgs.sway}/bin/sway";
          user = "greeter";
        };
      };
    };

    home-manager.users.jocelyn = {
      config,
      osConfig,
      ...
    }: {
      home.packages = with pkgs; [
        imv
        grim
        slurp
        waypipe
        wl-clipboard
        ydotool
      ];

      wayland.windowManager.sway = let
        mod = "Mod4";
        alt = "Mod1";
      in {
        enable = true;
        extraConfigEarly = ''
          set $ws1 1
          set $ws2 2
          set $ws3 3
          set $ws4 4
          set $ws5 5
          set $ws6 6
          set $ws7 7
          set $ws8 8
          set $ws9 9
          set $ws10 10
        '';
        extraConfig = ''
          bindsym --whole-window --no-repeat button9 exec ${pkgs.dbus}/bin/dbus-send --session --type=method_call --dest=net.sourceforge.mumble.mumble / net.sourceforge.mumble.Mumble.startTalking
          bindsym --whole-window --release button9 exec ${pkgs.dbus}/bin/dbus-send --session --type=method_call --dest=net.sourceforge.mumble.mumble / net.sourceforge.mumble.Mumble.stopTalking
        '';
        systemd.enable = true;
        xwayland = true;
        wrapperFeatures.gtk = true;
        extraSessionCommands = ''
          export GDK_BACKEND="wayland,x11"
          export QT_QPA_PLATFORM=wayland
          export CLUTTER_BACKEND=wayland
          export LIBSEAT_BACKEND=logind
          export NIXOS_OZONE_WL=1
        '';
        config = rec {
          modifier = mod;
          # Use kitty as default terminal
          terminal = "kitty";
          startup = [
            # Launch Firefox on start
            {command = "${pkgs.firefox}/bin/firefox";}
            {
              command = "${pkgs.swaybg}/bin/swaybg -i ${pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper}} --mode fill";
              always = true;
            }
            {
              command = "${pkgs.systemd}/bin/systemctl --user restart kanshi";
              always = true;
            }
          ];
          menu = "${pkgs.wofi}/bin/wofi -IS drun -W 40% -H 50%";
          bars = [];
          input = {
            "*" = {
              xkb_layout = "us";
              xkb_variant = "altgr-intl";
            };
          };
          workspaceAutoBackAndForth = false;
          focus = {
            followMouse = true;
            newWindow = "focus";
          };
          colors = {
            focused = {
              border = "#${config.colorScheme.palette.accent}";
              background = "#${config.colorScheme.palette.background01}";
              text = "#${config.colorScheme.palette.foreground}";
              indicator = "#${config.colorScheme.palette.accent}";
              childBorder = "#${config.colorScheme.palette.accent}";
            };
            focusedInactive = {
              border = "#${config.colorScheme.palette.background01}";
              background = "#${config.colorScheme.palette.background01}";
              text = "#${config.colorScheme.palette.foreground}";
              indicator = "#${config.colorScheme.palette.background01}";
              childBorder = "#${config.colorScheme.palette.background01}";
            };
            unfocused = {
              border = "#${config.colorScheme.palette.background02}";
              background = "#${config.colorScheme.palette.background}";
              text = "#${config.colorScheme.palette.foreground}";
              indicator = "#${config.colorScheme.palette.background02}";
              childBorder = "#${config.colorScheme.palette.background02}";
            };
            urgent = {
              border = "#${config.colorScheme.palette.red}";
              background = "#${config.colorScheme.palette.red}";
              text = "#${config.colorScheme.palette.foreground}";
              indicator = "#${config.colorScheme.palette.red}";
              childBorder = "#${config.colorScheme.palette.red}";
            };
            placeholder = {
              border = "#${config.colorScheme.palette.background}";
              background = "#${config.colorScheme.palette.background}";
              text = "#${config.colorScheme.palette.foreground}";
              indicator = "#${config.colorScheme.palette.background}";
              childBorder = "#${config.colorScheme.palette.background}";
            };
            background = "#${config.colorScheme.palette.foreground03}";
          };
          workspaceOutputAssign = [
            {
              workspace = "$ws1";
              output = ["DP-1" "DP-4" "eDP-1"];
            }
            {
              workspace = "$ws2";
              output = ["DP-1" "DP-4" "eDP-1"];
            }
            {
              workspace = "$ws3";
              output = ["DP-1" "DP-4" "eDP-1"];
            }
            {
              workspace = "$ws4";
              output = ["DP-1" "DP-4" "eDP-1"];
            }
            {
              workspace = "$ws5";
              output = ["DP-1" "DP-4" "eDP-1"];
            }
            {
              workspace = "$ws6";
              output = ["HDMI-A-1" "eDP-1"];
            }
            {
              workspace = "$ws7";
              output = ["HDMI-A-1" "eDP-1"];
            }
            {
              workspace = "$ws8";
              output = ["HDMI-A-1" "eDP-1"];
            }
            {
              workspace = "$ws9";
              output = ["HDMI-A-1" "eDP-1"];
            }
            {
              workspace = "$ws10";
              output = ["HDMI-A-1" "eDP-1"];
            }
          ];
          gaps = {
            inner = 10;
            outer = -3;
            smartGaps = false;
            smartBorders = "off";
          };
          keybindings = {
            "${mod}+Return" = "exec kitty";
            "${mod}+Shift+q" = "kill";
            "${mod}+x" = "[urgent=latest] focus";
            "${mod}+h" = "focus left";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+l" = "focus right";
            "${mod}+Left" = "focus left";
            "${mod}+Down" = "focus down";
            "${mod}+Up" = "focus up";
            "${mod}+Right" = "focus right";
            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+l" = "move right";
            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Down" = "move down";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Right" = "move right";
            "${mod}+Ctrl+Shift+l" = "move workspace to output right";
            "${mod}+Ctrl+Shift+h" = "move workspace to output left";
            "${mod}+Ctrl+Shift+j" = "move workspace to output down";
            "${mod}+Ctrl+Shift+k" = "move workspace to output up";
            "${mod}+${alt}+h" = "split h";
            "${mod}+${alt}+v" = "split v";
            "${mod}+f" = "fullscreen toggle";
            "${mod}+s" = "layout stacking";
            "${mod}+w" = "layout tabbed";
            "${mod}+e" = "layout toggle split";
            "${mod}+d" = "exec ${menu}";
            "${mod}+o" = "exec ${pkgs.rofi-ykman}/bin/rofi-ykman";
            "${mod}+Shift+a" = "exec ${pkgs.dunst}/bin/dunstctl context";
            "${mod}+Shift+space" = "floating toggle";
            "${mod}+space" = "focus mode_toggle";
            "${mod}+a" = "focus parent";
            "${mod}+1" = "workspace number $ws1";
            "${mod}+2" = "workspace number $ws2";
            "${mod}+3" = "workspace number $ws3";
            "${mod}+4" = "workspace number $ws4";
            "${mod}+5" = "workspace number $ws5";
            "${mod}+6" = "workspace number $ws6";
            "${mod}+7" = "workspace number $ws7";
            "${mod}+8" = "workspace number $ws8";
            "${mod}+9" = "workspace number $ws9";
            "${mod}+0" = "workspace number $ws10";
            "${mod}+Shift+1" = "move container to workspace number 1; workspace $ws1";
            "${mod}+Shift+2" = "move container to workspace number 2; workspace $ws2";
            "${mod}+Shift+3" = "move container to workspace number 3; workspace $ws3";
            "${mod}+Shift+4" = "move container to workspace number 4; workspace $ws4";
            "${mod}+Shift+5" = "move container to workspace number 5; workspace $ws5";
            "${mod}+Shift+6" = "move container to workspace number 6; workspace $ws6";
            "${mod}+Shift+7" = "move container to workspace number 7; workspace $ws7";
            "${mod}+Shift+8" = "move container to workspace number 8; workspace $ws8";
            "${mod}+Shift+9" = "move container to workspace number 9; workspace $ws9";
            "${mod}+Shift+0" = "move container to workspace number 10; workspace $ws10";
            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+r" = "restart";
            "${mod}+Shift+e" = "exec ${pkgs.wofi-powermenu}/bin/wofi-powermenu";
            "${mod}+r" = "mode resize";
            "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl --player spotify play-pause";
            "Print" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | wl-copy'';
            "${alt}+Print" = ''exec ${pkgs.sway}/bin/swaymsg -t get_tree | ${pkgs.jq}/bin/jq -r '.. | (.nodes? // empty)[] | select(.focused) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"' | ${pkgs.grim}/bin/grim -g - - | wl-copy'';
            "Ctrl+Shift+period" = "${pkgs.dunst}/bin/dunstctl context";
          };
          assigns = {
            "4" = [
              {class = "Steam";}
              {class = "steam";}
              {class = "steamwebhelper";}
            ];
            "7" = [
              {app_id = "Slack";}
              {class = "ArmCord";}
              {app_id = "info.mumble.Mumble";}
              {class = "Element";}
            ];
            "8" = [
              {con_mark = "Spotify";}
            ];
            "9" = [
              {app_id = "Bitwarden";}
            ];
            "10" = [
              {class = "Signal";}
            ];
          };
          window = {
            titlebar = false;
            border = 3;
            commands = [
              {
                command = "move scratchpad";
                criteria = {title = "Wine System Tray";};
              }
              {
                command = "move scratchpad";
                criteria = {title = "Firefox — Sharing Indicator";};
              }
              {
                command = "inhibit_idle fullscreen";
                criteria = {class = ".*";};
              }
              {
                command = "inhibit_idle fullscreen";
                criteria = {app_id = ".*";};
              }
            ];
          };
        };
      };
    };
  };
}
