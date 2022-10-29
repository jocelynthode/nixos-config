{ config, lib, ... }: {
  options.aspects.graphical.fingerprint = {
    enable = lib.mkEnableOption "fingerprint";
  };

  config = lib.mkIf config.aspects.graphical.fingerprint.enable {
    services.fprintd.enable = true;
    security.pam.services = {
      login.fprintAuth = false;
      lightdm.fprintAuth = false;
      xscreensaver.fprintAuth = false;
      i3lock.fprintAuth = false;
      sudo.fprintAuth = true;
    };

    aspects.base.persistence.systemPaths = [
      "/var/lib/fprint"
    ];
  };
}
