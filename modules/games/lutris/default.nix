{ config, lib, pkgs, ... }: {
  options.aspects.games.lutris.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.games.lutris.enable {
    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      ".config/lutris"
      ".local/share/lutris"
      ".wine"
    ];

    home-manager.users.jocelyn = { ... }: {
      home.packages = with pkgs; [ lutris ];
    };
  };
}
