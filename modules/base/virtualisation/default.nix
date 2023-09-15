{
  config,
  options,
  lib,
  ...
}: {
  options.aspects.base.virtualisation.enable = lib.mkOption {
    description = "This machine is a QEMU guest";
    readOnly = true;
    type = lib.types.bool;
  };

  config =
    if !(options.virtualisation ? qemu)
    then {}
    else {
      aspects.base = {
        virtualisation.enable = true;
        btrfs.enable = false;
        persistence.enable = false;
      };

      users.users.jocelyn.password = "foo";

      virtualisation.qemu.options = lib.mkIf config.aspects.graphical.hyprland.enable ["-device virtio-vga-gl" "-display gtk,gl=on"];

      hardware.video.hidpi.enable = lib.mkForce false;

      environment.variables = lib.mkIf config.aspects.graphical.hyprland.enable {
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
}
