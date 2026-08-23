{
  config,
  lib,
  ...
}:
{
  options.aspects.development.ai.mcp.enable = lib.mkEnableOption "mcp";

  config = lib.mkIf config.aspects.development.ai.mcp.enable {
    home-manager.users.jocelyn = _: {
      programs = {
        mcp = {
          enable = true;
          servers = {
            # GitHub access now goes through the gh CLI under nono Tool Sandbox
            # (proxy credential backed by /run/secrets/github); no MCP server needed.
            # grafana-poto = {
            #   enabled = true;
            #   command = "mcp-grafana";
            #   env = {
            #     GRAFANA_ORG_ID = "1";
            #     GRAFANA_URL.file = "https://grafana.k8s.flavus.ch";
            #     GRAFANA_SERVICE_ACCOUNT_TOKEN.file = config.sops.secrets.grafana.path;
            #   };
            # };
            # gitlab-liip = {
            #   url = "https://gitlab.liip.ch/api/v4/mcp";
            # };
            gitlab-poto = {
              url = "https://sources.poto.ch/api/v4/mcp";
            };
            opentofu = {
              url = "https://mcp.opentofu.org/mcp";
            };
          };
        };
      };
    };

    # GitHub token consumed supervisor-side by the nono sandbox
    # (tool-sandbox proxy credential: file:///run/secrets/github).
    sops.secrets.github = {
      sopsFile = ../../../../secrets/head/secrets.yaml;
      owner = config.users.users.jocelyn.name;
      inherit (config.users.users.jocelyn) group;
    };
  };
}
