{ config, lib, ... }: {
  options.aspects.graphical.fingerprint = {
    enable = lib.mkEnableOption "fingerprint";
  };

  config = lib.mkIf config.aspects.graphical.fingerprint.enable {
    services.fprintd.enable = true;
    security.pam.services = {
      login.fprintAuth = false;
      lightdm.fprintAuth = false;
      xscreensaver.fprintAuth = true;
      i3lock.fprintAuth = true;
      sudo.fprintAuth = true;
    };

    environment.persistence."${config.aspects.persistPrefix}".directories = [
      "/var/lib/fprint"
    ];
  };
}
