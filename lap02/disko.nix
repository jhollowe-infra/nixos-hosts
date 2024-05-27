{ lib, ... }:

let
  pool_name = "zroot";
  dataset_base = "local";
  starter_snapshot = "base_install";
in
{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = lib.mkDefault "/dev/disk/by-id/nvme-INTEL_SSDPEKKF256G8L_BTHH84100C6N256B";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = pool_name;
              };
            };
            # swap = {
            #   resumeDevice = true;
            # };
          };
        };
      };
    };
    zpool = {
      "${pool_name}" = {
        type = "zpool";
        rootFsOptions = {
          canmount = "off"; # don't mount root FS, mount datasets

          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };

        mountpoint = null;
        options = {
          # ashift = "12"; # 4096 sector size (recommended)
          autotrim = "on";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^${pool_name}@${starter_snapshot}$' || zfs snapshot -R ${pool_name}@${starter_snapshot}";

        datasets = {
          "${dataset_base}/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "/";
            options."com.sun:auto-snapshot" = "true";
          };

          "${dataset_base}/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "/home";
            options."com.sun:auto-snapshot" = "true";
          };

          "${dataset_base}/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "/nix";
            options."com.sun:auto-snapshot" = "false";
          };
        };
      };
    };
  };
}
