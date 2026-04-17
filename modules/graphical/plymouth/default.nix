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
      kernelParams = [
        "quiet"
        "splash"
      ];
    };
  };
}
