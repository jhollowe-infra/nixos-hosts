{ nixos-common, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./disko.nix
      ./network.nix

      nixos-common.nixosModules.user
      nixos-common.nixosModules.workloads-interactive
      nixos-common.nixosModules.workloads-ssh
      nixos-common.nixosModules.env-ny-time
      nixos-common.nixosModules.env-en-us-utf8
      nixos-common.nixosModules.fs-zram-swap
    ];

  # users.users.jhollowe.password = "areallygreatpassword";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
