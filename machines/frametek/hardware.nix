{ config, pkgs, lib, ... }: {
  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "kvm-intel" ];
      # name luks as hostname and label as hostname_crypt
      # Label btrfs partition as hostname
      luks.devices."${config.aspects.base.network.hostname}" = {
        device = "/dev/disk/by-label/${config.aspects.base.network.hostname}_crypt";
        preLVM = true;
        allowDiscards = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "resume_offset=15273662" "mitigations=off" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 32);
  }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.enableRedistributableFirmware = true;

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" "rep" ]; command = "${pkgs.light}/bin/light -U 5"; }
      { keys = [ 225 ]; events = [ "key" "rep" ]; command = "${pkgs.light}/bin/light -A 5"; }
    ];
  };
}


