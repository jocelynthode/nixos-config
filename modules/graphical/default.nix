{ config, lib, pkgs, ... }: {
  imports = [
    ./fingerprint
    ./firefox
    ./hyprland
    ./i3
    ./mpv
    ./printer
    ./rofi
    ./screenshot
    ./sound
    ./terminal
    ./theme
    ./xdg
  ];

  options.aspects.graphical = {
    enable = lib.mkOption {
      default = false;
      example = true;
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
    users.users.jocelyn.extraGroups = [ "audio" "video" "camera" ];
    aspects = {
      graphical = {
        fingerprint.enable = lib.mkDefault false;
        firefox.enable = lib.mkDefault true;
        i3.enable = lib.mkDefault true;
        hyprland.enable = lib.mkDefault false;
        mpv.enable = lib.mkDefault true;
        printer.enable = lib.mkDefault false;
        screenshot.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
        sound.enable = lib.mkDefault true;
        terminal.enable = lib.mkDefault true;
        theme.enable = lib.mkDefault true;
        xdg.enable = lib.mkDefault true;
      };
    };

    programs.nm-applet.enable = true;

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        networkmanagerapplet
      ];
    };
  };
}
