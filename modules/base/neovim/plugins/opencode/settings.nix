{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.aspects.development.opencode.enable {
    programs.nixvim = {
      dependencies.opencode.enable = true;
      plugins.opencode = {
        enable = true;
        settings = {
          # Use a fixed port so opencode.nvim can
          # connect via TCP without relying on pgrep/lsof.
          port = 39555;
          provider = {
            # Explicitly use the snacks provider; snacks.terminal
            # is enabled in plugins/snacks/default.nix.
            enabled = "snacks";
          };
        };
      };
    };
  };
}
