{ pkgs, config }:

pkgs.writeShellApplication {
  name = "polybar-bluetooth";
  checkPhase = "";

  runtimeInputs = with pkgs; [ bluez coreutils gnugrep ];

  text = ''
    if [ ''$(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
    then
      echo "%{F#${config.colorScheme.colors.base03}}"
    else
      if [ ''$(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
      then 
        echo ""
      fi
      echo "%{F#${config.colorScheme.colors.base0D}}"
    fi
  '';
}
