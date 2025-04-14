_: {
  programs.nixvim = {
    autoGroups = {
      _text = {
        clear = true;
      };
      _general_settings = {
        clear = true;
      };
      _auto_resize = {
        clear = true;
      };
    };
    autoCmd = [
      {
        event = "FileType";
        pattern = [
          "text"
          "markdown"
          "gitcommit"
          "taxi"
        ];
        callback.__raw = ''
          function()
              vim.api.nvim_command("setlocal spell")
              vim.api.nvim_command("setlocal wrap")
          end
        '';
        group = "_text";
      }
      {
        event = "FileType";
        pattern = [
          "qf"
          "help"
          "man"
          "lspinfo"
        ];
        command = "nnoremap <silent> <buffer> q :close<CR>";
        group = "_general_settings";
      }
      {
        event = "TextYankPost";
        pattern = [
          "*"
        ];
        callback.__raw = ''
          function()
              vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
          end
        '';
        group = "_general_settings";
      }
      {
        event = "BufWinEnter";
        pattern = [
          "*"
        ];
        command = "set formatoptions-=cro";
        group = "_general_settings";
      }
      {
        event = "FileType";
        pattern = [
          "qf"
        ];
        command = "set nobuflisted";
        group = "_general_settings";
      }
      {
        event = "VimResized";
        pattern = [
          "*"
        ];
        command = "tabdo wincmd =";
        group = "_auto_resize";
      }
    ];
  };
}
