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

    useNvidia = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    aspects.graphical.wayland.enable = true;

    programs.hyprland = {
      enable = true;
      nvidiaPatches = config.aspects.graphical.hyprland.useNvidia;
      xwayland = {
        enable = true;
        hidpi = true;
      };
    };

    environment.systemPackages = with pkgs; [
      qt5.qtwayland
      qt6.qtwayland
      xwaylandvideobridge
    ];

    environment.sessionVariables =
      {
        GDK_BACKEND = "wayland,x11";
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        LIBSEAT_BACKEND = "logind";
        NIXOS_OZONE_WL = "1";
      }
      // lib.attrsets.optionalAttrs config.aspects.graphical.hyprland.useNvidia {
        GBM_BACKEND = "nvidia-drm";
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
        XDG_SESSION_TYPE = "wayland";
      };

    services.greetd = {
      enable = true;
      settings = {
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
        nvidiaPatches = osConfig.aspects.graphical.hyprland.useNvidia;
        xwayland = {
          enable = true;
          hidpi = true;
        };
        recommendedEnvironment = true;
        systemdIntegration = true;
        extraConfig = ''
          general {
            gaps_in=5
            gaps_out=5
            border_size=3.5
            col.active_border=0xff${config.colorScheme.colors.accent}
            col.inactive_border=0xff${config.colorScheme.colors.background02}
            col.group_border_active=0xff${config.colorScheme.colors.accent}
            col.group_border=0xff${config.colorScheme.colors.foreground01}
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
            blur=true
            blur_size=6
            blur_passes=3
            blur_new_optimizations=true
            blur_ignore_opacity=false
            drop_shadow=false
          }
          misc {
            mouse_move_enables_dpms=true
            groupbar_gradients=false
            # TODO enable when available
            # groupbar_text_color=0xff${config.colorScheme.colors.foreground}
          }
          input {
            kb_layout=us
            kb_variant=altgr-intl
          }
          $mainMod = SUPER
          # Startup
          exec=${pkgs.swaybg}/bin/swaybg -i ${pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper}} --mode fill
          exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          # Program bindings
          bind=$mainMod,Return,exec,${pkgs.kitty}/bin/kitty
          bind=$mainMod,f,fullscreen,0
          bind=$mainMod,d,exec,${pkgs.wofi}/bin/wofi -IS drun -W 40% -H 50%
          bind=$mainMod,o,exec,${pkgs.rofi-ykman}/bin/rofi-ykman
          bind=$mainMod SHIFT,e,exec,${pkgs.wofi-powermenu}/bin/wofi-powermenu
          binde=,XF86AudioRaiseVolume,exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%
          binde=,XF86AudioLowerVolume,exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%
          bind=,XF86AudioMute,exec,${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle
          bind=,XF86AudioPlay,exec,${pkgs.playerctl}/bin/playerctl --player spotify play-pause
          bind=,Print,exec,${pkgs.gnome.gnome-screenshot}/bin/gnome-screenshot -i
          # Window manager controls
          bind=$mainMod CONTROL, h, moveintogroup,l
          bind=$mainMod CONTROL, j, moveintogroup,d
          bind=$mainMod CONTROL, k, moveintogroup,u
          bind=$mainMod CONTROL, l, moveintogroup,r
          bind=$mainMod, Tab, changegroupactive,f
          bind=$mainMod SHIFT, Tab, changegroupactive,b
          bind=$mainMod, w, togglegroup,
          bind=$mainMod SHIFT,q,killactive
          bind=$mainMod,1,workspace,01
          bind=$mainMod,2,workspace,02
          bind=$mainMod,3,workspace,03
          bind=$mainMod,4,workspace,04
          bind=$mainMod,5,workspace,05
          bind=$mainMod,6,workspace,06
          bind=$mainMod,7,workspace,07
          bind=$mainMod,8,workspace,08
          bind=$mainMod,9,workspace,09
          bind=$mainMod,0,workspace,10
          bind=$mainMod SHIFT,1,movetoworkspace,01
          bind=$mainMod SHIFT,2,movetoworkspace,02
          bind=$mainMod SHIFT,3,movetoworkspace,03
          bind=$mainMod SHIFT,4,movetoworkspace,04
          bind=$mainMod SHIFT,5,movetoworkspace,05
          bind=$mainMod SHIFT,6,movetoworkspace,06
          bind=$mainMod SHIFT,7,movetoworkspace,07
          bind=$mainMod SHIFT,8,movetoworkspace,08
          bind=$mainMod SHIFT,9,movetoworkspace,09
          bind=$mainMod SHIFT,0,movetoworkspace,10
          bind=$mainMod,h,movefocus,l
          bind=$mainMod,j,movefocus,d
          bind=$mainMod,k,movefocus,u
          bind=$mainMod,l,movefocus,r
          bind=$mainMod SHIFT,h,movewindow,l
          bind=$mainMod SHIFT,j,movewindow,d
          bind=$mainMod SHIFT,k,movewindow,u
          bind=$mainMod SHIFT,l,movewindow,r

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
          monitor=eDP-1,highres,auto,1.3
          monitor=DP-4,highres,0x1956,1.5
        '';
      };
    };
  };
}
