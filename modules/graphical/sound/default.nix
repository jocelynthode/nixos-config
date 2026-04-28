{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./guitar
  ];

  options.aspects.graphical.sound.enable = lib.mkEnableOption "sound";

  config = lib.mkIf config.aspects.graphical.sound.enable {
    aspects.base.persistence.homePaths = [
      ".local/state/wireplumber"
    ];
    aspects.graphical.sound.guitar.enable = lib.mkDefault false;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
        extraConfig = {
          "10-bluez-opts" = {
            "monitor.bluez.properties" = {
              "bluez5.enable-sbc-xq" = true;
              "bluez5.enable-msbc" = true;
              "bluez5.enable-hw-volume" = true;
              # Use PipeWire's native HFP backend for proper mSBC/wideband codec negotiation
              "bluez5.hfphsp-backend" = "native";
              # Only override roles that differ from WirePlumber defaults.
              # a2dp_sink lets the computer receive A2DP audio from the phone (BT speaker role).
              # hfp_ag/hsp_ag (phone gateway roles) are intentionally omitted.
              "bluez5.roles" = [
                "hsp_hs"
                "hfp_hf"
                "a2dp_sink"
                "a2dp_source"
              ];
              # Do NOT set bluez5.codecs: listing codecs restricts negotiation to only those
              # listed. enable-sbc-xq and enable-msbc above are sufficient to enable the
              # non-default codecs; everything else (AAC, LDAC, aptX, aptX HD) is on by default.
            };
          };
          "11-no-suspend" = {
            "monitor.alsa.rules" = [
              {
                matches = [
                  { "node.name" = "~alsa_input.*"; }
                  { "node.name" = "~alsa_output.*"; }
                ];
                apply_properties = {
                  "session.suspend-timeout-seconds" = 0;
                };
              }
            ];
          };
        };
      };
    };

    home-manager.users.jocelyn = _: {
      home.packages = with pkgs; [
        pwvucontrol
      ];

      services.easyeffects = {
        enable = true;
      };

      xdg.configFile."easyeffects" = {
        source = ./config;
        recursive = true;
      };

      xdg.dataFile."easyeffects" = {
        source = ./data;
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
