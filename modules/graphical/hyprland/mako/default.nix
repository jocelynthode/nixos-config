{ config, lib, ... }: {
  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    home-manager.users.jocelyn = { config, osConfig, ... }: {
      programs.mako = {
        enable = true;

        iconPath = "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark";

        anchor = "top-right";
        backgroundColor = "#${config.colorScheme.colors.base01}DD";
        borderColor = "#${config.colorScheme.colors.base0C}FF";

        borderRadius = 0;
        borderSize = 2;
        font = "${osConfig.aspects.base.fonts.monospace.family} ${toString osConfig.aspects.base.fonts.monospace.size}";
        width = 512;
        height = 128;

        defaultTimeout = 4000;
        maxVisible = 8;
      };
    };
  };
}
