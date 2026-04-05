_: {
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    autoInstall.enable = true;
    settings = {
      default_format_opts = {
        async = false;
        lsp_format = "fallback";
        quiet = false;
        timeout_ms = 3000;
      };
      format_on_save = {
        lsp_format = "fallback";
        timeout_ms = 3000;
      };
      formatters = {
        shfmt.prepend_args = [
          "-i"
          "2"
          "-ci"
        ];
      };
      formatters_by_ft = {
        javascript = [ "prettierd" ];
        javascriptreact = [ "prettierd" ];
        typescript = [ "prettierd" ];
        typescriptreact = [ "prettierd" ];
        vue = [ "prettierd" ];
        css = [ "prettierd" ];
        scss = [ "prettierd" ];
        less = [ "prettierd" ];
        html = [ "prettierd" ];
        graphql = [ "prettierd" ];
        handlebars = [ "prettierd" ];
        markdown = [ "prettierd" ];
        sh = [ "shfmt" ];
        bash = [ "shfmt" ];
        zsh = [ "shfmt" ];
        terraform = [ "tofu_fmt" ];
        tofu = [ "tofu_fmt" ];
      };
      notify_no_formatters = false;
    };
  };
}
