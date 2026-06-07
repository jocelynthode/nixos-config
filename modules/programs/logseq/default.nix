{
  config,
  # helix-notes,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.programs.logseq.enable = lib.mkEnableOption "logseq";

  config = lib.mkIf config.aspects.programs.logseq.enable {
    environment.systemPackages = with pkgs; [
      logseq
      # (helix-notes.packages.${pkgs.stdenv.hostPlatform.system}.default)
    ];

    aspects.base.persistence.homePaths = [
      ".local/share/logseq"
      ".config/Logseq/"
    ];
  };
}
