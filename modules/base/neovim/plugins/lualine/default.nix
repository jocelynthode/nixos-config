_: {
  programs.nixvim.plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "catppuccin";
        globalstatus = true;
        disabled_filetypes = ["alpha" "grug-far"];
      };
      extensions = [
        "nvim-tree"
        "toggleterm"
      ];
      sections = {
        lualine_a = ["mode"];
        lualine_b = [
          "branch"
          "diff"
          "diagnostics"
        ];
        lualine_c = [
          {
            __unkeyed-1 = "filename";
            path = 1;
          }
        ];
        lualine_x = [
          {
            __unkeyed-1.__raw = ''
              function(msg)
                msg = msg or "Inactive"
                local buf_clients = vim.lsp.get_clients()
                if next(buf_clients) == nil then
                  if type(msg) == "boolean" or #msg == 0 then
                    return "Inactive"
                  end
                  return msg
                end
                local buf_client_names = {}

                for _, client in pairs(buf_clients) do
                  if client.name ~= "none-ls" then
                    table.insert(buf_client_names, client.name)
                  end
                end

                return " " .. table.concat(buf_client_names, ", ")
              end
            '';
          }
          "encoding"
          "fileformat"
          "filetype"
        ];
        lualine_y = ["progress"];
        lualine_z = ["location"];
      };
      inactive_sections = {
        lualine_a = [];
        lualine_b = [];
        lualine_c = ["filename"];
        lualine_x = ["location"];
        lualine_y = [];
        lualine_z = [];
      };
    };
  };
}
