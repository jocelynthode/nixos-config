{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.development.rust.enable = lib.mkEnableOption "rust";

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
