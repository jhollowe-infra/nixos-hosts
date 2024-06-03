#!/usr/bin/env bash

# TODO check if an existing key is available to use to add new key

# TODO generate key from host SSH key(s)
local_age_key_id=$(cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age')

# TODO update all secrets with new key
