{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.aspects.development.ollama.enable {
    programs.nixvim.keymaps = [
      {
        action = ":CodeCompanionActions<cr>";
        key = "<leader>aa";
        mode = "n";
        options = {
          desc = "Open Actions";
        };
      }
      {
        action = ":CodeCompanionChat Toggle<cr>";
        key = "<leader>ac";
        mode = "n";
        options = {
          desc = "Open Chat";
        };
      }
      {
        action = ":CodeCompanion<cr>";
        key = "<leader>ap";
        mode = "n";
        options = {
          desc = "Open Prompt";
        };
      }

      {
        action = ":'<,'>CodeCompanionActions<cr>";
        key = "<leader>aa";
        mode = "v";
        options = {
          desc = "Open Actions";
          nowait = true;
          remap = false;
        };
      }

      {
        action = ":'<,'>:CodeCompanionChat Add<cr>";
        key = "<leader>ac";
        mode = "v";
        options = {
          desc = "Open Chat";
          nowait = true;
          remap = false;
        };
      }

      {
        action = ":'<,'>CodeCompanion /editor /fix<cr>";
        key = "<leader>af";
        mode = "v";
        options = {
          desc = "Fix selection";
          nowait = true;
          remap = false;
        };
      }
    ];
  };
}
