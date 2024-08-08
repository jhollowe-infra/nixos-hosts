# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nixos-common = builtins.fetchGit {
    url = "https://github.com/jhollowe-infra/nixos-common.git";
    ref = "main";
    rev = "a62bd558e56243e1bf051b4fee1b72891dd560da";
  };
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./network.nix

      "${nixos-common}/user"
      "${nixos-common}/workloads/interactive.nix"
      "${nixos-common}/workloads/ssh.nix"
      "${nixos-common}/env/ny_time.nix"
      "${nixos-common}/env/en_us_utf8.nix"
    ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;


  # # Set your time zone.
  # time.timeZone = "America/New_York";

  # # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    docker-client # containers
    # nixd nixpkgs-fmt # VS Code IDE extension language-server and formatting
    nixpkgs-fmt # VS Code IDE extension language-server and formatting
    libraspberrypi # raspberry pi util commands
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # enable a ld shim which allows non-nix compiled binaries to use nix-organized dynamic libraries
  # e.g. vscode remote
  # programs.nix-ld.enable = true;
  # environment.variables = {
  #   NIX_LD = pkgs.stdenv.cc.bintools.dynamicLinker;
  #   NIX_LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";
  # };

  # allow VSCode SSH remote to work properly
  # services.vscode-server.enable = true;

  # virtualisation.podman.dockerSocket.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
