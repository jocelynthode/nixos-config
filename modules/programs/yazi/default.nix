{
  config,
  lib,
  ...
}:
{
  options.aspects.programs.yazi.enable = lib.mkEnableOption "yazi";

  config = lib.mkIf config.aspects.programs.yazi.enable {
    home-manager.users.jocelyn = _: {
      programs.yazi = {
        enable = true;
        # Because stateVersion lower than 26.05
        shellWrapperName = "y";
        enableFishIntegration = true;
        /*
             keymap = {
            manager.prepend_keymap = [
              {
                run = ''shell 'dragon -x -i -T "$1"' --confirm"'';
                on = ["<C-d>"];
              }
            ];
          };
        */
        settings = {
          manager = {
            show_hidden = true;
            sort_by = "mtime";
            sort_dir_first = true;
            sort_reverse = true;
          };
        };
      };

      xdg = {
        desktopEntries = {
          yazi = {
            name = "Yazi";
            type = "Application";
            comment = "Launcher the yazi file manager";
            exec = "kitty yazi";
            icon = "utilities-terminal";
            mimeType = [
              "inode/directory"
            ];
            terminal = false;
            categories = [ "ConsoleOnly" ];
          };
        };
      };
    };
  };
}
