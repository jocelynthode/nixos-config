{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.graphical.theme.enable = lib.mkEnableOption "theme";

  config = lib.mkIf config.aspects.graphical.theme.enable {
    fonts = {
      fontconfig.enable = true;
      fontDir.enable = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-color-emoji
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
    };

    programs.dconf.enable = true;
    home-manager.users.jocelyn =
      {
        osConfig,
        ...
      }:
      {
        catppuccin = {
          flavor = "mocha";
          accent = "pink";
        };

        gtk = {
          enable = true;
        };

        dconf.settings = lib.mkIf (osConfig.aspects.theme == "dark") {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };

        services.xsettingsd = {
          enable = true;
        };
      };
  };
}
