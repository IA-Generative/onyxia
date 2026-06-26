#!/bin/bash
# init-script-opencode.sh — Configure OpenCode pour Onyxia
# Variables requises : API_KEY, API_URL
set -e

OPENCODE_CONFIG_DIR="${HOME}/.config/opencode"
OPENCODE_CONFIG_FILE="${OPENCODE_CONFIG_DIR}/opencode.json"
WORK_DIR="${HOME}/work"
REPO_RAW="https://raw.githubusercontent.com/IA-Generative/onyxia/refs/heads/feat/init-script-opencode"
STARTER_KIT_RAW="https://raw.githubusercontent.com/dnum-mi/starter-kit-opencode/main"
PROTO_HOME="${HOME}/.proto"

# --- Couleurs ---
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
log_info()  { echo -e "${GREEN}[opencode]${NC} $1"; }
log_error() { echo -e "${RED}[opencode]${NC} $1"; }

# --- Vérification des variables d'environnement ---
check_env() {
  if [ -z "${API_KEY}" ]; then
    log_error "API_KEY est requis."
    log_error "Définissez-le dans les secrets Onyxia ou via export."
    exit 1
  fi
}

# --- Installation de proto (toolchain manager) ---
install_proto() {
  export PATH="${PROTO_HOME}/bin:${PROTO_HOME}/shims:${PATH}"
  if command -v proto &>/dev/null; then
    log_info "proto déjà installé : $(proto --version 2>/dev/null)"
    return
  fi

  log_info "Installation de proto..."
  curl -fsSL https://moonrepo.dev/install/proto.sh | bash -s -- --yes
  export PATH="${PROTO_HOME}/bin:${PROTO_HOME}/shims:${PATH}"

  if ! command -v proto &>/dev/null; then
    log_error "Impossible de trouver proto après installation."
    exit 1
  fi

  grep -qF 'PROTO_HOME' "${HOME}/.bashrc" 2>/dev/null \
    || echo 'export PATH="${HOME}/.proto/bin:${HOME}/.proto/shims:${PATH}"' >> "${HOME}/.bashrc"

  log_info "proto installé : $(proto --version)"
}

# --- Installation de Node.js via proto ---
install_node() {
  export PATH="${PROTO_HOME}/bin:${PROTO_HOME}/shims:${PATH}"
  # Vérifie si node est déjà épinglé globalement dans ~/.proto/.prototools
  if grep -q "node" "${PROTO_HOME}/.prototools" 2>/dev/null; then
    log_info "Node.js déjà géré par proto : $(node --version 2>/dev/null)"
    return
  fi

  log_info "Installation de Node.js LTS via proto..."
  proto install node lts
  # Épingler avec la même spec pour que proto trouve node lors de l'install de pnpm
  proto pin node lts --to global \
    && log_info "Node.js LTS épinglé globalement via proto"
  log_info "Node.js installé : $(proto exec node -- node --version 2>/dev/null)"
}

# --- Installation de pnpm via proto ---
install_pnpm() {
  export PATH="${PROTO_HOME}/bin:${PROTO_HOME}/shims:${PATH}"
  if command -v pnpm &>/dev/null; then
    log_info "pnpm déjà installé : $(pnpm --version)"
    return
  fi

  log_info "Installation de pnpm via proto..."
  proto install pnpm latest
  proto pin pnpm latest --to global \
    && log_info "pnpm latest épinglé globalement via proto"
  log_info "pnpm installé : $(proto exec pnpm -- pnpm --version 2>/dev/null)"
}

# --- Installation d'OpenCode ---
install_opencode() {
  # L'installateur opencode place le binaire dans ~/.opencode/bin
  export PATH="${HOME}/.opencode/bin:${PATH}"
  if command -v opencode &>/dev/null; then
    log_info "OpenCode déjà installé : $(opencode --version 2>/dev/null || echo 'version inconnue')"
    return
  fi

  log_info "Installation d'OpenCode..."
  curl -fsSL https://opencode.ai/install | bash

  # L'installateur modifie .bashrc mais pas le PATH de la session courante
  export PATH="${HOME}/.opencode/bin:${PATH}"

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

# --- Config globale : provider + agents + MCP → ~/.config/opencode/opencode.json ---
install_global_config() {
  mkdir -p "${OPENCODE_CONFIG_DIR}"
  curl -fsSL "${REPO_RAW}/opencode/config/opencode-global.json" -o "${OPENCODE_CONFIG_FILE}"
  log_info "Config provider écrite dans ${OPENCODE_CONFIG_FILE}"
}

# --- Config projet : starter-kit dnum-mi → ~/work/opencode.json ---
install_project_config() {
  mkdir -p "${WORK_DIR}"
  curl -fsSL "${STARTER_KIT_RAW}/opencode.json" -o "${WORK_DIR}/opencode.json"
  log_info "Config projet (starter-kit) écrite dans ${WORK_DIR}/opencode.json"
}

# --- Installation GitHub CLI ---
install_gh() {
  if command -v gh &>/dev/null; then
    log_info "GitHub CLI déjà installé : $(gh --version | head -1)"
  else
    log_info "Installation de GitHub CLI..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update -qq && sudo apt-get install -y gh
    log_info "GitHub CLI installé : $(gh --version | head -1)"
  fi

  if [ -n "${GIT_PERSONAL_ACCESS_TOKEN}" ]; then
    echo "${GIT_PERSONAL_ACCESS_TOKEN}" | gh auth login --with-token 2>/dev/null \
      && log_info "GitHub CLI authentifié avec GIT_PERSONAL_ACCESS_TOKEN." \
      || log_info "Authentification gh échouée (token invalide ?)."
  else
    log_info "GIT_PERSONAL_ACCESS_TOKEN non défini — gh non authentifié."
  fi
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
install_proto
install_node
install_pnpm
install_opencode
install_gh
install_global_config
install_project_config
install_copilot
log_info "OpenCode prêt."
