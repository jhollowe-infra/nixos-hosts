# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, pkgs, ... }:

let
  nixos-common = builtins.fetchGit {
    url = "https://github.com/jhollowe-infra/nixos-common.git";
    ref = "main";
    rev = "5a64ff89e68de9f089395a01b97733c293431658";
  };
in
{
  imports = [
    # # Include the results of the hardware scan.
    # ./hardware-configuration.nix
    # ./network.nix

    "${nixos-common}/user"
    "${nixos-common}/workloads/interactive.nix"
    "${nixos-common}/workloads/ssh.nix"
    "${nixos-common}/env/ny_time.nix"
    "${nixos-common}/env/en_us_utf8.nix"
  ];

  wsl.enable = true;
  wsl.defaultUser = "jhollowe";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}