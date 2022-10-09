{ config, pkgs, lib, ... }:
let
  pinentry =
    if config.aspects.graphical.enable then {
      package = pkgs.pinentry-gnome;
      name = "gnome3";
    } else {
      package = pkgs.pinentry-curses;
      name = "curses";
    };
in
{
  environment.systemPackages = with pkgs; [
    gnupg
  ];

  environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [{ directory = ".gnupg"; mode = "0700"; }];
  services.dbus.packages = lib.optionals config.aspects.graphical.enable [ pkgs.gcr ];

 programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = pinentry.name;
    enableSSHSupport = true;
  };

  home-manager.users.jocelyn = { ... }: {
    home.packages = [ pinentry.package ];

    services.gpg-agent = {
      enable = true;
      enableFishIntegration = true;
      pinentryFlavor = pinentry.name;
      enableSshSupport = true;
      defaultCacheTtlSsh = 3600;
      defaultCacheTtl = 3600;
      maxCacheTtl = 7200;
      maxCacheTtlSsh = 7200;
      sshKeys = [ "91735B2D84D8598433447625D86582CE4993E068" ];
      enableExtraSocket = true;
    };
  };
}
