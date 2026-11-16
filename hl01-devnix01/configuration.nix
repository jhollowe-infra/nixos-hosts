{ nixos-common, modulesPath, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
    nixos-common.nixosModules.user
    nixos-common.nixosModules.env-qemu
    nixos-common.nixosModules.workloads-interactive
  ];

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # use grub for BIOS and UEFI dual support
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = true;
    PermitRootLogin = "yes";
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.jhollowe.password = "password";
  users.users.root.password = "password";
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
