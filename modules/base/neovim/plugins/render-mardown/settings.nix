_: {
  programs.nixvim.plugins.render-markdown = {
    enable = true;
    settings = {
      enabled.__raw = "vim.env.KITTY_SCROLLBACK_NVIM ~= 'true'";
      file_types = [
        "markdown"
        "norg"
        "rmd"
        "org"
        "codecompanion"
      ];
      anti_conceal = {
        enabled = false;
      };
      completions = {
        lsp = {
          enabled = true;
        };
      };
      on = {
        initial.__raw = ''
          function()
            local target = vim.api.nvim_get_current_buf()
            if not (type(target) == "number" and vim.api.nvim_buf_is_valid(target)) then
              return
            end

            local function run_preview()
              local ok, rm = pcall(require, "render-markdown")
              if ok and rm and type(rm.preview) == "function" then
                pcall(rm.preview)
              end
            end

            vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
              buffer = target,
              callback = run_preview,
            })
          end
        '';
      };
    };
  };
}
