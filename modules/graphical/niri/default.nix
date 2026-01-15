{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.aspects.graphical.niri;
in
{
  options.aspects.graphical.niri = {
    enable = lib.mkEnableOption "niri";
  };

  config = lib.mkIf cfg.enable (
    let
      niriSession = lib.getExe' config.programs.niri.package "niri-session";
    in
    {
      programs.uwsm = {
        enable = true;
        waylandCompositors.niri = {
          prettyName = "Niri";
          comment = "Niri compositor managed by UWSM";
          binPath = niriSession;
        };
      };

      programs.niri.enable = true;

      environment.systemPackages = with pkgs; [
        qt5.qtwayland
        qt6.qtwayland
        xwayland-satellite
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
            command = "${pkgs.uwsm}/bin/uwsm start niri";
            user = "jocelyn";
          };
          default_session = {
            command = "${pkgs.uwsm}/bin/uwsm start niri";
            user = "jocelyn";
          };
        };
      };

      home-manager.users.jocelyn = {
        home.packages = with pkgs; [
          imv
          grim
          slurp
          waypipe
          wl-clipboard
          ydotool
        ];

        programs.niri = {
          settings =
            let
              noctaliaIpc = [
                "noctalia-shell"
                "ipc"
                "call"
              ];
            in
            {
              workspaces = {
                "01" = {
                  open-on-output = "DP-1";
                };
                "02" = {
                  open-on-output = "DP-1";
                };
                "03" = {
                  open-on-output = "DP-1";
                };
                "04" = {
                  open-on-output = "DP-1";
                };
                "05" = {
                  open-on-output = "DP-1";
                };
                "06" = {
                  open-on-output = "HDMI-A-1";
                };
                "07" = {
                  open-on-output = "HDMI-A-1";
                };
                "08" = {
                  open-on-output = "HDMI-A-1";
                };
                "09" = {
                  open-on-output = "HDMI-A-1";
                };
                "10" = {
                  open-on-output = "HDMI-A-1";
                };
              };

              binds = {
                "Mod+Return".action.spawn = [
                  (lib.getExe pkgs.uwsm)
                  "app"
                  "--"
                  (lib.getExe pkgs.kitty)
                ];

                "Mod+n".action.spawn = noctaliaIpc ++ [
                  "launcher"
                  "toggle"
                ];

                "Mod+q".action.focus-workspace = "01";
                "Mod+c".action.focus-workspace = "02";
                "Mod+o".action.focus-workspace = "03";
                "Mod+p".action.focus-workspace = "04";
                "Mod+w".action.focus-workspace = "05";
                "Mod+j".action.focus-workspace = "06";
                "Mod+m".action.focus-workspace = "07";
                "Mod+d".action.focus-workspace = "08";
                "Mod+9".action.focus-workspace = "09";
                "Mod+y".action.focus-workspace = "10";

                "Mod+Shift+q".action.move-window-to-workspace = "01";
                "Mod+Shift+c".action.move-window-to-workspace = "02";
                "Mod+Shift+o".action.move-window-to-workspace = "03";
                "Mod+Shift+p".action.move-window-to-workspace = "04";
                "Mod+Shift+w".action.move-window-to-workspace = "05";
                "Mod+Shift+j".action.move-window-to-workspace = "06";
                "Mod+Shift+m".action.move-window-to-workspace = "07";
                "Mod+Shift+d".action.move-window-to-workspace = "08";
                "Mod+Shift+9".action.move-window-to-workspace = "09";
                "Mod+Shift+y".action.move-window-to-workspace = "10";

                "Mod+Left".action.focus-column-left = [ ];
                "Mod+Right".action.focus-column-right = [ ];
                "Mod+Up".action.focus-workspace-up = [ ];
                "Mod+Down".action.focus-workspace-down = [ ];

                "Mod+Shift+Left".action.move-column-left = [ ];
                "Mod+Shift+Right".action.move-column-right = [ ];
                "Mod+Shift+Up".action.move-workspace-up = [ ];
                "Mod+Shift+Down".action.move-workspace-down = [ ];

                "Mod+comma".action.consume-window-into-column = [ ];
                "Mod+period".action.expel-window-from-column = [ ];

                "Mod+minus".action.set-column-width = [ "-10%" ];
                "Mod+equal".action.set-column-width = [ "+10%" ];
                "Mod+Shift+minus".action.set-window-height = [ "-10%" ];
                "Mod+Shift+equal".action.set-window-height = [ "+10%" ];

                "Mod+r".action.maximize-column = [ ];
                "Mod+Shift+f".action.fullscreen-window = [ ];
                "Mod+g".action.toggle-column-display = [ ];

                "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];
                "Mod+Print".action.screenshot = [ ];
                "Ctrl+Print".action.screenshot-screen = [ ];

                "Mod+a".action.spawn = [
                  (lib.getExe pkgs.uwsm)
                  "app"
                  "--"
                  (lib.getExe pkgs.wofi-ykman)
                ];

                "Mod+e".action.spawn = noctaliaIpc ++ [
                  "sessionMenu"
                  "toggle"
                ];

                "XF86AudioMute".action.spawn = noctaliaIpc ++ [
                  "volume"
                  "muteInput"
                ];

                "XF86AudioPlay".action.spawn = noctaliaIpc ++ [
                  "media"
                  "playPause"
                ];

                "XF86AudioRaiseVolume".action.spawn = noctaliaIpc ++ [
                  "volume"
                  "increase"
                ];

                "XF86AudioLowerVolume".action.spawn = noctaliaIpc ++ [
                  "volume"
                  "decrease"
                ];

                "XF86MonBrightnessUp".action.spawn = noctaliaIpc ++ [
                  "brightness"
                  "increase"
                ];

                "XF86MonBrightnessDown".action.spawn = noctaliaIpc ++ [
                  "brightness"
                  "decrease"
                ];

                "Print".action.spawn = [
                  "${pkgs.hyprshot}/bin/hyprshot"
                  "--clipboard-only"
                  "-m"
                  "region"
                ];

                "Alt+Print".action.spawn = [
                  "${pkgs.hyprshot}/bin/hyprshot"
                  "--clipboard-only"
                  "-m"
                  "active"
                ];
              };
            };
        };

      };
    }
  );
}
