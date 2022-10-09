{ config, lib, pkgs, ... }: {
  imports = [
    ./bitwarden
    ./calibre
    ./deluge
    ./gammastep
    ./git
    ./htop
    ./kdeconnect
    ./ranger
    ./signal
    ./solaar
    ./spotify
    ./taskwarrior
    ./yubikey
  ];

  options.aspects.programs.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.enable {
    aspects.programs = {
      bitwarden.enable = lib.mkDefault true; 
      calibre.enable = lib.mkDefault true;
      deluge.enable = lib.mkDefault true;
      gammastep.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      htop.enable = lib.mkDefault true;
      kdeconnect.enable = lib.mkDefault true;
      ranger.enable = lib.mkDefault true;
      signal.enable = lib.mkDefault true;
      solaar.enable = lib.mkDefault false;
      spotify.enable = lib.mkDefault true;
      taskwarrior.enable = lib.mkDefault true;
      yubikey.enable = lib.mkDefault true;
    };
  };
}
