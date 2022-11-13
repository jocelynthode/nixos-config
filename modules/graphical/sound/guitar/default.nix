{ pkgs, lib, config, ... }: {

  options.aspects.graphical.sound.guitar.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.graphical.sound.guitar.enable {

    services.pipewire.config.pipewire = {
      "context.modules" = [
        {
          name = "libpipewire-module-rtkit";
          flags = [ "ifexists" "nofail" ];
        }
        { name = "libpipewire-module-protocol-native"; }
        { name = "libpipewire-module-profiler"; }
        { name = "libpipewire-module-metadata"; }
        { name = "libpipewire-module-spa-device-factory"; }
        { name = "libpipewire-module-spa-node-factory"; }
        { name = "libpipewire-module-client-node"; }
        { name = "libpipewire-module-client-device"; }
        {
          name = "libpipewire-module-portal";
          flags = [ "ifexists" "nofail" ];
        }
        {
          name = "libpipewire-module-access";
          args = { };
        }
        { name = "libpipewire-module-adapter"; }
        { name = "libpipewire-module-link-factory"; }
        { name = "libpipewire-module-session-manager"; }
        # {
        #   name = "libpipewire-module-loopback";
        #   args = {
        #     "capture.props" = {
        #       "node.name" = "Guitar Monitor";
        #       "target.object" = "alsa_input.usb-ZOOM_Corporation_ZOOM_G_Series-00.analog-stereo";
        #     };
        #     "playback.props" = {
        #       "target.object" = "alsa_output.pci-0000_10_00.4.analog-stereo";
        #       "node.passive" = true;
        #     };
        #   };
        # }
      ];
    };

    home-manager.users.jocelyn = { ... }: {
      home.packages = with pkgs; [
        tonelib-zoom
      ];
    };
  };
}
