{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.aspects.graphical.hyprland.enable {
    home-manager.users.jocelyn = {
      config,
      osConfig,
      ...
    }: {
      services.mako = {
        enable = true;

        iconPath = "${config.gtk.iconTheme.package}/share/icons/Papirus-Light";

        anchor = "top-right";
        backgroundColor = "#${config.colorScheme.colors.background01}DD";
        borderColor = "#${config.colorScheme.colors.teal}FF";

        output = "DP-2";
        borderRadius = 5;
        borderSize = 2;
        font = "${osConfig.aspects.base.fonts.monospace.family} ${toString osConfig.aspects.base.fonts.monospace.size}";
        width = 400;
        height = 256;

        defaultTimeout = 4000;
        maxVisible = 8;
      };
    };
  };
}
