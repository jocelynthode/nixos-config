{ config, lib, pkgs, ... }: {
  imports = [
    ./fingerprint
    ./firefox
    ./i3
    ./mpv
    ./printer
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
        mpv.enable = lib.mkDefault true;
        printer.enable = lib.mkDefault false;
        screenshot.enable = lib.mkDefault true;
        sound.enable = lib.mkDefault true;
        terminal.enable = lib.mkDefault true;
        theme.enable = lib.mkDefault true;
        xdg.enable = lib.mkDefault true;
      };
    };
    home-manager.users.jocelyn = { ... }: {
      home.packages = with pkgs; [
        networkmanagerapplet
      ];
    };
  };
}
