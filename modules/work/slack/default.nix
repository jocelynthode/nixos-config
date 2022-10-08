{ config, lib, pkgs, ... }: {
  options = {
    aspects.work.slack.enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.aspects.work.slack.enable {
    home-manager.users.jocelyn = { ... }: {
      home.packages = with pkgs; [ slack ];
    };

    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      ".config/Slack"
    ];
  };
}
