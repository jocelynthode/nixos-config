{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.development.ai.nono.enable = lib.mkEnableOption "nono";

  config = lib.mkIf config.aspects.development.ai.nono.enable {
    aspects.base.persistence = {
      homePaths = [
        ".config/nono"
      ];
    };

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        nono
      ];
    };
  };
}
