{
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
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/upower"
    ];
  };
}
