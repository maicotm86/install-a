#!/bin/bash

#CAMBIAR EL LIVEUB A ESPAÑOL
clear
echo ""
echo "Sistema en español"
echo ""
echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=es_ES.UTF-8" > /etc/locale.conf
export LANG=es_ES.UTF-8
echo ""
sleep 3

#ACTUALIZACION DE LLAVES Y MIRRORLIST
clear
pacman -Sy archlinux-keyring --noconfirm
clear
pacman -Sy reflector python rsync --noconfirm
sleep 3
clear
echo ""
echo "Actualizando lista de MirrorList"
echo ""
reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
clear
cat /etc/pacman.d/mirrorlist
sleep 3
clear

#DECLARAR USUARIOS Y CONTRASEÑAS EN MODO CLEAN PARA NO FALLAR
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
echo "print devices" | parted | grep /dev/ | awk '{if (NR!=1) {print}}'
echo ''
read -p "Introduce tu disco a instalar Arch: " disco
echo ""
read -p "Introduce la clave Root: " rootpasswd
echo ""
read -p "Introduce Nombre usuario Nuevo: " user
echo ""
read -p "Introduce la clave de $user: " userpasswd
echo ""
read -p "Introduce Nombre del Equipo (host): " hostname
echo ""
read -p "Introduce tu ubicación, Ejemplo (es_PE.UTF-8 / es_MX.UTF-8 / es_AR.UTF-8): " userpais
echo ""
read -p "Introduce la distribucion de tu teclado, Ejemplo (es / latam / us): " teclado
echo ""
echo "Selección de Disco: $disco"
echo ''
echo "USUARIO: $user"
echo ''
echo "CLAVE DE USUARIO: $userpasswd"
echo ''
echo "CLAVE DE ADMINISTRADOR: $rootpasswd"
sleep 4
echo ''

uefi=$( ls /sys/firmware/efi/ | grep -ic efivars )

if [ $uefi == 1 ]
then
	clear
	echo "Sistema UEFI"
	echo ""
#---METODO CON EFI - SWAP - ROOT-----------------------------------
	sgdisk --zap-all ${disco}
	parted ${disco} mklabel gpt
	sgdisk ${disco} -n=1:0:+100M -t=1:ef00
#	sgdisk ${disco} -n=2:0:+4G -t=2:8200
	sgdisk ${disco} -n=2:0:0
	fdisk -l ${disco} > /tmp/partition
	echo ""
	cat /tmp/partition
	sleep 3

	partition="$(cat /tmp/partition | grep /dev/ | awk '{if (NR!=1) {print}}' | sed 's/*//g' | awk -F ' ' '{print $1}')"

	echo $partition | awk -F ' ' '{print $1}' >  boot-efi
#	echo $partition | awk -F ' ' '{print $2}' >  swap-efi
	echo $partition | awk -F ' ' '{print $2}' >  root-efi

	echo ""
	echo "Partición EFI es:"
	cat boot-efi
	echo ""
#	echo "Partición SWAP es:"
#	cat swap-efi
	echo ""
	echo "Partición ROOT es:"
	cat root-efi
	echo ""
	echo "Partición HOME es:"
	cat home-efi
	sleep 3

	clear
	echo ""
	echo "Formateando Particiones"
	echo ""
	mkfs.ext4 $(cat root-efi)
	mount $(cat root-efi) /mnt

	mkdir -p /mnt/home
	mkfs.ext4 $(cat home-efi)
	mount $(cat home-efi) /mnt/home

	mkdir -p /mnt/efi
	mkfs.fat -F 32 $(cat boot-efi)
	mount $(cat boot-efi) /mnt/efi

#	mkswap $(cat swap-efi)
#	swapon $(cat swap-efi)

	clear
	echo ""
	echo "Revise en punto de montaje en MOUNTPOINT"
	echo ""
	lsblk -l
	sleep 3

else
	clear
	echo ""
	echo "Sistema BIOS"
	echo ""

