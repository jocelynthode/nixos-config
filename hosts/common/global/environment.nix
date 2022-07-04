{ pkgs, ... }: {
  environment = {
    variables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "bat";
      OPENER = "xdg-open";
    };
    systemPackages = with pkgs; [
      git
      killall
      bat
      neovim
      wget
      curl
      fzf
      blueberry
      any-nix-shell
    ];
  };
}
