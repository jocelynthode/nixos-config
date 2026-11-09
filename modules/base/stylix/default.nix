{
  config,
  lib,
  pkgs,
  stylix,
  ...
}:
{
  imports = [
    stylix.nixosModules.stylix
  ];

  config = lib.mkIf (config.aspects.graphical.enable or false) {
    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      polarity = "dark";

      fonts = {
        monospace = {
          name = config.aspects.base.fonts.monospace.family;
          inherit (config.aspects.base.fonts.monospace) package;
        };

        sansSerif = {
          name = config.aspects.base.fonts.regular.family;
          inherit (config.aspects.base.fonts.regular) package;
        };

        sizes = {
          terminal = 14;
        };
      };

      opacity = {
        desktop = 0.7;
        terminal = 0.90;
      };

      targets = {
        nixvim.enable = false;
        console.enable = false;
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
    # The rofi target still writes programs.rofi.font, deprecated in Home
    # Manager in favour of programs.rofi.settings.font. Nothing here uses rofi.
    home-manager.sharedModules = lib.singleton {
      stylix.targets.rofi.enable = lib.mkDefault false;
    };
  };
}
