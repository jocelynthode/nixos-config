{
  config,
  lib,
  pkgs,
  pkgs-stable,
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
      {
        directory = ".config/rbw";
        mode = "0700";
      }
    ];
    home-manager.users.jocelyn = _: {
      home.packages = [ pkgs-stable.bitwarden-desktop ];

      programs.rbw = {
        enable = true;
        settings = {
          email = "jocelyn@thode.email";
          pinentry = pkgs.pinentry-gnome3;
        };
      };
    };
  };
}
