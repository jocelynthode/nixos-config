{
  config,
  lib,
  ...
}: {
  options.aspects.development.ollama.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.development.ollama.enable {
    # aspects.base.persistence.homePaths = [
    #   ".android"
    # ];
    services.ollama = {
      enable = true;
      acceleration = "rocm";
      # environmentVariables = {
      #   HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      # };
    };
  };
}
