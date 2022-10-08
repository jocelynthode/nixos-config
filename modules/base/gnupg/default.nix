{ config, pkgs, ... }:
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
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = pinentry.name;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    gnupg-pkcs11-scd
  ] ++ (lib.optional config.aspects.graphical.enable pinentry-gnome);

  services.dbus.packages = with pkgs; (lib.optional config.aspects.graphical.enable gcr);

  environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [{ directory = ".gnupg"; mode = "0700"; }];
}
