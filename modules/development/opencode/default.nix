{
  config,
  lib,
  ...
}:
{
  options.aspects.development.opencode.enable = lib.mkEnableOption "opencode";

  config = lib.mkIf config.aspects.development.opencode.enable {
    aspects.base.persistence = {
      homePaths = [
        ".config/opencode"
        ".local/share/opencode"
      ];
    };

    home-manager.users.jocelyn = _: {
      programs.opencode = {
        enable = true;
        settings = {
          model = "openai/gpt-5.1-codex";
          small_model = "openai/gpt-5-mini";
          provider = {
          }
          // lib.optionalAttrs config.aspects.development.ollama.enable {
            ollama = {
              npm = "@ai-sdk/openai-compatible";
              name = "Ollama (local)";
              options = {
                baseURL = "http://localhost:11434/v1";
              };
              models = {
                "devstral-small-2:24b" = {
                  name = "Devstral Small 2";
                };
              };
            };
          };
          permission = {
            edit = "ask";
            write = "ask";
            patch = "ask";
            read = "ask";
            grep = "allow";
            glob = "allow";
            list = "allow";
            skill = "ask";
            bash = "ask";
            webfetch = "ask";
            todowrite = "allow";
            todoread = "allow";
            lsp = "ask";
            question = "allow";
            doom_loop = "ask";
            external_directory = "ask";
          };
        };
      };
    };
  };
}
