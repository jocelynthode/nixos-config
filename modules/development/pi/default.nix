{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.development.pi.enable = lib.mkEnableOption "pi";

  config = lib.mkIf config.aspects.development.pi.enable {
    aspects.base.backup.excludePaths = [ "/home/jocelyn/.pi" ];

    aspects.base.persistence = {
      homePaths = [
        ".pi"
      ];
    };

    nix.settings = {
      substituters = [ "https://cache.numtide.com" ];
      trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };

    home-manager.users.jocelyn = _: {

      home.sessionVariables = {
        PI_LENS_DISABLE_LSP_INSTALL = "1";
        PI_LENS_DISABLE_TOOL_INSTALL = "1";
      };

      home.packages = with pkgs; [
        pi-coding-agent

        # Infrastructure
        yaml-language-server
        yamllint
        nil

        # Shell
        bash-language-server
        fish-lsp

        # Go
        gopls

        # Python
        pyright
        ruff

        # Containers
        dockerfile-language-server

        # General
        vscode-langservers-extracted
        prettier
        marksman
        ast-grep
      ];
    };
  };
}
