{
  config,
  lib,
  ...
}:
{
  options.aspects.graphical.plymouth.enable = lib.mkEnableOption "plymouth";

  config = lib.mkIf config.aspects.graphical.plymouth.enable {
    stylix.targets.plymouth.enable = false;

    boot = {
      plymouth.enable = true;
      # TODO https://discourse.nixos.org/t/i-found-a-fix-for-plymouth-not-displaying-but-im-not-sure-who-to-tell/77247?u=waffle8946 while it is fixed
      # https://github.com/NixOS/nixpkgs/issues/26722#issuecomment-4345848717
      initrd.systemd.services.plymouth-start = {
        after = [ "systemd-modules-load.service" ];
        requires = [ "systemd-modules-load.service" ];
      };
      kernelParams = [
        "quiet"
        "splash"
      ];
    };
  };
}
