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
    services.tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
      };
    };
    powerManagement.powertop.enable = true;
    services.thermald.enable = true;

    services.upower = {
      enable = true;
      # Default values: 10/3/2/HybridSleep
      percentageLow = 10;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "HybridSleep";
    };

    aspects.base.persistence.systemPaths = [
      "/var/lib/upower"
    ];

    services.logind = {
      lidSwitch = "suspend-then-hibernate";
      extraConfig = ''
        IdleAction=suspend
        IdleActionSec=15min
        HandlePowerKey=hibernate
        HandlePowerKeyLongPress=poweroff
      '';
    };

    systemd.sleep.extraConfig = ''
      HibernateDelaySec=30min
    '';
  };
}
