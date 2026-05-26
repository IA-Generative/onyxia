#!/bin/bash

#############################################
# init-script-opencode.sh
# Script d'initialisation OpenCode pour Onyxia
# Auteur: IA-Generative
# Description: Installe et configure OpenCode avec les providers Spark et GitHub
#############################################

set -e  # Exit on error

# Couleurs pour l'output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration par défaut
OPENCODE_VERSION="${OPENCODE_VERSION:-latest}"
OPENCODE_INSTALL_DIR="${OPENCODE_INSTALL_DIR:-$HOME/.opencode}"
OPENCODE_BIN="$OPENCODE_INSTALL_DIR/bin/opencode"
OPENCODE_CONFIG_DIR="$HOME/.config/opencode"
WORK_DIR="${WORK_DIR:-$HOME/work}"
OPENCODE_CONFIG_FILE="$WORK_DIR/opencode.json"

# URLs par défaut
SPARK_API_URL="${SPARK_API_URL:-https://your-spark-api-endpoint.example.com/v1}"
GITHUB_API_URL="${GITHUB_API_URL:-https://models.github.com}"

# Fonctions utilitaires
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérifier si une commande existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Vérifier les variables d'environnement requises
check_required_env_vars() {
    log_info "Vérification des variables d'environnement..."
    
    local missing_vars=()
    local has_provider=false
    
    # Vérifier si au moins un provider est configuré
    if [ -n "$SPARK_API_KEY" ]; then
        has_provider=true
        log_success "SPARK_API_KEY défini"
    fi
    
    if [ -n "$GITHUB_TOKEN" ]; then
        has_provider=true
        log_success "GITHUB_TOKEN défini"
    fi
    
    # Si aucun provider n'est configuré, afficher un avertissement
    if [ "$has_provider" = false ]; then
        log_error "Aucun provider configuré !"
        echo ""
        echo -e "${YELLOW}Pour utiliser OpenCode, vous devez définir au moins une des variables suivantes :${NC}"
        echo ""
        echo -e "  ${BLUE}SPARK_API_KEY${NC}    - Pour utiliser le provider Spark (qwen3.5:122b)"
        echo -e "  ${BLUE}GITHUB_TOKEN${NC}     - Pour utiliser le provider GitHub (claude-sonnet-4.5)"
        echo ""
        echo -e "${YELLOW}Exemple :${NC}"
        echo -e "  export SPARK_API_KEY=\"votre-clé-api\""
        echo -e "  $0"
        echo ""
        echo -e "${YELLOW}Pour tester le script sans clés réelles :${NC}"
        echo -e "  cp .env.example .env"
        echo -e "  source .env"
        echo -e "  $0"
        echo ""
        exit 1
    fi
    
    log_success "Variables d'environnement vérifiées"
}

