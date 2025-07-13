{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.programs.logseq.enable = lib.mkEnableOption "logseq";

  config = lib.mkIf config.aspects.programs.logseq.enable {
    environment.systemPackages = with pkgs; [
      logseq
    ];

    aspects.base.persistence.homePaths = [
      ".local/share/logseq"
    ];
  };
}
