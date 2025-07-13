{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.aspects.development.ollama.enable {
    programs.nixvim.plugins.codecompanion = {
      enable = true;
      settings = {
        display = {
          diff = {
            provider = "mini_diff";
          };
        };
        adapters = {
          ollama = {
            __raw = ''
              function()
                return require("codecompanion.adapters").extend("ollama", {
                  name = "ollama",
                  schema = {
                    model = {
                      default = "qwq:32b",
                    },
                  },
                  })
              end
            '';
          };
        };
        strategies = {
          chat = {
            adapter = "ollama";
          };
          inline = {
            adapter = "ollama";
          };
          agent = {
            adapter = "ollama";
          };
        };
      };
    };
  };
}
