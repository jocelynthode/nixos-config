{
  config,
  pkgs,
  lib,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      # name luks as hostname and label as hostname_crypt
      # Label btrfs partition as hostname
      luks = {
        gpgSupport = true;
        devices."${config.networking.hostName}" = {
          gpgCard = {
            gracePeriod = 10; # needs some time to connect
            encryptedPass = ./gpg/luks-passphrase.asc;
            publicKey = ./gpg/public-keys.asc;
          };
          bypassWorkqueues = true; # May improve SSD performance
          device = "/dev/disk/by-label/${config.networking.hostName}_crypt";
          preLVM = true;
          allowDiscards = true;
        };
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["resume_offset=533785" "mitigations=off"];
    kernelModules = ["kvm-intel"];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 1024 * 32;
    }
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.enableRedistributableFirmware = true;

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [224];
        events = ["key" "rep"];
        command = "${pkgs.light}/bin/light -U 5";
      }
      {
        keys = [225];
        events = ["key" "rep"];
        command = "${pkgs.light}/bin/light -A 5";
      }
    ];
  };
}
