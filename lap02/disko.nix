{ lib, ... }:

let
  pool_name = "zroot";
  dataset_base = "local";
  starter_snapshot = "base_install";
in
{
  # UEFI bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = lib.mkDefault "/dev/nvme0n1";
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
            swap = {
              size = "4G";
              content = {
                type = "swap";
                # TODO look into hibernation in nixos
                # https://gist.github.com/mattdenner/befcf099f5cfcc06ea04dcdd4969a221
                # resumeDevice = true;
              };
            };
          };
        };
      };
    };
    zpool = {
      "${pool_name}" = {
        type = "zpool";
        mountpoint = null;
        rootFsOptions = {
          canmount = "off"; # don't mount root FS, mount datasets

          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };

        options = {
          # ashift = "12"; # 4096 sector size (recommended)
          autotrim = "on";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^${pool_name}@${starter_snapshot}$' || zfs snapshot -r ${pool_name}@${starter_snapshot}";

        datasets = {
          "${dataset_base}" = {
            type = "zfs_fs";
            mountpoint = null;
            options.readonly = "on";
          };

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
