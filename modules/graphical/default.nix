{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./fingerprint
    ./firefox
    ./hyprland
    ./kanshi
    ./mpv
    ./nix-ld
    ./printer
    ./screenshot
    ./sound
    ./sway
    ./swayidle
    ./terminal
    ./theme
    ./wofi
    ./xdg
    ./niri
    ./noctalia-shell
    ./stylix
  ];

  options.aspects.graphical = {
    enable = lib.mkEnableOption "graphical";

    dpi = lib.mkOption {
      default = 100;
      example = 150;
    };

    wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "";
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
        firefox.enable = lib.mkDefault true;
        hyprland.enable = lib.mkDefault false;
        niri.enable = lib.mkDefault false;
        mpv.enable = lib.mkDefault true;
        nix-ld.enable = lib.mkDefault true;
        printer.enable = lib.mkDefault false;
        screenshot.enable = lib.mkDefault false;
        sound.enable = lib.mkDefault true;
        sway.enable = lib.mkDefault false;
        terminal.enable = lib.mkDefault true;
        theme.enable = lib.mkDefault true;
        xdg.enable = lib.mkDefault true;
        noctalia-shell.enable = lib.mkDefault true;
        stylix.enable = lib.mkDefault true;
      };
    };

    programs.nm-applet.enable = false;
    services.gnome.gnome-keyring.enable = true;

    hardware.graphics = {
      enable = true;
    };

    programs.gdk-pixbuf.modulePackages = [
      pkgs.librsvg
    ];
  };
}
