{ pkgs, lib, config, ... }: {
  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "kvm-intel" ];
    };
    kernelPackages = pkgs.linuxPackages;
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11_legacy390 ];
  };

  fileSystems = {
    "/var/www/dde" = {
      device = "/dev/disk/by-label/dde";
      fsType = "ext4";
      options = [ "defaults" "noatime" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 8);
  }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.enableRedistributableFirmware = true;

  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;

  hardware.opengl.extraPackages = with pkgs; [
    vaapiVdpau
  ];

  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      IdleAction=ignore
      HandlePowerKey=poweroff
      HandlePowerKeyLongPress=poweroff
    '';
  };
}


