{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    gnupg
  ];

  environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [{ directory = ".gnupg"; mode = "0700"; }];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
  };
}