# Installation des dépendances
install_dependencies() {
    log_info "Vérification des dépendances..."
    
    local deps_to_install=()
    
    # Vérifier curl
    if ! command_exists curl; then
        deps_to_install+=("curl")
    fi
    
    # Vérifier jq
    if ! command_exists jq; then
        deps_to_install+=("jq")
    fi
    
    # Vérifier git
    if ! command_exists git; then
        deps_to_install+=("git")
    fi
    
    # Installer les dépendances manquantes
    if [ ${#deps_to_install[@]} -gt 0 ]; then
        log_info "Installation des dépendances: ${deps_to_install[*]}"
        sudo apt-get update -qq
        sudo apt-get install -y "${deps_to_install[@]}"
        log_success "Dépendances installées"
    else
        log_success "Toutes les dépendances sont présentes"
    fi
    
    # Installer gh CLI si absent
    if ! command_exists gh; then
        log_info "Installation de GitHub CLI..."
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt-get update -qq
        sudo apt-get install -y gh
        log_success "GitHub CLI installé"
    else
        log_success "GitHub CLI déjà installé"
    fi
}

# Configurer GitHub CLI
configure_gh_cli() {
    # Configurer gh CLI si GITHUB_TOKEN est défini
    if [ -n "$GITHUB_TOKEN" ]; then
        log_info "Configuration de GitHub CLI..."
        
        # Vérifier si gh est déjà authentifié
        if gh auth status >/dev/null 2>&1; then
            log_success "GitHub CLI déjà authentifié"
        else
            # Authentifier gh avec le token
            echo "$GITHUB_TOKEN" | gh auth login --with-token 2>/dev/null
            
            if gh auth status >/dev/null 2>&1; then
                log_success "GitHub CLI authentifié avec succès"
                
                # Configurer les permissions pour les repos, workflows, org et projects
                gh auth refresh -h github.com -s repo,workflow,read:org,read:project 2>/dev/null || true
                log_info "Permissions configurées : repo, workflow, read:org, read:project"
            else
                log_warning "Échec de l'authentification GitHub CLI (non bloquant)"
            fi
        fi
    else
        log_info "GITHUB_TOKEN non défini, GitHub CLI non configuré"
    fi
}

# Installer OpenCode
install_opencode() {
    if [ -f "$OPENCODE_BIN" ]; then
        local current_version=$("$OPENCODE_BIN" --version 2>/dev/null || echo "unknown")
        log_info "OpenCode déjà installé (version: $current_version)"
        
        if [ "$OPENCODE_VERSION" != "latest" ] && [ "$current_version" != "$OPENCODE_VERSION" ]; then
            log_warning "Version différente demandée, réinstallation..."
        else
            log_success "OpenCode est déjà installé"
            return 0
        fi
    fi
    
    log_info "Installation d'OpenCode..."
    
    # Détecter l'architecture
    local arch=$(uname -m)
    local platform="linux"
    
    case "$arch" in
        x86_64)
            arch="x64"
            ;;
        aarch64|arm64)
            arch="arm64"
            ;;
        *)
            log_error "Architecture non supportée: $arch"
            exit 1
            ;;
    esac
    
    # Créer le répertoire d'installation
    mkdir -p "$OPENCODE_INSTALL_DIR"
    
    # Télécharger et installer OpenCode
    log_info "Téléchargement d'OpenCode pour $platform-$arch..."
    
    local install_script=$(mktemp)
    curl -fsSL https://opencode.ai/install.sh -o "$install_script"
    
    if [ ! -s "$install_script" ]; then
        log_error "Échec du téléchargement du script d'installation"
        rm -f "$install_script"
        exit 1
    fi
    
    bash "$install_script"
    rm -f "$install_script"
    
    # Vérifier l'installation
    if [ -f "$OPENCODE_BIN" ]; then
        local installed_version=$("$OPENCODE_BIN" --version 2>/dev/null || echo "unknown")
        log_success "OpenCode installé avec succès (version: $installed_version)"
    else
        log_error "L'installation d'OpenCode a échoué"
        exit 1
    fi
    
    # Ajouter au PATH si nécessaire
    if ! echo "$PATH" | grep -q "$OPENCODE_INSTALL_DIR/bin"; then
        log_info "Ajout d'OpenCode au PATH..."
        
        # Ajouter au .bashrc
        if [ -f "$HOME/.bashrc" ]; then
            if ! grep -q "OPENCODE_INSTALL_DIR" "$HOME/.bashrc"; then
                echo "" >> "$HOME/.bashrc"
                echo "# OpenCode" >> "$HOME/.bashrc"
                echo "export PATH=\"$OPENCODE_INSTALL_DIR/bin:\$PATH\"" >> "$HOME/.bashrc"
                log_success "PATH mis à jour dans .bashrc"
            fi
        fi
        
        # Ajouter au PATH actuel
        export PATH="$OPENCODE_INSTALL_DIR/bin:$PATH"
    fi
}

