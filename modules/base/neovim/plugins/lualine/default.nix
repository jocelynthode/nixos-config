_: {
  programs.nixvim.plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "catppuccin";
        globalstatus = true;
        disabled_filetypes = [
          "alpha"
          "grug-far"
        ];
      };
      extensions = [
        "neo-tree"
      ];
      sections = {
        lualine_a = [ "mode" ];
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
              function()
                local ok, taxi = pcall(require, "taxi")
                if not ok then
                  return ""
                end

                if taxi.is_balance_inflight() or taxi.is_alias_update_inflight() then
                  return "Taxi running"
                end

                return ""
              end
            '';
            cond.__raw = ''
              function()
                return vim.bo.filetype == "taxi"
              end
            '';
          }
          {
            __unkeyed-1.__raw = ''
              function(msg)
                msg = msg or "Inactive"
                local bufnr = vim.api.nvim_get_current_buf()
                local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
                if next(buf_clients) == nil then
                  if type(msg) == "boolean" or #msg == 0 then
                    return "Inactive"
                  end
                  return msg
                end
                local buf_client_names = {}

                for _, client in pairs(buf_clients) do
                  table.insert(buf_client_names, client.name)
                end

                return " " .. table.concat(buf_client_names, ", ")
              end
            '';
          }
          "encoding"
          "fileformat"
          "filetype"
        ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
      inactive_sections = {
        lualine_a = [ ];
        lualine_b = [ ];
        lualine_c = [ "filename" ];
        lualine_x = [ "location" ];
        lualine_y = [ ];
        lualine_z = [ ];
      };
    };
  };
}
