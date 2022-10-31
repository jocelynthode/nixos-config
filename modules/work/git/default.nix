{ config, lib, ... }: {
  options = {
    aspects.work.git.enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.aspects.work.git.enable {
    home-manager.users.jocelyn = { ... }: {
      programs.git.includes = [
        {
          condition = "gitdir:~/Liip/";
          contents = {
            user = {
              email = "jocelyn.thode@liip.ch";
            };
          };
        }
      ];
    };
  };
}
