{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.programs.bitwarden.enable = lib.mkEnableOption "bitwarden";

  config = lib.mkIf config.aspects.programs.bitwarden.enable {
    aspects.base.persistence.homePaths = [
      {
        directory = ".config/Bitwarden";
        mode = "0700";
      }
    ];
    home-manager.users.jocelyn = _: {
      home.packages = [ pkgs.bitwarden ];
    };
  };
}
