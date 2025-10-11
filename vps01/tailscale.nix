{ config, pkgs, ... }:
let
  auth_key = "tskey-auth-asdf-asdf";
in
{
  config = {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      # extraSetFlags = [ "--advertise-exit-node" ];
      useRoutingFeatures = "server";
    };
  };
}
