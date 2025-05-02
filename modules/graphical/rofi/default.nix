{
  pkgs,
  lib,
  config,
  ...
}: {
  options.aspects.graphical.rofi = {
    enable = lib.mkEnableOption "rofi";

    package = lib.mkOption {
      default = pkgs.rofi;
      example = pkgs.rofi-wayland;
    };
  };

  config = lib.mkIf config.aspects.graphical.rofi.enable {
    home-manager.users.jocelyn = {osConfig, ...}: {
      catppuccin.rofi.enable = true;
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
