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
          prettyName = "niri";
          comment = "niri compositor managed by UWSM";
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
        GDK_BACKEND = "wayland";
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
            command = "${lib.getExe config.programs.uwsm.package} start -D niri -- niri-uwsm.desktop";
            user = "jocelyn";
          };
          default_session = {
            command = "${lib.getExe config.programs.uwsm.package} start -D niri -- niri-uwsm.desktop";
            user = "jocelyn";
          };
        };
      };

      home-manager.users.jocelyn = {
        home.packages = with pkgs; [
          imv
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
              uwsmApp = [
                "uwsm"
                "app"
                "--"
              ];
            in
            {
              prefer-no-csd = true;
              spawn-at-startup = [
                {
                  argv = uwsmApp ++ [
                    "kitty"
                  ];
                }
                {
                  argv = uwsmApp ++ [
                    "firefox"
                  ];
                }

                {
                  argv = uwsmApp ++ [
                    "feishin"
                  ];
                }
                {
                  argv = uwsmApp ++ [
                    "signal-desktop"
                  ];
                }
              ]
              ++ lib.optional config.aspects.games.steam.enable {
                argv = uwsmApp ++ [
                  "steam"
                ];
              };
              input = {
                focus-follows-mouse.enable = true;
              };
              gestures = {
                hot-corners.enable = false;
              };
              layout = {
                border = {
                  active = {
                    color = config.lib.stylix.colors.withHashtag.base0E;
                  };
                };

                default-column-width = {
                  proportion = 1. / 2.;
                };

                preset-column-widths = [
                  { proportion = 1. / 3.; }
                  { proportion = 1. / 2.; }
                  { proportion = 2. / 3.; }
                  { proportion = 3. / 3.; }
                ];

                preset-window-heights = [
                  { proportion = 1. / 3.; }
                  { proportion = 1. / 2.; }
                  { proportion = 2. / 3.; }
                  { proportion = 3. / 3.; }
                ];
              };
              workspaces = {
                "01" = {
                  name = "browser";
                  open-on-output = "DP-1";
                };
                "02" = {
                  name = "terminal";
                  open-on-output = "DP-1";
                };
                "03" = {
                  name = "mail";
                  open-on-output = "DP-1";
                };
                "04" = {
                  name = "game";
                  open-on-output = "DP-1";
                };
                "05" = {
                  name = "extra";
                  open-on-output = "DP-1";
                };
                "06" = {
                  name = "secondary";
                  open-on-output = "HDMI-A-1";
                };
                "07" = {
                  name = "chat";
                  open-on-output = "HDMI-A-1";
                };
                "08" = {
                  name = "music";
                  open-on-output = "HDMI-A-1";
                };
                "09" = {
                  name = "extra-secondary";
                  open-on-output = "HDMI-A-1";
                };
                "10" = {
                  name = "messenger";
                  open-on-output = "HDMI-A-1";
                };
              };

              layer-rules = [
                {
                  matches = [
                    { namespace = ".*notifications.*"; }
                  ];
                  block-out-from = "screencast";
                }
              ];
              window-rules = [
                {
                  matches = [
                    {
                      app-id = "kitty";
                      at-startup = true;
                    }
                  ];
                  open-on-workspace = "terminal";
                  open-maximized = true;
                }
                {
                  matches = [
                    {
                      app-id = "firefox";
                      at-startup = true;
                    }
                  ];
                  open-on-workspace = "browser";
                }
                {
                  matches = [
                    { app-id = "feishin"; }
                  ];
                  open-on-workspace = "music";
                  open-maximized = true;
                }
                {
                  matches = [
                    { app-id = "signal"; }
                  ];
                  open-on-workspace = "messenger";
                  open-maximized = true;
                }
                {
                  matches = [
                    { app-id = "vesktop"; }
                  ];
                  open-on-workspace = "chat";
                  open-maximized = true;
                }
                {
                  matches = [
                    { app-id = "steam"; }
                  ];
                  open-on-workspace = "game";
                }
                {
                  matches = [
                    {
                      is-window-cast-target = true;
                    }
                  ];
                  focus-ring = {
                    active.color = config.lib.stylix.colors.withHashtag.base08;
                    inactive.color = config.lib.stylix.colors.withHashtag.base09;
                  };
                  border = {
                    inactive.color = config.lib.stylix.colors.withHashtag.base09;
                    active.color = config.lib.stylix.colors.withHashtag.base08;
                  };
                  shadow = {
                    color = config.lib.stylix.colors.withHashtag.base08;
                  };
                  tab-indicator = {
                    active.color = config.lib.stylix.colors.withHashtag.base08;
                    inactive.color = config.lib.stylix.colors.withHashtag.base09;
                  };
                }
              ];

              binds = {
                "Mod+Return".action.spawn = [
                  (lib.getExe config.programs.uwsm.package)
                  "app"
                  "--"
                  (lib.getExe pkgs.kitty)
                ];

                "Mod+n".action.spawn = noctaliaIpc ++ [
                  "launcher"
                  "toggle"
                ];

                "Mod+q".action.focus-workspace = "browser";
                "Mod+c".action.focus-workspace = "terminal";
                "Mod+o".action.focus-workspace = "mail";
                "Mod+p".action.focus-workspace = "game";
                "Mod+w".action.focus-workspace = "extra";
                "Mod+j".action.focus-workspace = "secondary";
                "Mod+m".action.focus-workspace = "chat";
                "Mod+d".action.focus-workspace = "music";
                "Mod+9".action.focus-workspace = "extra-secondary";
                "Mod+y".action.focus-workspace = "messenger";

                "Mod+Shift+q".action.move-window-to-workspace = "browser";
                "Mod+Shift+c".action.move-window-to-workspace = "terminal";
                "Mod+Shift+o".action.move-window-to-workspace = "mail";
                "Mod+Shift+p".action.move-window-to-workspace = "game";
                "Mod+Shift+w".action.move-window-to-workspace = "extra";
                "Mod+Shift+j".action.move-window-to-workspace = "secondary";
                "Mod+Shift+m".action.move-window-to-workspace = "chat";
                "Mod+Shift+d".action.move-window-to-workspace = "music";
                "Mod+Shift+9".action.move-window-to-workspace = "extra-secondary";
                "Mod+Shift+y".action.move-window-to-workspace = "messenger";

                "Mod+Left".action.focus-column-left = [ ];
                "Mod+Right".action.focus-column-right = [ ];
                "Mod+Up".action.focus-window-up = [ ];
                "Mod+Down".action.focus-window-down = [ ];

                "Mod+Shift+Left".action.move-column-left = [ ];
                "Mod+Shift+Right".action.move-column-right = [ ];
                "Mod+Shift+Up".action.move-workspace-up = [ ];
                "Mod+Shift+Down".action.move-workspace-down = [ ];

                "Mod+comma".action.consume-window-into-column = [ ];
                "Mod+period".action.expel-window-from-column = [ ];

                "Mod+z".action.set-column-width = [ "-10%" ];
                "Mod+v".action.set-column-width = [ "+10%" ];
                "Mod+Shift+z".action.set-window-height = [ "-10%" ];
                "Mod+Shift+v".action.set-window-height = [ "+10%" ];

                "Mod+r".action.fullscreen-window = [ ];
                "Mod+Shift+r".action.maximize-column = [ ];
                "Mod+t".action.toggle-window-floating = [ ];
                "Mod+space".action.toggle-overview = [ ];
                "Mod+x".action.close-window = [ ];
                "Mod+minus".action.expand-column-to-available-width = [ ];
                "Mod+Shift+minus".action.switch-preset-column-width = [ ];
                "Mod+Shift+Ctrl+minus".action.switch-preset-window-height = [ ];
                "Mod+k".action.set-dynamic-cast-window = [ ];
                "Mod+Shift+k".action.set-dynamic-cast-monitor = [ ];

                "Print".action.screenshot = [
                  {
                    show-pointer = false;
                    # write-to-disk = false;
                  }
                ];
                "Ctrl+Print".action.screenshot-screen = [
                  {
                    write-to-disk = false;
                  }
                ];
                "Alt+Print".action.screenshot-window = [
                  {
                    write-to-disk = false;
                  }
                ];

                "Mod+a".action.spawn = [
                  (lib.getExe config.programs.uwsm.package)
                  "app"
                  "--"
                  (lib.getExe pkgs.wofi-ykman)
                  "wofi-ykman"
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

              };
            };
        };

      };
    }
  );
}
