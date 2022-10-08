{ config, lib, pkgs, ... }: {
  options.aspects.games.mumble.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.games.mumble.enable {
    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      ".config/Mumble"
      ".local/share/Mumble"
    ];

    home-manager.users.jocelyn = { ... }: {
      home.packages = with pkgs; [ mumble ];
    };
  };
}
