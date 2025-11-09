#!/bin/bash

#SETUP mount points
mkdir /mnt/stash
mkdir /mnt/data
chown $USER:$USER /mnt/stash
chown $USER:$USER /mnt/data
echo "## STASH MOUNT" >> /etc/fstab
echo "192.168.1.4:/mnt/stash   /mnt/stash  nfs defaults,user,rw,nofail,noatime 0   0" >> /etc/fstab
echo "## DATA MOUNT SWITCH OUT UUID" >> /etc/fstab
echo "#UUID=468d014d-d953-4b33-846c-f265d710e0d4       /mnt/data       btrfs   defaults        0       0" >> /etc/fstab
#####

## GNOME EXTENSIONS INSTALLATION


# Array of extension IDs to install
extensions=(
    "dash-to-panel@jderose9.github.com"
    "just-perfection-desktop@just-perfection"
    "forge@jmmaranan.com"
    "nightthemeswitcher@romainvigier.fr"
    "gsconnect@andyholmes.github.io"
    "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
    "system-monitor@gnome-shell-extensions.gcampax.github.com"
    "appindicatorsupport@rgcjonas.gmail.com"
)

# Check if gnome-extensions CLI is installed
if ! command -v gnome-extensions &> /dev/null; then
    echo "gnome-extensions tool is not installed. Installing it now."
    sudo apt update && sudo apt install gnome-shell-extensions -y
fi

# Loop through each extension
for extension in "${extensions[@]}"; do
    if gnome-extensions list | grep -q "$extension"; then
        echo "Extension $extension is already installed. Skipping..."
    else
        echo "Installing and enabling extension: $extension"
        gnome-extensions install "$extension"
        gnome-extensions enable "$extension"
    fi
done

echo "All extensions have been checked, installed if necessary, and enabled. Restart GNOME Shell to apply changes."

dconf load  / < ~/.gnome-extension-settings


#### Source the zsh shell
source ~/.zshrc

modprobe zfs

