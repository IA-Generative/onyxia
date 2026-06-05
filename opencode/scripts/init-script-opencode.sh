#!/bin/bash
# init-script-opencode.sh — Configure OpenCode pour Onyxia
# Variables requises : API_KEY, API_URL
set -e

OPENCODE_CONFIG_DIR="${HOME}/.config/opencode"
OPENCODE_CONFIG_FILE="${OPENCODE_CONFIG_DIR}/opencode.json"

# --- Couleurs ---
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log_info()    { echo -e "${GREEN}[opencode]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[opencode]${NC} $1"; }
log_error()   { echo -e "${RED}[opencode]${NC} $1"; }

# --- Vérification des variables d'environnement ---
check_env() {
  if [ -z "${API_KEY}" ] || [ -z "${API_URL}" ]; then
    log_error "API_KEY et API_URL sont requis."
    log_error "Définissez-les dans les secrets Onyxia ou via export."
    exit 1
  fi
}

# --- Installation d'OpenCode ---
install_opencode() {
  if command -v opencode &>/dev/null; then
    log_info "OpenCode déjà installé : $(opencode --version 2>/dev/null || echo 'version inconnue')"
    return
  fi

  log_info "Installation d'OpenCode..."
  curl -fsSL https://opencode.ai/install | bash
  if ! command -v opencode &>/dev/null; then
    OPENCODE_BIN=$(find "${HOME}/.opencode" -name "opencode" -type f 2>/dev/null | head -1)
    if [ -n "${OPENCODE_BIN}" ]; then
      ln -sf "${OPENCODE_BIN}" /usr/local/bin/opencode
    else
      log_error "Impossible de trouver le binaire opencode après installation."
      exit 1
    fi
  fi
  log_info "OpenCode installé : $(opencode --version 2>/dev/null)"
}

# --- Génération de ~/.config/opencode/opencode.json ---
create_config() {
  mkdir -p "${OPENCODE_CONFIG_DIR}"

  cat > "${OPENCODE_CONFIG_FILE}" <<EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "provider": {
    "spark": {
      "name": "spark",
      "npm": "@ai-sdk/openai-compatible",
      "models": {
        "qwen3.5:122b": { "name": "qwen3.5:122b", "_launch": true }
      },
      "options": {
        "apiKey": "{env:API_KEY}",
        "baseURL": "{env:API_URL}"
      }
    }
  },
  "agent": {
    "build":    { "temperature": 0.1 },
    "plan":     { "temperature": 0.1 },
    "creative": { "temperature": 0.8 }
  },
  "mcp": {
    "searchcode": { "type": "remote", "url": "https://api.searchcode.com/v1/mcp" }
  }
}
EOF

  log_info "Config écrite dans ${OPENCODE_CONFIG_FILE}"
}

# --- Main ---
check_env
install_opencode
create_config
log_info "OpenCode prêt. Modèle par défaut : spark/qwen3.5:122b"
