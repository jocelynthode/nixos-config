{
  config,
  lib,
  pkgs-master,
  ...
}:
{
  options.aspects.development.ai.nono.enable = lib.mkEnableOption "nono";

  config = lib.mkIf config.aspects.development.ai.nono.enable {
    aspects.base.persistence = {
      homePaths = [
        ".config/nono"
        ".local/state/nono"
      ];
    };

    home-manager.users.jocelyn = _: {
      # TODO use pkgs after https://nixpk.gs/pr-tracker.html?pr=556028
      home.packages = with pkgs-master; [
        nono
      ];
    };
  };
}
