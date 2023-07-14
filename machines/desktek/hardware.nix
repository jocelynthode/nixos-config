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
    kernelParams = ["resume_offset=533881" "mitigations=off"];
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
  hardware.amdgpu.opencl = false;
}
