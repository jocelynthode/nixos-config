{ config, lib, pkgs, ... }: {
  options.aspects.programs.spotify.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.spotify.enable {
    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      ".config/spotify"
    ];
    home-manager.users.jocelyn = { ... }: {
      home.packages = [ pkgs.spotify pkgs.playerctl ];
      services.playerctld = {
        enable = true;
      };
    };
  };
}