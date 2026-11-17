#!/usr/bin/env bash

host=${1:-$(hostname)}

nixos-rebuild build --flake ".#${host}" --show-trace
