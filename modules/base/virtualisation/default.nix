{
  config,
  options,
  lib,
  ...
}: {
  options.aspects.base.virtualisation.enable = lib.mkEnableOption "virtualisation";

  config =
    if !(options.virtualisation ? qemu)
    then {}
    else {
      aspects.base = {
        virtualisation.enable = true;
        fileSystems.enable = false;
        persistence.enable = false;
      };

      users.users.jocelyn.password = "foo";

      virtualisation.qemu.options = lib.mkIf config.aspects.graphical.hyprland.enable ["-device virtio-vga-gl" "-display gtk,gl=on"];

      environment.variables = lib.mkIf config.aspects.graphical.hyprland.enable {
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
}
