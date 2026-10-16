{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.development.ai.gemini.enable = lib.mkEnableOption "claude-code";

  config = lib.mkIf config.aspects.development.ai.gemini.enable {
    aspects.base.backup.excludePaths = [ "/home/jocelyn/.gemini" ];

    aspects.base.persistence = {
      homePaths = [
        ".gemini"
      ];
    };

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        antigravity-hub
      ];
    };
  };
}
