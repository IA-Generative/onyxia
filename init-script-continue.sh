code-server --install-extension Continue.continue
mkdir -p /home/onyxia/.continue/
curl -s -o /home/onyxia/.continue/config.json https://raw.githubusercontent.com/IA-Generative/onyxia/refs/heads/main/.continue/config.json
##MY_TMP_VAR=$(echo "$VSCODE_PROXY_URI" | awk -F'.' '{print $3}')
MY_TMP_VAR=cloud-pi-native
sed -i "s|__PLACEHOLDER_OLLAMA_URL__|https://ollama.c1.${MY_TMP_VAR}.com/|g" /home/onyxia/.continue/config.json
