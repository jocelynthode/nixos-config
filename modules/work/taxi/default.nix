{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    aspects.work.taxi.enable = lib.mkEnableOption "taxi";
  };

  config = lib.mkIf config.aspects.work.taxi.enable {
    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        (taxi-cli.withPlugins (
          plugins: with plugins; [
            zebra
          ]
        ))
      ];
    };

    aspects.base.persistence.homePaths = [
      ".config/taxi"
      ".local/share/taxi"
      ".local/share/nvim"
      ".local/share/zebra"
    ];
  };
}
