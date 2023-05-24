{pkgs}:
pkgs.writeShellApplication {
  name = "wofi-powermenu";
  checkPhase = "";

  runtimeInputs = with pkgs; [systemd wofi coreutils gnugrep];

  text = ''
    entries=" Lock\n󰍃 Logout\n󰒲 Suspend\n󰋊 Hibernate\n⭮ Reboot\n Shutdown"

    selected=$(echo -e $entries|wofi --insensitive -W 20% -H 30% --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

    case $selected in
      lock)
        exec loginctl lock-session ''${XDG_SESSION_ID-};;
      logout)
        exec loginctl terminate-session ''${XDG_SESSION_ID-};;
      suspend)
        exec systemctl suspend;;
      hibernate)
        exec systemctl hibernate;;
      reboot)
        exec systemctl reboot;;
      shutdown)
        exec systemctl poweroff;;
    esac
  '';
}
