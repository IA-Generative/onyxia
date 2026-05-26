# 🧪 Guide de test - init-script-opencode.sh

## Vue d'ensemble

Ce guide explique comment tester le script `init-script-opencode.sh` de manière sécurisée, sans exposer de vraies clés API.

## ⚠️ Sécurité

**IMPORTANT** : Le script ne contient AUCUNE clé API par défaut. Vous devez fournir vos propres clés via des variables d'environnement.

### Fichiers de configuration

| Fichier | Usage | Commiter ? |
|---------|-------|-----------|
| `.env.example` | Template avec documentation | ✅ Oui |
| `.env.test` | Valeurs factices pour tests | ✅ Oui |
| `.env` | Vos vraies clés API | ❌ **NON** |
| `opencode.json` | Config générée avec clés | ❌ **NON** |

## 🚀 Méthodes de test

### Méthode 1 : Test avec valeurs factices (Recommandé pour CI/CD)

```bash
# Charger les variables de test
source .env.test

# Exécuter le script
./init-script-opencode.sh
```

**Résultat** : Le script s'exécute et crée une configuration avec des clés factices. Parfait pour tester la logique du script.

### Méthode 2 : Test avec vraies clés (Développement local)

```bash
# 1. Copier le template
cp .env.example .env

# 2. Éditer avec vos vraies clés
nano .env

# 3. Charger les variables
source .env

# 4. Exécuter le script
./init-script-opencode.sh
```

**Résultat** : Le script s'exécute avec vos vraies clés et OpenCode sera fonctionnel.

### Méthode 3 : Test avec variables inline

```bash
SPARK_API_KEY="sk-test-key" \
GITHUB_TOKEN="ghp-test-token" \
./init-script-opencode.sh
```

**Résultat** : Les variables sont définies uniquement pour cette exécution.

### Méthode 4 : Test automatisé

```bash
# Utilise automatiquement .env.test
./test-init-script-opencode.sh
```

**Résultat** : Test complet avec vérifications automatiques.

## 📋 Scénarios de test

### Test 1 : Sans variables (doit échouer)

```bash
# Désactiver toutes les variables
unset SPARK_API_KEY
unset GITHUB_TOKEN

# Exécuter le script
./init-script-opencode.sh
```

**Résultat attendu** :
```
[ERROR] Aucun provider configuré !

Pour utiliser OpenCode, vous devez définir au moins une des variables suivantes :

  SPARK_API_KEY    - Pour utiliser le provider Spark (qwen3.5:122b)
  GITHUB_TOKEN     - Pour utiliser le provider GitHub (claude-sonnet-4.5)
```

### Test 2 : Avec Spark uniquement

```bash
export SPARK_API_KEY="sk-test-key"
unset GITHUB_TOKEN

./init-script-opencode.sh
```

**Résultat attendu** :
- ✅ Provider Spark configuré
- ⚠️ Provider GitHub non configuré (warning)

### Test 3 : Avec GitHub uniquement

```bash
unset SPARK_API_KEY
export GITHUB_TOKEN="ghp-test-token"

./init-script-opencode.sh
```

**Résultat attendu** :
- ⚠️ Provider Spark non configuré (warning)
- ✅ Provider GitHub configuré

### Test 4 : Avec les deux providers

```bash
export SPARK_API_KEY="sk-test-key"
export GITHUB_TOKEN="ghp-test-token"

./init-script-opencode.sh
```

**Résultat attendu** :
- ✅ Provider Spark configuré (actif par défaut)
- ✅ Provider GitHub configuré

### Test 5 : Idempotence (ré-exécution)

```bash
source .env.test

# Première exécution
./init-script-opencode.sh

# Deuxième exécution (doit fonctionner sans erreur)
./init-script-opencode.sh
```

**Résultat attendu** : Les deux exécutions réussissent, la configuration est mise à jour.

## 🔍 Vérifications après test

### Vérifier la configuration générée

```bash
# Afficher la configuration
cat opencode.json | jq .

# Vérifier les providers
cat opencode.json | jq '.provider | keys'

# Vérifier le provider actif par défaut
cat opencode.json | jq '.provider.spark.models."qwen3.5:122b"._launch'
```

### Vérifier OpenCode

