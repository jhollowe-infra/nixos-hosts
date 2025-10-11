{ config, pkgs, ... }:
let
  auth_key = "tskey-auth-asdf-asdf";
in
{
  config = {
    virtualisation.docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      enable = true;
    };
  };
}
