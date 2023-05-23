{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./kanshi
    ./mako
    ./swayidle
    ./waybar
    ./wofi
  ];

  options.aspects.graphical.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    dpi = lib.mkOption {
      default = 100;
      example = 150;
    };
    useNvidia = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    xdg.portal = {
      wlr.enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
    };

    programs.hyprland = {
      enable = true;
      nvidiaPatches = config.aspects.graphical.hyprland.useNvidia;
    };

    environment.systemPackages = with pkgs; [
      qt5.qtwayland
    ];

    environment.etc."greetd/environments".text = "Hyprland";
    environment.etc."greetd/gtkgreet.css".text = ''
      window {
         background-size: cover;
         background-position: center;
      }
      box#body {
         border-radius: 10px;
         position: center;
         padding: 15px;
      }
    '';
    environment.sessionVariables =
      {
        MOZ_ENABLE_WAYLAND = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        LIBSEAT_BACKEND = "logind";
        SDL_VIDEODRIVER = "wayland";
      }
      // lib.attrsets.optionalAttrs config.hardware.nvidia.modesetting.enable {
        GBM_BACKEND = "nvidia-drm";
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
        GDK_BACKEND = "wayland,x11";
        WLR_NO_HARDWARE_CURSORS = "1";
        XDG_SESSION_TYPE = "wayland";
      };

    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -s /etc/greetd/gtkgreet.css";
          user = "jocelyn";
        };
        default_session = initial_session;
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
        extraConfig = ''
          general {
            gaps_in=5
            gaps_out=5
            border_size=2.7
            col.active_border=0xff${config.colorScheme.colors.pink}
            col.inactive_border=0xff${config.colorScheme.colors.background02}
            col.group_border_active=0xff${config.colorScheme.colors.green}
            col.group_border=0xff${config.colorScheme.colors.foreground01}
            cursor_inactive_timeout=0
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
          }
          input {
            kb_layout=us
            kb_variant=altgr-intl
          }
          # Startup
          exec=${pkgs.swaybg}/bin/swaybg -i ${pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper}} --mode fill
          exec-once=${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          # Mouse binding
          bindm=SUPER,mouse:272,movewindow
          bindm=SUPER,mouse:273,resizewindow
          # Program bindings
          bind=SUPER,Return,exec,${pkgs.kitty}/bin/kitty
          bind=SUPER,f,fullscreen,0
          bind=SUPER,d,exec,${pkgs.wofi}/bin/wofi -IS drun -W 25% -H 25%
          bind=SUPERSHIFT,e,exec,${pkgs.wofi-powermenu}/bin/wofi-powermenu
          binde=,XF86AudioRaiseVolume,exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%
          binde=,XF86AudioLowerVolume,exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%
          bind=,XF86AudioMute,exec,${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle
          bind=,XF86AudioPlay,exec,${pkgs.playerctl}/bin/playerctl --player spotify play-pause
          bind=,Print,exec,${pkgs.gnome.gnome-screenshot}/bin/gnome-screenshot -i
          # Window manager controls
          bind=SUPERSHIFT,q,killactive
          bind=SUPER,1,workspace,01
          bind=SUPER,2,workspace,02
          bind=SUPER,3,workspace,03
          bind=SUPER,4,workspace,04
          bind=SUPER,5,workspace,05
          bind=SUPER,6,workspace,06
          bind=SUPER,7,workspace,07
          bind=SUPER,8,workspace,08
          bind=SUPER,9,workspace,09
          bind=SUPER,0,workspace,10
          bind=SUPERSHIFT,1,movetoworkspace,01
          bind=SUPERSHIFT,2,movetoworkspace,02
          bind=SUPERSHIFT,3,movetoworkspace,03
          bind=SUPERSHIFT,4,movetoworkspace,04
          bind=SUPERSHIFT,5,movetoworkspace,05
          bind=SUPERSHIFT,6,movetoworkspace,06
          bind=SUPERSHIFT,7,movetoworkspace,07
          bind=SUPERSHIFT,8,movetoworkspace,08
          bind=SUPERSHIFT,9,movetoworkspace,09
          bind=SUPERSHIFT,0,movetoworkspace,10
          bind=SUPER,h,movefocus,l
          bind=SUPER,j,movefocus,d
          bind=SUPER,k,movefocus,u
          bind=SUPER,l,movefocus,r
          bind=SUPERSHIFT,h,movewindow,l
          bind=SUPERSHIFT,j,movewindow,d
          bind=SUPERSHIFT,k,movewindow,u
          bind=SUPERSHIFT,l,movewindow,r

          blurls=waybar
          blurls=wofi

          windowrule=workspace 4,Steam
          windowrule=workspace 4,steamwebhelper
          windowrule=workspace 7,Slack
          windowrule=workspace 7,discord
          windowrule=workspace 7,Mumble
          windowrule=workspace 7,Signal
          windowrule=workspace 8,Spotify
          windowrule=workspace 9,Bitwarden
          windowrule=opacity 0.85,Spotify
          windowrule=tile,Spotify

          workspace=1,monitor:DP-4,default:true
          workspace=2,monitor:DP-4
          workspace=3,monitor:DP-4
          workspace=4,monitor:DP-4
          workspace=5,monitor:DP-4
          workspace=6,monitor:eDP-1,default:true
          workspace=7,monitor:eDP-1
          workspace=8,monitor:eDP-1
          workspace=9,monitor:eDP-1
          workspace=10,monitor:eDP-1
        '';
      };
    };
  };
}
