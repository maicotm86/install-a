# pacstrap
#pacstrap -i /mnt base base-devel linux-lts linux-lts-headers linux-firmware bash-completion vim git curl wget
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
#mkinitcpio -p linux-lts
#pacman -S grub intel-ucode os-prober networkmanager xdg-user-dirs --noconfirm
#grub-install --target=i386-pc --recheck /dev/sda
#grub-mkconfig -o /boot/grub/grub.cfg
#systemctl enable NetworkManager.service

# after reboot
#useradd -m -g users -G sys,network,power,wheel,audio,video,storage -s /bin/bash maico
#passwd maico
#sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

#sudo pacman -S xorg-server xorg-xwininfo xorg-xinit xorg-xprop xorg-xdpyinfo xorg-xbacklight ttf-inconsolata ttf-linux-libertine arandr bc calcurse xcompmgr dosfstools libnotify dunst exfat-utils sxiv xwallpaper ffmpeg gnome-keyring neovim mpd mpc mpv ncmpcpp noto-fonts-emoji ntfs-3g alsa-utils maim socat tmux unclutter unrar unzip lynx xcape xclip xdotool youtube-dl zathura zathura-pdf-mupdf poppler mediainfo atool fzf highlight zsh-syntax-highlighting slock xf86-input-libinput network-manager-applet volumeicon xf86-video-intel xf86-input-libinput python-pip --noconfirm


#yay -S gtk-theme-arc-gruvbox-git brave-bin sc-im task-spooler simple-mtpfs-git mutt-wizard-git 


#yay -S lf-git gtk-theme-arc-gruvbox-git brave-bin sc-im task-spooler simple-mtpfs-git mutt-wizard-git 


#sudo pacman -S archlinux-keyring xorg-server xorg-apps xorg-xinit xf86-input-libinput xf86-input-mouse xf86-input-synaptics xf86-input-keyboard xf86-video-intel pulseaudio pulseaudio-alsa i3-gaps i3lock i3blocks dmenu ntfs-3g p7zip unzip unrar xfce4-settings networkmanager network-manager-applet compton libreoffice-still-pt-br imagemagic volumeicon shellcheck feh nemo nemo-fileroller nemo-preview xfce4-appfinder xfce4-power-manager xfce4-notifyd vulkan-intel xfwm4 xfwm4-themes terminator lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings python-pip qbittorrent simplescreenrecorder xcursor-simpleandsoft adobe-source-sans-pro-fonts awesome-terminal-fonts noto-fonts ttf-bitstream-vera ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-liberation ttf-roboto ttf-ubuntu-font-family arc-icon-theme adapta-gtk-theme arc-gtk-theme dconf-editor htop tree youtube-dl zsh zsh-completions zsh-syntax-highlighting --noconfirm 

#localectl set-keymap br-abnt2
#localectl set-x11-keymap br
#systemctl enable lightdm-service
