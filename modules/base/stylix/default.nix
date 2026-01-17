{
  config,
  pkgs,
  ...
}:
{
  config = {
    stylix = {
      enable = true;
      autoEnable = config.aspects.graphical.enable;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      polarity = "dark";

      fonts = {
        monospace = {
          inherit (config.aspects.base.fonts.monospace) package;
          name = config.aspects.base.fonts.monospace.family;
        };

        sansSerif = {
          inherit (config.aspects.base.fonts.regular) package;
          name = config.aspects.base.fonts.regular.family;
        };

        sizes = {
          terminal = 12;
        };
      };

      opacity = {
        desktop = 0.7;
        terminal = 0.90;
      };

      targets = {
        nixvim.enable = false;
      };

      cursor = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
      };

      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        light = "Papirus";
        dark = "Papirus-Dark";
      };

      image = pkgs.wallpapers.${config.aspects.graphical.wallpaper};
    };
  };
}
