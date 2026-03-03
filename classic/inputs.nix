{ sources }:
let
  flakeCompat = src: (import sources.flake-compat { inherit src; }).defaultNix;
in
{
  inherit (sources) nixpkgs nixpkgs-master nixpkgs-stable;

  import-tree = import sources.import-tree;

  authentik-nix = flakeCompat sources."authentik-nix";
  devenv = flakeCompat sources.devenv;
  niri = flakeCompat sources.niri;
  nixvim = flakeCompat sources.nixvim;
  noctalia = flakeCompat sources.noctalia;
  spicetify-nix = flakeCompat sources."spicetify-nix";
  stylix = flakeCompat sources.stylix;

  catppuccin = {
    homeModules.catppuccin = sources.catppuccin + "/modules/home-manager";
    nixosModules.catppuccin = sources.catppuccin + "/modules/nixos";
  };

  disko.nixosModules.disko = sources.disko + "/module.nix";
  home-manager.nixosModules.home-manager = sources."home-manager" + "/nixos";
  impermanence.nixosModules.impermanence = sources.impermanence + "/nixos.nix";
  nix-index-database.nixosModules.default = sources."nix-index-database" + "/nixos-module.nix";
  sops-nix.nixosModules.sops = sources."sops-nix" + "/modules/sops";

  hardware.nixosModules = {
    common-cpu-amd = sources.hardware + "/common/cpu/amd";
    common-cpu-intel = sources.hardware + "/common/cpu/intel";
    common-gpu-amd = sources.hardware + "/common/gpu/amd";
    common-pc-laptop = sources.hardware + "/common/pc/laptop";
    common-pc-laptop-ssd = sources.hardware + "/common/pc/ssd";
    common-pc-ssd = sources.hardware + "/common/pc/ssd";
    framework-11th-gen-intel = sources.hardware + "/framework/13-inch/11th-gen-intel";
  };

  nur.overlays.default = _: prev: {
    nur = import sources.nur {
      nurpkgs = prev;
      pkgs = prev;
    };
  };

  taxi.overlays.default =
    final: _prev:
    let
      taxiBase = (final.callPackage (sources.taxi + "/pkgs.nix") { }).overridePythonAttrs (_old: {
        doCheck = false;
        doInstallCheck = false;
        nativeCheckInputs = [ ];
        checkPhase = "true";
        installCheckPhase = "true";
      });
      taxiZebra = final.python3.pkgs.buildPythonPackage rec {
        pname = "taxi_zebra";
        version = "5.0.0";
        src = final.fetchFromGitHub {
          owner = "liip";
          repo = "taxi-zebra";
          rev = version;
          sha256 = "sha256-vwlCdeWvbmoKYdEwKVmBkQTokOY4MGaxnOU3t0CRDS4=";
        };
        format = "pyproject";
        buildInputs = [ taxiBase ];
        nativeBuildInputs = [
          final.python3.pkgs.setuptools
          final.python3.pkgs.wheel
        ];
        propagatedBuildInputs = [
          final.python3.pkgs.requests
          final.python3.pkgs.click
        ];
        doCheck = false;
        meta = {
          homepage = "https://github.com/liip/taxi-zebra";
          description = "Zebra backend for the Taxi timesheeting application";
          license = final.lib.licenses.wtfpl;
        };
      };
      taxiClockify = final.python3.pkgs.buildPythonPackage rec {
        pname = "taxi_clockify";
        version = "1.5.0";
        src = final.python3.pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-ujdacSOw7R0fNAk8ekiERNf90vg1Sk3ti8gbx4YqZFU=";
        };
        format = "pyproject";
        buildInputs = [ taxiBase ];
        nativeBuildInputs = [ final.python3.pkgs.flit-core ];
        propagatedBuildInputs = [
          final.python3.pkgs.requests
          final.python3.pkgs.arrow
        ];
        doCheck = false;
        meta = {
          homepage = "https://github.com/sephii/taxi-clockify";
          description = "Clockify backend for the Taxi timesheeting application";
          license = final.lib.licenses.wtfpl;
        };
      };
      taxiPetzi = final.python3.pkgs.buildPythonPackage rec {
        pname = "taxi_petzi";
        version = "1.1.0";
        src = final.python3.pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-m76pDp6/noJ05MgNJf+yFxD+TAqoFnTwhFTHSclcLxo=";
        };
        format = "pyproject";
        buildInputs = [ taxiBase ];
        nativeBuildInputs = [ final.python3.pkgs.flit-core ];
        nativeCheckInputs = [ final.python3.pkgs.pytestCheckHook ];
        propagatedBuildInputs = [
          final.python3.pkgs.google-auth-oauthlib
          final.python3.pkgs.google-auth-httplib2
          final.python3.pkgs.google_api_python_client
        ];
        doCheck = false;
        meta = {
          homepage = "https://github.com/sephii/taxi-petzi";
          description = "Petzi backend for the Taxi timesheeting application";
          license = final.lib.licenses.wtfpl;
        };
      };
      availablePlugins = {
        zebra = taxiZebra;
        petzi = taxiPetzi;
        clockify = taxiClockify;
      };
      mkWithPlugins =
        pluginsFunc:
        let
          plugins = pluginsFunc availablePlugins;
        in
        final.python3.pkgs.buildPythonPackage {
          name = "${taxiBase.name}-with-plugins";
          inherit (taxiBase) version meta;
          format = "other";
          nativeBuildInputs = [ final.makeWrapper ];
          propagatedBuildInputs = plugins ++ taxiBase.propagatedBuildInputs;
          installPhase = ''
            makeWrapper ${taxiBase}/bin/taxi $out/bin/taxi \
              --prefix PYTHONPATH : "${taxiBase}/${final.python3.sitePackages}:$PYTHONPATH"
          '';
          doCheck = false;
          dontUnpack = true;
          dontBuild = true;
          passthru = taxiBase.passthru // {
            withPlugins = morePlugins: mkWithPlugins (morePlugins ++ plugins);
          };
        };
    in
    {
      taxi-cli = taxiBase.overridePythonAttrs (old: {
        passthru = old.passthru // {
          inherit availablePlugins;
          withPlugins = mkWithPlugins;
        };
      });
    };

  wofi-ykman.overlays.default = _: prev: {
    wofi-ykman = prev.stdenv.mkDerivation {
      pname = "wofi-ykman";
      version = "1.0.0";
      src = sources."wofi-ykman";
      dontBuild = true;
      buildInputs = with prev; [
        yubikey-manager
        wofi
        wl-clipboard
        wtype
        libnotify
      ];
      installPhase = ''
        mkdir -p $out/bin
        cp ${sources."wofi-ykman"}/wofi-ykman $out/bin/wofi-ykman
        chmod +x $out/bin/wofi-ykman
      '';
      meta.mainProgram = "wofi-ykman";
    };
  };
}
