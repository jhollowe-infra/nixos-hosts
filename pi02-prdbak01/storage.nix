{ config, pkgs, ... }:

{
  boot.supportedFilesystems = [ "zfs" ];

  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "monthly";

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  boot.zfs.extraPools = [ "hindenburg" ];
}
