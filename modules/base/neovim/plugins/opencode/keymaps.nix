{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.aspects.development.opencode.enable {
    programs.nixvim.keymaps = [
      {
        action = "<cmd>lua require(\"opencode\").ask(\"@this: \", { submit = true })<cr>";
        key = "<leader>aa";
        mode = [
          "n"
          "x"
        ];
        options = {
          desc = "Ask opencode";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>lua require(\"opencode\").select()<cr>";
        key = "<leader>as";
        mode = [
          "n"
          "x"
        ];
        options = {
          desc = "Execute opencode action…";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>lua require(\"opencode\").prompt(\"@this\")<cr>";
        key = "<leader>ap";
        mode = [
          "n"
          "x"
        ];
        options = {
          desc = "Prompt opencode (@this)…";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>lua require(\"opencode\").toggle()<cr>";
        key = "<leader>at";
        mode = [
          "n"
          "t"
        ];
        options = {
          desc = "Toggle opencode";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>lua require(\"opencode\").command(\"session.half.page.up\")<cr>";
        key = "<S-C-u>";
        mode = "n";
        options = {
          desc = "opencode half page up";
          nowait = true;
          remap = false;
        };
      }
      {
        action = "<cmd>lua require(\"opencode\").command(\"session.half.page.down\")<cr>";
        key = "<S-C-d>";
        mode = "n";
        options = {
          desc = "opencode half page down";
          nowait = true;
          remap = false;
        };
      }
    ];
  };
}
