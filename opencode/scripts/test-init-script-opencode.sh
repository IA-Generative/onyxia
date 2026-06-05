#!/bin/bash
# test-init-script-opencode.sh — Teste init-script-opencode.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/../config/.env.test"
INIT_SCRIPT="${SCRIPT_DIR}/init-script-opencode.sh"
GLOBAL_CONFIG="${HOME}/.config/opencode/opencode.json"
PROJECT_CONFIG="${HOME}/work/opencode.json"

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

# Sauvegarder les configs existantes
[ -f "${GLOBAL_CONFIG}" ] && cp "${GLOBAL_CONFIG}" "${GLOBAL_CONFIG}.bak"
[ -f "${PROJECT_CONFIG}" ] && cp "${PROJECT_CONFIG}" "${PROJECT_CONFIG}.bak"

# Lancer le script
echo ""
bash "${INIT_SCRIPT}"
echo ""

echo "=== Vérifications config globale (~/.config/opencode/opencode.json) ==="

[ -f "${GLOBAL_CONFIG}" ] \
  && pass "Fichier global créé" \
  || fail "Fichier global absent"

jq . "${GLOBAL_CONFIG}" > /dev/null 2>&1 \
  && pass "JSON global valide" \
  || fail "JSON global invalide"

jq -e '.provider["infocepo-nothink"]' "${GLOBAL_CONFIG}" > /dev/null 2>&1 \
  && pass "Provider infocepo-nothink présent" \
  || fail "Provider infocepo-nothink absent"

jq -e '.provider["infocepo-nothink"].options.apiKey == "{env:API_KEY}"' "${GLOBAL_CONFIG}" > /dev/null 2>&1 \
  && pass "apiKey référence {env:API_KEY}" \
  || fail "apiKey incorrect"

jq -e '.mcp.searchcode' "${GLOBAL_CONFIG}" > /dev/null 2>&1 \
  && pass "MCP searchcode présent" \
  || fail "MCP searchcode absent"

echo ""
echo "=== Vérifications config projet (~/work/opencode.json) ==="

[ -f "${PROJECT_CONFIG}" ] \
  && pass "Fichier projet créé" \
  || fail "Fichier projet absent"

jq . "${PROJECT_CONFIG}" > /dev/null 2>&1 \
  && pass "JSON projet valide" \
  || fail "JSON projet invalide"

jq -e '.plugin | length > 0' "${PROJECT_CONFIG}" > /dev/null 2>&1 \
  && pass "Plugin superpowers présent" \
  || fail "Plugin superpowers absent"

jq -e '.skills.urls | length > 0' "${PROJECT_CONFIG}" > /dev/null 2>&1 \
  && pass "skills.urls présent" \
  || fail "skills.urls absent"

jq -e '.permission.skill' "${PROJECT_CONFIG}" > /dev/null 2>&1 \
  && pass "Permission skills présente" \
  || fail "Permission skills absente"

echo ""
echo "Config globale :"
jq . "${GLOBAL_CONFIG}"
echo ""
echo "Config projet :"
jq . "${PROJECT_CONFIG}"

# Restaurer les configs
[ -f "${GLOBAL_CONFIG}.bak" ] && mv "${GLOBAL_CONFIG}.bak" "${GLOBAL_CONFIG}" && echo "Config globale restaurée."
[ -f "${PROJECT_CONFIG}.bak" ] && mv "${PROJECT_CONFIG}.bak" "${PROJECT_CONFIG}" && echo "Config projet restaurée."

echo ""
echo "=== Tous les tests passés ==="
