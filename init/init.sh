#!/bin/sh

# Add symlink to persistant .ssh directory
if [ -d ~/.ssh ]; then
    mv ~/.ssh ~/.ssh."$(date +%s)"
fi
ln -s work/.init/.ssh ~/.ssh

# Install FR locales
sudo locale-gen fr_FR.UTF-8
sudo update-locale
