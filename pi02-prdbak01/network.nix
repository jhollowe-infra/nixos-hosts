# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running nixos-help).

{ config, pkgs, ... }:

{
  networking = {
    hostName = "pi02-prdbak01";
    # domain = "home.internal.johnhollowell.com";
    hostId = "21f0a55d";
    enableIPv6 = false;
    usePredictableInterfaceNames = true;

  };

  # Firewall settings
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
