{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.development.rust.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.development.rust.enable {
    environment.systemPackages = with pkgs; [
      cargo
      rustc
      gcc
      rustfmt
    ];

    aspects.base.persistence.homePaths = [
      ".cargo"
    ];
  };
}
