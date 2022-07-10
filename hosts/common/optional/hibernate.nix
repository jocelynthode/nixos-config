{
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      IdleAction=suspend
      IdleActionSec=15min
      HandlePowerKey=hibernate
      HandlePowerKeyLongPress=poweroff
    '';
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';
}