#---METODO CON BIOS - SWAP - ROOT----------------------------
	clear
	echo ""
	echo "Sistema BIOS"
	echo ""
	sgdisk --zap-all ${disco}
	(echo o; echo n; echo p; echo 1; echo ""; echo +200M; echo n; echo p; echo 2; echo ""; echo +2G; eco n; echo p; echo 3; echo ""; echo ""; echo t; echo 2; echo 82; echo a; echo 1; echo w; echo q) | fdisk ${disco}
	fdisk -l ${disco} > /tmp/partition
	cat /tmp/partition
	sleep 3

	partition="$(cat /tmp/partition | grep /dev/ | awk '{if (NR!=1) {print}}' | sed 's/*//g' | awk -F ' ' '{print $1}')"

	echo $partition | awk -F ' ' '{print $1}' >  boot-bios
	echo $partition | awk -F ' ' '{print $2}' >  swap-bios
	echo $partition | awk -F ' ' '{print $3}' >  root-bios

	echo ""
	echo "Partición BOOT es:"
	cat boot-bios
	echo ""
	echo "Partición SWAP es:"
	cat swap-bios
	echo ""
	echo "Partición ROOT es:"
	cat root-bios
	sleep 3

	clear
	echo ""
	echo "Formateando Particiones"
	echo ""
	mkfs.ext4 $(cat root-bios)
	mount $(cat root-bios) /mnt

	mkdir -p /mnt/boot
	mkfs.ext4 $(cat boot-bios)
	mount $(cat boot-bios) /mnt/boot

	mkswap $(cat swap-bios)
	swapon $(cat swap-bios)

	clear
	echo ""
	echo "Revise en punto de montaje en MOUNTPOINT"
	echo ""
	lsblk -l
	sleep 4
	clear

fi

echo ""
echo "Instalando Sistema base"
echo ""
pacstrap /mnt base base-devel reflector python rsync
clear

echo ""
echo "Actualizando lista de MirrorList"
echo ""
arch-chroot /mnt /bin/bash -c "reflector --verbose --latest 15 --sort rate --save /etc/pacman.d/mirrorlist"
clear
cat /mnt/etc/pacman.d/mirrorlist
sleep 3
clear

echo ""
echo "Archivo FSTAB"
echo ""
echo "genfstab -U -p /mnt >> /mnt/etc/fstab"
echo ""

genfstab -U -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
sleep 4
clear

#CONFIGURANDO PACMAN
sed -i 's/#Color/Color/g' /mnt/etc/pacman.conf
sed -i 's/#TotalDownload/TotalDownload/g' /mnt/etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /mnt/etc/pacman.conf

sed -i "37i ILoveCandy" /mnt/etc/pacman.conf

sed -i '93d' /mnt/etc/pacman.conf
sed -i '94d' /mnt/etc/pacman.conf
sed -i "93i [multilib]" /mnt/etc/pacman.conf
sed -i "94i Include = /etc/pacman.d/mirrorlist" /mnt/etc/pacman.conf
clear

#HOST
clear
#NOMBRE DEL COMPUTADOR
echo "$hostname" > /mnt/etc/hostname
echo "127.0.1.1 $hostname.localdomain $hostname" > /mnt/etc/hosts
clear
echo "Hostname: $(cat /mnt/etc/hostname)"
echo ""
echo "Hosts: $(cat /mnt/etc/hosts)"
echo ""
clear

#USUARIO Y ADMIN
arch-chroot /mnt /bin/bash -c "(echo $rootpasswd ; echo $rootpasswd) | passwd root"
#arch-chroot /mnt /bin/bash -c "groupadd wheel"
arch-chroot /mnt /bin/bash -c "useradd -m -g users -G wheel -s /bin/bash $user"
arch-chroot /mnt /bin/bash -c "(echo $userpasswd ; echo $userpasswd) | passwd $user"

sed -i "82c %wheel ALL=(ALL) NOPASSWD: ALL"  /mnt/etc/sudoers

#ACTUALIZACIÓN DE IDIOMA Y ZONA HORARIA
echo ""
echo -e ""
echo -e "\t\t\t| Actualizando Idioma del Sistema |"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
echo -e ""

echo "$userpais UTF-8" > /mnt/etc/locale.gen
arch-chroot /mnt /bin/bash -c "locale-gen"
echo "LANG=$userpais" > /mnt/etc/locale.conf
echo ""
cat /mnt/etc/locale.conf
cat /mnt/etc/locale.gen
sleep 4
echo ""
arch-chroot /mnt /bin/bash -c "export $(cat /mnt/etc/locale.conf)"
export $(cat /mnt/etc/locale.conf)
arch-chroot /mnt /bin/bash -c "sudo -u $user export $(cat /etc/locale.conf)"
export $(cat /mnt/etc/locale.conf)
sleep 3

