{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.graphical.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    workspace = lib.mkOption {
      default = [ ];
      example = [
        "1,monitor:DP-1,default:true"
        "2,monitor:DP-1"
      ];
    };
    monitor = lib.mkOption {
      default = [
        ",highres,auto,auto"
      ];
      example = [
        ",highres,auto,auto"
        "eDP-1,highres,auto,1.33333"
      ];
    };
  };

  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      withUWSM = true;
    };

    programs.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
      qt5.qtwayland
      qt6.qtwayland
      hyprland-qtutils
    ];

    environment.sessionVariables = {
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      CLUTTER_BACKEND = "wayland";
      LIBSEAT_BACKEND = "logind";
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
          user = "jocelyn";
        };
        default_session = {
          command = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
          user = "jocelyn";
        };
      };
    };

    home-manager.users.jocelyn =
      { osConfig, ... }:
      {
        home.packages = with pkgs; [
          imv
          grim
          slurp
          waypipe
          wl-clipboard
          ydotool
        ];

        programs.hyprlock = {
          enable = true;
          settings = {
            general = {
              disable_loading_bar = true;
              grace = 5;
              hide_cursor = true;
              no_fade_in = false;
            };
            background = [
              {
                path = "${pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper}}";
                blur_passes = 0;
                color = "$base";
              }
            ];

            label = [
              {
                monitor = "";
                text = "Layout: $LAYOUT";
                color = "$text";
                font_size = 25;
                font_family = osConfig.aspects.base.fonts.monospace.family;
                position = "30, -30";
                halign = "left";
                valign = "top";
              }
              {
                monitor = "";
                text = "$TIME";
                color = "$text";
                font_size = 90;
                font_family = osConfig.aspects.base.fonts.monospace.family;
                position = "-30, 0";
                halign = "right";
                valign = "top";
              }
              {
                monitor = "";
                text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
                color = "$text";
                font_size = 25;
                font_family = osConfig.aspects.base.fonts.monospace.family;
                position = "-30, -150";
                halign = "right";
                valign = "top";
              }
            ];

            input-field = [
              {
                monitor = "";
                size = "300, 60";
                outline_thickness = 4;
                dots_size = 0.2;
                dots_spacing = 0.2;
                dots_center = true;
                outer_color = "$accent";
                inner_color = "$surface0";
                font_color = "$text";
                fade_on_empty = false;
                placeholder_text = "<span foreground=\"##$textAlpha\"><i>󰌾 Logged in as </i><span foreground=\"##$accentAlpha\">$USER</span></span>";
                hide_input = false;
                check_color = "$accent";
                fail_color = "$red";
                fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
                capslock_color = "$yellow";
                position = "0, -47";
                halign = "center";
                valign = "center";
              }
            ];
          };
        };

        # Fix services for uwsm
        systemd.user.services = {
          hyprpaper.Unit.After = [
            "graphical-session.target"
          ];
          hypridle.Unit.After = [
            "graphical-session.target"
          ];
          waybar.Unit = {
            PartOf = [
              "graphical-session.target"
            ];
            After = [
              "graphical-session.target"
            ];
          };
        };

        services = {
          hyprpaper = {
            enable = true;
            settings = {
              ipc = "on";
              splash = false;
              splash_offset = 2.0;
              preload = [
                "${pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper}}"
              ];
              wallpaper = [
                ",${pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper}}"
              ];
            };
          };
          hypridle = {
            enable = true;
            settings = {
              general = {
                lock_cmd = "pidof hyprlock || hyprlock -q";
                before_sleep_cmd = "loginctl lock-session";
                after_sleep_cmd = "hyprctl dispatch dpms on";
                ignore_dbus_inhibit = false;
                ignore_systemd_inhibit = false;
              };

              listener = [
                {
                  timeout = 600;
                  on-timeout = "hyprlock";
                }
                {
                  timeout = 610;
                  command = "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ yes";
                }
                {
                  timeout = 700;
                  on-timeout = "hyprctl dispatch dpms off";
                  on-resume = "hyprctl dispatch dpms on";
                }
              ];
            };
          };
        };

        catppuccin = {
          hyprland.enable = true;
          hyprlock.enable = true;
        };
        wayland.windowManager.hyprland = {
          enable = true;
          xwayland = {
            enable = true;
          };
          systemd = {
            enable = false;
          };
          settings = {
            general = {
              gaps_in = 5;
              gaps_out = 5;
              border_size = 3;
              layout = "dwindle";
              "col.active_border" = "$accent";
              "col.inactive_border" = "$base";
            };
            cursor = {
              inactive_timeout = 0;
            };
            # https://github.com/ValveSoftware/gamescope/issues/1825#issuecomment-2883202415
            debug = {
              full_cm_proto = true;
              # disable_logs = false;
            };
            dwindle = {
              force_split = 2;
              preserve_split = true;
            };
            decoration = {
              active_opacity = 1.0;
              inactive_opacity = 1.0;
              fullscreen_opacity = 1.0;
              rounding = 5;
              blur = {
                enabled = true;
                size = 6;
                passes = 3;
              };
              shadow = {
                enabled = false;
              };
            };
            exec = [
              "${pkgs.hyprland}/bin/hyprctl switchxkblayout current 1"
            ];
            exec-once = [
              "uwsm app -- firefox"
              "uwsm app -- signal-desktop"
              "uwsm app -- feishin"
            ]
            ++ lib.optional osConfig.aspects.games.steam.enable "uwsm app -- steam";
            ecosystem = {
              no_update_news = true;
              no_donation_nag = true;
            };
            group = {
              "col.border_active" = "$accent";
              "col.border_inactive" = "$base";
              groupbar = {
                gradients = true;
                text_color = "$text";
              };
            };
            misc = {
              mouse_move_enables_dpms = true;
              force_default_wallpaper = 0;
            };
            input = {
              kb_layout = "us,fr";
              kb_variant = ",ergol";
              resolve_binds_by_sym = true;
            };
            "$mod" = "SUPER";
            bind = [
              "$mod,Return,exec,uwsm app -- ${pkgs.kitty}/bin/kitty"
              "$mod,n,exec,${pkgs.wofi}/bin/wofi -IS drun -W 40% -H 50%"
              "$mod,a,exec,${pkgs.wofi-ykman}/bin/wofi-ykman"
              "$mod,e,exec,${pkgs.wleave}/bin/wleave"
              ",XF86AudioMute,exec,${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle"
              ",XF86AudioPlay,exec,${pkgs.playerctl}/bin/playerctl --player spotify play-pause"
              ",Print,exec,${pkgs.hyprshot}/bin/hyprshot --clipboard-only -m region"
              "ALT,Print,exec,${pkgs.hyprshot}/bin/hyprshot --clipboard-only -m active"
              "$mod CONTROL, left, moveintogroup,l"
              "$mod CONTROL, down, moveintogroup,d"
              "$mod CONTROL, up, moveintogroup,u"
              "$mod CONTROL, right, moveintogroup,r"
              "$mod, Tab, changegroupactive,f"
              "$mod SHIFT, Tab, changegroupactive,b"
              "$mod, t, togglegroup,"
              "$mod,x,killactive"
              "$mod,r,fullscreen"
              "$mod,q,workspace,01"
              "$mod,c,workspace,02"
              "$mod,o,workspace,03"
              "$mod,p,workspace,04"
              "$mod,w,workspace,05"
              "$mod,j,workspace,06"
              "$mod,m,workspace,07"
              "$mod,d,workspace,08"
              "$mod,9,workspace,09"
              "$mod,y,workspace,10"
              "$mod SHIFT,q,movetoworkspace,01"
              "$mod SHIFT,c,movetoworkspace,02"
              "$mod SHIFT,o,movetoworkspace,03"
              "$mod SHIFT,p,movetoworkspace,04"
              "$mod SHIFT,w,movetoworkspace,05"
              "$mod SHIFT,j,movetoworkspace,06"
              "$mod SHIFT,m,movetoworkspace,07"
              "$mod SHIFT,d,movetoworkspace,08"
              "$mod SHIFT,9,movetoworkspace,09"
              "$mod SHIFT,y,movetoworkspace,10"
              "$mod,left,movefocus,l"
              "$mod,down,movefocus,d"
              "$mod,up,movefocus,u"
              "$mod,right,movefocus,r"
              "$mod SHIFT,left,movewindow,l"
              "$mod SHIFT,down,movewindow,d"
              "$mod SHIFT,up,movewindow,u"
              "$mod SHIFT,right,movewindow,r"
              "$mod,space,exec,hyprctl switchxkblayout current next"
            ];
            binde = [
              ",XF86AudioRaiseVolume,exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%"
              ",XF86AudioLowerVolume,exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%"
            ];
            blurls = "wofi";
            windowrulev2 = [
              "workspace 4 silent,class:steam"
              "workspace 4 silent,class:steamwebhelper"
              "workspace 4 silent,class:gamescope"
              "workspace 7 silent,class:Slack"
              "workspace 7 silent,class:vesktop"
              "workspace 7 silent,class:info.mumble.Mumble"
              "workspace 10 silent,class:signal"
              "workspace 8 silent,class:spotify"
              "workspace 8 silent,class:feishin"
              "workspace 9 silent,class:Bitwarden"
              "opacity 0.85 0.85,class:spotify"
              "opacity 0.85 0.85,class:feishin"
              "opacity 0.85 0.85,class:kitty"
              "tile,class:spotify"
              "float,title:^(Firefox — Sharing Indicator)$"
              "float,title:^(Proton VPN)$"
              "pin,title:^(Firefox — Sharing Indicator)$"
              "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
              "noanim,class:^(xwaylandvideobridge)$"
              "nofocus,class:^(xwaylandvideobridge)$"
              "noinitialfocus,class:^(xwaylandvideobridge)$"
              "idleinhibit fullscreen, class:^(.*)$"
              "idleinhibit fullscreen, title:^(.*)$"
              "idleinhibit fullscreen, fullscreen:1"
            ];
            inherit (osConfig.aspects.graphical.hyprland) workspace monitor;
          };
        };
      };
  };
}
