{
  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    resumeDevice = "/dev/disk/by-label/root";
    kernelParams = [ "resume_offset=22150286" ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "btrfs";
      options = [ "defaults,noatime,compress=zstd:1,subvol=@" ];
    };

    "/swap" = {
      device = "/dev/disk/by-label/root";
      fsType = "btrfs";
      options = [ "defaults,noatime,compress=zstd:1,subvol=swap" ];
    };

    "/boot/efi" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = [ "defaults,noatime" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 32);
  }];
}
