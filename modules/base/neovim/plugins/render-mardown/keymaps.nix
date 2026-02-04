_: {
  programs.nixvim.keymaps = [
    {
      action = "<cmd>RenderMarkdown preview<cr>";
      key = "<leader>mp";
      mode = "n";
      options = {
        desc = "Preview Markdown";
        nowait = true;
        remap = false;
      };
    }
  ];
}
