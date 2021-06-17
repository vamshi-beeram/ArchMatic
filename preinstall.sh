#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo "-------------------------------------------------"
echo "Setting timedatectl"
echo "-------------------------------------------------"
timedatectl set-ntp true

echo "-------------------------------------------------"
echo "-------select your disk to format----------------"
echo "-------------------------------------------------"
fdisk -l
echo "Please enter disk: (example /dev/sda)"
read DISK
echo "--------------------------------------"
echo -e "\nPartitioning disk...\n"
echo "--------------------------------------"

cfdisk ${DISK}

fdisk -l
echo "please enter boot partition"
read BPART
echo "please enter swap partition"
read SPART
echo "please enter root partition"
read RPART

echo "Formatting partitions"
mkfs.fat -F32 ${BPART}
mkfs.ext4 ${RPART}
mkswap ${SPART}
swapon ${SPART}

echo "--------------------------------------"
echo "-- Mounting Partitions       --"
echo "--------------------------------------"
mount ${RPART} /mnt
mkdir /mnt/boot
mount ${BPART} /mnt/boot

echo "--------------------------------------"
echo "-- Arch Install on Main Drive       --"
echo "--------------------------------------"
pacstrap /mnt base base-devel linux-lts linux-firmware util-linux grub efibootmgr os-prober vim networkmanager nano sudo --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
