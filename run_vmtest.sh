#!/usr/bin/env bash

host=${1:-test}

nix run github:nix-community/nixos-anywhere --show-trace -- --flake .#${host} --vm-test
