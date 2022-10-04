{ config, pkgs, ... }: {
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    sshKeys = [ "2061C6E686AC5F11BFAF593156B477D691C4AFC2" ];
    pinentryFlavor = "gnome3";
  };
}
