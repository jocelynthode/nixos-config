{inputs, ...}: final: prev: let
  inherit (inputs.nix-colors.lib-contrib {pkgs = final;}) gtkThemeFromScheme;
  inherit (inputs.nix-colors) colorSchemes;
  inherit (builtins) mapAttrs;
in
  {
    vimPlugins =
      prev.vimPlugins
      // {
        taxi-vim = prev.pkgs.callPackage ../pkgs/vimPlugins/taxi-vim {};
        deferred-clipboard-nvim = prev.pkgs.callPackage ../pkgs/vimPlugins/deferred-clipboard-nvim {};
        search-replace-nvim = prev.pkgs.callPackage ../pkgs/vimPlugins/search-replace-nvim {};
        nvim-dap-repl-highlights = prev.pkgs.callPackage ../pkgs/vimPlugins/nvim-dap-repl-highlights {};
      };

    waybar = prev.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      patches =
        (oldAttrs.patches or [])
        ++ [
          (prev.pkgs.fetchpatch {
            name = "fix waybar hyprctl";
            url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
            sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
          })
        ];
    });

    pythonPackagesExtensions =
      prev.pythonPackagesExtensions
      ++ [
        (
          _python-final: python-prev: {
            catppuccin = python-prev.catppuccin.overridePythonAttrs (_oldAttrs: rec {
              version = "1.3.2";

              src = prev.fetchFromGitHub {
                owner = "catppuccin";
                repo = "python";
                rev = "refs/tags/v${version}";
                hash = "sha256-spPZdQ+x3isyeBXZ/J2QE6zNhyHRfyRQGiHreuXzzik=";
              };

              # can be removed next version
              disabledTestPaths = [
                "tests/test_flavour.py" # would download a json to check correctness of flavours
              ];
            });
          }
        )
      ];

    slack = prev.slack.overrideAttrs (previousAttrs: {
      installPhase =
        previousAttrs.installPhase
        + ''
          sed -i'.backup' -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar

        '';
    });

    devenv = inputs.devenv.packages.${final.system}.default;

    proton-ge-custom = prev.pkgs.callPackage ../pkgs/core/proton-ge-custom {};

    mm-server-ui = prev.pkgs.callPackage ../pkgs/services/media-homepage {};

    generated-gtk-themes =
      mapAttrs
      (_: scheme:
        gtkThemeFromScheme {
          inherit scheme;
        })
      colorSchemes;
  }
  // import ../pkgs {pkgs = final;}
