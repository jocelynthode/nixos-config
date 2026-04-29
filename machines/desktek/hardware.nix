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
      kernelModules = [ "amdgpu" ];
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      # "resume_offset=533881"
      "mitigations=off" # disable CPU security mitigations for performance
      "preempt=full" # full kernel preemption for lower input latency
      "video=DP-1:2560x1440@144"
      "video=HDMI-A-1:1920x1080@60"
    ];
    kernelModules = [ "kvm-amd" ];
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642; # required by some 32-bit games and Wine
      "vm.swappiness" = 10; # strongly prefer RAM over swap
    };
  };

  networking.hostName = "desktek";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.enableRedistributableFirmware = true;
  hardware.amdgpu = {
    opencl.enable = true; # ROCm/OpenCL support on 7900XTX
  };

  # latency-criticality aware scheduler, tuned for 3D V-Cache topology
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  # process priority rules from CachyOS, tuned for gaming workloads
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };
  # services.tailscale.enable = true;
  # TODO persists /var/lib/tailscale
}
