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
      fonts = with pkgs; [
        carlito
        vegur
        noto-fonts
        font-awesome
        corefonts
        material-design-icons
        material-icons
        feathers
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
            "Noto"
          ];
        })
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
      ...
    }: rec {
      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
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
          name = "Catppuccin-Latte-Standard-Pink-Light";
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
        settings = {
          "Net/ThemeName" = gtk.theme.name;
          "Net/IconThemeName" = gtk.iconTheme.name;
        };
      };
    };
  };
}
