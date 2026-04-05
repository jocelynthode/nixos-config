_: {
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      settings = {
        ensure_installed = [
          "bash"
          "diff"
          "dockerfile"
          "git_config"
          "gitcommit"
          "go"
          "gomod"
          "gosum"
          "helm"
          "json"
          "json5"
          "lua"
          "markdown"
          "markdown_inline"
          "nix"
          "python"
          "query"
          "regex"
          "rust"
          "toml"
          "tsx"
          "typescript"
          "vim"
          "vimdoc"
          "yaml"
        ];
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
        };
        indent = {
          enable = true;
        };
      };
    };
    ts-comments.enable = true;
  };
}
