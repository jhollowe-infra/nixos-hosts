{ pkgs, ... }:

let
  nixos-common = builtins.fetchGit {
    url = "https://github.com/jhollowe-infra/nixos-common.git";
    ref = "main";
    rev = "b2da754603d7b53b3fc245a17322d6688755aa87";
  };
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./disko.nix
      ./network.nix

      ./gui.nix
      "${nixos-common}/user"
      "${nixos-common}/workloads/interactive.nix"
      "${nixos-common}/workloads/ssh.nix"
      "${nixos-common}/env/ny_time.nix"
      "${nixos-common}/env/en_us_utf8.nix"
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
