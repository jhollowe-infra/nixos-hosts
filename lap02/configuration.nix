{ nixos-common, nixos-hardware, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./disko.nix
      ./network.nix
      nixos-hardware.nixosModules.lenovo-thinkpad-t480s

      nixos-common.nixosModules.desktop
      nixos-common.nixosModules.desktop-touchpad
      nixos-common.nixosModules.security-gpg-agent
      nixos-common.nixosModules.fs-nix-gc
      nixos-common.nixosModules.fs-zfs-auto-maintenance
      nixos-common.nixosModules.user
      nixos-common.nixosModules.workloads-interactive
      nixos-common.nixosModules.workloads-ssh
      nixos-common.nixosModules.env-ny-time
      nixos-common.nixosModules.env-en-us-utf8
    ];

  users.users.jhollowe.password = "password";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vscode
  ];
  # Install firefox.
  programs.firefox.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
