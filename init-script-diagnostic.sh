#!/bin/bash

# init-script-diagnostic.sh
# Script de diagnostic pour Onyxia VSCode Python
# Identifie les problèmes courants au démarrage

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DIAG_LOG="/home/onyxia/work/diagnostic.log"

log() {
    local level="$1"; shift
    local msg="[$(date '+%H:%M:%S')] [$level] $*"
    echo -e "$msg" | tee -a "$DIAG_LOG"
    case "$level" in
        ERROR)   echo -e "${RED}$msg${NC}" ;;
        SUCCESS) echo -e "${GREEN}$msg${NC}" ;;
        WARN)    echo -e "${YELLOW}$msg${NC}" ;;
        INFO)    echo -e "${BLUE}$msg${NC}" ;;
        *)       echo -e "$msg" ;;
    esac
}

# ============================================================
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Diagnostic Onyxia VSCode Python${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# ============================================================
# 1. Informations système
# ============================================================
log INFO "=== 1. Informations système ==="
uname -a | tee -a "$DIAG_LOG"
echo ""

log INFO "Date/Heure: $(date)"
echo ""

# ============================================================
# 2. Variables d'environnement
# ============================================================
log INFO "=== 2. Variables d'environnement Onyxia ==="

declare -A onyxia_vars=(
    ["ONYXIA_USERID"]="ID utilisateur"
    ["ONYXIA_ACCESSKEY"]="Clé d'accès S3"
    ["ONYXIA_SECRETKEY"]="Clé secrète S3"
    ["ONYXIA_BUCKETNAME"]="Nom du bucket S3"
    ["ONYXIA_REGION"]="Région"
    ["ONYXIA_ENDPOINT"]="Endpoint S3"
    ["WORK_DIR"]="Répertoire de travail"
    ["HOME"]="Home directory"
    ["USER"]="Utilisateur"
    ["PATH"]="PATH"
    ["GIT_PERSONAL_ACCESS_TOKEN"]="Token GitHub"
    ["SPARK_API_KEY"]="Clé Spark"
    ["SPARK_API_URL"]="URL Spark"
    ["PERSONAL_INIT_ARGS"]="Args init"
    ["VSCODE_PROXY_URI"]="Proxy VSCode"
)

for var in "${!onyxia_vars[@]}"; do
    val="${!var}"
    if [ -z "$val" ]; then
        log WARN "${var}: NON DEFINI"
    else
        # Masquer les secrets
        if [[ "$var" == *KEY* ]] || [[ "$var" == *TOKEN* ]] || [[ "$var" == *SECRET* ]]; then
            log INFO "${onyxia_vars[$var]}: [MASQUE - ${#val} chars]"
        else
            log INFO "${onyxia_vars[$var]}: $val"
        fi
    fi
done
echo ""

# ============================================================
# 3. Espace disque
# ============================================================
log INFO "=== 3. Espace disque ==="
df -h / /home 2>/dev/null | tee -a "$DIAG_LOG"
echo ""

# ============================================================
# 4. Ressources disponibles
# ============================================================
log INFO "=== 4. Ressources système ==="
log INFO "CPU: $(nproc) cœurs"
free -h 2>/dev/null | tee -a "$DIAG_LOG"
echo ""

# ============================================================
# 5. Vérification du réseau
# ============================================================
log INFO "=== 5. Connectivité réseau ==="

declare -A targets=(
    ["https://registry.npmjs.org"]="Registry npm"
    ["https://pypi.org"]="PyPI"
    ["https://github.com"]="GitHub"
    ["https://cli.github.com"]="GitHub CLI"
    ["https://raw.githubusercontent.com"]="Raw GitHub"
)

for url in "${!targets[@]}"; do
    if curl -sS --connect-timeout 10 --max-time 20 -o /dev/null -w "%{http_code}" "$url" 2>/dev/null | grep -q "2"; then
        log SUCCESS "${targets[$url]} ($url): OK"
    else
        log ERROR "${targets[$url]} ($url): KO"
    fi
done
echo ""

# ============================================================
# 6. Vérification code-server
# ============================================================
log INFO "=== 6. code-server ==="

if command -v code-server &>/dev/null; then
    log SUCCESS "code-server trouvé: $(which code-server)"
    log INFO "Version: $(code-server --version 2>/dev/null)"
else
    log ERROR "code-server NON TROUVE dans PATH"
fi

# Vérifier les logs de code-server
if [ -d "/home/onyxia/.local/share/code-server" ]; then
    log INFO "Répertoire code-server: /home/onyxia/.local/share/code-server"
    ls -la /home/onyxia/.local/share/code-server/ 2>/dev/null | tee -a "$DIAG_LOG"
    
    # Logs
    if [ -f "/home/onyxia/.local/share/code-server/logs/codeserver.log" ]; then
        log INFO "Dernières erreurs code-server:"
        grep -i "error\|fatal\|fail" /home/onyxia/.local/share/code-server/logs/codeserver.log 2>/dev/null | tail -20 | tee -a "$DIAG_LOG"
    fi
else
    log WARN "Répertoire code-server inexistent: /home/onyxia/.local/share/code-server"
fi
echo ""

# ============================================================
# 7. Extensions VSCode
# ============================================================
log INFO "=== 7. Extensions VSCode ==="

# Extensions installées
EXTENSIONS_DIR="/home/onyxia/.local/share/code-server/extensions"
if [ -d "$EXTENSIONS_DIR" ]; then
    log INFO "Extensions installées:"
    ls "$EXTENSIONS_DIR" 2>/dev/null | while read ext; do
        log INFO "  - $ext"
    done
else
    log WARN "Répertoire extensions inexistent"
fi
echo ""

# ============================================================
# 8. Extensions personnalisées à installer
# ============================================================
log INFO "=== 8. Extensions personnalisées ==="

declare -A custom_extensions=(
    ["privy.privy-vscode"]="Privy (IA)"
    ["Continue.continue"]="Continue (IA)"
    ["anwar.papyrus-pdf"]="PDF viewer"
    ["vivaxy.vscode-conventional-commits"]="Conventional commits"
    ["charliermarsh.ruff"]="Ruff linter"
)

for ext_id in "${!custom_extensions[@]}"; do
    if code-server --list-extensions 2>/dev/null | grep -q "$ext_id"; then
        log SUCCESS "Extension installée: ${custom_extensions[$ext_id]} ($ext_id)"
    else
        log WARN "Extension NON installée: ${custom_extensions[$ext_id]} ($ext_id)"
    fi
done
echo ""

# ============================================================
# 9. Python
# ============================================================
log INFO "=== 9. Environnement Python ==="

if command -v python3 &>/dev/null; then
    log SUCCESS "Python3: $(python3 --version 2>&1)"
    log INFO "Path: $(which python3)"
else
    log ERROR "Python3 NON TROUVE"
fi

if command -v pip3 &>/dev/null; then
    log SUCCESS "pip3: $(pip3 --version 2>&1)"
else
    log WARN "pip3 NON TROUVE"
fi

if command -v pip &>/dev/null; then
    log SUCCESS "pip: $(pip --version 2>&1)"
else
    log WARN "pip NON TROUVE"
fi

# Virtual environments
if [ -d "/home/onyxia/.local/share/code-server" ]; then
    venvs=$(find /home/onyxia -name "requirements.txt" -o -name "pyproject.toml" -o -name "setup.py" 2>/dev/null | head -10)
    if [ -n "$venvs" ]; then
        log INFO "Projets Python détectés:"
        echo "$venvs" | while read f; do
            log INFO "  - $f"
        done
    else
        log INFO "Aucun projet Python détecté dans /home/onyxia"
    fi
fi
echo ""

# ============================================================
# 10. Dépendances système
# ============================================================
log INFO "=== 10. Dépendances système ==="

declare -A sys_deps=(
    ["curl"]="curl"
    ["wget"]="wget"
    ["git"]="git"
    ["jq"]="jq"
    ["unzip"]="unzip"
    ["tar"]="tar"
    ["sudo"]="sudo"
    ["apt-get"]="apt-get"
)

for cmd in "${!sys_deps[@]}"; do
    if command -v "$cmd" &>/dev/null; then
        log SUCCESS "${sys_deps[$cmd]}: OK ($(which $cmd))"
    else
        log ERROR "${sys_deps[$cmd]}: MANQUANT"
    fi
done
echo ""

# ============================================================
# 11. Fichiers de config
# ============================================================
log INFO "=== 11. Fichiers de configuration ==="

declare -A config_files=(
    ["/home/onyxia/.local/share/code-server/User/settings.json"]="settings.json"
    ["/home/onyxia/.vscode/settings.json"]="vscode settings (legacy)"
    ["/home/onyxia/.config/code-server/config.yaml"]="code-server config"
    ["/home/onyxia/.config/rclone/rclone.conf"]="rclone config"
    ["/home/onyxia/.gitconfig"]="git config"
)

for cfg in "${!config_files[@]}"; do
    if [ -f "$cfg" ]; then
        log SUCCESS "${config_files[$cfg]}: EXISTE ($cfg)"
        # Afficher les 10 premières lignes pour settings.json
        if [[ "$cfg" == *"settings.json" ]]; then
            log INFO "  Aperçu:"
            head -10 "$cfg" 2>/dev/null | sed 's/^/    /' | tee -a "$DIAG_LOG"
        fi
    else
        log WARN "${config_files[$cfg]}: INEXISTANT ($cfg)"
    fi
done
echo ""

# ============================================================
# 12. Scripts personnalisés
# ============================================================
log INFO "=== 12. Scripts personnalisés ==="

if [ -d "/home/onyxia/work" ]; then
    scripts=$(find /home/onyxia/work -name "*.sh" -type f 2>/dev/null)
    if [ -n "$scripts" ]; then
        log INFO "Scripts trouvés:"
        echo "$scripts" | while read s; do
            if [ -x "$s" ]; then
                log INFO "  - $s (executable)"
            else
                log WARN "  - $s (NON executable)"
            fi
        done
    else
        log INFO "Aucun script shell dans /home/onyxia/work"
    fi
fi
echo ""

# ============================================================
# 13. Permissions
# ============================================================
log INFO "=== 13. Permissions ==="

declare -A perm_dirs=(
    ["/home/onyxia"]="Home"
    ["/home/onyxia/work"]="Work dir"
    ["/home/onyxia/.local/share/code-server"]="code-server data"
    ["/home/onyxia/.config"]="Config"
    ["/tmp"]="Tmp"
)

for dir in "${!perm_dirs[@]}"; do
    if [ -d "$dir" ]; then
        perms=$(stat -c '%A %U:%G' "$dir" 2>/dev/null)
        log INFO "${perm_dirs[$dir]}: $dir -> $perms"
    else
        log WARN "${perm_dirs[$dir]}: $dir INEXISTANT"
    fi
done
echo ""

# ============================================================
# 14. Processus en cours
# ============================================================
log INFO "=== 14. Processus en cours ==="
ps aux 2>/dev/null | head -30 | tee -a "$DIAG_LOG"
echo ""

# ============================================================
# 15. Port écoute
# ============================================================
log INFO "=== 15. Ports ==="
if command -v ss &>/dev/null; then
    ss -tlnp 2>/dev/null | tee -a "$DIAG_LOG"
elif command -v netstat &>/dev/null; then
    netstat -tlnp 2>/dev/null | tee -a "$DIAG_LOG"
else
    log WARN "ss/netstat non disponibles"
fi
echo ""

# ============================================================
# Résumé
# ============================================================
echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Résumé du diagnostic${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Compter les problèmes
errors=$(grep -c "\[ERROR\]" "$DIAG_LOG" 2>/dev/null || echo "0")
warnings=$(grep -c "\[WARN\]" "$DIAG_LOG" 2>/dev/null || echo "0")

if [ "$errors" -gt 0 ]; then
    echo -e "${RED}ERREURS: $errors${NC}"
    grep "\[ERROR\]" "$DIAG_LOG" | while read line; do
        echo -e "  ${RED}$line${NC}"
    done
    echo ""
fi

if [ "$warnings" -gt 0 ]; then
    echo -e "${YELLOW}WARNINGS: $warnings${NC}"
    grep "\[WARN\]" "$DIAG_LOG" | while read line; do
        echo -e "  ${YELLOW}$line${NC}"
    done
    echo ""
fi

echo -e "${GREEN}Log complet: $DIAG_LOG${NC}"
echo ""

# ============================================================
# Actions de dépannage suggérées
# ============================================================
log INFO "=== Suggestions de dépannage ==="
echo ""

if [ "$errors" -gt 0 ]; then
    echo -e "${YELLOW}Problèmes détectés. Actions recommandées :${NC}"
    echo ""
    echo "1. Vérifier les logs complets:"
    echo "   cat $DIAG_LOG"
    echo ""
    echo "2. Vérifier les logs du pod:"
    echo "   kubectl logs <pod-name> --tail=200"
    echo "   kubectl logs <pod-name> -c init --tail=200"
    echo ""
    echo "3. Décrire le pod pour les événements:"
    echo "   kubectl describe pod <pod-name>"
    echo ""
    echo "4. Entrer dans le pod pour debug:"
    echo "   kubectl exec -it <pod-name> -- bash"
    echo ""
    echo "5. Vérifier les ressources du pod:"
    echo "   kubectl top pod <pod-name>"
    echo ""
fi

log SUCCESS "Diagnostic terminé. Log: $DIAG_LOG"
