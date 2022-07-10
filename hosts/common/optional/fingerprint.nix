{ config, pkgs, lib, ... }:
{
  services.fprintd.enable = true;
  security.pam.services = {
    login.fprintAuth = false;
    lightdm.fprintAuth = false;
    xscreensaver.fprintAuth = true;
    i3lock.fprintAuth = true;
    sudo.fprintAuth = true;
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/fprint"
    ];
  };
}
