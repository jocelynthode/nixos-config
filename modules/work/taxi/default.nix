{ config, lib, pkgs, ... }: {
  options = {
    aspects.work.taxi.enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.aspects.work.taxi.enable {
    home-manager.users.jocelyn = { ... }: {
      home.packages = with pkgs; [
        (taxi-cli.withPlugins (
          plugins: with plugins; [
            zebra
          ]
        ))
      ];
    };

    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      ".config/taxi"
      ".local/share/taxi"
      ".local/share/nvim"
      ".local/share/zebra"
    ];
  };
}
