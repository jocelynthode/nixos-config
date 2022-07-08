{ lib, hostname, ... }: {
  imports = [
    ../common/optional/btrfs.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "kvm-amd" ];
    };
    kernelParams = [ "resume_offset=22150286" ];
  };
}

