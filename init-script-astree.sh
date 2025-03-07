sudo apt update
sudo apt install rclone fuse3 htop nvtop -y
mkdir -p /home/onyxia/.config/rclone
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add S3 rclone bucket [scw-astree]
cat << EOF > /home/onyxia/.config/rclone/rclone.conf 
[scw-astree]
type = s3
provider = Scaleway
env_auth = true
endpoint = $AWS_S3_ENDPOINT
region = $AWS_DEFAULT_REGION

# Mount data
mkdir ./data
rclone mount scw-astree:siaj ./data --daemon
code-server --install-extension anwar.papyrus-pdf
