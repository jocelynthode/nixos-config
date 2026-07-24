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
      {
        directory = ".config/rbw";
        mode = "0700";
      }
    ];

    environment.systemPackages = with pkgs; [
      bitwarden-desktop
    ];

    home-manager.users.jocelyn = _: {
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
