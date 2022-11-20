{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    aspects.work.terraform.enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.aspects.work.terraform.enable {
    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        terraform
      ];
    };
  };
}
