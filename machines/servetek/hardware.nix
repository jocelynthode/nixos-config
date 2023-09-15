{
  pkgs,
  lib,
  config,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    };
    kernelPackages = pkgs.linuxPackages;
    kernelModules = ["kvm-intel"];
    extraModulePackages = [config.boot.kernelPackages.nvidia_x11_legacy390];
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

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  hardware = {
    enableRedistributableFirmware = true;
    nvidia.modesetting.enable = true;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
    opengl.extraPackages = with pkgs; [
      vaapiVdpau
    ];
  };

  services.xserver = {
    videoDrivers = ["nvidia"];
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
