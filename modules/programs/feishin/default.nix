{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.programs.feishin.enable = lib.mkEnableOption "feishin";

  config = lib.mkIf config.aspects.programs.feishin.enable {
    aspects.base.persistence.homePaths = [
      ".config/feishin"
    ];

    home-manager.users.jocelyn = _: {
      home.packages = [ pkgs.feishin ];
    };
  };
}
