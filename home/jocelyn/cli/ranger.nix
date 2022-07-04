{ pkgs, ... }: {
  home.packages = with pkgs; [
    ranger
    ueberzug
  ];

  xdg.configFile."ranger/rc.conf".text = ''
    default_linemode devicons
    map <C-d> shell dragon -a -x %p
    set preview_images true
    set preview_images_method ueberzug
  '';

  xdg.configFile."ranger/plugins/ranger_devicons".source = pkgs.fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = "ranger_devicons";
    rev = "49fe4753c89615a32f14b2f4c78bbd02ee76be3c";
    sha256 = "sha256-YT7YFiTA2XtIoVzaVjUWMu6j4Nwo4iGzvOtjjWva/80=";
  };

  # Allow firefox to open folder in ranger
  xdg.desktopEntries = {
    ranger = {
      name = "Ranger";
      type = "Application";
      comment = "Launcher the ranger file manager";
      exec = "kitty ranger";
      icon = "utilities-terminal";
      mimeType = [
        "inode/directory"
      ];
      terminal = false;
      categories = [ "ConsoleOnly" ];
    };
  };
}
