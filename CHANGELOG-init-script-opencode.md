# Changelog - init-script-opencode.sh

## Version 1.0.0 (2026-05-26)

### ✨ Fonctionnalités

- **Installation automatique d'OpenCode**
  - Détection de l'architecture (x64, arm64)
  - Téléchargement depuis le script officiel
  - Installation dans `~/.opencode`
  - Ajout automatique au PATH

- **Configuration des providers**
  - Provider Spark (qwen3.5:122b) - actif par défaut
  - Provider GitHub (claude-sonnet-4.5) - optionnel
  - Support des variables d'environnement pour les API keys
  - Configuration via `opencode.json`

- **Configuration des agents**
  - Agent `build` : temperature 0.1
  - Agent `plan` : temperature 0.1
  - Agent `creative` : temperature 0.8

- **Configuration MCP**
  - Serveur searchcode configuré par défaut

- **Installation des dépendances**
  - curl, jq, git
  - GitHub CLI (gh)

### 🎨 Interface

- Output coloré pour meilleure lisibilité
- Messages informatifs à chaque étape
- Résumé détaillé à la fin de l'installation
- Indicateurs visuels (✓, ○) pour les providers

### 🔒 Sécurité

- Pas de secrets hardcodés
- Utilisation de variables d'environnement
- Validation des entrées
- Gestion des erreurs robuste

### 🚀 Performance

- Idempotent (peut être exécuté plusieurs fois)
- Détection de l'installation existante
- Pas de réinstallation inutile

### 📝 Documentation

- README complet avec exemples
- Documentation des variables d'environnement
- Exemples de configuration Onyxia
- Guide de dépannage

### 🧪 Tests

- Script de test inclus
- Validation de la configuration JSON
- Vérification de l'installation

## Améliorations par rapport aux scripts existants

### vs init-script-beta.sh

| Fonctionnalité | init-script-beta.sh | init-script-opencode.sh |
|----------------|---------------------|-------------------------|
| Installation automatique | ❌ Non | ✅ Oui |
| Gestion des erreurs | ⚠️ Basique | ✅ Robuste |
| Output coloré | ❌ Non | ✅ Oui |
| Idempotence | ⚠️ Partielle | ✅ Complète |
| Documentation | ⚠️ Basique | ✅ Complète |
| Variables d'env | ⚠️ Limitées | ✅ Complètes |
| Backup/Restore | ✅ Oui | ❌ Non (focus init) |

### vs init-script-continue.sh

| Fonctionnalité | init-script-continue.sh | init-script-opencode.sh |
|----------------|-------------------------|-------------------------|
| Installation outil | ✅ Extension VS Code | ✅ OpenCode complet |
| Configuration | ⚠️ Basique | ✅ Avancée |
| Providers multiples | ❌ Non | ✅ Oui |
| Gestion des erreurs | ⚠️ Basique | ✅ Robuste |
| Documentation | ⚠️ Limitée | ✅ Complète |

### vs init-script-astree.sh

| Fonctionnalité | init-script-astree.sh | init-script-opencode.sh |
|----------------|----------------------|-------------------------|
| Scope | ⚠️ Multi-outils | ✅ Focus OpenCode |
| Installation S3 | ✅ Oui | ❌ Non |
| Installation UV | ✅ Oui | ❌ Non |
| Configuration IA | ⚠️ Via Continue | ✅ Native OpenCode |
| Modularité | ⚠️ Appelle d'autres scripts | ✅ Autonome |

## Points forts

1. **Robustesse**
   - Gestion complète des erreurs
   - Validation à chaque étape
   - Messages d'erreur clairs

2. **Flexibilité**
   - Variables d'environnement pour tout personnaliser
   - Support de multiples providers
   - Configuration modulaire

3. **Sécurité**
   - Pas de secrets hardcodés
   - Utilisation de variables d'environnement
   - Validation des entrées

4. **Maintenabilité**
   - Code bien structuré
   - Fonctions réutilisables
   - Documentation inline

5. **Expérience utilisateur**
   - Output coloré et clair
   - Messages informatifs
   - Résumé détaillé

## Limitations connues

1. **Pas de backup/restore**
   - Focus sur l'initialisation uniquement
   - Pour le backup, utiliser init-script-beta.sh

2. **Providers limités**
   - Actuellement : Spark et GitHub
   - Extensible pour d'autres providers

3. **Pas d'installation d'outils additionnels**
   - Pas d'installation de rclone, uv, etc.
   - Pour cela, utiliser init-script-astree.sh

4. **Pas d'extensions VS Code**
   - Focus sur OpenCode CLI
   - Pour les extensions, utiliser init-script-continue.sh

## Roadmap

### Version 1.1.0 (à venir)

- [ ] Support pour d'autres providers (Anthropic, OpenAI, Mistral)
- [ ] Configuration de modèles personnalisés
- [ ] Mode interactif pour la configuration
- [ ] Support pour les workspaces multiples

### Version 1.2.0 (à venir)

- [ ] Backup/restore de la configuration
- [ ] Mise à jour automatique d'OpenCode
- [ ] Gestion des versions multiples
- [ ] Configuration de plugins OpenCode

### Version 2.0.0 (futur)

- [ ] Interface web pour la configuration
- [ ] Intégration avec VS Code Server
- [ ] Support pour les environnements multi-utilisateurs
- [ ] Monitoring et logs avancés

## Contribution

Pour contribuer :

1. Fork le dépôt
2. Créez une branche pour votre fonctionnalité
3. Testez vos modifications
4. Soumettez une Pull Request

## Remerciements

- Équipe OpenCode pour l'outil
- Équipe Onyxia pour la plateforme
- Contributeurs du projet IA-Generative

## Licence

MIT License - Voir LICENSE pour plus de détails
