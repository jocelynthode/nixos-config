{ config, lib, pkgs, ... }: {
  options.aspects.graphical.sound.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.aspects.graphical.sound.enable {
    environment.persistence."${config.aspects.persistPrefix}".users.jocelyn.directories = [
      ".local/state/wireplumber"
      ".config/pavucontrol-qt"
    ];

    security.rtkit.enable = true;
    sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    environment.etc = {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]",
          ["bluez5.codecs"] = "[ sbc sbc_xq aac ldac aptx aptx_hd ]"
        }
      '';
    };

    home-manager.users.jocelyn = { ... }: {
      home.packages = with pkgs; [
        lxqt.pavucontrol-qt
      ];

      services.easyeffects = {
        enable = true;
      };

      xdg.configFile."easyeffects" = {
        source = ./config;
        recursive = true;
      };

      dconf.settings = {
        "com/github/wwmm/easyeffects" = {
          use-dark-theme = true;
        };
      };
    };
  };
}