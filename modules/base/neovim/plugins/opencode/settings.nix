{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.aspects.development.opencode.enable or false) {
    programs.nixvim = {
      dependencies.opencode.enable = true;
      plugins.opencode = {
        enable = true;
        settings = {
          # port = 39555;
          provider = {
            enabled = "snacks";
          };
        };
      };
    };
  };
}
