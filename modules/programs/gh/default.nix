{
  config,
  lib,
  ...
}:
{
  options.aspects.programs.gh.enable = lib.mkEnableOption "gh GitHub CLI";

  config = lib.mkIf config.aspects.programs.gh.enable {
    home-manager.users.jocelyn = _: {
      programs.gh = {
        enable = true;
        settings = {
          git_protocol = "ssh";
          prompt = "enabled";
        };
      };
    };
  };
}
