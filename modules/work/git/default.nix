{
  config,
  lib,
  ...
}:
{
  options = {
    aspects.work.git.enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf config.aspects.work.git.enable {
    home-manager.users.jocelyn = _: {
      programs.git.includes = [
        {
          condition = "gitdir:~/Liip/";
          contents = {
            user = {
              email = "jocelyn.thode@liip.ch";
            };
          };
        }
        {
          condition = "gitdir:~/poto/";
          contents = {
            user = {
              email = "jocelyn.thode@poto.ch";
            };
          };
        }
      ];
    };
  };
}
