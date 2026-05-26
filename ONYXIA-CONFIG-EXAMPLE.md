# Exemple de configuration Onyxia pour init-script-opencode.sh

## Configuration minimale (Spark uniquement)

```yaml
init:
  personalInit: "https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh"
  personalInitArgs: ""

env:
  SPARK_API_KEY: "sk-6890deeabfbaa37b8aa1469c0fe548bd"
  SPARK_API_URL: "https://your-spark-api-endpoint.example.com/v1"
```

## Configuration complète (Spark + GitHub)

```yaml
init:
  personalInit: "https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh"
  personalInitArgs: ""

env:
  # Provider Spark (obligatoire)
  SPARK_API_KEY: "sk-6890deeabfbaa37b8aa1469c0fe548bd"
  SPARK_API_URL: "https://your-spark-api-endpoint.example.com/v1"
  
  # Provider GitHub (optionnel)
  GITHUB_TOKEN: "ghp_votre_token_github"
  GITHUB_API_URL: "https://models.inference.ai.azure.com"
  
  # Configuration OpenCode (optionnel)
  OPENCODE_VERSION: "latest"
  OPENCODE_INSTALL_DIR: "/home/onyxia/.opencode"
  WORK_DIR: "/home/onyxia/work"
```

## Configuration avec version spécifique

```yaml
init:
  personalInit: "https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh"
  personalInitArgs: ""

env:
  SPARK_API_KEY: "sk-6890deeabfbaa37b8aa1469c0fe548bd"
  SPARK_API_URL: "https://your-spark-api-endpoint.example.com/v1"
  OPENCODE_VERSION: "1.15.10"  # Version spécifique
```

## Combinaison avec d'autres scripts

### Avec init-script-continue.sh

```yaml
init:
  personalInit: |
    curl -sSL https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh | bash
    curl -sSL https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-continue.sh | bash
  personalInitArgs: ""

env:
  SPARK_API_KEY: "sk-6890deeabfbaa37b8aa1469c0fe548bd"
  SPARK_API_URL: "https://your-spark-api-endpoint.example.com/v1"
```

### Avec init-script-astree.sh

```yaml
init:
  personalInit: |
    curl -sSL https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh | bash
    curl -sSL https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-astree.sh | bash
  personalInitArgs: ""

env:
  SPARK_API_KEY: "sk-6890deeabfbaa37b8aa1469c0fe548bd"
  SPARK_API_URL: "https://your-spark-api-endpoint.example.com/v1"
  AWS_S3_ENDPOINT: "s3.fr-par.scw.cloud"
  AWS_DEFAULT_REGION: "fr-par"
```

## Variables d'environnement disponibles

| Variable | Obligatoire | Défaut | Description |
|----------|-------------|--------|-------------|
| `SPARK_API_KEY` | ✅ Oui | - | Clé API pour le provider Spark |
| `SPARK_API_URL` | ❌ Non | `https://your-spark-api-endpoint.example.com/v1` | URL de l'API Spark |
| `GITHUB_TOKEN` | ❌ Non | - | Token GitHub pour GitHub Models |
| `GITHUB_API_URL` | ❌ Non | `https://models.inference.ai.azure.com` | URL de l'API GitHub Models |
| `OPENCODE_VERSION` | ❌ Non | `latest` | Version d'OpenCode à installer |
| `OPENCODE_INSTALL_DIR` | ❌ Non | `$HOME/.opencode` | Répertoire d'installation |
| `WORK_DIR` | ❌ Non | `$HOME/work` | Répertoire de travail |

## Notes de sécurité

⚠️ **Important** : Les clés API sont stockées en clair dans le fichier `opencode.json`. 

**Bonnes pratiques** :
- Utilisez des variables d'environnement Onyxia pour stocker les secrets
- Ne commitez jamais les clés API dans Git
- Ajoutez `opencode.json` à `.gitignore` si nécessaire
- Utilisez des tokens avec des permissions minimales

## Vérification après installation

Après le démarrage de votre service Onyxia, vous pouvez vérifier l'installation :

```bash
# Vérifier la version d'OpenCode
opencode --version

# Vérifier la configuration
cat ~/work/opencode.json | jq .

# Lancer OpenCode
opencode
```

## Dépannage

### Le script ne s'exécute pas

Vérifiez les logs du service Onyxia pour voir les erreurs.

### Provider Spark non configuré

Assurez-vous que `SPARK_API_KEY` est bien défini dans les variables d'environnement.

### OpenCode n'est pas dans le PATH

Le script ajoute automatiquement OpenCode au PATH. Si ce n'est pas le cas, ajoutez manuellement :

```bash
export PATH="$HOME/.opencode/bin:$PATH"
```

### Réinstallation

Le script est idempotent. Vous pouvez le ré-exécuter sans problème :

```bash
curl -sSL https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh | bash
```

## Support

Pour toute question ou problème :
- Ouvrez une issue sur [GitHub](https://github.com/IA-Generative/onyxia/issues)
- Consultez la [documentation OpenCode](https://opencode.ai/docs)
