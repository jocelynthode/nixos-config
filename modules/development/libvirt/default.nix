{ config, lib, ... }: {
  options.aspects.development.libvirt.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.development.libvirt.enable {
    virtualisation.libvirtd = {
      enable = true;
    };
    users.users.jocelyn.extraGroups = [ "libvirtd" ];
  };
}
