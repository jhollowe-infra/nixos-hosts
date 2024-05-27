{ lib, ... }:
let
  nixos-common = builtins.fetchGit {
    url = "https://github.com/jhollowe-infra/nixos-common.git";
    ref = "main";
    rev = "a62bd558e56243e1bf051b4fee1b72891dd560da";
  };
in
{
  imports = [
    "${nixos-common}/workloads/diag.nix"
    "${nixos-common}/workloads/deep_diag.nix"
  ];

  # use zstd compression for the ISO image
  isoImage.squashfsCompression = "zstd -Xcompression-level 19";

  # enable "experimental" features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # enable SSH and allow pretty much any type of connection
  services.openssh = {
    settings = {
      PermitRootLogin = "yes";
      KbdInteractiveAuthentication = true;
      PasswordAuthentication = true;
    };
    extraConfig = ''
      PubkeyAuthentication yes
      PermitEmptyPasswords yes
      HostbasedAuthentication yes
    '';
  };

  # make the root user super accessible
  users.users = {
    root = {
      password = "password";
      hashedPassword = lib.mkForce null;
      hashedPasswordFile = lib.mkForce null;
      initialHashedPassword = lib.mkForce null;
      initialPassword = lib.mkForce null;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILjyoZakOhGPmzJx3zH8vEizvfMbM5Aa8iTuP5VAk+QK 3:jhollowe@JOHN-DESKTOP.internal.johnhollowell.com"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDr9lnRhfAPce+yYxNMIL9EWa7dOl2u0vjq5qVM5P17i jhollowe@JOHN-LAPTOP.internal.johnhollowell.com"
      ];
    };

  };
}
