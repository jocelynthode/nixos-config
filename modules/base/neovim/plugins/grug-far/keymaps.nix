_: {
  programs.nixvim.keymaps = [
    {
      action.__raw = ''
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end
      '';
      key = "<leader>sr";
      mode = ["n" "v"];
      options = {
        desc = "Search and Replace";
        nowait = true;
        remap = false;
      };
    }
  ];
}
