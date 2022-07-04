{
  programs.git = {
    enable = true;
    userName = "Jocelyn Thode";
    userEmail = "jocelyn.thode@gmail.com";
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
