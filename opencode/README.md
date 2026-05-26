# 🚀 OpenCode - Scripts d'initialisation pour Onyxia

Configuration automatique d'OpenCode avec support Spark et GitHub Models pour la plateforme Onyxia.

## 📖 Documentation

Pour la documentation complète, consultez [INDEX.md](./INDEX.md)

## ⚡ Démarrage rapide

### Utilisation avec Onyxia

```yaml
init:
  personalInit: "https://raw.githubusercontent.com/IA-Generative/onyxia/main/opencode/scripts/init-script-opencode.sh"

env:
  SPARK_API_KEY:
    fromSecret: "spark-api-key"
```

### Utilisation locale

```bash
# 1. Configuration
cp config/.env.example config/.env
nano config/.env

# 2. Installation
source config/.env
./scripts/init-script-opencode.sh
```

## 📚 Documentation disponible

- **[INDEX.md](./INDEX.md)** - Index complet et navigation
- **[docs/QUICKSTART.md](./docs/QUICKSTART.md)** - Guide de démarrage rapide
- **[docs/README-init-script-opencode.md](./docs/README-init-script-opencode.md)** - Documentation technique complète
- **[docs/TESTING-GUIDE.md](./docs/TESTING-GUIDE.md)** - Guide de test
- **[docs/ONYXIA-CONFIG-EXAMPLE.md](./docs/ONYXIA-CONFIG-EXAMPLE.md)** - Exemples de configuration Onyxia

## 🗂️ Structure

```
opencode/
├── README.md              # Ce fichier
├── INDEX.md               # Index complet
├── scripts/               # Scripts d'installation
│   ├── init-script-opencode.sh
│   └── test-init-script-opencode.sh
├── config/                # Fichiers de configuration
│   ├── .env.example
│   ├── .env.test
│   └── .gitignore-opencode
└── docs/                  # Documentation
    ├── QUICKSTART.md
    ├── README-init-script-opencode.md
    ├── TESTING-GUIDE.md
    ├── REAL-TESTING-GUIDE.md
    ├── ONYXIA-CONFIG-EXAMPLE.md
    ├── CHANGELOG-init-script-opencode.md
    ├── GITHUB-CLI-INTEGRATION.md
    ├── GITHUB-TOKEN-PERMISSIONS.md
    └── TEST-RESULTS.md
```

## 🔐 Sécurité

**⚠️ Ne commitez JAMAIS vos clés API !**

- `.env` et `opencode.json` sont dans `.gitignore`
- Utilisez toujours les secrets Onyxia en production
- Consultez [docs/GITHUB-TOKEN-PERMISSIONS.md](./docs/GITHUB-TOKEN-PERMISSIONS.md) pour les permissions

## 📝 Licence

MIT License - Voir LICENSE pour plus de détails

---

**Ministère de l'Intérieur** - IA-Generative
