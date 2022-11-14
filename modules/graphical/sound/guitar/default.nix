{ pkgs, lib, config, ... }: {

  options.aspects.graphical.sound.guitar.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.graphical.sound.guitar.enable {

    home-manager.users.jocelyn = { ... }: {
      home.packages = with pkgs; [
        tonelib-zoom
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
