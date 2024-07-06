{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.graphical.screenshot.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.graphical.screenshot.enable {
    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [gnome-screenshot];
    };
  };
}
