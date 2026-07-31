{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.development.opencode.enable = lib.mkEnableOption "opencode";

  config = lib.mkIf config.aspects.development.opencode.enable {
    aspects.base.backup.excludePaths = [
      "/home/jocelyn/.local/share/opencode"
      "/home/jocelyn/.config/opencode"
    ];

    aspects.base.persistence = {
      homePaths = [
        ".config/opencode"
        ".local/share/opencode"
      ];
    };

    home-manager.users.jocelyn = _: {

      stylix.targets.opencode.enable = false;
      programs = {
        mcp = {
          enable = true;
          servers = {
            github = {
              url = "https://api.githubcopilot.com/mcp/";
              headers = {
                Authorization = "Bearer {file:${config.sops.secrets.github.path}}";
              };
            };
            # grafana-poto = {
            #   enabled = true;
            #   command = "mcp-grafana";
            #   env = {
            #     GRAFANA_ORG_ID = "1";
            #     GRAFANA_URL.file = "https://grafana.k8s.flavus.ch";
            #     GRAFANA_SERVICE_ACCOUNT_TOKEN.file = config.sops.secrets.grafana.path;
            #   };
            # };
            gitlab-liip = {
              enabled = false;
              url = "https://gitlab.liip.ch/api/v4/mcp";
            };
            gitlab-poto = {
              url = "https://sources.poto.ch/api/v4/mcp";
            };
          };
        };
        opencode = {
          enable = true;
          enableMcpIntegration = true;
          extraPackages = [
            pkgs.mcp-grafana
          ];
          tui = {
            theme = "catppuccin";
          };
          settings = {
            model = "openrouter/deepseek/deepseek-v4-flash";
            small_model = "opencode/deepseek-v4-flash-free";
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
              gitlab-poto_create_issue = "ask";
              gitlab-poto_create_merge_request = "ask";
              gitlab-poto_create_workitem_note = "ask";
              gitlab-poto_link_work_items = "ask";
              gitlab-poto_manage_pipeline = "ask";
              gitlab-liip_create_issue = "ask";
              gitlab-liip_create_merge_request = "ask";
              gitlab-liip_create_workitem_note = "ask";
              gitlab-liip_link_work_items = "ask";
              gitlab-liip_manage_pipeline = "ask";
            };
          };
        };
      };
    };

    sops.secrets = {
      github = {
        sopsFile = ../../../secrets/head/secrets.yaml;
        owner = config.users.users.jocelyn.name;
        inherit (config.users.users.jocelyn) group;
      };
      # grafana = {
      #   sopsFile = ../../../secrets/head/secrets.yaml;
      #   owner = config.users.users.jocelyn.name;
      #   inherit (config.users.users.jocelyn) group;
      # };
    };
  };

}
