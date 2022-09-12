{ pkgs, lib, hostname, config, ... }: {
  imports = [
    ../common/optional/btrfs.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "kvm-intel" ];
    };
    kernelPackages = pkgs.linuxPackages;
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11_legacy390 ];
  };
}

