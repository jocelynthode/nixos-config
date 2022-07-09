{ pkgs, ... }: {
  home.packages = with pkgs; [ solaar ];

  systemd.user.services.solaar = {
    Unit = {
      Description = "Solaar Logitech status applet";
      After = [ "graphical-session-pre.target" "tray.target" ];
      PartOf = [ "graphical-session.target" ];
      Requires = [ "tray.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.solaar}/bin/solaar --restart-on-wake-up --window=hide";
      KillMode = "process";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
