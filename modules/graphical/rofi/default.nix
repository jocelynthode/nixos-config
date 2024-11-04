{
  pkgs,
  lib,
  config,
  ...
}: {
  options.aspects.graphical.rofi = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };

    package = lib.mkOption {
      default = pkgs.rofi;
      example = pkgs.rofi-wayland;
    };
  };

  config = lib.mkIf config.aspects.graphical.rofi.enable {
    home-manager.users.jocelyn = {osConfig, ...}: {
      home.packages = with pkgs; [
        rofi-power-menu
      ];

      programs.rofi = {
        enable = true;
        inherit (osConfig.aspects.graphical.rofi) package;
        font = "${osConfig.aspects.base.fonts.monospace.family} ${toString osConfig.aspects.base.fonts.monospace.size}";
        terminal = "${pkgs.kitty}/bin/kitty";
        location = "center";
      };

      xdg.configFile."rofi" = {
        source = ./themes;
        recursive = true;
      };
    };
  };
}
