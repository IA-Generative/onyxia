# 📚 Index - init-script-opencode

## Vue d'ensemble

Ce dossier contient le script d'initialisation OpenCode pour Onyxia, avec toute la documentation et les fichiers de test nécessaires.

## 📁 Structure des fichiers

### Scripts principaux

| Fichier | Taille | Description |
|---------|--------|-------------|
| `init-script-opencode.sh` | 13K | Script principal d'installation et configuration |
| `test-init-script-opencode.sh` | 2.1K | Script de test automatisé |

### Configuration

| Fichier | Taille | Commiter ? | Description |
|---------|--------|-----------|-------------|
| `.env.example` | 1.8K | ✅ Oui | Template de configuration avec documentation |
| `.env.test` | 478B | ✅ Oui | Valeurs factices pour tests automatisés |
| `.env` | - | ❌ **NON** | Vos vraies clés API (à créer localement) |
| `opencode.json` | - | ❌ **NON** | Configuration générée (contient les clés) |
| `.gitignore-opencode` | 418B | ✅ Oui | Protection contre commit de secrets |

### Documentation

| Fichier | Taille | Description |
|---------|--------|-------------|
| `README-init-script-opencode.md` | 7.2K | Documentation complète du script |
| `QUICKSTART.md` | 3.2K | Guide de démarrage rapide |
| `TESTING-GUIDE.md` | 7.6K | Guide de test complet |
| `ONYXIA-CONFIG-EXAMPLE.md` | 4.5K | Exemples de configuration Onyxia |
| `CHANGELOG-init-script-opencode.md` | 5.1K | Historique des versions |
| `GITHUB-CLI-INTEGRATION.md` | 8.5K | Intégration GitHub CLI |
| `GITHUB-TOKEN-PERMISSIONS.md` | 7.8K | Guide des permissions du token GitHub |
| `TEST-RESULTS.md` | 6.2K | Résultats des tests |
| `INDEX.md` | - | Ce fichier |

## 🚀 Démarrage rapide

### Pour les utilisateurs Onyxia

1. Créer les secrets dans Onyxia :
   - `spark-api-key` : Votre clé API Spark
   - `github-token` : Votre token GitHub (optionnel)

2. Configurer votre service :
   ```yaml
   init:
     personalInit: "https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh"
   
   env:
     SPARK_API_KEY:
       fromSecret: "spark-api-key"
   ```

3. Démarrer le service → OpenCode sera automatiquement installé et configuré !

### Pour les développeurs locaux

```bash
# 1. Copier le template
cp .env.example .env

# 2. Éditer avec vos clés
nano .env

# 3. Charger et exécuter
source .env
./init-script-opencode.sh
```

### Pour les tests

```bash
# Test automatisé avec valeurs factices
./test-init-script-opencode.sh

# Ou manuellement
source .env.test
./init-script-opencode.sh
```

## 📖 Guide de lecture

### Je veux juste utiliser le script
→ Lisez [QUICKSTART.md](./QUICKSTART.md)

### Je veux comprendre comment ça marche
→ Lisez [README-init-script-opencode.md](./README-init-script-opencode.md)

### Je veux tester le script
→ Lisez [TESTING-GUIDE.md](./TESTING-GUIDE.md)

### Je veux configurer Onyxia
→ Lisez [ONYXIA-CONFIG-EXAMPLE.md](./ONYXIA-CONFIG-EXAMPLE.md)

### Je veux voir l'historique
→ Lisez [CHANGELOG-init-script-opencode.md](./CHANGELOG-init-script-opencode.md)

## 🔐 Sécurité

### ⚠️ À NE JAMAIS COMMITER

- `.env` (vos vraies clés)
- `opencode.json` (configuration générée avec clés)
- Tout fichier contenant des secrets

### ✅ Peut être commité

- `.env.example` (template sans secrets)
- `.env.test` (valeurs factices)
- `.gitignore-opencode` (protection)
- Tous les fichiers de documentation

### 🛡️ Protection

Ajoutez à votre `.gitignore` :
```bash
cat .gitignore-opencode >> .gitignore
```

## 🧪 Tests

### Tests disponibles

