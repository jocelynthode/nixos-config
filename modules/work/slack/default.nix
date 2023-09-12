{
  config,
  lib,
  pkgs-master,
  ...
}: {
  options = {
    aspects.work.slack.enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.aspects.work.slack.enable {
    home-manager.users.jocelyn = _: {
      home.packages = [pkgs-master.slack];
    };

    aspects.base.persistence.homePaths = [
      ".config/Slack"
    ];
  };
}
