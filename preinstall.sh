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
echo "\n please enter swap partition"
read SPART
echo "\n please enter root partition"
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

echo "Setting up language, locale and clock"
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
nano /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo vneeha > /etc/hostname
echo "127.0.0.1 localhost
::1   localhost
127.0.0.1   vneeha.localdomain vneeha" >> /etc/hosts

echo "--------------------------------------"
echo "--      Set Password for Root       --"
echo "--------------------------------------"
echo "Enter password for root user: "
passwd


echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"
systemctl enable NetworkManager

echo "Bootloader"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
exit

