{ modulesPath, lib, pkgs, ... }:

let
  nixos-common = builtins.fetchGit {
    url = "https://github.com/jhollowe-infra/nixos-common.git";
    ref = "main";
  };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
    "${nixos-common}/user"
    "${nixos-common}/env/qemu.nix"
    "${nixos-common}/workloads/interactive.nix"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = true;
    PermitRootLogin = "yes";
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.jhollowe.password = "pass4nix";
  users.users.root.password = "pass4nix";
  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrywzyq3ic8BJ+bJX0gqfmt43ROTwJz2HJFPIiUoeib tmp"
  ];
  users.users.jhollowe.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrywzyq3ic8BJ+bJX0gqfmt43ROTwJz2HJFPIiUoeib tmp"
  ];

  system.stateVersion = "23.11";
}
