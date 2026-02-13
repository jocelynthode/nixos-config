{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.development.qmk.enable = lib.mkEnableOption "qmk";

  config = lib.mkIf config.aspects.development.qmk.enable {
    environment.systemPackages = with pkgs; [
      qmk
    ];
    hardware.keyboard.qmk.enable = true;
    services.udisks2.enable = true;
    security.polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.user == "jocelyn" && action.id == "org.freedesktop.udisks2.filesystem-mount") {
            var fsLabel = action.lookup("id.fs-label");
            var label = action.lookup("id.label");
            if (fsLabel == "RPI-RP2" || label == "RPI-RP2") {
              return polkit.Result.YES;
            }
          }
        });
      '';
    };
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_LABEL}=="RPI-RP2", TAG+="systemd", ENV{SYSTEMD_WANTS}="rp2040-udisks-mount@%k.service"
    '';
    systemd.services."rp2040-udisks-mount@" = {
      description = "Mount RP2040 UF2 volume via udisks";
      after = [ "udisks2.service" ];
      requires = [ "udisks2.service" ];
      serviceConfig = {
        User = "jocelyn";
        Type = "oneshot";
        ExecStart = "${pkgs.udisks}/bin/udisksctl mount --no-user-interaction -b /dev/%I";
      };
    };
    aspects.base.persistence.homePaths = [
      ".config/qmk"
    ];
  };
}
