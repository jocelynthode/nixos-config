{
  pkgs,
  lib,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    };
    kernelPackages = pkgs.linuxPackages;
    kernelModules = ["kvm-intel"];
    extraModprobeConfig = ''
      # enable in‑kernel block cloning (reflink) support
      options zfs zfs_bclone_enabled=1
    '';
    kernel.sysctl = {
      "fs.inotify.max_user_instances" = 256;
    };
  };

  networking.wireless.enable = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    enableRedistributableFirmware = true;
    intelgpu.vaapiDriver = "intel-media-driver";
    graphics = {
      enable = true;
    };
    bluetooth = {
      enable = false;
      powerOnBoot = false;
    };
    sensor = {
      hddtemp = {
        enable = true;
        drives = [
          "/dev/disk/by-id/ata-WDC_WD80EFPX-68C4ZN0_WD-RD2A957H"
          "/dev/disk/by-id/ata-WDC_WD80EFPX-68C4ZN0_WD-RD1S9A1H"
          "/dev/disk/by-id/ata-WDC_WD80EFPX-68C4ZN0_WD-RD2A07SH"
          "/dev/disk/by-id/ata-WDC_WD80EFPX-68C4ZN0_WD-RD1S9TBH"
        ];
        dbEntries = [
          "\"WDC WD80EFPX-68C4ZN0\" 194 C \"WDC WD80EFPX-68C4ZN0\""
        ];
      };
    };
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";
    LIBVA_DRIVERS_PATH = "${pkgs.intel-media-driver}/lib/dri";
  };

  zramSwap.enable = true;
}
