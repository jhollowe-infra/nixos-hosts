#!/usr/bin/env bash

host=${1:-test}

# nixos-anywhere is pinned by flake.lock (inputs.nixos-anywhere)
nix run --show-trace --inputs-from . nixos-anywhere -- --flake ".#${host}" --vm-test
