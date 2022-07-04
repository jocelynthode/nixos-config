{ pkgs, inputs, config, lib, home-manager, ... }: {
  users = {
    mutableUsers = false;
    users = {
      jocelyn = {
        isNormalUser = true;
        shell = pkgs.fish;
        hashedPassword = "$6$NJJ.620jUk.rcc5K$HqgPT6id5YmxIUBttuXsZjetVcdzAQywlqlwxNfcq0ZE/igh1bYvADLOaviKdW5ly.GASPubSm1KlpSztDJFl/";
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
      };
      root = {
        home = "/root";
      };
    };
  };

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
