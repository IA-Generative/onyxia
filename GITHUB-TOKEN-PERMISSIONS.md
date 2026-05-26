# 🔑 Permissions du Token GitHub - Guide complet

## Vue d'ensemble

Pour utiliser pleinement le script `init-script-opencode.sh` avec GitHub, votre token doit avoir les bonnes permissions. Ce guide explique en détail chaque permission et pourquoi elle est nécessaire.

## 📋 Permissions requises

### 1. `repo` - Accès complet aux repositories

**Pourquoi ?**
- Lire le code source des repos
- Créer/modifier des issues
- Créer/merger des Pull Requests
- Accéder aux releases
- Lire/écrire les commits

**Inclut automatiquement :**
- `repo:status` - Accès au statut des commits
- `repo_deployment` - Accès aux déploiements
- `public_repo` - Accès aux repos publics
- `repo:invite` - Inviter des collaborateurs
- `security_events` - Accès aux alertes de sécurité

**Commandes gh disponibles :**
```bash
gh repo view <repo>
gh repo clone <repo>
gh issue create/list/view/close
gh pr create/list/view/merge
gh release create/list/view
```

### 2. `workflow` - Gestion des GitHub Actions

**Pourquoi ?**
- Lire les workflows GitHub Actions
- Voir les runs et leurs résultats
- Télécharger les artifacts
- Re-run des workflows
- Analyser les logs

**Commandes gh disponibles :**
```bash
gh workflow list
gh run list
gh run view <run-id>
gh run download <run-id>
gh run rerun <run-id>
gh run watch <run-id>
```

**Cas d'usage avec OpenCode :**
```bash
# Analyser un échec de CI
gh run view 123456 --log > ci-logs.txt
opencode "Analyse ces logs et trouve la cause de l'échec"

# Télécharger et analyser des artifacts
gh run download 123456
opencode "Analyse les artifacts de test"
```

### 3. `read:org` - Lecture des organisations

**Pourquoi ?**
- Lister les repos d'une organisation
- Voir les membres d'une équipe
- Accéder aux repos privés de l'org

**Commandes gh disponibles :**
```bash
gh repo list <org>
gh org view <org>
```

**Exemple :**
```bash
gh repo list IA-Generative
```

### 4. `read:project` - Lecture des projets

**Pourquoi ?**
- Accéder aux project boards
- Voir les colonnes et cartes
- Suivre l'avancement des tâches

**Commandes gh disponibles :**
```bash
gh project list
gh project view <project-id>
```

## 🔧 Créer le token avec les bonnes permissions

### Étape 1 : Aller sur GitHub

Ouvrir : https://github.com/settings/tokens/new

### Étape 2 : Configurer le token

**Note** : `OpenCode - GitHub Models & CLI`

**Expiration** : 90 jours (recommandé)

**Permissions à cocher** :

```
☑ repo
  ☑ repo:status
  ☑ repo_deployment
  ☑ public_repo
  ☑ repo:invite
  ☑ security_events

☑ workflow

☑ read:org

☑ read:project
```

### Étape 3 : Générer et copier

1. Cliquer sur **Generate token**
2. **Copier le token** : `github_pat_...`
3. ⚠️ **Important** : Vous ne pourrez plus le voir après !

### Étape 4 : Utiliser le token

```bash
# Dans .env
export GITHUB_TOKEN="github_pat_votre_token_ici"

# Exécuter le script
./init-script-opencode.sh
```

## 📊 Tableau récapitulatif

| Permission | Scope | Nécessaire pour | Commandes gh |
|------------|-------|-----------------|--------------|
| **repo** | Full | Code, Issues, PRs, Releases | `gh repo`, `gh issue`, `gh pr`, `gh release` |
| **workflow** | Full | Actions, Workflows, Artifacts | `gh workflow`, `gh run` |
| **read:org** | Read | Repos d'organisation | `gh repo list <org>` |
| **read:project** | Read | Project boards | `gh project` |

## 🧪 Vérifier les permissions

### Après configuration

```bash
# Vérifier l'authentification
gh auth status

# Résultat attendu :
# ✓ Logged in to github.com account <username>
# - Token scopes: 'repo', 'workflow', 'read:org', 'read:project'
```

### Tester chaque permission

```bash
# Test repo
gh repo view IA-Generative/onyxia

# Test workflow
gh run list --repo cli/cli --limit 3

# Test read:org
gh repo list IA-Generative

# Test read:project
gh project list --owner IA-Generative
```

## ⚠️ Permissions manquantes

### Symptômes

Si vous voyez des erreurs comme :
```
HTTP 403: Resource not accessible by personal access token
```

C'est que votre token n'a pas les bonnes permissions.

### Solution

1. Aller sur https://github.com/settings/tokens
2. Cliquer sur votre token
3. Cocher les permissions manquantes
4. Cliquer sur **Update token**
5. Ré-exécuter le script :
   ```bash
   gh auth refresh -h github.com -s repo,workflow,read:org,read:project
   ```

## 🔐 Sécurité

### Bonnes pratiques

1. **Expiration** : Définir une expiration (90 jours recommandé)
2. **Permissions minimales** : Ne cocher que ce qui est nécessaire
3. **Rotation** : Changer le token régulièrement
4. **Stockage** : Ne jamais commiter le token dans Git
5. **Révocation** : Révoquer immédiatement si compromis

### Révoquer un token

Si votre token est compromis :

1. Aller sur https://github.com/settings/tokens
2. Cliquer sur **Delete** à côté du token
3. Créer un nouveau token
4. Mettre à jour `.env`

## 📚 Ressources

- [GitHub Token Documentation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [GitHub Token Scopes](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/scopes-for-oauth-apps)
- [GitHub CLI Authentication](https://cli.github.com/manual/gh_auth_login)

## 🎯 Cas d'usage avancés

### 1. CI/CD avec OpenCode

```bash
# Analyser les échecs de CI
gh run list --workflow=ci.yml --status=failure
gh run view <run-id> --log > logs.txt
opencode "Analyse ces logs et propose des fixes"
```

### 2. Gestion des issues

```bash
# Créer des issues automatiquement
opencode "Crée une issue pour documenter la nouvelle fonctionnalité X"

# Analyser les issues ouvertes
gh issue list --state=open --json title,body > issues.json
opencode "Analyse ces issues et priorise-les"
```

### 3. Review de PRs

```bash
# Review automatique
gh pr view 123 --json title,body,files > pr.json
opencode "Review cette PR et suggère des améliorations"
```

### 4. Analyse de repos

```bash
# Cloner et analyser
gh repo clone IA-Generative/onyxia
cd onyxia
opencode "Analyse ce projet et explique sa structure"
```

## ✅ Checklist

Avant de commencer, vérifiez que :

- [ ] Vous avez créé un token sur GitHub
- [ ] Le token a les 4 permissions : `repo`, `workflow`, `read:org`, `read:project`
- [ ] Vous avez copié le token
- [ ] Vous avez ajouté le token à `.env`
- [ ] Vous avez exécuté le script
- [ ] `gh auth status` montre les bonnes permissions
- [ ] Vous pouvez exécuter `gh repo view`, `gh run list`, etc.

## 🎉 Résumé

**Permissions minimales requises** :
```
repo + workflow + read:org + read:project
```

**Créer le token** :
https://github.com/settings/tokens/new

**Utiliser** :
```bash
export GITHUB_TOKEN="github_pat_..."
./init-script-opencode.sh
```

**Vérifier** :
```bash
gh auth status
gh repo view IA-Generative/onyxia
gh run list --repo cli/cli --limit 3
```

C'est tout ! 🚀
