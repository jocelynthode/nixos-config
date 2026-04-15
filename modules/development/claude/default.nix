{
  config,
  lib,
  ...
}:
{
  options.aspects.development.claude.enable = lib.mkEnableOption "claude-code";

  config = lib.mkIf config.aspects.development.claude.enable {
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
