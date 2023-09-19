{
  config,
  pkgs,
  lib,
  ...
}: {
  boot.supportedFilesystems = ["bcachefs" "btrfs" "vfat"];
  environment.systemPackages = with pkgs; [
    neovim
    git
    fish
    (writeShellScriptBin "mount-btrfs" ''      #quick script, should make more dynamic later
           if [[ "$0" =~ nvme ]]; then
             DATA_DRIVE="$A"p2;
             BOOT_DRIVE="$A"p1;
             echo "mount -o compress=zstd,subvol=root "/dev/$DATA_DRIVE" /mnt";
             echo "mkdir /mnt/{home,nix}";
             echo "mount -o compress=zstd,subvol=home /dev/$DATA_DRIVE /mnt/home";
             echo "mount -o compress=zstd,noatime,subvol=nix /dev/$DATA_DRIVE /mnt/nix";

             echo "mkdir /mnt/boot";
             echo "mount /dev/$BOOT_DRIVE /mnt/boot";

           fi
    '')
  ];
  # kernelPackages already defined in installation-cd-minimal-new-kernel-no-zfs.nix
  boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_testing_bcachefs;
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
