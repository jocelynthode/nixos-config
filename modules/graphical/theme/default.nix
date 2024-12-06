{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.graphical.theme.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.graphical.theme.enable {
    fonts = {
      fontconfig.enable = true;
      fontDir.enable = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-emoji
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        font-awesome
        corefonts
        material-design-icons
        material-icons
        feathers
        nerd-fonts.jetbrains-mono
        nerd-fonts.noto
      ];
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita";
    };

    programs.dconf.enable = true;
    home-manager.users.jocelyn = {
      pkgs,
      osConfig,
      catppuccin,
      ...
    }: {
      catppuccin = {
        flavor = "latte";
        accent = "pink";
      };

      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };

      gtk = {
        enable = true;
        font = {
          name = osConfig.aspects.base.fonts.regular.family;
          inherit (osConfig.aspects.base.fonts.regular) package;
          inherit (osConfig.aspects.base.fonts.regular) size;
        };
        theme = {
          name = "catppuccin-latte-pink-standard+normal";
          package = pkgs.catppuccin-gtk.override {
            accents = ["pink"];
            size = "standard";
            tweaks = ["normal"];
            variant = "latte";
          };
        };
        iconTheme = {
          name = "Papirus-Light";
          package = pkgs.papirus-icon-theme;
        };
      };

      services.xsettingsd = {
        enable = true;
      };
    };
  };
}
