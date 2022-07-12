{ pkgs, lib, ... }: {
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

  environment.persistence = {
    "/persist" = {
      directories = [
        "/var/lib/containers"
      ];
    };
  };
}
