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
      # systemd.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "resume_offset=533785"
      "mitigations=off"
    ];
    kernelModules = [ "kvm-intel" ];
    resumeDevice = "/dev/disk/by-label/frametek_crypt";
  };

  networking.hostName = "frametek";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  hardware = {
    enableRedistributableFirmware = true;
    intelgpu.vaapiDriver = "intel-media-driver";
    graphics = {
      enable = true;
    };
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";
    LIBVA_DRIVERS_PATH = "${pkgs.intel-media-driver}/lib/dri";
  };

  environment.sessionVariables = {
    GDK_SCALE = "2";
  };

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [ 224 ];
        events = [
          "key"
          "rep"
        ];
        command = "${pkgs.light}/bin/light -U 5";
      }
      {
        keys = [ 225 ];
        events = [
          "key"
          "rep"
        ];
        command = "${pkgs.light}/bin/light -A 5";
      }
    ];
  };
}
