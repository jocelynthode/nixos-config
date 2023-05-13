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
    home-manager.users.jocelyn = {
      config,
      osConfig,
      ...
    }: {
      home.packages = with pkgs; [
        rofi-power-menu
      ];

      programs.rofi = {
        enable = true;
        inherit (osConfig.aspects.graphical.rofi) package;
        font = "${osConfig.aspects.base.fonts.monospace.family} ${toString osConfig.aspects.base.fonts.monospace.size}";
        terminal = "${pkgs.kitty}/bin/kitty";
        location = "center";
        theme = "launcher";
      };

      xdg.configFile."rofi/colors.rasi" = {
        text = ''
          * {
            al:   #00000000;
            bg:   #${config.colorScheme.colors.background}cc;
            bga:  #${config.colorScheme.colors.background01}cc;
            fg:   #${config.colorScheme.colors.foreground03}ff;
            ac:   #${config.colorScheme.colors.red}ff;
            se:   #${config.colorScheme.colors.pink}ff;
          }
        '';
      };

      xdg.configFile."rofi" = {
        source = ./themes;
        recursive = true;
      };
    };
  };
}
