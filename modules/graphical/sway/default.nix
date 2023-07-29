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
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
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
        systemd.enable = true;
        xwayland = true;
        wrapperFeatures.gtk = true;
        extraSessionCommands = ''
          export GDK_BACKEND="wayland,x11"
          export QT_QPA_PLATFORM=wayland
          export SDL_VIDEODRIVE =wayland
          export CLUTTER_BACKEND=wayland
          export MOZ_ENABLE_WAYLAND=1
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
              border = "#${config.colorscheme.colors.accent}";
              background = "#${config.colorscheme.colors.background01}";
              text = "#${config.colorscheme.colors.foreground}";
              indicator = "#${config.colorscheme.colors.accent}";
              childBorder = "#${config.colorscheme.colors.accent}";
            };
            focusedInactive = {
              border = "#${config.colorscheme.colors.background01}";
              background = "#${config.colorscheme.colors.background01}";
              text = "#${config.colorscheme.colors.foreground}";
              indicator = "#${config.colorscheme.colors.background01}";
              childBorder = "#${config.colorscheme.colors.background01}";
            };
            unfocused = {
              border = "#${config.colorscheme.colors.background02}";
              background = "#${config.colorscheme.colors.background}";
              text = "#${config.colorscheme.colors.foreground}";
              indicator = "#${config.colorscheme.colors.background02}";
              childBorder = "#${config.colorscheme.colors.background02}";
            };
            urgent = {
              border = "#${config.colorscheme.colors.red}";
              background = "#${config.colorscheme.colors.red}";
              text = "#${config.colorscheme.colors.foreground}";
              indicator = "#${config.colorscheme.colors.red}";
              childBorder = "#${config.colorscheme.colors.red}";
            };
            placeholder = {
              border = "#${config.colorscheme.colors.background}";
              background = "#${config.colorscheme.colors.background}";
              text = "#${config.colorscheme.colors.foreground}";
              indicator = "#${config.colorscheme.colors.background}";
              childBorder = "#${config.colorscheme.colors.background}";
            };
            background = "#${config.colorscheme.colors.foreground03}";
          };
          workspaceOutputAssign = [
            {
              workspace = "1";
              output = "DP-4 DP-3 eDP-1 DP-1";
            }
            {
              workspace = "2";
              output = "DP-4 DP-3 eDP-1 DP-1";
            }
            {
              workspace = "3";
              output = "DP-4 DP-3 eDP-1 DP-1";
            }
            {
              workspace = "4";
              output = "DP-4 DP-3 eDP-1 DP-1";
            }
            {
              workspace = "5";
              output = "DP-4 DP-3 eDP-1 DP-1";
            }
            {
              workspace = "6";
              output = "eDP-1 DP-3 DP-4 HDMI-A-1";
            }
            {
              workspace = "7";
              output = "eDP-1 DP-3 DP-4 HDMI-A-1";
            }
            {
              workspace = "8";
              output = "eDP-1 DP-3 DP-4 HDMI-A-1";
            }
            {
              workspace = "9";
              output = "eDP-1 DP-3 DP-4 HDMI-A-1";
            }
            {
              workspace = "10";
              output = "eDP-1 DP-3 DP-4 HDMI-A-1";
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
            "${mod}+Shift+space" = "floating toggle";
            "${mod}+space" = "focus mode_toggle";
            "${mod}+a" = "focus parent";
            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";
            "${mod}+0" = "workspace number 10";
            "${mod}+Shift+1" = "move container to workspace number 1; workspace 1";
            "${mod}+Shift+2" = "move container to workspace number 2; workspace 2";
            "${mod}+Shift+3" = "move container to workspace number 3; workspace 3";
            "${mod}+Shift+4" = "move container to workspace number 4; workspace 4";
            "${mod}+Shift+5" = "move container to workspace number 5; workspace 5";
            "${mod}+Shift+6" = "move container to workspace number 6; workspace 6";
            "${mod}+Shift+7" = "move container to workspace number 7; workspace 7";
            "${mod}+Shift+8" = "move container to workspace number 8; workspace 8";
            "${mod}+Shift+9" = "move container to workspace number 9; workspace 9";
            "${mod}+Shift+0" = "move container to workspace number 10; workspace 10";
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
              {class = "Slack";}
              {class = "discord";}
              {class = "Mumble";}
              {class = "Element";}
            ];
            "9" = [
              {class = "Bitwarden";}
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
                command = "move to workspace 8";
                criteria = {class = "Spotify";};
              }
              {
                command = "move scratchpad";
                criteria = {title = "Wine System Tray";};
              }
              {
                command = "move scratchpad";
                criteria = {title = "Firefox — Sharing Indicator";};
              }
            ];
          };
        };
      };
    };
  };
}
