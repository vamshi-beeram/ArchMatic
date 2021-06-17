echo "Setting up language, locale and clock"
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
printf '%s' 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo vneeha > /etc/hostname
printf '%s \n %s \n %s' '127.0.0.1 localhost' '::1   localhost' '127.0.0.1  vneeha.localdomain vneeha' >> /etc/hosts

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
