{
  pkgs,
  config,
}:
pkgs.writeShellApplication {
  name = "polybar-gammastep";
  checkPhase = "";

  runtimeInputs = with pkgs; [coreutils systemd gnugrep findutils];

  text = ''
    if unit_status="$(systemctl --user is-active gammastep)"; then
      status="$unit_status ($(journalctl --user -u gammastep.service | grep 'Period: ' | cut -d ':' -f6 | tail -1 | xargs))"
      echo "%{F#${config.colorScheme.colors.yellow}}󱠂"
    else
      status="$unit_status"
      echo "%{F#${config.colorScheme.colors.yellow}}󱠃"
    fi
  '';
}
