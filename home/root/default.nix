{ pkgs, config, inputs, lib, home-manager, ... }: {

  imports = [
    ../common/rice
    ../common/cli
  ];

  systemd.user.startServices = "sd-switch";
  programs = {
    home-manager.enable = true;
  };

  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "22.11";
  };
} 
