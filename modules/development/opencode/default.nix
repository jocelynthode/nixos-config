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

      stylix.targets.opencode.enable = false;
      programs.opencode = {
        enable = true;
        tui = {
          theme = "catppuccin";
        };
        settings = {
          model = "openai/gpt-5.3-codex";
          small_model = "openai/gpt-5.3-codex-spark";
          default_agent = "devops-orchestrator";
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
          mcp = {
            github = {
              enabled = true;
              oauth = false;
              type = "remote";
              url = "https://api.githubcopilot.com/mcp/";
              headers = {
                Authorization = "Bearer {file:${config.sops.secrets.github.path}}";
              };
            };
          };
          tools = {
            "github_*" = false;
            github_get_file_contents = true;
            github_list_issues = true;
            github_issue_read = true;
            github_list_pull_requests = true;
            github_pull_request_read = true;
            github_list_commits = true;
            github_get_commit = true;
            github_list_branches = true;
            github_list_tags = true;
            github_list_releases = true;
            github_get_latest_release = true;
            github_get_release_by_tag = true;
            github_get_label = true;
            github_list_issue_types = true;
            github_get_me = true;
          };
          lsp = {
            yaml-ls = {
              disabled = true;
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
            skill = "allow";
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

    sops.secrets.github = {
      sopsFile = ../../../secrets/head/secrets.yaml;
      owner = config.users.users.jocelyn.name;
      inherit (config.users.users.jocelyn) group;
    };
  };

}
