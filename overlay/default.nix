_: final: prev:
{ }
// import ../pkgs {
  pkgs = final;
  inherit (prev) vimPlugins home-assistant-custom-components;
}
// {
  # nono with the NixOS ELF-dependency resolution fix from
  # https://github.com/nolabs-ai/nono/pull/1650 (closes #1649): resolve
  # RPATH-less `NEEDED` entries via the binary's ELF interpreter directory.
  # Remove once the fix lands in a nixpkgs nono release.
  nono = prev.nono.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [ ./nono/elf-interpreter-fallback.patch ];
  });
}
