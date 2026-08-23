{
  config,
  lib,
  pkgs-stable,
  ...
}:
{
  options.aspects.development.ai.ollama.enable = lib.mkEnableOption "ollama";

  config = lib.mkIf config.aspects.development.ai.ollama.enable {
    aspects.base.backup.excludePaths = [ "/var/lib/private/ollama" ];

    # aspects.base.persistence.homePaths = [
    #   ".android"
    # ];
    services.ollama = {
      enable = true;
      package = pkgs-stable.ollama-rocm;
      rocmOverrideGfx = "11.0.0";
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "32768";
      };
    };
  };
}
