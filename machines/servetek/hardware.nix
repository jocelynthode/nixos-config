{
  pkgs,
  lib,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    };
    kernelPackages = pkgs.linuxPackages;
    kernelModules = ["kvm-intel"];
  };

  networking.wireless.enable = false;

  fileSystems = {
    "/var/www/dde" = {
      device = "/dev/disk/by-label/dde";
      fsType = "ext4";
      options = ["defaults" "noatime"];
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 1024 * 8;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  hardware = {
    enableRedistributableFirmware = true;
  };

  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      IdleAction=ignore
      HandlePowerKey=poweroff
      HandlePowerKeyLongPress=poweroff
    '';
  };
}
