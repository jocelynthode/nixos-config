{
  config,
  pkgs,
  lib,
  ...
}: let
  pinentry =
    if config.aspects.graphical.enable
    then {
      package = pkgs.pinentry-gnome3;
    }
    else {
      package = pkgs.pinnentry-curses;
    };
in {
  environment.systemPackages = with pkgs; [
    gnupg
  ];

  aspects.base.persistence.homePaths = [
    {
      directory = ".gnupg";
      mode = "0700";
    }
  ];
  services.dbus.packages = lib.optionals config.aspects.graphical.enable [pkgs.gcr];

  home-manager.users.jocelyn = _: {
    services.gpg-agent = {
      enable = true;
      enableFishIntegration = true;
      pinentryPackage = pinentry.package;
      enableSshSupport = true;
      defaultCacheTtlSsh = 3600;
      defaultCacheTtl = 3600;
      maxCacheTtl = 7200;
      maxCacheTtlSsh = 7200;
      sshKeys = ["91735B2D84D8598433447625D86582CE4993E068"];
      enableExtraSocket = true;
    };

    programs.gpg = {
      enable = true;
      scdaemonSettings = {
        # Required for ykman and gpg to play nice together
        disable-ccid = true;
        card-timeout = "1";
        reader-port = "Yubico YubiKey";
      };
    };
  };
}
