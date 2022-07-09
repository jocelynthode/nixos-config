{ lib, hostname, ... }: {
  imports = [
    ../common/optional/btrfs.nix
    ../common/optional/encrypted-root.nix
  ];

  boot = {
    initrd = {
      kernelModules = [ "kvm-intel" ];
    };
    # kernelParams = [ "resume_offset=22150286" ];
  };
}
