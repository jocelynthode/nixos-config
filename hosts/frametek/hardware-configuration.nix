{ lib, hostname, ... }: {
  imports = [
    ../common/optional/btrfs.nix
    ../common/optional/encrypted-root.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "kvm-intel" ];
    };
    kernelParams = [ "resume_offset=15273662" ];
  };
}
