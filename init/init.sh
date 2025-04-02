#!/bin/sh

# Add symlink to persistant .ssh directory
if [ -d ~/.ssh ]; then
    mv ~/.ssh ~/.ssh."$(date +%s)"
fi
ln -s work/.init/.ssh ~/.ssh
