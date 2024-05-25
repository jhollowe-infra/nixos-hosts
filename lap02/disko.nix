{ lib, ... }:
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
                pool = "zroot";
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
      zroot = {
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
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

        datasets = {
          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "/";
            options."com.sun:auto-snapshot" = "true";
          };

          "local/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "/home";
            options."com.sun:auto-snapshot" = "true";
          };

          "local/nix" = {
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