```bash
# Version
opencode --version

# Aide
opencode --help
```

## 🧹 Nettoyage après test

```bash
# Supprimer la configuration générée
rm -f opencode.json

# Supprimer les variables d'environnement
unset SPARK_API_KEY
unset GITHUB_TOKEN
unset SPARK_API_URL
unset GITHUB_API_URL
unset OPENCODE_VERSION
```

## 🤖 Tests automatisés (CI/CD)

### GitHub Actions

```yaml
name: Test init-script-opencode

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Test script sans variables (doit échouer)
        run: |
          ./init-script-opencode.sh || echo "✓ Échec attendu"
      
      - name: Test script avec variables factices
        run: |
          source .env.test
          ./init-script-opencode.sh
      
      - name: Vérifier la configuration
        run: |
          test -f opencode.json
          jq empty opencode.json
          jq -e '.provider.spark' opencode.json
          jq -e '.provider.github' opencode.json
```

### Script de test local

```bash
#!/bin/bash

echo "=== Tests du script init-script-opencode.sh ==="

# Test 1: Sans variables
echo "Test 1: Sans variables (doit échouer)..."
if ./init-script-opencode.sh 2>&1 | grep -q "Aucun provider configuré"; then
    echo "✓ Test 1 réussi"
else
    echo "✗ Test 1 échoué"
    exit 1
fi

# Test 2: Avec variables
echo "Test 2: Avec variables de test..."
source .env.test
if ./init-script-opencode.sh; then
    echo "✓ Test 2 réussi"
else
    echo "✗ Test 2 échoué"
    exit 1
fi

# Test 3: Vérifier la configuration
echo "Test 3: Vérification de la configuration..."
if jq -e '.provider.spark' opencode.json >/dev/null 2>&1; then
    echo "✓ Test 3 réussi"
else
    echo "✗ Test 3 échoué"
    exit 1
fi

echo "=== Tous les tests réussis ! ==="
```

## 📝 Provisionnement dans Onyxia

### Configuration Onyxia avec secrets

Dans Onyxia, vous pouvez définir des secrets qui seront injectés comme variables d'environnement :

```yaml
# Configuration du service
init:
  personalInit: "https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh"

# Variables d'environnement (depuis les secrets Onyxia)
env:
  SPARK_API_KEY: 
    fromSecret: "spark-api-key"
  GITHUB_TOKEN:
    fromSecret: "github-token"
```

### Créer les secrets dans Onyxia

1. Aller dans **Mon compte** > **Secrets**
2. Créer un secret `spark-api-key` avec votre clé Spark
3. Créer un secret `github-token` avec votre token GitHub (optionnel)
4. Les secrets seront automatiquement injectés comme variables d'environnement

### Alternative : Variables d'environnement directes

```yaml
env:
  SPARK_API_KEY: "sk-votre-clé-réelle"
  GITHUB_TOKEN: "ghp-votre-token"
```

⚠️ **Attention** : Cette méthode expose les clés dans la configuration. Préférez les secrets.

## 🔐 Bonnes pratiques de sécurité

1. **Ne jamais commiter de clés réelles**
   ```bash
   # Ajouter à .gitignore
   echo ".env" >> .gitignore
   echo "opencode.json" >> .gitignore
   ```

2. **Utiliser des secrets Onyxia**
   - Plus sécurisé que les variables d'environnement directes
   - Centralisé et réutilisable

3. **Rotation des clés**
   - Changez régulièrement vos clés API
   - Révoquez les clés compromises immédiatement

4. **Permissions minimales**
   - Utilisez des tokens avec les permissions strictement nécessaires
   - Pour GitHub : `read:packages` suffit

5. **Audit**
   - Vérifiez régulièrement qui a accès aux secrets
   - Loggez les utilisations des clés API

## 📚 Ressources

- [Documentation OpenCode](https://opencode.ai/docs)
- [Onyxia Secrets](https://docs.onyxia.sh/)
- [GitHub Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

## 🆘 Support

En cas de problème :
1. Vérifiez que les variables sont bien définies : `echo $SPARK_API_KEY`
2. Vérifiez les logs du script
3. Testez avec `.env.test` pour isoler le problème
4. Ouvrez une issue sur GitHub avec les logs (sans les clés !)