clear
arch-chroot /mnt /bin/bash -c "pacman -Sy curl --noconfirm"
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/$(curl https://ipapi.co/timezone) /etc/localtime"

#OPCIONAL
echo "KEYMAP="$teclado"" > /mnt/etc/vconsole.conf
cat /mnt/etc/vconsole.conf
clear

arch-chroot /mnt /bin/bash -c "timedatectl set-timezone $(curl https://ipapi.co/timezone)"
arch-chroot /mnt /bin/bash -c "pacman -S ntp --noconfirm"
clear
arch-chroot /mnt /bin/bash -c "ntpd -qg"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
sleep 3

clear

#INSTALACION DEL KERNEL
arch-chroot /mnt /bin/bash -c "pacman -S linux-firmware linux linux-headers mkinitcpio --noconfirm"

#arch-chroot /mnt /bin/bash -c "pacman -S gnome-shell gdm gnome-control-center gnome-backgrounds gnome-tweaks --noconfirm"
#arch-chroot /mnt /bin/bash -c "systemctl enable gdm"

uefi=$( ls /sys/firmware/efi/ | grep -ic efivars )

if [ $uefi == 1 ]
then
clear
arch-chroot /mnt /bin/bash -c "pacman -S grub efibootmgr os-prober dosfstools ntfs-3g --noconfirm"
echo ''
echo 'Instalando EFI System >> bootx64.efi'
arch-chroot /mnt /bin/bash -c 'grub-install --target=x86_64-efi --efi-directory=/efi --removable'
echo ''
echo 'Instalando UEFI System >> grubx64.efi'
arch-chroot /mnt /bin/bash -c 'grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=Arch'
######
sed -i "6iGRUB_CMDLINE_LINUX_DEFAULT="loglevel=3"" /mnt/etc/default/grub
sed -i '7d' /mnt/etc/default/grub
######
echo ''
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
echo ''
echo 'ls -l /mnt/efi'
ls -l /mnt/efi
echo ''
echo 'Lea bien que no tenga ningún error marcado'
echo '> Confirme tener las IMG de linux para el arranque'
echo '> Confirme tener la carpeta de GRUB para el arranque'
sleep 4

else
clear
arch-chroot /mnt /bin/bash -c "pacman -S grub os-prober ntfs-3g --noconfirm"
echo ''
arch-chroot /mnt /bin/bash -c "grub-install --target=i386-pc $disco"

######
sed -i "6iGRUB_CMDLINE_LINUX_DEFAULT="loglevel=3"" /mnt/etc/default/grub
sed -i '7d' /mnt/etc/default/grub
######
echo ''
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
echo ''
echo 'ls -l /mnt/boot'
ls -l /mnt/boot
echo ''
echo 'Lea bien que no tenga ningún error marcado'
echo '> Confirme tener las IMG de linux para el arranque'
echo
fi

#INSTALACION DE SOFTWARE PERSONAL
arch-chroot /mnt /bin/bash -c "pacman -S dhcpcd networkmanager iwd net-tools ifplugd --noconfirm"
#ACTIVAR SERVICIOS
arch-chroot /mnt /bin/bash -c "systemctl enable dhcpcd NetworkManager"

echo "noipv6rs" >> /mnt/etc/dhcpcd.conf
echo "noipv6" >> /mnt/etc/dhcpcd.conf

#INSTALACION DE DRIVERS WIFI
arch-chroot /mnt /bin/bash -c "pacman -S iw wireless_tools wpa_supplicant dialog wireless-regdb --noconfirm"

#INSTALACION DE DRIVERS BLUETOOTH
arch-chroot /mnt /bin/bash -c "pacman -S bluez bluez-utils pulseaudio-bluetooth --noconfirm"

#SHELL
#arch-chroot /mnt /bin/bash -c "pacman -S zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions --noconfirm"
#SH=zsh
#arch-chroot /mnt /bin/bash -c "chsh -s /bin/$SH"
#arch-chroot /mnt /bin/bash -c "chsh -s /usr/bin/$SH $user"
#arch-chroot /mnt /bin/bash -c "chsh -s /bin/$SH $user"

#INSTALACION DE SERVIDOR X
arch-chroot /mnt /bin/bash -c "pacman -S xorg xorg-apps xorg-xinit xorg-twm xorg-xclock --noconfirm"

#UTILIDADES
arch-chroot /mnt /bin/bash -c "pacman -S p7zip unrar zip unzip gzip bzip2 arj lzop git wget neofetch lsb-release xdg-user-dirs android-file-transfer android-tools android-udev msmtp libmtp libcddb gvfs gvfs-afc gvfs-smb gvfs-gphoto2 gvfs-mtp gvfs-goa gvfs-nfs gvfs-google dosfstools jfsutils f2fs-tools btrfs-progs exfat-utils ntfs-3g reiserfsprogs udftools xfsprogs nilfs-utils polkit gpart mtools ffmpeg aom libde265 x265 x264 libmpeg2 xvidcore libtheora libvpx schroedinger sdl gstreamer gst-plugins-bad gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-ugly xine-lib libdvdcss libdvdread dvd+rw-tools lame --noconfirm"
arch-chroot /mnt /bin/bash -c "xdg-user-dirs-update"
clear
echo ""
arch-chroot /mnt /bin/bash -c "ls -l /home/$user"
sleep 5

#AUDIO
arch-chroot /mnt /bin/bash -c "pacman -S pulseaudio pulseaudio-alsa pavucontrol alsa-plugins alsa-utils --noconfirm"

#FONTS (TIPOGRAFIAS)
arch-chroot /mnt /bin/bash -c "pacman -S ttf-dejavu ttf-liberation xorg-fonts-type1 ttf-bitstream-vera gnu-free-fonts ttf-hack ttf-inconsolata --noconfirm"

#NAVEGADOR WEB
#arch-chroot /mnt /bin/bash -c "pacman -S chromium --noconfirm"
#chromium
#opera
#vivaldi

#ESTABLECER FORMATO DE TECLADO
	  clear

      arch-chroot /mnt /bin/bash -c "localectl --no-convert set-x11-keymap "$teclado""
      arch-chroot /mnt /bin/bash -c "setxkbmap -layout "$teclado""

      echo -e 'Section "InputClass"' > /mnt/etc/X11/xorg.conf.d/00-keyboard.conf
      echo -e 'Identifier "system-keyboard"' >> /mnt/etc/X11/xorg.conf.d/00-keyboard.conf
      echo -e 'MatchIsKeyboard "on"' >> /mnt/etc/X11/xorg.conf.d/00-keyboard.conf
      echo -e 'Option "XkbLayout" "'$teclado'"' >> /mnt/etc/X11/xorg.conf.d/00-keyboard.conf
      echo -e 'EndSection' >> /mnt/etc/X11/xorg.conf.d/00-keyboard.conf
      echo ""
      cat /mnt/etc/X11/xorg.conf.d/00-keyboard.conf
      sleep 3
      clear

# INSTALAR YAY
echo "cd && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si --noconfirm && cd && rm -rf yay-bin" | arch-chroot /mnt /bin/bash -c "su $user"
sed -i "82c %wheel ALL=(ALL) ALL"  /mnt/etc/sudoers

case $(systemd-detect-virt) in
        oracle)
            grafica="virtualbox-guest-utils xf86-video-vmware virtualbox-host-modules-arch mesa mesa-libglx"
        ;;
        vmware)
            grafica="xf86-video-vmware xf86-input-vmmouse open-vm-tools net-tools gtkmm mesa mesa-libgl"
        ;;
        qemu)
            grafica="spice-vdagent xf86-video-fbdev mesa mesa-libgl qemu-guest-agent"
        ;;
        kvm)
            grafica="spice-vdagent xf86-video-fbdev mesa mesa-libgl qemu-guest-agent"
        ;;
        microsoft)
            grafica="xf86-video-fbdev mesa-libgl"
        ;;
        xen)
            grafica="xf86-video-fbdev mesa-libgl"
        ;;
        *)
            if (lspci | grep VGA | grep "NVIDIA\|nVidia" &>/dev/null); then
                grafica="xf86-video-nouveau mesa lib32-mesa mesa-vdpau libva-mesa-driver"

            elif (lspci | grep VGA | grep "Radeon R\|R2/R3/R4/R5" &>/dev/null); then
                grafica="xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon mesa-vdpau libva-mesa-driver lib32-mesa-vdpau lib32-libva-mesa-driver libva-vdpau-driver libvdpau-va-gl libva-utils vdpauinfo opencl-mesa clinfo ocl-icd lib32-ocl-icd opencl-headers"

            elif (lspci | grep VGA | grep "ATI\|AMD/ATI" &>/dev/null); then
                grafica="xf86-video-ati mesa lib32-mesa mesa-vdpau libva-mesa-driver lib32-mesa-vdpau lib32-libva-mesa-driver libva-vdpau-driver libvdpau-va-gl libva-utils vdpauinfo opencl-mesa clinfo ocl-icd lib32-ocl-icd opencl-headers"

             elif (lspci | grep VGA | grep "Intel" &>/dev/null); then
                grafica="xf86-video-intel vulkan-intel mesa lib32-mesa intel-media-driver libva-intel-driver libva-vdpau-driver libvdpau-va-gl libva-utils vdpauinfo intel-compute-runtime clinfo ocl-icd lib32-ocl-icd opencl-headers"

             else
                grafica="xf86-video-vesa"

        fi
        ;;
    esac

arch-chroot /mnt /bin/bash -c "pacman -S $grafica --noconfirm --needed"
sleep 3


#DESMONTAR Y REINICIAR
umount -R /mnt
swapoff -a
      clear
      echo ""
      echo "                                   S u s c r i b e t e :  y o u t u b e . c o m / m x h e c t o r v e g a"
      sleep 7
reboot
