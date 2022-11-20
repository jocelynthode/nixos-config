{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.games.mumble.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.games.mumble.enable {
    aspects.base.persistence.homePaths = [
      ".config/Mumble"
      ".local/share/Mumble"
    ];

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [mumble];
    };
  };
}
