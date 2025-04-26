{
  pkgs,
  lib,
  config,
  ...
}: {
  options.aspects.graphical.sound.guitar.enable = lib.mkEnableOption "guitar";

  config = lib.mkIf config.aspects.graphical.sound.guitar.enable {
    # services.udev.extraRules = ''
    #   SUBSYSTEM=="sound", SUBSYSTEMS=="usb", ATTR{idVendor}=="1686",ATTR{idProduct}=="02df", ENV{SYSTEMD_ALIAS}="test-zoom", TAG+="systemd"
    # '';

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        tonelib-zoom
        audacity
      ];
      #
      # systemd.user = {
      #   services.guitar-monitor = {
      #     Unit = {
      #       Description = "Guitar Monitor";
      #       Requires = [
      #         "pipewire.service"
      #       ];
      #     };
      #
      #     Service = {
      #       Type = "simple";
      #       ExecStart = "${pkgs.pipewire}/bin/pw-loopback -C 'alsa_input.usb-ZOOM_Corporation_ZOOM_G_Series-00.analog-stereo' --capture-props='node.name=\"Guitar Monitor\"'";
      #       Restart = "on-failure";
      #     };
      #   };
      # };
    };
  };
}
