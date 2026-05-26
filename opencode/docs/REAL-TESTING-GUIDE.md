# 🧪 Guide de test RÉEL - init-script-opencode.sh

## Différence entre tests factices et tests réels

### Tests factices (CI/CD, validation du script)
- Utilisent `.env.test` avec des valeurs bidons
- Vérifient que le script **fonctionne** (logique, syntaxe, etc.)
- Ne testent PAS les vraies APIs
- ✅ Safe pour Git et CI/CD

### Tests réels (validation fonctionnelle)
- Utilisent `.env` avec vos **vraies clés**
- Vérifient que le script fonctionne avec les **vraies APIs**
- Testent la connexion réelle aux services
- ❌ Ne JAMAIS commiter `.env`

## 🔑 Test avec de vraies clés

### Étape 1 : Créer votre fichier .env

```bash
# Copier le template
cp .env.example .env

# Éditer avec vos VRAIES clés
nano .env
```

Contenu de `.env` :
```bash
# VRAIES clés - NE PAS COMMITER
export SPARK_API_KEY="sk-6890deeabfbaa37b8aa1469c0fe548bd"
export SPARK_API_URL="https://your-spark-api-endpoint.example.com/v1"

# Optionnel : GitHub
export GITHUB_TOKEN="ghp_votre_vrai_token"
export GITHUB_API_URL="https://models.inference.ai.azure.com"
```

### Étape 2 : Vérifier que .env est dans .gitignore

```bash
# Vérifier
grep "^\.env$" .gitignore

# Si absent, ajouter
echo ".env" >> .gitignore
```

### Étape 3 : Tester avec les vraies clés

```bash
# Charger les vraies clés
source .env

# Vérifier qu'elles sont chargées
echo "SPARK_API_KEY: ${SPARK_API_KEY:0:10}..."

# Exécuter le script
./init-script-opencode.sh
```

### Étape 4 : Vérifier que ça fonctionne vraiment

```bash
# Vérifier la configuration
cat opencode.json | jq '.provider.spark.options.apiKey' | head -c 20

# Tester OpenCode avec la vraie API
opencode --version

# Optionnel : Tester une requête simple
# opencode "Hello, test"
```

## 🔒 Sécurité : Checklist avant de commiter

Avant de faire `git add` ou `git commit`, vérifiez :

```bash
# 1. Vérifier que .env n'est PAS tracké
git status | grep -q "\.env" && echo "⚠️  ATTENTION : .env est tracké !" || echo "✓ .env n'est pas tracké"

# 2. Vérifier que opencode.json n'est PAS tracké
git status | grep -q "opencode.json" && echo "⚠️  ATTENTION : opencode.json est tracké !" || echo "✓ opencode.json n'est pas tracké"

# 3. Vérifier le contenu de .gitignore
cat .gitignore | grep -E "^\.env$|^opencode\.json$"

# 4. Vérifier qu'aucun fichier ne contient de vraies clés
grep -r "sk-6890dee" . --exclude-dir=.git 2>/dev/null && echo "⚠️  VRAIE CLÉ TROUVÉE !" || echo "✓ Aucune vraie clé trouvée"
```

## 📋 Scénarios de test réels

### Test 1 : Provider Spark uniquement

```bash
# .env
export SPARK_API_KEY="sk-6890deeabfbaa37b8aa1469c0fe548bd"
export SPARK_API_URL="https://your-spark-api-endpoint.example.com/v1"

# Tester
source .env
./init-script-opencode.sh

# Vérifier
cat opencode.json | jq '.provider | keys'
# Résultat attendu : ["spark"]
```

### Test 2 : Provider Spark + GitHub

```bash
# .env
export SPARK_API_KEY="sk-6890deeabfbaa37b8aa1469c0fe548bd"
export GITHUB_TOKEN="ghp_votre_vrai_token"

# Tester
source .env
./init-script-opencode.sh

# Vérifier
cat opencode.json | jq '.provider | keys'
# Résultat attendu : ["github", "spark"]
```

### Test 3 : Vérifier la connexion réelle

```bash
# Après avoir exécuté le script avec vraies clés
source .env
./init-script-opencode.sh

# Tester OpenCode
opencode --version

# Optionnel : Tester une vraie requête
# opencode "Écris un hello world en Python"
```

## 🔄 Workflow complet de test

