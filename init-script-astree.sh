sudo apt update
sudo apt install rclone fuse3 -y
mkdir -p /home/onyxia/.config/rclone


# Add S3 rclone bucket [ovh-snc]
cat << EOF > /home/onyxia/.config/rclone/rclone.conf 
[ovh-snc]
type = s3
provider = Minio
env_auth = true
endpoint = $AWS_S3_ENDPOINT
region = $AWS_DEFAULT_REGION
acl = private
server_side_encryption = aws:kms
sse_kms_key_id = minio-kms-key
upload_cutoff = 0

[secret]
type = crypt
remote = ovh-snc:vjourne-astree
filename_encryption = obfuscate
EOF

rclone config password secret password $PERSONAL_INIT_ARGS

# Mount data
mkdir ./data
rclone mount secret:vjourne-astree ./data --daemon
