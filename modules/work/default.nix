{ config, lib, ... }: {
  imports = [
    ./git
    ./taxi
    ./slack
    ./kubernetes
    ./vpn
  ];

  options.aspects.work.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.work.enable {
    aspects = {
      development.enable = true;
      work = {
        git.enable = lib.mkDefault true;
        taxi.enable = lib.mkDefault true;
        slack.enable = lib.mkDefault true;
        kubernetes.enable = lib.mkDefault true;
        vpn.enable = lib.mkDefault true;
      };
    };

    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      "Liip"
    ];
  };
}
