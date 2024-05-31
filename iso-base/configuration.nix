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

  services.getty.helpLine = lib.mkForce ''
    the default password for root is `password` and password SSH is enabled
    THIS IS INSECURE; DO NOT USE IN PRODUCTION!

    If you need a wireless connection, type
    `sudo systemctl start wpa_supplicant` and configure a
    network using `wpa_cli`. See the NixOS manual for details.
  '';

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
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9KL65SQ9oyX6U7iIPqDDU4DB4PSoE5AWYfkIk8wyC4BzvaFlZhiBcT03uKEDiTRemeJdqilBLNtsGg54eOiZ1uFYssquMYc5iSAz1t2s5Y353hlYnEblUpnQbC35vrnVbLO5CVcKR5cajqBmjOraPbPq8EuwPR5i5cLzFQYLcjIG+suG0wlBt/SVKV5lv236x0PUB4qiNko9NWbOZ1DMRTdrMtkmlRfzikL9v6/2+aTFxq6/iR4pbNf56dQ81STgOAc9FHiue7cuva+GeCJS2b28JRaUydCMqBfs2coSKznzBc1ZWRcEztDJSMdASg0Mhldm6Cp0cIpCaUvQ7zmUd/UiH+9T3BdADt0+JSXrk/JTy8vVKVRZ1SVSm6gkEr7lUT+pUhzc8ZDgT5AdiheYJ5et6/7B2ecMVSU0witmYoL/5Qwa3L+OEWTXSjRUhcLiKQrLJbR+fIumP+kV+QE/dPa9RmOUE2zLQlsb9SU9tqPNNDhCCwSCzpKg1re5pFdE2HcvfYCNHMybhrB4AtNcCwm8A9AgX9aQl+25qBfgFEWUWXiUmLV6uFZLjQxqPRVwEQFz/eFnoRfpj1MZ+whsY+sZnXB2l7v9dAVCe+0e/2TYL0NV5NxGQWgYsSSYOr2nUDcrm2J+mf4a+9ZdYZRTcaD1EU2CZ1s/XDlmu1Ym2cw=="
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCn6oQL/Il1j9UANp7k5aCSYWXmg30hb2a/ZYGrxG1VsaS8e3zUVTKCV0DvrGRm4D9IwM6GY5rOSD/DWG2dTiG7Lf28O2Ls/BRdhEu6yzH5fibds8gpRIWYPbr4npnVz74z1cHSUAxJmgMRNBuLJWpKrsP4nEUHzYo8o5xJt6OXdBycsKwGfSUuDM+yq6SFBUwjGYmD7ZPewUgYi46VKA2c3QqMsX/dY1o6pw9Ev4bxEgKEpyUmPWZ6iN2aeKGIStwoAl9oZuNN6K1pgl0W0mL6PpQvzTUuK2Ku6TEa9MNNwDddFsCkYkp3RGOS3nK62rCc7xZqt3e50PIyjsnNG8xoOy2Db2PJlvw0yS1krri9Dd1m4Ras9T/UOrkwz3UOws4VH+1O36VyVnNc4v5t+TXwHqzBUZD3hVFn4lhF1B1l6fVlgkEa/XU1cGyFXvKhQcL648BvFcyUtIzGiuQ5kgPxNOj0rNntGj2+B2p7meS2R8ezpUHlk+TsldO8jyRzag9LK8VCoKyFDw29TeJ9ll6n20RNMQHSijq0zhYOPSWY9Zs/60osacsinVdWgOowR4NVTxU9ZOSJYbEyiOKQSmYICD0K6f34VcbvRX1vekE1bFKMeM97O9FUfYID6nYPEhplINr+uSxNGX1JV6BGvSqgskKHstOTpwc8OVuaAwzRZQ=="
      ];
    };
  };
}
