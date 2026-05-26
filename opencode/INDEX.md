# 📚 Index - OpenCode pour Onyxia

## Vue d'ensemble

Ce dossier contient une version organisée du script d'initialisation OpenCode pour Onyxia, avec toute la documentation et les fichiers de test nécessaires.

> **Note** : Les fichiers originaux restent à la racine du dépôt pour compatibilité. Ce dossier propose une organisation améliorée.

## 📁 Structure des fichiers

```
opencode/
├── README.md                    # Présentation et démarrage rapide
├── INDEX.md                     # Ce fichier - Navigation complète
├── scripts/                     # Scripts d'installation et test
│   ├── init-script-opencode.sh           # Script principal (13K)
│   └── test-init-script-opencode.sh      # Tests automatisés (2.1K)
├── config/                      # Configuration
│   ├── .env.example             # Template (✅ committable)
│   ├── .env.test                # Tests (✅ committable)
│   └── .gitignore-opencode      # Protection secrets (✅ committable)
└── docs/                        # Documentation
    ├── README-init-script-opencode.md    # Doc complète (7.2K)
    ├── QUICKSTART.md                     # Démarrage rapide (3.2K)
    ├── TESTING-GUIDE.md                  # Tests (7.6K)
    ├── REAL-TESTING-GUIDE.md             # Tests réels (7.8K)
    ├── ONYXIA-CONFIG-EXAMPLE.md          # Config Onyxia (4.5K)
    ├── CHANGELOG-init-script-opencode.md # Historique (5.1K)
    ├── GITHUB-CLI-INTEGRATION.md         # GitHub CLI (8.5K)
    ├── GITHUB-TOKEN-PERMISSIONS.md       # Permissions (7.8K)
    └── TEST-RESULTS.md                   # Résultats tests (6.2K)
```

## 🚀 Démarrage rapide

### Pour les utilisateurs Onyxia

1. Créer les secrets dans Onyxia :
   - `spark-api-key` : Votre clé API Spark
   - `github-token` : Votre token GitHub (optionnel)

2. Configurer votre service :
   ```yaml
   init:
     personalInit: "https://raw.githubusercontent.com/IA-Generative/onyxia/main/opencode/scripts/init-script-opencode.sh"
   
   env:
     SPARK_API_KEY:
       fromSecret: "spark-api-key"
   ```

3. Démarrer le service → OpenCode sera automatiquement installé et configuré !

### Pour les développeurs locaux

```bash
# 1. Copier le template
cp config/.env.example config/.env

# 2. Éditer avec vos clés
nano config/.env

# 3. Charger et exécuter
source config/.env
./scripts/init-script-opencode.sh
```

### Pour les tests

```bash
# Test automatisé avec valeurs factices
./scripts/test-init-script-opencode.sh

# Ou manuellement
source config/.env.test
./scripts/init-script-opencode.sh
```

## 📖 Guide de lecture

### Je veux juste utiliser le script
→ Lisez [docs/QUICKSTART.md](./docs/QUICKSTART.md)

### Je veux comprendre comment ça marche
→ Lisez [docs/README-init-script-opencode.md](./docs/README-init-script-opencode.md)

### Je veux tester le script
→ Lisez [docs/TESTING-GUIDE.md](./docs/TESTING-GUIDE.md)

### Je veux configurer Onyxia
→ Lisez [docs/ONYXIA-CONFIG-EXAMPLE.md](./docs/ONYXIA-CONFIG-EXAMPLE.md)

### Je veux voir l'historique
→ Lisez [docs/CHANGELOG-init-script-opencode.md](./docs/CHANGELOG-init-script-opencode.md)

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
cat opencode/config/.gitignore-opencode >> .gitignore
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
cd opencode
./scripts/test-init-script-opencode.sh
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
| Script ne s'exécute pas | Vérifier les permissions : `chmod +x scripts/init-script-opencode.sh` |

### Obtenir de l'aide

1. Consultez [docs/TESTING-GUIDE.md](./docs/TESTING-GUIDE.md)
2. Vérifiez les logs du script
3. Testez avec `config/.env.test` pour isoler le problème
4. Ouvrez une issue sur GitHub (sans inclure vos clés !)

## 📝 Contribution

Pour contribuer :

1. Fork le dépôt
2. Créez une branche : `git checkout -b feature/ma-fonctionnalite`
3. Testez vos modifications : `./scripts/test-init-script-opencode.sh`
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
