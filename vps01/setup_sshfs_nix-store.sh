
mkdir /mnt/disk
mount /dev/vda1 /mnt/disk
mount -B /mnt/disk/nix/store /nix/store

nix-channel --update
nix-shell -p sshfs

mkdir /mnt/remote-nix-store
sshfs root@vps.johnhollowell.com:/home/jhollowe/remote-nix-store /mnt/remote-nix-store
mount -B /mnt/remote-nix-store /nix/store