```bash
# 1. Tests factices (validation du script)
echo "=== Tests factices ==="
source .env.test
./init-script-opencode.sh
echo "✓ Script fonctionne avec valeurs factices"

# 2. Nettoyage
rm -f opencode.json

# 3. Tests réels (validation fonctionnelle)
echo "=== Tests réels ==="
source .env
./init-script-opencode.sh
echo "✓ Script fonctionne avec vraies clés"

# 4. Vérification de sécurité
echo "=== Vérification sécurité ==="
git status | grep -q "\.env\|opencode.json" && echo "⚠️  ATTENTION : Fichiers sensibles trackés !" || echo "✓ Sécurité OK"

# 5. Nettoyage final
rm -f opencode.json
unset SPARK_API_KEY
unset GITHUB_TOKEN
```

## 🚀 Test dans Onyxia (environnement réel)

### Méthode 1 : Avec secrets Onyxia (RECOMMANDÉ)

1. **Créer les secrets dans Onyxia** :
   - Aller dans **Mon compte** > **Secrets**
   - Créer `spark-api-key` avec votre vraie clé
   - Créer `github-token` avec votre vrai token (optionnel)

2. **Configurer le service** :
   ```yaml
   init:
     personalInit: "https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh"
   
   env:
     SPARK_API_KEY:
       fromSecret: "spark-api-key"
     GITHUB_TOKEN:
       fromSecret: "github-token"
   ```

3. **Démarrer le service** et vérifier les logs

### Méthode 2 : Variables directes (pour test rapide)

```yaml
init:
  personalInit: "https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh"

env:
  SPARK_API_KEY: "sk-6890deeabfbaa37b8aa1469c0fe548bd"
  # GITHUB_TOKEN: "ghp_votre_token"  # Optionnel
```

⚠️ **Attention** : Cette méthode expose la clé dans la configuration. Préférez les secrets.

## 📊 Tableau récapitulatif

| Fichier | Contenu | Usage | Commiter ? |
|---------|---------|-------|-----------|
| `.env.test` | Valeurs factices | Tests CI/CD, validation script | ✅ Oui |
| `.env.example` | Placeholders | Template pour utilisateurs | ✅ Oui |
| `.env` | **VRAIES clés** | Tests locaux réels | ❌ **NON** |
| `opencode.json` | Config générée avec clés | Utilisé par OpenCode | ❌ **NON** |

## 🛡️ Protection automatique

Ajoutez ce hook Git pour éviter les accidents :

```bash
# .git/hooks/pre-commit
#!/bin/bash

# Vérifier qu'aucun fichier sensible n'est commité
if git diff --cached --name-only | grep -qE "^\.env$|^opencode\.json$"; then
    echo "❌ ERREUR : Vous essayez de commiter des fichiers sensibles !"
    echo "   Fichiers bloqués : .env, opencode.json"
    exit 1
fi

# Vérifier qu'aucune vraie clé n'est présente
if git diff --cached | grep -qE "sk-6890dee|ghp_[a-zA-Z0-9]{36}"; then
    echo "❌ ERREUR : Une vraie clé API a été détectée !"
    exit 1
fi

exit 0
```

Rendre exécutable :
```bash
chmod +x .git/hooks/pre-commit
```

## 💡 Bonnes pratiques

1. **Toujours tester avec `.env.test` d'abord**
   - Valide que le script fonctionne
   - Pas de risque d'exposer des clés

2. **Tester avec `.env` ensuite**
   - Valide la connexion aux vraies APIs
   - Vérifier que `.env` est dans `.gitignore`

3. **Nettoyer après les tests**
   ```bash
   rm -f opencode.json
   unset SPARK_API_KEY
   unset GITHUB_TOKEN
   ```

4. **Utiliser les secrets Onyxia en production**
   - Plus sécurisé
   - Centralisé
   - Auditable

5. **Rotation régulière des clés**
   - Changer les clés tous les 3-6 mois
   - Révoquer immédiatement si compromises

## 🆘 En cas de fuite de clé

Si vous avez accidentellement commité une vraie clé :

```bash
# 1. Révoquer immédiatement la clé compromise
# 2. Supprimer du Git history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env" \
  --prune-empty --tag-name-filter cat -- --all

# 3. Force push (ATTENTION : coordonner avec l'équipe)
git push origin --force --all

# 4. Générer une nouvelle clé
# 5. Mettre à jour .env localement
```

## 📚 Ressources

- [Documentation OpenCode](https://opencode.ai/docs)
- [Onyxia Secrets](https://docs.onyxia.sh/)
- [GitHub Tokens](https://docs.github.com/en/authentication)
- [Git Secrets](https://github.com/awslabs/git-secrets)

---

**Résumé** : Utilisez `.env.test` pour valider le script, `.env` pour tester avec les vraies APIs, et les secrets Onyxia en production. Ne commitez JAMAIS `.env` ou `opencode.json` !