1. **Test sans variables** : Vérifie que le script échoue proprement
2. **Test avec Spark uniquement** : Vérifie la configuration Spark
3. **Test avec GitHub uniquement** : Vérifie la configuration GitHub
4. **Test complet** : Vérifie les deux providers
5. **Test d'idempotence** : Vérifie la ré-exécution

### Exécuter tous les tests

```bash
./test-init-script-opencode.sh
```

## 📊 Diagramme de flux

```
┌─────────────────────────────────────────────────────────────┐
│                    Démarrage du script                      │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│         Vérification des variables d'environnement          │
│  (SPARK_API_KEY ou GITHUB_TOKEN doit être défini)          │
└─────────────────────────┬───────────────────────────────────┘
                          │
                ┌─────────┴─────────┐
                │                   │
                ▼                   ▼
         ✅ Au moins un      ❌ Aucun provider
            provider             configuré
                │                   │
                │                   ▼
                │            Afficher erreur
                │            et quitter
                │
                ▼
┌─────────────────────────────────────────────────────────────┐
│           Installation des dépendances                      │
│         (curl, jq, git, gh si absents)                     │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              Installation d'OpenCode                        │
│    (si absent ou version différente demandée)              │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│         Création de la configuration JSON                   │
│  • Provider Spark (si SPARK_API_KEY défini)                │
│  • Provider GitHub (si GITHUB_TOKEN défini)                │
│  • Agents (build, plan, creative)                          │
│  • MCP (searchcode)                                        │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│           Vérification de l'installation                    │
│  • OpenCode accessible                                      │
│  • Configuration JSON valide                               │
│  • Providers configurés                                    │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              ✅ Installation terminée !                     │
│         Affichage du résumé et instructions                │
└─────────────────────────────────────────────────────────────┘
```

## 🔧 Variables d'environnement

### Obligatoires (au moins une)

- `SPARK_API_KEY` : Clé API pour Spark
- `GITHUB_TOKEN` : Token GitHub pour GitHub Models

### Optionnelles

- `SPARK_API_URL` : URL de l'API Spark (défaut fourni)
- `GITHUB_API_URL` : URL de l'API GitHub Models (défaut fourni)
- `OPENCODE_VERSION` : Version à installer (défaut: latest)
- `OPENCODE_INSTALL_DIR` : Répertoire d'installation (défaut: ~/.opencode)
- `WORK_DIR` : Répertoire de travail (défaut: ~/work)

## 🆘 Support

### Problèmes courants

| Problème | Solution |
|----------|----------|
| "Aucun provider configuré" | Définir SPARK_API_KEY ou GITHUB_TOKEN |
| "OpenCode n'est pas dans le PATH" | Redémarrer le shell ou `source ~/.bashrc` |
| "Configuration JSON invalide" | Vérifier les valeurs des variables d'env |
| Script ne s'exécute pas | Vérifier les permissions : `chmod +x init-script-opencode.sh` |

### Obtenir de l'aide

1. Consultez [TESTING-GUIDE.md](./TESTING-GUIDE.md)
2. Vérifiez les logs du script
3. Testez avec `.env.test` pour isoler le problème
4. Ouvrez une issue sur GitHub (sans inclure vos clés !)

## 📝 Contribution

Pour contribuer :

1. Fork le dépôt
2. Créez une branche : `git checkout -b feature/ma-fonctionnalite`
3. Testez vos modifications : `./test-init-script-opencode.sh`
4. Commitez : `git commit -m "feat: ma fonctionnalité"`
5. Push : `git push origin feature/ma-fonctionnalite`
6. Créez une Pull Request

## 📜 Licence

MIT License - Voir LICENSE pour plus de détails

## 🔗 Liens utiles

- [OpenCode Documentation](https://opencode.ai/docs)
- [Dépôt GitHub](https://github.com/IA-Generative/onyxia)
- [Onyxia Documentation](https://docs.onyxia.sh/)
- [GitHub Models](https://github.com/marketplace/models)

---

**Dernière mise à jour** : 2026-05-26  
**Version** : 1.0.0  
**Auteur** : IA-Generative - Ministère de l'Intérieur
