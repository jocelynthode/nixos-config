_: {
  programs.nixvim.plugins.none-ls = {
    enable = true;
    sources = {
      code_actions = {
        # gitsigns.enable = true;
      };
      diagnostics = {
        gitlint.enable = true;
        hadolint.enable = true;
      };
      formatting = {
        shfmt = {
          enable = true;
          settings = {
            disabled_filetypes = [
              "lua"
            ];
            extra_args = [
              "-i"
              "2"
              "-ci"
            ];
            extra_filetypes = [
              "toml"
            ];
          };
        };
        opentofu_fmt.enable = true;
        prettier = {
          enable = true;
          settings = {
            filetypes = [
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
              "vue"
              "css"
              "scss"
              "less"
              "html"
              "markdown"
              "graphql"
              "handlebars"
            ];
          };
        };
      };
    };
  };
}
