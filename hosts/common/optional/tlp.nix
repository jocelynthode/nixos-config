{
  services.tlp = {
    enable = true;
    settings = {
      PCIE_ASPM_ON_BAT = "powersupersave";
    };
  };
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;
}
