{ lib }:
let
  mapAttrsMaybe =
    f: attrs:
    lib.pipe attrs [
      (lib.mapAttrsToList f)
      (builtins.filter (x: x != null))
      builtins.listToAttrs
    ];
in
{
  inherit mapAttrsMaybe;

  forAllDirsWithDefaultNix =
    dir:
    if builtins.pathExists dir then
      lib.pipe dir [
        builtins.readDir
        (mapAttrsMaybe (
          name: type:
          if type == "directory" && builtins.pathExists "${dir}/${name}/default.nix" then
            lib.nameValuePair name "${dir}/${name}"
          else
            null
        ))
      ]
    else
      { };
}
