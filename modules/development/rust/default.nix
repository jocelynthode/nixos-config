{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.development.rust.enable = lib.mkEnableOption "rust";

  config = lib.mkIf config.aspects.development.rust.enable {
    aspects.base.backup.excludePaths = [ "/home/jocelyn/.cargo" ];

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
