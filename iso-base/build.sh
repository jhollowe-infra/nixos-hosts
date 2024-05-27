#!/usr/bin/env bash

release=${1:-23.11}
use_flake=${2:-1}
iso_link_name=nixos-custom-base_${release}.iso

if [ $use_flake -eq 1 ]; then
  nix build .#nixosConfigurations.iso-base.config.system.build.isoImage
else
  nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixpkgs=channel:nixos-${release} -I nixos-config=iso.nix
fi

if [ $? -eq 0 ]; then
  # make a link to the built image
  fileName=$(find result/iso -name '*.iso')
  rm -f $iso_link_name ; ln -s $(realpath $fileName) $iso_link_name
fi
