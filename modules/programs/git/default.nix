{
  config,
  lib,
  ...
}: {
  options.aspects.programs.git.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.programs.git.enable {
    home-manager.users.jocelyn = _: {
      programs.git = {
        enable = true;
        userName = "Jocelyn Thode";
        userEmail = "jocelyn@thode.email";
        signing = {
          key = "00E063D5E30126C1A3DF114E77B3416DE9D092BD";
          signByDefault = true;
        };
        extraConfig = {
          pull = {
            rebase = true;
          };
          push = {
            autoSetupRemote = true;
          };
          diff = {
            colorMoved = "default";
          };
          merge = {
            conflictstyle = "diff3";
          };
          delta = {
            navigate = true;
            line-numbers = true;
            side-by-side = true;
          };
          core = {
            pager = "delta";
          };
          submodule = {
            recurse = true;
          };
          interactive = {
            diffFilter = "delta --color-only";
          };
        };
      };
    };
  };
}
