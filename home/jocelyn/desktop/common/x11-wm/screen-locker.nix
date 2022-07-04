{ pkgs, ... }: {
  home.packages = with pkgs; [ betterlockscreen ];

  services.screen-locker = {
    enable = true;
    inactiveInterval = 15;
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
    xautolock.extraOptions = [
      "Xautolock.killer: systemctl suspend"
    ];
  };
}
