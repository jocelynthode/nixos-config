{ pkgs, lib, config, ... }: {
  config = lib.mkIf config.aspects.graphical.i3.enable {
    home-manager.users.jocelyn = { config, osConfig, ... }: {
      home.packages = with pkgs; [
        rofi-power-menu
      ];

      programs.rofi = {
        enable = true;
        font = "${osConfig.aspects.base.fonts.monospace.family} ${toString osConfig.aspects.base.fonts.monospace.size}";
        terminal = "${pkgs.kitty}/bin/kitty";
        location = "center";
      };

      xdg.configFile."rofi/colors.rasi" = {
        text = ''
          * {
            al:   #00000000;
            bg:   #${config.colorScheme.colors.base00}cc;
            bga:  #${config.colorScheme.colors.base01}cc;
            fg:   #${config.colorScheme.colors.base07}ff;
            ac:   #${config.colorScheme.colors.base08}ff;
            se:   #${config.colorScheme.colors.base0C}ff;
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
