{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.aspects.development.ollama.enable = lib.mkEnableOption "ollama";

  config = lib.mkIf config.aspects.development.ollama.enable {
    # aspects.base.persistence.homePaths = [
    #   ".android"
    # ];
    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      rocmOverrideGfx = "11.0.0";
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "32768";
      };
    };
  };
}
