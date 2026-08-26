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

    aspects.base.persistence.homePaths = [
      ".config/opentofu"
    ];

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        opentofu
        tflint
        tofu-ls
      ];
    };
  };
}
