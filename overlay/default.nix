_: final: prev:
{ }
// import ../pkgs {
  pkgs = final;
  inherit (prev) vimPlugins;
}
