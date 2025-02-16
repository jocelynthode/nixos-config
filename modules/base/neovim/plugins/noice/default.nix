_: {
  programs.nixvim.plugins.noice = {
    enable = true;
    settings = {
      lsp = {
        override = {
          "__rawKey__vim.lsp.util.convert_input_to_markdown_lines" = true;
          "__rawKey__vim.lsp.util.stylize_markdown" = true;
        };
      };
      routes = [
        {
          filter = {
            event = "msg_show";
            any = [
              {find = "%d+L; %d+B";}
              {find = "; after #%d+";}
              {find = "; before #%d+";}
            ];
          };
          view = "mini";
        }
      ];
      presets = {
        bottom_search = false;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = false;
        lsp_doc_border = false;
      };
    };
  };
}
