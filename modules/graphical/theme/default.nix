{ config, lib, pkgs, nix-colors, ... }: {
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

    programs.dconf.enable = true;
    home-manager.users.jocelyn = { pkgs, config, osConfig, ... }:
      let
        inherit (nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
      in
      rec {

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
            package = osConfig.aspects.base.fonts.regular.package;
            size = 11;
          };
          theme = {
            name = "${config.colorscheme.slug}";
            package = gtkThemeFromScheme { scheme = config.colorscheme; };
          };
          iconTheme = {
            name = "Papirus";
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

        qt = {
          enable = true;
          platformTheme = "gnome";
          style = {
            name = "adwaita-dark";
            package = pkgs.adwaita-qt;
          };
        };
      };
  };
}
