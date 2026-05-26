# init-script-opencode.sh

## Vue d'ensemble

Script d'initialisation automatique pour OpenCode dans l'environnement Onyxia. Ce script installe OpenCode, configure les providers IA (Spark et GitHub), et prépare l'environnement de développement.

## Fonctionnalités

- ✅ Installation automatique d'OpenCode (dernière version)
- ✅ Installation des dépendances (curl, jq, git, gh)
- ✅ Configuration du provider Spark (qwen3.5:122b) - actif par défaut
- ✅ Configuration optionnelle du provider GitHub (claude-sonnet-4.5)
- ✅ Configuration des agents (build, plan, creative)
- ✅ Configuration MCP (searchcode)
- ✅ Vérification et validation de l'installation
- ✅ Gestion des erreurs robuste
- ✅ Idempotent (peut être exécuté plusieurs fois)

## Variables d'environnement

### Obligatoires

| Variable | Description | Exemple |
|----------|-------------|---------|
| `SPARK_API_KEY` | Clé API pour le provider Spark | `sk-6890dee...` |

### Optionnelles

| Variable | Description | Défaut |
|----------|-------------|--------|
| `SPARK_API_URL` | URL de l'API Spark | `https://your-spark-api-endpoint.example.com/v1` |
| `GITHUB_TOKEN` | Token GitHub pour GitHub Models | _(non configuré si absent)_ |
| `GITHUB_API_URL` | URL de l'API GitHub Models | `https://models.inference.ai.azure.com` |
| `OPENCODE_VERSION` | Version spécifique à installer | `latest` |
| `OPENCODE_INSTALL_DIR` | Répertoire d'installation | `$HOME/.opencode` |
| `WORK_DIR` | Répertoire de travail | `$HOME/work` |

## Utilisation

### Dans Onyxia

Ajoutez le script dans la configuration de votre service Onyxia :

```yaml
init:
  personalInit: "https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh"
  personalInitArgs: ""

env:
  SPARK_API_KEY: "votre-clé-api-spark"
  SPARK_API_URL: "https://your-spark-api-endpoint.example.com/v1"
  GITHUB_TOKEN: ""  # Optionnel
```

### Exécution manuelle

```bash
# Avec les variables d'environnement
export SPARK_API_KEY="votre-clé-api"
export SPARK_API_URL="https://your-spark-api-endpoint.example.com/v1"
export GITHUB_TOKEN="ghp_votre_token"  # Optionnel

# Exécuter le script
bash init-script-opencode.sh
```

### Test local

```bash
# Télécharger le script
curl -fsSL https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh -o init-script-opencode.sh

# Rendre exécutable
chmod +x init-script-opencode.sh

# Définir les variables et exécuter
export SPARK_API_KEY="votre-clé"
./init-script-opencode.sh
```

## Configuration générée

Le script crée un fichier `opencode.json` dans `$WORK_DIR` avec la structure suivante :

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "spark": {
      "models": {
        "qwen3.5:122b": {
          "name": "qwen3.5:122b",
          "_launch": true
        }
      },
      "name": "spark",
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "apiKey": "...",
        "baseURL": "https://your-spark-api-endpoint.example.com/v1"
      }
    },
    "github": {
      "models": {
        "claude-sonnet-4.5": {
          "name": "claude-sonnet-4.5"
        }
      },
      "name": "github",
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "apiKey": "...",
        "baseURL": "https://models.inference.ai.azure.com"
      }
    }
  },
  "agent": {
    "build": { "temperature": 0.1 },
    "plan": { "temperature": 0.1 },
    "creative": { "temperature": 0.8 }
  },
  "mcp": {
    "searchcode": {
      "type": "remote",
      "url": "https://api.searchcode.com/v1/mcp"
    }
  }
}
```

## Providers configurés

### Spark (actif par défaut)

- **Modèle**: qwen3.5:122b
- **Usage**: Modèle par défaut pour toutes les tâches
- **Configuration**: Nécessite `SPARK_API_KEY`

### GitHub Models (optionnel)

- **Modèle**: claude-sonnet-4.5
- **Usage**: Modèle alternatif puissant
- **Configuration**: Nécessite `GITHUB_TOKEN`
- **Note**: Configuré uniquement si `GITHUB_TOKEN` est défini

## Agents configurés

| Agent | Temperature | Usage |
|-------|-------------|-------|
| `build` | 0.1 | Tâches de construction et code précis |
| `plan` | 0.1 | Planification et architecture |
| `creative` | 0.8 | Tâches créatives et brainstorming |

## Dépendances installées

Le script installe automatiquement :

- `curl` - Téléchargement de fichiers
- `jq` - Manipulation JSON
- `git` - Gestion de version
- `gh` - GitHub CLI

## Vérification de l'installation

Après l'exécution, le script affiche un résumé :

```
========================================
  OpenCode installé et configuré !
========================================

Version: 1.15.10
Config: /home/onyxia/work/opencode.json

Providers configurés:
  ✓ Spark (qwen3.5:122b) - actif par défaut
  ✓ GitHub (claude-sonnet-4.5)

Pour utiliser OpenCode:
  opencode                    # Lancer OpenCode
  opencode --help             # Afficher l'aide
```

## Dépannage

### OpenCode n'est pas dans le PATH

Le script ajoute automatiquement OpenCode au PATH dans `.bashrc`. Si ce n'est pas le cas :

```bash
export PATH="$HOME/.opencode/bin:$PATH"
```

### Provider Spark non configuré

Vérifiez que `SPARK_API_KEY` est défini :

```bash
echo $SPARK_API_KEY
```

### Provider GitHub non configuré

C'est normal si `GITHUB_TOKEN` n'est pas défini. Pour l'ajouter :

```bash
export GITHUB_TOKEN="ghp_votre_token"
./init-script-opencode.sh  # Ré-exécuter le script
```

### Erreur de permission

Si vous avez des erreurs de permission :

```bash
chmod +x init-script-opencode.sh
```

### Vérifier la configuration

```bash
cat $HOME/work/opencode.json | jq .
```

## Sécurité

⚠️ **Important** : Ne commitez jamais les clés API dans Git !

- Les clés API sont passées via variables d'environnement
- Le fichier `opencode.json` contient les clés en clair
- Ajoutez `opencode.json` à `.gitignore` si nécessaire

## Intégration avec d'autres scripts

Ce script est autonome mais peut être combiné avec d'autres scripts d'initialisation :

```bash
# Exemple : Combiner avec init-script-continue.sh
curl -sSL https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh | bash
curl -sSL https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-continue.sh | bash
```

## Améliorations futures

- [ ] Support pour d'autres providers (Anthropic, OpenAI, etc.)
- [ ] Configuration de modèles personnalisés
- [ ] Backup/restore de la configuration
- [ ] Mode interactif pour la configuration
- [ ] Support pour les workspaces multiples
- [ ] Intégration avec VS Code Server extensions

## Contribution

Pour contribuer ou signaler un problème :

1. Fork le dépôt [IA-Generative/onyxia](https://github.com/IA-Generative/onyxia)
2. Créez une branche pour votre fonctionnalité
3. Soumettez une Pull Request

## Licence

Ce script est fourni tel quel sous licence MIT.

## Auteur

IA-Generative - Ministère de l'Intérieur

## Voir aussi

- [OpenCode Documentation](https://opencode.ai/docs)
- [init-script-beta.sh](./init-script-beta.sh) - Script de backup/restore
- [init-script-continue.sh](./init-script-continue.sh) - Configuration Continue
- [init-script-astree.sh](./init-script-astree.sh) - Configuration Astree
