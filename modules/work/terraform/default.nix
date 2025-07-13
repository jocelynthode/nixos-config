{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    aspects.work.terraform.enable = lib.mkEnableOption "terraform";
  };

  config = lib.mkIf config.aspects.work.terraform.enable {
    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        opentofu
      ];
    };
  };
}
