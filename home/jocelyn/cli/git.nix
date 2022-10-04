{
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
}
