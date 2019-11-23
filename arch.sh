# pacstrap
#pacstrap -i /mnt base base-devel linux linux-firmware linux-headers bash-completion vim git curl wget
#genfstab -U /mnt >> /mnt/etc/fstab

#loadkeys br-abnt2
#sed -i 's/#Color/Color/' /etc/pacman.conf
#sed -i 's/#TotalDownload/TotalDownload\nILoveCandy/' /etc/pacman.conf
#timedatectl set-ntp true
#ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
#sed -i 's/#pt_BR.UTF-8/pt_BR.UTF-8/' /etc/locale.gen
#echo 'LANG=pt_BR.UTF-8' > /etc/locale.conf
#locale-gen
#echo 'KEYMAP=br-abnt2' > /etc/vconsole.conf
#echo 'arch' > /etc/hostname
#echo -e '127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tarch.linux\tarch\n' > /etc/hosts
#mkinitcpio -p linux
#pacman -S grub intel-ucode --noconfirm
#grub-install --target=i386-pc --recheck /dev/sda
#pacman -S os-prober --noconfirm
#grub-mkconfig -o /boot/grub/grub.cfg
#pacman -S dhcpcd --noconfirm
#systemctl enable dhcpcd

# after reboot
#useradd -m -g users -G sys,network,power,wheel,audio,video,storage -s /bin/bash maico
#passwd maico
#sed -i 's/# %wheel/%wheel/' /etc/sudores
# exit
sudo pacman -S archlinux-keyring xorg-server xorg-apps xorg-xinit xf86-input-libinput xf86-input-mouse xf86-input-synaptics xf86-input-keyboard xf86-video-intel pulseaudio pulseaudio-alsa i3-gaps i3lock i3blocks dmenu ntfs-3g p7zip unzip unrar xfce4-settings termite compton volumeicon feh nemo nemo-fileroller nemo-preview xfce4-appfinder xfce4-power-manager lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings python-pip --noconfirm 

localectl set-keymap br-abnt2
localectl set-x11-keymap br

