# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running nixos-help).

{ config, pkgs, ... }:

let
  vars = import ./vars.nix;
in
{
  networking = {
    hostName = "pi04-prdradio01";
    domain = "home.internal.johnhollowell.com";
    hostId = "3081613c";
    enableIPv6 = false;
    usePredictableInterfaceNames = true;

    # nameservers = [ "10.10.0.1" ];
    # timeServers = [ "time.johnhollowell.com" ];
    # defaultGateway = "10.10.0.1";
  };

  # pi 4
  # networking.interfaces."eth0" = {
  #   ipv4 = {
  #     addresses = [{ address = "10.10.0.8"; prefixLength = 16; }];
  #   };
  # };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowPing = true;

    # ports exposed by docker override these settings
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = true;
}
