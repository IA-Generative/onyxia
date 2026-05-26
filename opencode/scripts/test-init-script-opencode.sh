#!/bin/bash

#############################################
# test-init-script-opencode.sh
# Script de test pour init-script-opencode.sh
#############################################

echo "========================================="
echo "  Test du script init-script-opencode.sh"
echo "========================================="
echo ""

# Charger les variables d'environnement de test
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/.env.test" ]; then
    echo "Chargement des variables de test depuis .env.test..."
    source "$SCRIPT_DIR/.env.test"
    echo "✓ Variables chargées"
else
    echo "⚠️  Fichier .env.test non trouvé, utilisation de valeurs par défaut"
    export SPARK_API_KEY="sk-test-spark-key"
    export SPARK_API_URL="https://your-spark-api-endpoint.example.com/v1"
    export GITHUB_TOKEN="ghp-test-github-token"
fi
echo ""

# Créer un répertoire de test temporaire
TEST_DIR="/tmp/opencode-test-$(date +%s)"
mkdir -p "$TEST_DIR"

echo "Répertoire de test: $TEST_DIR"
echo ""

# Copier le script dans le répertoire de test
cp /home/onyxia/work/init-script-opencode.sh "$TEST_DIR/"

# Exécuter le script avec un répertoire de travail de test
cd "$TEST_DIR"
export WORK_DIR="$TEST_DIR"
export OPENCODE_INSTALL_DIR="$HOME/.opencode"  # Utiliser l'installation existante

echo "Exécution du script..."
echo ""

bash "$TEST_DIR/init-script-opencode.sh"

echo ""
echo "========================================="
echo "  Vérification des résultats"
echo "========================================="
echo ""

# Vérifier que le fichier de config a été créé
if [ -f "$TEST_DIR/opencode.json" ]; then
    echo "✓ Fichier de configuration créé"
    echo ""
    echo "Contenu de la configuration:"
    cat "$TEST_DIR/opencode.json" | jq .
else
    echo "✗ Fichier de configuration non créé"
    exit 1
fi

echo ""
echo "========================================="
echo "  Test terminé avec succès !"
echo "========================================="
echo ""
echo "Répertoire de test: $TEST_DIR"
echo "Pour nettoyer: rm -rf $TEST_DIR"
