{
  config,
  lib,
  ...
}:
{
  options.aspects.programs.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.aspects.programs.git.enable {
    home-manager.users.jocelyn = _: {
      catppuccin.delta.enable = true;
      programs = {
        delta = {
          enable = true;
          options = {
            navigate = true;
            line-numbers = true;
            side-by-side = true;
          };
        };
        git = {
          enable = true;
          settings = {
            user = {
              name = "Jocelyn Thode";
              email = "jocelyn@thode.email";
            };
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
          lfs.enable = true;
          signing = {
            key = "00E063D5E30126C1A3DF114E77B3416DE9D092BD";
            signByDefault = true;
          };
        };
      };
    };
  };
}
