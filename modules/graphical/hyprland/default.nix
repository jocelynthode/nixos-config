{ config, lib, pkgs, inputs, ... }: {

  imports = [
    ./kanshi
    ./mako
    ./swayidle
    ./waybar
  ];

  options.aspects.graphical.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    dpi = lib.mkOption {
      default = 100;
      example = 150;
    };
  };

  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    xdg.portal = {
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    };

    programs.hyprland = {
      enable = true;
      package = null;
    };

    environment.systemPackages = with pkgs; [
      qt5.qtwayland
    ];

    environment.etc."greetd/environments".text = "Hyprland";
    environment.etc."greetd/gtkgreet.css".text = ''
      window {
         background-color: #000000; 
         background-size: cover;
         background-position: center;
      }
      box#body {
         border-radius: 10px;
         position: center;
         padding: 100px;
      }
    '';

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

    aspects.graphical.rofi.package = pkgs.rofi-wayland;

    home-manager.sharedModules = [ inputs.hyprland.homeManagerModules.default ];

    home-manager.users.jocelyn = { config, osConfig, ... }: {
      home.packages = with pkgs; [
        imv
        # primary-xwayland
        waypipe
        wl-clipboard
        # wl-mirror
        # wl-mirror-pick
        ydotool
      ];

      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = "true";
        QT_QPA_PLATFORM = "wayland;xcb";
        LIBSEAT_BACKEND = "logind";
      } // lib.attrsets.optionalAttrs osConfig.hardware.nvidia.modesetting.enable {
        GBM_BACKEND = "nvidia-drm";
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
        GDK_BACKEND = "wayland,x11";
      };

      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = ''
          general {
            main_mod=SUPER
            gaps_in=5
            gaps_out=5
            border_size=2.7
            col.active_border=0xff${config.colorScheme.colors.base0C}
            col.inactive_border=0xff${config.colorScheme.colors.base02}
            cursor_inactive_timeout=4
          }
          decoration {
            active_opacity=1.0
            inactive_opacity=1.0
            fullscreen_opacity=1.0
            rounding=0
            blur=true
            blur_size=6
            blur_passes=3
            blur_new_optimizations=true
            blur_ignore_opacity=true
            drop_shadow=true
            shadow_range=12
            shadow_offset=3 3
            col.shadow=0x44000000
            col.shadow_inactive=0x66000000
          }
          dwindle {
            col.group_border_active=0xff${config.colorScheme.colors.base0B}
            col.group_border=0xff${config.colorScheme.colors.base04}
            split_width_multiplier=1.35
          }
          misc {
            no_vfr=false
            mouse_move_enables_dpms=true
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
          bind=SUPER,d,exec,${pkgs.rofi}/bin/rofi -show drun -modi drun -theme launcher -dpi 1
          bind=SUPERSHIFT,e,exec,${pkgs.rofi}/bin/rofi -show menu -modi "menu:rofi-power-menu" -theme powermenu -dpi 1
          binde=,XF86AudioRaiseVolume,exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%
          binde=,XF86AudioLowerVolume,exec,${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%
          bind=,XF86AudioMute,${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle
          bind=,XF86AudioPlay,${pkgs.playerctl}/bin/playerctl --player spotify play-pause
          bind=,Print,${pkgs.gnome.gnome-screenshot}/bin/gnome-screenshot -i
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
          windowrule=workspace 4,Steam
          windowrule=workspace 7,Slack
          windowrule=workspace 7,discord
          windowrule=workspace 7,Mumble
          windowrule=workspace 7,Signal
          windowrule=workspace 8,Spotify
          windowrule=workspace 9,Bitwarden
          windowrule=float,Rofi
          windowrule=center,Rofi

          workspace=DP-1,1
          workspace=HDMI-A-1,6
          wsbind=1,DP-1
          wsbind=2,DP-1
          wsbind=3,DP-1
          wsbind=4,DP-1
          wsbind=5,DP-1
          wsbind=6,HDMI-A-1
          wsbind=7,HDMI-A-1
          wsbind=8,HDMI-A-1
          wsbind=9,HDMI-A-1
          wsbind=10,HDMI-A-1
        '';
      };
    };
  };
}
