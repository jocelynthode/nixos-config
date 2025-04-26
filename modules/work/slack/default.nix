{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    aspects.work.slack.enable = lib.mkEnableOption "slack";
  };

  config = lib.mkIf config.aspects.work.slack.enable {
    home-manager.users.jocelyn = _: {
      home.packages = [pkgs.slack];
    };

    aspects.base.persistence.homePaths = [
      ".config/Slack"
    ];
  };
}
