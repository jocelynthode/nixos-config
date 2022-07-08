{ hostname, ... }: {
  boot.initrd = {
    # name luks as hostname and label as hostname_crypt
    # Label btrfs partition as hostname
    luks.devices."${hostname}" = {
      device = "/dev/disk/by-label/${hostname}_crypt";
      preLVM = true;
      allowDiscards = true;
    };
  };
}
