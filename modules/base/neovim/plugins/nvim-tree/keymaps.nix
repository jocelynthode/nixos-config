_: {
  programs.nixvim.keymaps = [
    {
      action = "<cmd>NvimTreeToggle<cr>";
      key = "<leader>e";
      mode = "n";
      options = {
        desc = "Explorer";
        nowait = true;
        remap = false;
      };
    }
  ];
}
