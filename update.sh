#!/usr/bin/env bash
set -euo pipefail
set -x

git pull

if [ -z "${OVERRIDE:-}" ]
then
    sudo nixos-rebuild --flake . switch
else
    sudo nixos-rebuild --flake . --override-input nixpkgs ../nixpkgs --no-write-lock-file switch
fi
