{
  pkgs,
  lib,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "resume_offset=533881"
      "mitigations=off"
      "video=DP-1:2560x1440@144"
      "video=HDMI-A-1:1920x1080@60"
    ];
    kernelModules = ["kvm-amd"];
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 1024 * 32;
    }
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.enableRedistributableFirmware = true;
  # hardware.amdgpu.amdvlk = true;
  programs.corectrl.enable = true;

  aspects.base.persistence.homePaths = [
    {
      directory = ".config/corectrl";
    }
  ];

  environment.systemPackages = with pkgs; [
    lact
  ];

  hardware.amdgpu.opencl = false;
  services.system76-scheduler.enable = true;
}
