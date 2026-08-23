{
  config,
  lib,
  ...
}:
{
  options.aspects.development.ai.claude.enable = lib.mkEnableOption "claude-code";

  config = lib.mkIf config.aspects.development.ai.claude.enable {
    aspects.base.backup.excludePaths = [ "/home/jocelyn/.claude" ];

    aspects.base.persistence = {
      homePaths = [
        ".claude"
      ];
    };

    home-manager.users.jocelyn = _: {
      programs.claude-code = {
        enable = true;
      };
    };
  };
}
