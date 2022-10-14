{ config, lib, ... }: {
  options.aspects.games.steam.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.games.steam.enable {
    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      ".steam"
      ".local/share/Steam"
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    hardware.steam-hardware.enable = true;
  };
}

