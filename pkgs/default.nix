{
  pkgs ? null,
  vimPlugins ? null,
}:
let
  mapAttrsMaybe =
    f: attrs:
    let
      names = builtins.attrNames attrs;
      mapped = builtins.filter (x: x != null) (map (name: f name attrs.${name}) names);
    in
    builtins.listToAttrs mapped;

  forAllPackages =
    dir:
    if builtins.pathExists dir then
      mapAttrsMaybe (
        name: type:
        if type == "directory" && builtins.pathExists "${dir}/${name}/default.nix" then
          {
            inherit name;
            value = pkgs.callPackage "${dir}/${name}" { };
          }
        else
          null
      ) (builtins.readDir dir)
    else
      { };

  corePackages = forAllPackages ./core;
  vimPluginPackages = forAllPackages ./vimPlugins;
  vimPluginsBase = if vimPlugins == null then { } else vimPlugins;
in
corePackages
// {
  vimPlugins = vimPluginsBase // vimPluginPackages;
}
