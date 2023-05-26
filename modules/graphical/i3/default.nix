{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./autorandr
    ./picom
    ./polybar
  ];

  options.aspects.graphical.i3 = {
    enable = lib.mkEnableOption "i3";
  };

  config = lib.mkIf config.aspects.graphical.i3.enable {
    aspects.graphical.rofi.package = pkgs.rofi;
    services.xserver = {
      enable = true;
      inherit (config.aspects.graphical) dpi;
      layout = "us";
      xkbVariant = "altgr-intl";
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
      desktopManager = {
        xterm.enable = false;
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dex
        ];
      };
    };

    aspects.base.persistence.homePaths = [
      ".cache/betterlockscreen"
    ];

    home-manager.users.jocelyn = {
      config,
      osConfig,
      ...
    }: {
      # Required packages (hotkeys, etc)
      home.packages = with pkgs; [
        betterlockscreen
        dex
        libnotify
        feh
        playerctl
        pulseaudio # pactl
        ponymix
        xdotool
        xsel
      ];

      services.screen-locker = {
        enable = true;
        inactiveInterval = 15;
        lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
        xautolock.extraOptions = [
          "Xautolock.killer: systemctl suspend"
        ];
      };

      xresources.properties = {
        "*background" = "#${config.colorscheme.colors.background}";
        "*foreground" = "#${config.colorscheme.colors.foreground}";

        "*color0" = "#5C5F77";
        "*color8" = "#6C6F85";

        "*color1" = "#${config.colorscheme.colors.red}";
        "*color9" = "#${config.colorscheme.colors.red}";

        "*color2" = "#${config.colorscheme.colors.green}";
        "*color10" = "#${config.colorscheme.colors.green}";

        "*color3" = "#${config.colorscheme.colors.yellow}";
        "*color11" = "#${config.colorscheme.colors.yellow}";

        "*color4" = "#${config.colorscheme.colors.blue}";
        "*color12" = "#${config.colorscheme.colors.blue}";

        "*color5" = "#${config.colorScheme.colors.accent}";
        "*color13" = "#${config.colorScheme.colors.accent}";

        "*color6" = "#${config.colorscheme.colors.teal}";
        "*color14" = "#${config.colorscheme.colors.teal}";

        "*color7" = "#${config.colorscheme.colors.foreground01}";
        "*color15" = "#${config.colorscheme.colors.background03}";

        "Xft.dpi" = osConfig.aspects.graphical.dpi;
      };

      xsession = let
        inherit (config.colorscheme) colors;

        mod = "Mod4";
        alt = "Mod1";
      in {
        enable = true;
        # make gnome-keyring/pinentry work
        profileExtra = ''
          ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
        '';
        windowManager.i3 = {
          enable = true;
          config = {
            modifier = mod;
            bars = []; # use kde panels instead
            workspaceOutputAssign = [
              {
                workspace = "1";
                output = "DP-4 DP-3 eDP-1 DP-2";
              }
              {
                workspace = "2";
                output = "DP-4 DP-3 eDP-1 DP-2";
              }
              {
                workspace = "3";
                output = "DP-4 DP-3 eDP-1 DP-2";
              }
              {
                workspace = "4";
                output = "DP-4 DP-3 eDP-1 DP-2";
              }
              {
                workspace = "5";
                output = "DP-4 DP-3 eDP-1 DP-2";
              }
              {
                workspace = "6";
                output = "eDP-1 DP-3 DP-4 HDMI-0";
              }
              {
                workspace = "7";
                output = "eDP-1 DP-3 DP-4 HDMI-0";
              }
              {
                workspace = "8";
                output = "eDP-1 DP-3 DP-4 HDMI-0";
              }
              {
                workspace = "9";
                output = "eDP-1 DP-3 DP-4 HDMI-0";
              }
              {
                workspace = "10";
                output = "eDP-1 DP-3 DP-4 HDMI-0";
              }
            ];
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
            colors = {
              focused = {
                border = "#${colors.accent}";
                background = "#${colors.background01}";
                text = "#${colors.foreground}";
                indicator = "#${colors.accent}";
                childBorder = "#${colors.accent}";
              };
              focusedInactive = {
                border = "#${colors.background01}";
                background = "#${colors.background01}";
                text = "#${colors.foreground}";
                indicator = "#${colors.background01}";
                childBorder = "#${colors.background01}";
              };
              unfocused = {
                border = "#${colors.background02}";
                background = "#${colors.background}";
                text = "#${colors.foreground}";
                indicator = "#${colors.background02}";
                childBorder = "#${colors.background02}";
              };
              urgent = {
                border = "#${colors.red}";
                background = "#${colors.red}";
                text = "#${colors.foreground}";
                indicator = "#${colors.red}";
                childBorder = "#${colors.red}";
              };
              placeholder = {
                border = "#${colors.background}";
                background = "#${colors.background}";
                text = "#${colors.foreground}";
                indicator = "#${colors.background}";
                childBorder = "#${colors.background}";
              };
              background = "#${colors.foreground03}";
            };

            floating = {
              border = 0;
              criteria = [
                {window_role = "pop-up";}
                {window_role = "task_dialog";}
                {window_type = "notification";}
                {window_type = "dialog";}
                {class = "easyeffects";}
                {class = "ProtonUp-Qt";}
                {class = "mullvad vpn";}
                {class = "Solaar";}
                {class = "org.remmina.Remmina";}
                {class = "Nm-connection-editor";}
                {class = "pavucontrol-qt";}
              ];
            };

            workspaceAutoBackAndForth = false;
            focus = {
              followMouse = true;
              newWindow = "focus";
            };

            gaps = {
              inner = 10;
              outer = -3;
              smartGaps = false;
              smartBorders = "off";
            };

            startup = [
              {
                command = "${pkgs.autorandr}/bin/autorandr --change --force";
                always = true;
                notification = false;
              }
              {
                command = "${pkgs.dex}/bin/dex --autostart --environment i3";
                notification = false;
              }
            ];
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
              "${mod}+d" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show drun -modi drun -theme launcher -dpi 1";
              "${mod}+o" = "exec --no-startup-id ${pkgs.rofi-ykman}/bin/rofi-ykman";
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
              "${mod}+Shift+e" = ''exec --no-startup-id ${pkgs.rofi}/bin/rofi -show menu -modi "menu:rofi-power-menu" -theme powermenu -dpi 1'';
              "${mod}+r" = "mode resize";
              "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
              "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
              "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
              "XF86AudioPlay" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl --player spotify play-pause";
              "Print" = "exec --no-startup-id ${pkgs.gnome.gnome-screenshot}/bin/gnome-screenshot -i";
              "${alt}+Print" = "exec --no-startup-id ${pkgs.gnome.gnome-screenshot}/bin/gnome-screenshot -c -w";
            };
            assigns = {
              "3" = [
                {class = "Falendar";}
                {class = "Kmail";}
              ];
              "4" = [
                {class = "Steam";}
                {class = "steam";}
                {class = "steamwebhelper";}
              ];
              "7" = [
                {class = "Signal";}
                {class = "Slack";}
                {class = "discord";}
                {class = "Mumble";}
                {class = "Element";}
              ];
              "9" = [
                {class = "Bitwarden";}
              ];
            };
            modes = {
              resize = {
                "j" = "resize shrink width 10 px or 10 ppt";
                "k" = "resize grow height 10 px or 10 ppt";
                "l" = "resize shrink height 10 px or 10 ppt";
                "semicolon" = "resize grow width 10 px or 10 ppt";
                "Return" = "mode default";
                "Escape" = "mode default";
                "$mod+r" = "mode default";
              };
            };
          };
        };
      };
    };
  };
}
