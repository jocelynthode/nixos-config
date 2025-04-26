{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.graphical.screenshot.enable = lib.mkEnableOption "screenshot";

  config = lib.mkIf config.aspects.graphical.screenshot.enable {
    home-manager.users.jocelyn = _: {
      services.flameshot = {
        enable = true;
        package = pkgs.flameshot.override {
          enableWlrSupport = true;
        };
      };
    };
  };
}
