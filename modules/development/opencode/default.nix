{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.development.opencode.enable = lib.mkEnableOption "opencode";

  config = lib.mkIf config.aspects.development.opencode.enable {
    aspects.base.persistence = {
      homePaths = [
        ".config/opencode"
        ".local/share/opencode"
      ];
    };

    environment.systemPackages = with pkgs; [
      opencode
      lsof
      procps
      curl
    ];
  };
}
