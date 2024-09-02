sudo apt update

git clone https://github.com/IA-Generative/technical-tests.git -b r2i-extraction

# Create .env
cat << EOF > /home/onyxia/work/technical-tests/.env
OPENAI_API_BASE=https://api-ai.numerique-interieur.com/v1
OPENAI_API_KEY=$PERSONAL_INIT_ARGS
EOF
