{
  config,
  lib,
  ...
}: {
  options.aspects.development.libvirt.enable = lib.mkEnableOption "libvirt";

  config = lib.mkIf config.aspects.development.libvirt.enable {
    virtualisation.libvirtd = {
      enable = true;
    };
    users.users.jocelyn.extraGroups = ["libvirtd"];
  };
}
