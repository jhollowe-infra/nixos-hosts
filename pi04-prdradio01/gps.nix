{ config, pkgs, ... }:

let
  listenerPort = 9999;
in
{
  config = {
    environment.systemPackages = with pkgs; [
      gpsd
    ];

    networking.firewall = {
      allowedTCPPorts = [
        listenerPort # allow phone to send GPS messages into GPSd
        config.services.gpsd.port
      ];
    };

    services.gpsd = {
      enable = true;
      readonly = false; # allows GPSd to configure the reciever(s) to get better performance
      listenany = true;

      devices = [
        "/dev/serial/by-id/usb-u-blox_AG_-_www.u-blox.com_u-blox_GNSS_receiver-if00" # USB GPS device
        "udp://*:${toString listenerPort}" # allow other devices (phones) to send GPS sentence
      ];
    };
  };
}
