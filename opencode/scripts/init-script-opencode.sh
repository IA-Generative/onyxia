#!/bin/bash
# init-script-opencode.sh — Configure OpenCode pour Onyxia
# Variables requises : au moins API_KEY+API_URL ou NOTHINK_API_KEY+NOTHINK_API_URL
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_CONFIG_DIR="${HOME}/.config/opencode"
OPENCODE_CONFIG_FILE="${OPENCODE_CONFIG_DIR}/opencode.json"
CONFIG_TEMPLATE="${SCRIPT_DIR}/../config/opencode-global.json"

# --- Couleurs ---
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
log_info()  { echo -e "${GREEN}[opencode]${NC} $1"; }
log_error() { echo -e "${RED}[opencode]${NC} $1"; }

# --- Vérification des variables d'environnement ---
check_env() {
  if [ -z "${API_KEY}" ] && [ -z "${NOTHINK_API_KEY}" ]; then
    log_error "Au moins API_KEY ou NOTHINK_API_KEY est requis."
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

# --- Copie de la config globale ---
install_config() {
  mkdir -p "${OPENCODE_CONFIG_DIR}"
  cp "${CONFIG_TEMPLATE}" "${OPENCODE_CONFIG_FILE}"
  log_info "Config copiée dans ${OPENCODE_CONFIG_FILE}"
}

# --- Installation extension VS Code Copilot ---
install_copilot() {
  export EXTENSIONS_GALLERY='{"serviceUrl":"https://marketplace.visualstudio.com/_apis/public/gallery","cacheUrl":"https://vscode.blob.core.windows.net/gallery/index","itemUrl":"https://marketplace.visualstudio.com/items"}'
  log_info "Installation de l'extension GitHub Copilot..."
  code-server --install-extension GitHub.copilot 2>&1 \
    && log_info "GitHub Copilot installé." \
    || log_info "Échec installation Copilot (extension peut-être déjà présente ou non disponible)."
}

# --- Main ---
check_env
install_opencode
install_config
install_copilot
log_info "OpenCode prêt."
