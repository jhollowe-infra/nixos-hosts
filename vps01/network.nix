{ ... }:

{
  networking = {
    hostName = "vps01";
    hostId = "74a9a1ba";
    enableIPv6 = false;
    # usePredictableInterfaceNames = true;

    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    defaultGateway = "104.153.208.1";
  };

  networking.interfaces."ens3" = {
    ipv4 = {
      addresses = [{ address = "104.153.208.168"; prefixLength = 30; }];
    };
  };

  networking.useDHCP = false;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowPing = true;

    # ports exposed by docker override these settings
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };
}
