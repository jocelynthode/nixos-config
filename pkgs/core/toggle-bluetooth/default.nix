{ pkgs }:

pkgs.writeShellApplication {
  name = "toggle_bluetooth";
  checkPhase = "";

  runtimeInputs = with pkgs; [ bluez coreutils gnugrep ];

  text = ''
    if [ ''$(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
    then
      bluetoothctl power on
    else
      bluetoothctl power off
    fi
  '';
}
