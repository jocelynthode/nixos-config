{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./fingerprint
    ./firefox
    ./hyprland
    ./kanshi
    ./mpv
    ./nix-ld
    ./notification
    ./printer
    ./rofi
    ./screenshot
    ./sound
    ./sway
    ./terminal
    ./theme
    ./waybar
    ./wofi
    ./xdg
  ];

  options.aspects.graphical = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };

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
    users.users.jocelyn.extraGroups = ["audio" "video" "camera" "corectrl"];
    aspects = {
      graphical = {
        fingerprint.enable = lib.mkDefault false;
        firefox.enable = lib.mkDefault true;
        hyprland.enable = lib.mkDefault false;
        mpv.enable = lib.mkDefault true;
        nix-ld.enable = lib.mkDefault true;
        notification.enable = lib.mkDefault true;
        printer.enable = lib.mkDefault false;
        screenshot.enable = lib.mkDefault false;
        rofi.enable = lib.mkDefault true;
        sound.enable = lib.mkDefault true;
        sway.enable = lib.mkDefault false;
        terminal.enable = lib.mkDefault true;
        theme.enable = lib.mkDefault true;
        xdg.enable = lib.mkDefault true;
      };
    };

    programs.nm-applet.enable = true;
    services.gnome.gnome-keyring.enable = true;

    hardware.graphics = {
      enable = true;
    };

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        networkmanagerapplet
      ];
    };
  };
}
