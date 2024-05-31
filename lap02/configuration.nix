{ pkgs, ... }:

let
  nixos-common = builtins.fetchGit {
    url = "https://github.com/jhollowe-infra/nixos-common.git";
    ref = "main";
    rev = "71cb6b701b9c4b4a73af04f303dd8bc0ecd8be7f";
  };
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./disko.nix

      ./gui.nix
      ./network.nix
      "${nixos-common}/user/_default.nix"
      "${nixos-common}/workloads/interactive.nix"
      "${nixos-common}/env/ny_time.nix"
      "${nixos-common}/env/en_us_utf8.nix"
    ];

  users.users.jhollowe.password = "password";

  # UEFI bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vscode
  ];
  # Install firefox.
  programs.firefox.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
