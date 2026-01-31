{
  pkgs,
  lib,
  ...
}:
{
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      # "resume_offset=533881"
      "mitigations=off"
      "video=DP-1:2560x1440@144"
      "video=HDMI-A-1:1920x1080@60"
    ];
    kernelModules = [ "kvm-amd" ];
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.enableRedistributableFirmware = true;
  hardware.amdgpu = {
    opencl.enable = false;
  };

  services.system76-scheduler.enable = true;
  # services.tailscale.enable = true;
  # TODO persists /var/lib/tailscale
}
