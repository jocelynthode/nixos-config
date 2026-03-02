{ inputs }:
let
  sharedSpecialArgs = {
    inherit (inputs)
      authentik-nix
      spicetify-nix
      catppuccin
      impermanence
      nix-index-database
      nixvim
      niri
      noctalia
      stylix
      ;
  };
in
{
  inherit sharedSpecialArgs;

  mkHostSpecialArgs =
    system:
    sharedSpecialArgs
    // {
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-master = import inputs.nixpkgs-master {
        inherit system;
        config.allowUnfree = true;
      };
    };
}
