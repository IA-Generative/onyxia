sudo apt update

# Create .env
cat << EOF > /home/onyxia/work/.env
OPENAI_API_BASE=https://api-ai.numerique-interieur.com/v1
OPENAI_API_KEY=$PERSONAL_INIT_ARGS
EOF

git clone https://github.com/IA-Generative/technical-tests.git -b r2i-extraction
