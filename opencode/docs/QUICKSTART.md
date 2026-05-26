# 🚀 Guide de démarrage rapide - init-script-opencode.sh

## Installation en 3 étapes

### 1️⃣ Configurer les variables d'environnement dans Onyxia

Dans votre configuration de service Onyxia, ajoutez :

```yaml
env:
  SPARK_API_KEY: "votre-clé-api-spark"
```

### 2️⃣ Ajouter le script d'initialisation

```yaml
init:
  personalInit: "https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh"
```

### 3️⃣ Démarrer votre service

Le script s'exécutera automatiquement au démarrage et configurera OpenCode !

---

## ⚡ Test rapide en local

```bash
# Télécharger le script
curl -fsSL https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-opencode.sh -o init-script-opencode.sh

# Rendre exécutable
chmod +x init-script-opencode.sh

# Définir les variables et exécuter
export SPARK_API_KEY="votre-clé"
./init-script-opencode.sh
```

---

## 📊 Résultat attendu

```
========================================
  OpenCode installé et configuré !
========================================

Version: 1.15.10
Config: /home/onyxia/work/opencode.json

Providers configurés:
  ✓ Spark (qwen3.5:122b) - actif par défaut
  ○ GitHub (non configuré - définissez GITHUB_TOKEN)

Pour utiliser OpenCode:
  opencode                    # Lancer OpenCode
  opencode --help             # Afficher l'aide
```

---

## 🔧 Configuration minimale vs complète

### Minimale (Spark uniquement)

```yaml
env:
  SPARK_API_KEY: "sk-..."
```

### Complète (Spark + GitHub)

```yaml
env:
  SPARK_API_KEY: "sk-..."
  GITHUB_TOKEN: "ghp_..."
```

---

## ✅ Vérification après installation

```bash
# Vérifier la version
opencode --version

# Vérifier la configuration
cat ~/work/opencode.json | jq .

# Lancer OpenCode
opencode
```

---

## 🆘 Aide rapide

### Le script ne s'exécute pas ?
→ Vérifiez les logs du service Onyxia

### Provider Spark non configuré ?
→ Vérifiez que `SPARK_API_KEY` est défini

### OpenCode n'est pas dans le PATH ?
→ Ajoutez : `export PATH="$HOME/.opencode/bin:$PATH"`

---

## 📚 Documentation complète

- [README complet](./README-init-script-opencode.md)
- [Exemples de configuration](./ONYXIA-CONFIG-EXAMPLE.md)
- [Changelog](./CHANGELOG-init-script-opencode.md)

---

## 🎯 Cas d'usage

### Développeur solo
```yaml
env:
  SPARK_API_KEY: "sk-..."
```

### Équipe avec GitHub
```yaml
env:
  SPARK_API_KEY: "sk-..."
  GITHUB_TOKEN: "ghp_..."
```

### Environnement de production
```yaml
env:
  SPARK_API_KEY: "sk-..."
  OPENCODE_VERSION: "1.15.10"  # Version fixe
```

---

## 💡 Astuces

1. **Réutilisation** : Le script est idempotent, vous pouvez le ré-exécuter sans problème
2. **Sécurité** : Ne commitez jamais les clés API dans Git
3. **Combinaison** : Vous pouvez combiner avec d'autres scripts d'init
4. **Personnalisation** : Toutes les URLs et versions sont configurables

---

## 🔗 Liens utiles

- [OpenCode Documentation](https://opencode.ai/docs)
- [Dépôt GitHub](https://github.com/IA-Generative/onyxia)
- [Issues](https://github.com/IA-Generative/onyxia/issues)

---

**Prêt à commencer ? Lancez votre service Onyxia et profitez d'OpenCode ! 🚀**
