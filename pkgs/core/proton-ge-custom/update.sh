#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

version=$(curl https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | jq -r '.tag_name')

update-source-version --file ./default.nix proton-ge-custom "$version"

