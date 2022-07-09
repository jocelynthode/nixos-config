{ pkgs, hostname, inputs, config, lib, home-manager, ... }: {
  users = {
    mutableUsers = false;
    users = {
      jocelyn = {
        isNormalUser = true;
        shell = pkgs.fish;
        passwordFile = config.age.secrets.jocelyn-password.path;
        extraGroups = [
          "wheel"
          "video"
          "audio"
          "camera"
        ]
        ++ (lib.optional config.networking.networkmanager.enable "networkmanager")
        ++ (lib.optional config.hardware.sane.enable "scanner")
        ++ (lib.optional config.virtualisation.docker.enable "docker")
        ++ (lib.optional config.virtualisation.podman.enable "podman");
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNw5wtM2BvjEcatJfnW28HwLK617om8YM8Ca/RIeuEK1eULcZxGdQ++QzfUdRrX57RLfVjzYawKWAmhh3g/OFC2vcfD+PUYiBoNAY0crBkf3e94RtvXPp6Cma13aEOJA6haatt3u7G7aehJCEFqdfR62coULoHHUPIykoC1Tnbdu0a5ZVkUdj3OPVTbRIlkfokbRueRTQ9cbPrFbfDq6ZlftvPm3UuTHObOrKPCjdtmHLHH5/jMZG254QpZ5hmMMYlHutC2lxBx3Rhqs6nv4RinixmrIZ7Z5Xpu0CLXQeGtnfTT/kdSDvrTFfZln26KX4KXHv/93EN4sHysxwsrBKF jocelyn"
        ];
      };
      root = {
        home = "/root";
      };
    };
  };

  age.secrets.jocelyn-password.file = ../secrets/jocelyn-password.age;

  services.geoclue2.enable = true;

  home-manager.users = {
    jocelyn = {
      imports = builtins.attrValues (import ../../../modules/home-manager) ++ [
        ../../../home/jocelyn
      ];
    };
    root = {
      imports = [ ../../../home/root ];
    };
  };
}
