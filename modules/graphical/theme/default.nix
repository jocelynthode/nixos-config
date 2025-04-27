{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.graphical.theme.enable = lib.mkEnableOption "theme";

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
      style =
        if config.aspects.theme == "dark"
        then "adwaita-dark"
        else "adwaita";
    };

    programs.dconf.enable = true;
    home-manager.users.jocelyn = {
      pkgs,
      osConfig,
      catppuccin,
      ...
    }: {
      catppuccin = {
        flavor = "mocha";
        accent = "pink";
      };

      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };

      catppuccin.gtk.icon.enable = true;
      gtk = {
        enable = true;
        theme = {
          name =
            if osConfig.aspects.theme == "dark"
            then "Adwaita-dark"
            else "Adwaita";
        };
        font = {
          name = osConfig.aspects.base.fonts.regular.family;
          inherit (osConfig.aspects.base.fonts.regular) package;
          inherit (osConfig.aspects.base.fonts.regular) size;
        };
        gtk3.extraConfig = lib.mkIf (osConfig.aspects.theme == "dark") {
          gtk-application-prefer-dark-theme = true;
        };
        gtk4.extraConfig = lib.mkIf (osConfig.aspects.theme == "dark") {
          gtk-application-prefer-dark-theme = true;
        };
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
