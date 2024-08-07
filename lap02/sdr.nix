{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Hardware
    rtl-sdr
    kalibrate-rtl # use GSM signals to calibrate SDR

    # General SDR Apps
    urh
    gnuradio

    # Specific Protocol Apps
    gnss-sdr

    # Basic SDR Listening Apps
    sdrpp
    sdrangel
    # gqrx-portaudio
    # gqrx-gr-audio
    gqrx
    cubicsdr
    qradiolink
  ];

  # Sets up permissions for "plugdev" group to have non-root access to the SDR dongle(s)
  hardware.rtl-sdr.enable = true;
}
