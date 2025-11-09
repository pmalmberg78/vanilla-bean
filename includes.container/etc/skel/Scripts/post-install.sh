#!/bin/bash

#SETUP mount points
pkexec mkdir /mnt/stash
pkexec mkdir /mnt/data
pkexec chown $USER:$USER /mnt/stash
pkexec chown $USER:$USER /mnt/data
pkexec echo "## STASH MOUNT" >> /etc/fstab
pkexec echo "192.168.1.4:/mnt/stash   /mnt/stash  nfs defaults,user,rw,nofail,noatime 0   0" >> /etc/fstab
pkexec echo "## DATA MOUNT SWITCH OUT UUID" >> /etc/fstab
pkexec echo "#UUID=468d014d-d953-4b33-846c-f265d710e0d4       /mnt/data       btrfs   defaults        0       0" >> /etc/fstab
#####

## GNOME EXTENSIONS INSTALLATION


# Array of extension IDs to install
extensions=( "dash-to-panel@jderose9.github.com" "just-perfection-desktop@just-perfection" "forge@jmmaranan.com" "nightthemeswitcher@romainvigier.fr" "gsconnect@andyholmes.github.io" "auto-move-windows@gnome-shell-extensions.gcampax.github.com" "system-monitor@gnome-shell-extensions.gcampax.github.com" "appindicatorsupport@rgcjonas.gmail.com" )

#Install and enable the extensions
for i in "${extensions[@]}"
do
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=${i}" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O ${i}.zip "https://extensions.gnome.org/download-extension/${i}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${i}; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${i}
    fi
    gnome-extensions enable ${i}
    rm ${EXTENSION_ID}.zip
done


echo "All extensions have been checked, installed if necessary, and enabled. Restart GNOME Shell to apply changes."

# Load the extension settings
dconf load /org/gnome/shell/extensions/ < ./gnome-extension-settings


### Install ohmyposh
curl -s https://ohmyposh.dev/install.sh | bash -s


#### Source the zsh shell
source ~/.zshrc

modprobe zfs

