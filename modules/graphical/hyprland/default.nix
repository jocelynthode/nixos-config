{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./kanshi
    ./swayidle
    ./waybar
    ./wofi
  ];

  options.aspects.graphical.hyprland = {
    enable = lib.mkEnableOption "hyprland";

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
          }
          input {
            kb_layout=us
            kb_variant=altgr-intl
          }
          $mainMod = SUPER
          # Startup
          exec=${pkgs.swaybg}/bin/swaybg -i ${pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper}} --mode fill
          exec-once=${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          # Mouse binding
          bindm=$mainMod,mouse:272,movewindow
          bindm=$mainMod,mouse:273,resizewindow
          # Program bindings
          bind=$mainMod,Return,exec,${pkgs.kitty}/bin/kitty
          bind=$mainMod,f,fullscreen,0
          bind=$mainMod,d,exec,${pkgs.wofi}/bin/wofi -IS drun -W 40% -H 50%
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

          windowrule=workspace 4,Steam
          windowrule=workspace 4,steamwebhelper
          windowrule=workspace 7,Slack
          windowrule=workspace 7,discord
          windowrule=workspace 7,Mumble
          windowrule=workspace 7,Signal
          windowrule=workspace 8,title:^(Spotify)$
          windowrule=workspace 9,Bitwarden
          windowrule=opacity 0.85 0.85,title:^(Spotify)$
          windowrule=opacity 0.85 0.85,kitty
          windowrule=tile,title:^(Spotify)$


          monitor=,highres,auto,1.3
        '';
      };
    };
  };
}
