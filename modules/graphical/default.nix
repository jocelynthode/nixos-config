{ inputs, ... }:
{
  flake.nixosModules.graphicalModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        (inputs.import-tree.match "^/[^/]+/default\\.nix$" ./.)
      ];

      options.aspects.graphical = {
        enable = lib.mkEnableOption "graphical";

        dpi = lib.mkOption {
          default = 100;
          example = 150;
        };

        wallpaper = lib.mkOption {
          type = lib.types.str;
          default = "japan-spring";
          description = ''
            Wallpaper name
          '';
        };
      };

      config = lib.mkIf config.aspects.graphical.enable {
        users.users.jocelyn.extraGroups = [
          "audio"
          "video"
          "camera"
          "corectrl"
        ];
        aspects = {
          graphical = {
            fingerprint.enable = lib.mkDefault false;
            plymouth.enable = lib.mkDefault true;
            firefox.enable = lib.mkDefault true;
            hyprland.enable = lib.mkDefault false;
            niri.enable = lib.mkDefault false;
            mpv.enable = lib.mkDefault true;
            nix-ld.enable = lib.mkDefault true;
            printer.enable = lib.mkDefault false;
            protonvpn.enable = lib.mkDefault true;
            screenshot.enable = lib.mkDefault false;
            sound.enable = lib.mkDefault true;
            sway.enable = lib.mkDefault false;
            terminal.enable = lib.mkDefault true;
            theme.enable = lib.mkDefault true;
            xdg.enable = lib.mkDefault true;
            noctalia-shell.enable = lib.mkDefault true;
          };
        };

        programs.nm-applet.enable = false;
        services.gnome.gnome-keyring.enable = true;
        security.pam.services.greetd.enableGnomeKeyring = true;

        hardware.graphics = {
          enable = true;
        };

        services.greetd = {
          enable = true;
          settings.default_session = {
            user = lib.mkDefault "greeter";
            environment = {
              XKB_DEFAULT_LAYOUT = config.services.xserver.xkb.layout;
              XKB_DEFAULT_VARIANT = config.services.xserver.xkb.variant;
            };
          };
        };

        aspects.base.persistence.systemPaths = [
          {
            directory = "/var/lib/regreet";
            user = "greeter";
            group = "greeter";
            mode = "0755";
          }
        ];

        programs.gdk-pixbuf.modulePackages = [
          pkgs.librsvg
        ];
      };
    };
}
