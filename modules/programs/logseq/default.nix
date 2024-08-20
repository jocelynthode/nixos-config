{
  config,
  lib,
  pkgs,
  ...
}: {
  options.aspects.programs.logseq.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.logseq.enable {
    environment.systemPackages = with pkgs; [
      logseq
    ];

    aspects.base.persistence.homePaths = [
      ".local/share/logseq"
    ];
  };
}