# Créer la configuration OpenCode
create_opencode_config() {
    log_info "Création de la configuration OpenCode..."
    
    # Vérifier les variables d'environnement requises
    if [ -z "$SPARK_API_KEY" ]; then
        log_warning "SPARK_API_KEY n'est pas défini. Le provider Spark ne sera pas configuré correctement."
    fi
    
    # Créer le répertoire de config si nécessaire
    mkdir -p "$OPENCODE_CONFIG_DIR"
    mkdir -p "$(dirname "$OPENCODE_CONFIG_FILE")"
    
    # Construire la configuration JSON
    local config_json='{
  "$schema": "https://opencode.ai/config.json",
  "provider": {},
  "agent": {
    "build": {
      "temperature": 0.1
    },
    "plan": {
      "temperature": 0.1
    },
    "creative": {
      "temperature": 0.8
    }
  },
  "mcp": {
    "searchcode": {
      "type": "remote",
      "url": "https://api.searchcode.com/v1/mcp"
    }
  }
}'
    
    # Ajouter le provider Spark
    if [ -n "$SPARK_API_KEY" ]; then
        log_info "Configuration du provider Spark..."
        config_json=$(echo "$config_json" | jq --arg apiKey "$SPARK_API_KEY" \
                                               --arg baseURL "$SPARK_API_URL" \
                                               '.provider.spark = {
          "models": {
            "qwen3.5:122b": {
              "name": "qwen3.5:122b",
              "_launch": true
            }
          },
          "name": "spark",
          "npm": "@ai-sdk/openai-compatible",
          "options": {
            "apiKey": $apiKey,
            "baseURL": $baseURL
          }
        }')
        log_success "Provider Spark configuré"
    fi
    
    # Ajouter le provider GitHub si le token est présent
    if [ -n "$GITHUB_TOKEN" ]; then
        log_info "Configuration du provider GitHub..."
        config_json=$(echo "$config_json" | jq --arg apiKey "$GITHUB_TOKEN" \
                                               --arg baseURL "$GITHUB_API_URL" \
                                               '.provider.github = {
          "models": {
            "claude-sonnet-4.5": {
              "name": "claude-sonnet-4.5"
            }
          },
          "name": "github",
          "npm": "@ai-sdk/openai-compatible",
          "options": {
            "apiKey": $apiKey,
            "baseURL": $baseURL
          }
        }')
        log_success "Provider GitHub configuré"
    else
        log_warning "GITHUB_TOKEN n'est pas défini. Le provider GitHub ne sera pas configuré."
        log_info "Pour utiliser GitHub Models, définissez la variable GITHUB_TOKEN"
    fi
    
    # Sauvegarder la configuration
    echo "$config_json" > "$OPENCODE_CONFIG_FILE"
    log_success "Configuration sauvegardée dans $OPENCODE_CONFIG_FILE"
    
    # Créer aussi une copie dans .config/opencode si nécessaire
    if [ ! -f "$OPENCODE_CONFIG_DIR/opencode.jsonc" ]; then
        echo '{}' > "$OPENCODE_CONFIG_DIR/opencode.jsonc"
    fi
}

# Vérifier la configuration
verify_installation() {
    log_info "Vérification de l'installation..."
    
    # Vérifier que OpenCode est accessible
    if ! command_exists opencode; then
        log_error "OpenCode n'est pas dans le PATH"
        return 1
    fi
    
    # Vérifier la version
    local version=$(opencode --version 2>/dev/null || echo "unknown")
    log_info "Version d'OpenCode: $version"
    
    # Vérifier que le fichier de config existe
    if [ ! -f "$OPENCODE_CONFIG_FILE" ]; then
        log_error "Le fichier de configuration n'existe pas: $OPENCODE_CONFIG_FILE"
        return 1
    fi
    
    # Valider le JSON
    if ! jq empty "$OPENCODE_CONFIG_FILE" 2>/dev/null; then
        log_error "Le fichier de configuration n'est pas un JSON valide"
        return 1
    fi
    
    log_success "Installation vérifiée avec succès"
    
    # Afficher un résumé
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  OpenCode installé et configuré !${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "Version: ${BLUE}$version${NC}"
    echo -e "Config: ${BLUE}$OPENCODE_CONFIG_FILE${NC}"
    echo ""
    echo -e "Providers configurés:"
    
    if jq -e '.provider.spark' "$OPENCODE_CONFIG_FILE" >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} Spark (qwen3.5:122b) - ${GREEN}actif par défaut${NC}"
    fi
    
    if jq -e '.provider.github' "$OPENCODE_CONFIG_FILE" >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} GitHub (claude-sonnet-4.5)"
    else
        echo -e "  ${YELLOW}○${NC} GitHub (non configuré - définissez GITHUB_TOKEN)"
    fi
    
    echo ""
    echo -e "Pour utiliser OpenCode:"
    echo -e "  ${BLUE}opencode${NC}                    # Lancer OpenCode"
    echo -e "  ${BLUE}opencode --help${NC}             # Afficher l'aide"
    echo ""
}

# Fonction principale
main() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Init Script OpenCode pour Onyxia${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    
    # Étape 0: Vérifier les variables d'environnement
    check_required_env_vars
    
    # Étape 1: Installer les dépendances
    install_dependencies
    
    # Étape 2: Configurer GitHub CLI
    configure_gh_cli
    
    # Étape 3: Installer OpenCode
    install_opencode
    
    # Étape 4: Créer la configuration
    create_opencode_config
    
    # Étape 5: Vérifier l'installation
    verify_installation
    
    log_success "Initialisation terminée avec succès !"
}

# Exécuter le script
main "$@"
