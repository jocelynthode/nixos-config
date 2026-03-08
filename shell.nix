{
  sources ? import ./npins,
}:
let
  system = builtins.currentSystem or "x86_64-linux";
  pkgs = import sources.nixpkgs { inherit system; };

  treefmtNix = import sources.treefmt-nix;
  gitHooks = import sources.git-hooks-nix;

  treefmtConfig = {
    projectRootFile = "default.nix";
    programs = {
      nixfmt.enable = true;
      deadnix.enable = true;
      statix = {
        enable = true;
        disabled-lints = [ "manual_inherit_from" ];
      };
      prettier.enable = true;
      shfmt.enable = true;
    };
    settings.formatter.prettier.excludes = [ "secrets/**" ];
    settings.global.excludes = [ "npins/**" ];
  };

  treefmtWrapper = treefmtNix.mkWrapper pkgs treefmtConfig;

  preCommitCheck = gitHooks.run {
    src = ./.;
    hooks = {
      actionlint.enable = true;
      treefmt = {
        enable = true;
        package = treefmtWrapper;
      };
    };
    package = pkgs.prek;
  };
in
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.git
    pkgs.sops
    pkgs.ssh-to-age
    pkgs.disko
    pkgs.nixos-anywhere
    treefmtWrapper
  ]
  ++ preCommitCheck.enabledPackages;

  shellHook = preCommitCheck.shellHook;
}
