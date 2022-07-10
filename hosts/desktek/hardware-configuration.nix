{ pkgs, lib, hostname, ... }: {
  imports = [
    ../common/optional/btrfs.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "kvm-amd" ];
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "resume_offset=533760" ];
  };
}

