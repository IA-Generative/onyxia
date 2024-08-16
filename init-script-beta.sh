#!/bin/bash

# Install vscode extension
code-server --install-extension privy.privy-vscode
# Add privy conf to vscode
jq '. + {
  "privy.providerBaseUrl": "https://ollama.c1.cloud-pi-native.com/",
  "privy.autocomplete.model": "deepseek-coder:1.3b-base",
  "privy.model": "custom",
  "privy.customModel": "gemma2:27b"
}' /home/onyxia/.local/share/code-server/User/settings.json > /home/onyxia/.local/share/code-server/User/settings_tmp.json
mv /home/onyxia/.local/share/code-server/User/settings_tmp.json /home/onyxia/.local/share/code-server/User/settings.json

if [ ! -e "/home/onyxia/work/restore_backup.sh" ] ;then
  cat <<'EOT' >/home/onyxia/work/restore_backup.sh
#!/bin/bash

# Define backup directory
BACKUP_DIR="/home/onyxia/work/backup"

# Get the last backup directory
LAST_BACKUP=$(ls -1t $BACKUP_DIR | head -n 1)
BACKUP_SUBDIR="$BACKUP_DIR/$LAST_BACKUP"

# Restore files and directories
#VSCode settings
#VSCODE_SETTINGS_DIR="/home/onyxia/.config/Code/User"
#if [ -d "$VSCODE_SETTINGS_DIR" ]; then
    tar -xzf "$BACKUP_SUBDIR/files.tar.gz" -C /
    #"$VSCODE_SETTINGS_DIR"
#fi

# Restore frozen Python packages
#pip install -r "$BACKUP_SUBDIR/requirements.txt"

# Restore apt packages
sudo apt update
xargs -a "/home/onyxia/work/apt_requirements.txt" sudo apt-get install -y

EOT

  cat <<'EOT' >/home/onyxia/work/backup_script.sh
#!/bin/bash

while true ;do
# Define backup directory
BACKUP_DIR="/home/onyxia/work/backup"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_SUBDIR="$BACKUP_DIR/$TIMESTAMP"

# Create backup directory
mkdir -p $BACKUP_SUBDIR

# Backup files and directories
filesList="/home/onyxia/.ssh
/home/onyxia/.config
/home/onyxia/.local/share/code-server"

echo "${filesList}" |grep . |\
 cpio -ov --format=ustar |\
 gzip >"$BACKUP_SUBDIR/files.tar.gz"

# Backup frozen Python packages
#pip freeze > "$BACKUP_SUBDIR/requirements.txt"

# Optional: Cleanup older backups, keeping only the last 10
cd $BACKUP_DIR && ls -1t | tail -n +11 | xargs rm -rf

sleep 90
done
EOT

  chmod +x /home/onyxia/work/*.sh
else
  /home/onyxia/work/restore_backup.sh
  sleep 90
  nohup /home/onyxia/work/backup_script.sh >/dev/null 2>&1
fi
