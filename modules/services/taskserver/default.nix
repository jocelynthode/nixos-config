{ config, lib, ... }: {
  options.aspects.services.taskserver.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.services.taskserver.enable {
    aspects.base.persistence.systemPaths = [
      "/var/lib/taskserver"
    ];

    services.taskserver = {
      enable = true;
      openFirewall = true;
      listenHost = "::";
      fqdn = "tasks.tekila.ovh";
      listenPort = 53589;
      ciphers = "NORMAL:-VERS-SSL3.0:-VERS-TLS1.0:-VERS-TLS1.1";
      organisations.public = {
        users = [
          "jocelyn"
        ];
      };
    };
  };
}
