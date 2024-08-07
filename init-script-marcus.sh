# Install vscode extension
code-server --install-extension ext install privy.privy-vscode
# Add privy conf to vscode
jq '. + {
  "privy.providerBaseUrl": "https://ollama.c1.cloud-pi-native.com/",
  "privy.autocomplete.model": "deepseek-coder:1.3b-base",
  "privy.model": "custom",
  "privy.customModel": "gemma2:27b"
}' /home/onyxia/.local/share/code-server/User/settings.json > /home/onyxia/.local/share/code-server/User/settings_tmp.json
mv /home/onyxia/.local/share/code-server/User/settings_tmp.json /home/onyxia/.local/share/code-server/User/settings.json

