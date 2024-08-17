{ lib, ... }:

let
  pool_name = "zroot";
  dataset_base = "vps01";
  starter_snapshot = "base_install";
in
{
  # Legacy/BIOS bootloader (grub)
  boot.loader.grub.enable = true;
  boot.zfs.devNodes = "/dev/disk/by-uuid"; # for some reason vda is not added to the default /dev/disk/by-id

  disko.devices = {
    disk = {
      primary = {
        type = "disk";
        device = lib.mkDefault "/dev/vda";

        # this is used for the building of a disk image to write to the host since it does not have enough memory for nixos-anywhere
        imageSize = "50G";

        content = {
          type = "gpt";
          partitions = {
            # GRUB legacy/BIOS boot partition
            grub = {
              size = "1M";
              type = "EF02";
              priority = 1;
            };

            # grub doesn't like booting from ZFS for some reason; this fixes that
            boot = {
              size = "1G";
              priority = 2;
              content = {
                type = "filesystem";
                format = "ext4";
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
              size = "2G";
              content = {
                type = "swap";
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
            options.mountpoint = "none";
            options.readonly = "on";
          };

          "${dataset_base}/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "/";
            options."com.sun:auto-snapshot" = "true";
            options.readonly = "off"; #prevent inheriting from parent
          };

          "${dataset_base}/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "/home";
            options."com.sun:auto-snapshot" = "true";
            options.readonly = "off"; #prevent inheriting from parent
          };

          "${dataset_base}/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "/nix";
            options."com.sun:auto-snapshot" = "false";
            options.readonly = "off"; #prevent inheriting from parent
          };
        };
      };
    };
  };
}
