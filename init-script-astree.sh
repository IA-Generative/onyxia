curl -sSL https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-continue.sh | bash

sudo apt update
sudo apt install rclone fuse3 htop nvtop -y
mkdir -p /home/onyxia/.config/rclone
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install FR locales
sudo locale-gen fr_FR.UTF-8
sudo update-locale

# Add S3 rclone bucket [scw-astree]
cat << EOF > /home/onyxia/.config/rclone/rclone.conf
[scw-astree]
type = s3
provider = Scaleway
env_auth = true
endpoint = $AWS_S3_ENDPOINT
region = $AWS_DEFAULT_REGION
EOF

# Mount data
mkdir -p /home/onyxia/data
rclone mount scw-astree:siaj /home/onyxia/data --daemon

#code-server --install-extension anwar.papyrus-pdf
#code-server --install-extension vivaxy.vscode-conventional-commits
#code-server --install-extension charliermarsh.ruff

# Run custom user init script
if [ -f /home/onyxia/work/.init/init.sh ]; then
  cat /home/onyxia/work/.init/init.sh | bash
fi
