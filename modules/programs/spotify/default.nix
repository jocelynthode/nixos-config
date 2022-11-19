{ config, lib, pkgs, ... }: {
  options.aspects.programs.spotify.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.spotify.enable {
    aspects.base.persistence.homePaths = [
      ".config/spotify"
    ];
    home-manager.users.jocelyn = _: {
      home.packages = [ pkgs.spotify pkgs.playerctl ];
      services.playerctld = {
        enable = true;
      };
    };
  };
}
