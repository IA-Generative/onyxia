#!/bin/bash
# test-init-script-opencode.sh — Teste init-script-opencode.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/../config/.env.test"
INIT_SCRIPT="${SCRIPT_DIR}/init-script-opencode.sh"
CONFIG_FILE="${HOME}/.config/opencode/opencode.json"

GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
pass() { echo -e "${GREEN}[PASS]${NC} $1"; }
fail() { echo -e "${RED}[FAIL]${NC} $1"; exit 1; }

echo "=== Test init-script-opencode.sh ==="

# Charger les variables
if [ -f "${ENV_FILE}" ]; then
  source "${ENV_FILE}"
  echo "Variables chargées depuis ${ENV_FILE}"
else
  fail "Fichier ${ENV_FILE} introuvable"
fi

# Sauvegarder la config existante si présente
BACKUP_FILE=""
if [ -f "${CONFIG_FILE}" ]; then
  BACKUP_FILE="${CONFIG_FILE}.bak"
  cp "${CONFIG_FILE}" "${BACKUP_FILE}"
  echo "Config existante sauvegardée dans ${BACKUP_FILE}"
fi

# Lancer le script
echo ""
bash "${INIT_SCRIPT}"
echo ""

# Vérifications
echo "=== Vérifications ==="

[ -f "${CONFIG_FILE}" ] && pass "Fichier ${CONFIG_FILE} créé" || fail "Fichier ${CONFIG_FILE} absent"

jq . "${CONFIG_FILE}" > /dev/null 2>&1 && pass "JSON valide" || fail "JSON invalide"

jq -e '.provider.spark' "${CONFIG_FILE}" > /dev/null 2>&1 && pass "Provider spark présent" || fail "Provider spark absent"

jq -e '.provider.spark.models["qwen3.5:122b"]' "${CONFIG_FILE}" > /dev/null 2>&1 && pass "Modèle qwen3.5:122b présent" || fail "Modèle qwen3.5:122b absent"

jq -e '.provider.spark.options.apiKey == "{env:API_KEY}"' "${CONFIG_FILE}" > /dev/null 2>&1 && pass "apiKey référence {env:API_KEY}" || fail "apiKey incorrect"

jq -e '.mcp.searchcode' "${CONFIG_FILE}" > /dev/null 2>&1 && pass "MCP searchcode présent" || fail "MCP searchcode absent"

echo ""
echo "Contenu généré :"
jq . "${CONFIG_FILE}"

# Restaurer la config si elle existait
if [ -n "${BACKUP_FILE}" ]; then
  mv "${BACKUP_FILE}" "${CONFIG_FILE}"
  echo ""
  echo "Config originale restaurée."
fi

echo ""
echo "=== Tous les tests passés ==="
