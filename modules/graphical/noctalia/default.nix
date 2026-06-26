{
  config,
  lib,
  noctalia,
  pkgs,
  ...
}:
let
  cfg = config.aspects.graphical.noctalia;
in
{
  options.aspects.graphical.noctalia = {
    enable = lib.mkEnableOption "Noctalia";
  };

  config = lib.mkIf cfg.enable {
    aspects.base.persistence.homePaths = [
      ".config/noctalia"
      ".cache/noctalia"
      ".local/state/noctalia"
    ];

    home-manager.sharedModules = [ noctalia.homeModules.default ];

    nix.settings = {
      substituters = [ "https://noctalia.cachix.org" ];
      trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    home-manager.users.jocelyn =
      { osConfig, config, ... }:
      {
        home.file.".cache/noctalia/wallpapers.json" = {
          text = builtins.toJSON { defaultWallpaper = osConfig.stylix.image; };
        };

        xdg.configFile."noctalia/sounds" = {
          source = ./sounds;
          recursive = true;
        };

        stylix.targets.noctalia-shell.enable = false;

        programs.noctalia = {
          enable = true;
          systemd = {
            enable = true;
          };

          settings = {
            audio = {
              notification_sound = "/home/jocelyn/.config/noctalia/sounds/link.wav";
            };

            bar = {
              widgets = {
                background_opacity = 0.60;
                center = [
                  "media"
                  "date"
                ];
                end = [
                  "network"
                  "notifications"
                  "Microphone"
                  "volume"
                  "brightness"
                  "bluetooth"
                  "nightlight"
                  "battery"
                  "tray"
                  "control-center"
                ];
                margin_edge = 5;
                margin_ends = 12;
                start = [
                  "workspaces"
                  "cpu"
                  "Memory"
                  "Disk"
                  "network_tx"
                  "network_rx"
                ];
              };
            };

            desktop_widgets = {
              enabled = false;
            };

            location = {
              address = "Fribourg, Switzerland";
            };

            nightlight = {
              enabled = true;
            };

            osd = {
              position = "top_right";
            };

            shell = {
              font_family = osConfig.aspects.base.fonts.regular.family;
              settings_show_advanced = true;
              polkit_agent = true;
              launch_apps_as_systemd_services = config.programs.noctalia.systemd.enable;
              clipboard_enabled = false;

              animation = {
                speed = 1.50;
              };

              mpris = {
                blacklist = [ "firefox" ];
              };

              panel = {
                open_near_click_control_center = true;
                session_placement = "centered";
                transparency_mode = "soft";
              };
            };

            theme = {
              community_palette = "Catppuccin Lavender";
              source = "community";
            };

            wallpaper = {
              default = {
                path = pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper};
              };
              last = {
                path = pkgs.wallpapers.${osConfig.aspects.graphical.wallpaper};
              };
            };

            widget = {
              workspaces = {
                display = "none";
              };
              Disk = {
                stat = "disk_pct";
                type = "sysmon";
              };
              Memory = {
                stat = "ram_pct";
                type = "sysmon";
              };
              Microphone = {
                device = "input";
                type = "volume";
              };
              battery = {
                display_mode = "graphic";
              };
              cpu_1 = {
                type = "sysmon";
              };
              date = {
                format = "{:%a, %d %b %Y %H:%M:%S}";
              };
              media = {
                hide_when_no_media = true;
                title_scroll = "always";
              };
              network_rx = {
                display = "text";
              };
              network_tx = {
                display = "text";
              };
            };
          };
        };
      };
  };
}
