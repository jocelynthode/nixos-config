{ config, lib, pkgs, ... }:

{
  options.aspects.development.containers.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.development.containers.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.dnsname.enable = true;
      };
      containers = {
        enable = true;
        containersConf.cniPlugins = with pkgs; [ cni-plugins ];
      };
    };

    environment.systemPackages = with pkgs; [
      podman-compose
    ];

    environment.persistence."${config.aspects.persistPrefix}".directories = [
      "/var/lib/containers"
    ];

    users.users.jocelyn = {
      subUidRanges = [{ startUid = 100000; count = 65536; }];
      subGidRanges = [{ startGid = 100000; count = 65536; }];
    };
  };
}
