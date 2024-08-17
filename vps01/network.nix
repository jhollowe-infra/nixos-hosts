{ ... }:

let
  main_v4_ip = "104.153.208.168";
  primary_interface = "ens3";
  ipv6_tunnel_name = "he";
in
{
  networking = {
    hostName = "vps01";
    hostId = "74a9a1ba";
    enableIPv6 = true;
    usePredictableInterfaceNames = true;

    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    defaultGateway = "104.153.208.1";
  };

  networking.interfaces."${primary_interface}" = {
    ipv4 = {
      addresses = [{ address = main_v4_ip; prefixLength = 22; }];
    };
  };

  # IPv6 over IPv4 Hurricane Electric (HE) tunnel
  networking.sits."${ipv6_tunnel_name}" = {
    dev = primary_interface;
    remote = "64.62.134.130";
    ttl = 255;
  };
  networking.interfaces."${ipv6_tunnel_name}" = {
    ipv6 = {
      addresses = [{ address = "2001:470:66:14e::2"; prefixLength = 64; }];
    };
  };
  networking.defaultGateway6 = {
    address = "2001:470:66:14e::1";
    interface = "${ipv6_tunnel_name}";
  };


  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowPing = true;

    # ports exposed by docker override these settings
    # allowedTCPPorts = [ ];
    # allowedUDPPorts = [ ];
  };
}
