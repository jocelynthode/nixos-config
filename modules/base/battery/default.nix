{
  config,
  lib,
  ...
}: {
  options.aspects.base.battery.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.base.battery.enable {
    services = {
      tlp = {
        enable = true;
        settings = {
          PCIE_ASPM_ON_BAT = "powersupersave";
        };
      };
      upower = {
        enable = true;
        # Default values: 10/3/2/HybridSleep
        percentageLow = 10;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "HybridSleep";
      };
      thermald.enable = true;
      logind = {
        lidSwitch = "suspend";
        extraConfig = ''
          IdleAction=suspend
          IdleActionSec=15min
          HandlePowerKey=suspend
          HandlePowerKeyLongPress=poweroff
        '';
      };
    };
    powerManagement.powertop.enable = true;

    aspects.base.persistence.systemPaths = [
      "/var/lib/upower"
    ];

    systemd.sleep.extraConfig = ''
      HibernateDelaySec=30min
    '';
  };
}
