#!/usr/bin/env bash

host=${1:-$(hostname)}

sudo nixos-rebuild build --flake .#${host} --impure --show-trace
