{ config, lib, pkgs, nix-colors, ... }:
let
  globalConfig = config;
in
{
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
    home-manager.users.jocelyn = { pkgs, config, ... }:
      let
        inherit (nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
      in
      rec {
        gtk = {
          enable = true;
          font = {
            name = globalConfig.aspects.base.fonts.regular.family;
            package = globalConfig.aspects.base.fonts.regular.package;
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
          cursorTheme = {
            name = "Adwaita";
            package = pkgs.gnome.adwaita-icon-theme;
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
