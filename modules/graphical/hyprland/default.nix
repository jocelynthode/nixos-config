{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../wayland
  ];

  options.aspects.graphical.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    aspects.graphical.wayland.enable = true;

    programs.hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };

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
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "jocelyn";
        };
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    home-manager.sharedModules = [inputs.hyprland.homeManagerModules.default];

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
        hyprpaper
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland = {
          enable = true;
        };
        systemd = {
          enable = true;
        };
        extraConfig = ''
          general {
            gaps_in=5
            gaps_out=5
            border_size=3
            col.active_border=0xff${config.colorScheme.palette.accent}
            col.inactive_border=0xff${config.colorScheme.palette.background02}
            cursor_inactive_timeout=0
            layout=dwindle
          }

          dwindle {
            force_split=2
            preserve_split=true
          }

          decoration {
            active_opacity=1.0
            inactive_opacity=1.0
            fullscreen_opacity=1.0
            rounding=5
            blur {
              enabled = true
              size = 6
              passes = 3
            }
            drop_shadow=false
          }
          misc {
            mouse_move_enables_dpms=true
            force_default_wallpaper=0
          }
          group {
            col.border_active=0xff${config.colorScheme.palette.accent}
            col.border_inactive=0xff${config.colorScheme.palette.background02}
            groupbar {
              gradients=true
              text_color=0xff${config.colorScheme.palette.foreground}
            }
          }
          input {
            kb_layout=fr
            kb_variant=ergol
          }
          $mainMod = SUPER
          # Startup
          exec=${pkgs.swaybg}/bin/swaybg -i ${pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper}} --mode fill
          exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          # Program bindings
          bind=$mainMod,Return,exec,${pkgs.kitty}/bin/kitty
          bind=$mainMod,r,fullscreen,0
          bind=$mainMod,n,exec,${pkgs.wofi}/bin/wofi -IS drun -W 40% -H 50%
          bind=$mainMod,a,exec,${pkgs.rofi-ykman}/bin/rofi-ykman
          bind=$mainMod,e,exec,${pkgs.wofi-powermenu}/bin/wofi-powermenu
          binde=,XF86AudioRaiseVolume,exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%
          binde=,XF86AudioLowerVolume,exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%
          bind=,XF86AudioMute,exec,${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle
          bind=,XF86AudioPlay,exec,${pkgs.playerctl}/bin/playerctl --player spotify play-pause
          bind=,Print,exec,${pkgs.gnome-screenshot}/bin/gnome-screenshot -i
          # Window manager controls
          bind=$mainMod CONTROL, left, moveintogroup,l
          bind=$mainMod CONTROL, down, moveintogroup,d
          bind=$mainMod CONTROL, up, moveintogroup,u
          bind=$mainMod CONTROL, right, moveintogroup,r
          bind=$mainMod, Tab, changegroupactive,f
          bind=$mainMod SHIFT, Tab, changegroupactive,b
          bind=$mainMod, t, togglegroup,
          bind=$mainMod SHIFT,q,killactive
          bind=$mainMod,q,workspace,01
          bind=$mainMod,c,workspace,02
          bind=$mainMod,o,workspace,03
          bind=$mainMod,p,workspace,04
          bind=$mainMod,w,workspace,05
          bind=$mainMod,j,workspace,06
          bind=$mainMod,m,workspace,07
          bind=$mainMod,d,workspace,08
          bind=$mainMod,9,workspace,09
          bind=$mainMod,y,workspace,10
          bind=$mainMod SHIFT,q,movetoworkspace,01
          bind=$mainMod SHIFT,c,movetoworkspace,02
          bind=$mainMod SHIFT,o,movetoworkspace,03
          bind=$mainMod SHIFT,p,movetoworkspace,04
          bind=$mainMod SHIFT,w,movetoworkspace,05
          bind=$mainMod SHIFT,j,movetoworkspace,06
          bind=$mainMod SHIFT,m,movetoworkspace,07
          bind=$mainMod SHIFT,d,movetoworkspace,08
          bind=$mainMod SHIFT,9,movetoworkspace,09
          bind=$mainMod SHIFT,y,movetoworkspace,10
          bind=$mainMod,left,movefocus,l
          bind=$mainMod,down,movefocus,d
          bind=$mainMod,up,movefocus,u
          bind=$mainMod,right,movefocus,r
          bind=$mainMod SHIFT,left,movewindow,l
          bind=$mainMod SHIFT,down,movewindow,d
          bind=$mainMod SHIFT,up,movewindow,u
          bind=$mainMod SHIFT,right,movewindow,r

          blurls=wofi

          windowrulev2=workspace 4 silent,class:steam
          windowrulev2=workspace 4 silent,class:steamwebhelper
          windowrulev2=workspace 7 silent,class:Slack
          windowrulev2=workspace 7 silent,class:discord
          windowrulev2=workspace 7 silent,class:Mumble
          windowrulev2=workspace 7 silent,class:Signal
          windowrulev2=workspace 8 silent,title:^(Spotify)$
          windowrulev2=workspace 9 silent,class:Bitwarden
          windowrulev2=opacity 0.85 0.85,title:^(Spotify)$
          windowrulev2=opacity 0.85 0.85,class:kitty
          windowrulev2=tile,title:^(Spotify)$
          windowrulev2=tile,class:^(battle.net.exe)$
          windowrulev2=float,title:^(Firefox — Sharing Indicator)$
          windowrulev2=pin,title:^(Firefox — Sharing Indicator)$
          windowrulev2 = opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$
          windowrulev2 = noanim,class:^(xwaylandvideobridge)$
          windowrulev2 = nofocus,class:^(xwaylandvideobridge)$
          windowrulev2 = noinitialfocus,class:^(xwaylandvideobridge)$

          workspace=1,monitor:DP-1,default:true
          workspace=2,monitor:DP-1
          workspace=3,monitor:DP-1
          workspace=4,monitor:DP-1
          workspace=5,monitor:DP-1
          workspace=6,monitor:HDMI-A-1,default:true
          workspace=7,monitor:HDMI-A-1
          workspace=8,monitor:HDMI-A-1
          workspace=9,monitor:HDMI-A-1
          workspace=10,monitor:HDMI-A-1

          monitor=,highres,auto,auto
          monitor=eDP-1,highres,auto,1.33333
          monitor=DP-4,highres,0x1956,1.5
          monitor=DP-3,highres,0x1440,1.5
        '';
      };
    };
  };
}
