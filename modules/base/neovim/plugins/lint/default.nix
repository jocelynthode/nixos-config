{ pkgs, ... }:
{
  programs.nixvim.extraPackages = with pkgs; [
    gitlint
    hadolint
  ];

  programs.nixvim.plugins.lint = {
    enable = true;
    autoCmd = {
      event = [
        "BufWritePost"
        "BufReadPost"
        "InsertLeave"
      ];
      callback.__raw = ''
        function()
          require("lint").try_lint()
        end
      '';
    };
    lintersByFt = {
      dockerfile = [ "hadolint" ];
      gitcommit = [ "gitlint" ];
    };
  };
}
