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
    nixpkgs.config.permittedInsecurePackages = [
      "electron-28.3.3"
    ];

    environment.systemPackages = with pkgs; [
      logseq
    ];

    aspects.base.persistence.homePaths = [
      ".local/share/logseq"
    ];
  };
}
