#!/bin/sh

# Add symlink to persistent .ssh directory
if [ -d ~/.ssh ]; then
    mv ~/.ssh ~/.ssh."$(date +%s)"
fi
ln -s work/.init/.ssh ~/.ssh
