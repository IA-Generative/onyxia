# 🔧 Intégration GitHub CLI - init-script-opencode.sh

## Vue d'ensemble

Le script `init-script-opencode.sh` configure automatiquement **GitHub CLI (`gh`)** lorsqu'un `GITHUB_TOKEN` est fourni. Cela permet à OpenCode et aux développeurs d'interagir facilement avec GitHub (repos, issues, PRs, etc.).

## ✨ Fonctionnalités

### Configuration automatique

Lorsque `GITHUB_TOKEN` est défini, le script :

1. ✅ Installe `gh` CLI (si absent)
2. ✅ Authentifie `gh` avec votre token
3. ✅ Configure les permissions nécessaires :
   - `repo` : Accès complet aux repos (code, issues, PRs, releases)
   - `workflow` : Gestion des GitHub Actions et workflows
   - `read:org` : Lecture des organisations
   - `read:project` : Lecture des projets

### Permissions configurées

| Permission | Description | Usage |
|------------|-------------|-------|
| `repo` | Accès complet aux repos | Code, issues, PRs, releases, commits |
| `workflow` | Gestion des workflows | Actions, workflows, artifacts |
| `read:org` | Lecture des organisations | Lister les repos d'une org |
| `read:project` | Lecture des projets | Accéder aux project boards |

## 🚀 Utilisation

### Avec le script d'initialisation

```bash
# Définir le token GitHub
export GITHUB_TOKEN="github_pat_votre_token"
export SPARK_API_KEY="sk-votre-clé"

# Exécuter le script
./init-script-opencode.sh
```

Le script configurera automatiquement `gh` CLI.

### Vérifier la configuration

```bash
# Vérifier le statut d'authentification
gh auth status

# Résultat attendu :
# github.com
#   ✓ Logged in to github.com account <username>
#   - Token scopes: 'repo', 'read:org', 'read:project'
```

## 📋 Commandes `gh` disponibles

Une fois configuré, vous pouvez utiliser toutes les commandes `gh` :

### Repos

```bash
# Voir les infos d'un repo
gh repo view IA-Generative/onyxia

# Cloner un repo
gh repo clone IA-Generative/onyxia

# Lister vos repos
gh repo list

# Créer un repo
gh repo create mon-nouveau-repo --public
```

### Issues

```bash
# Lister les issues
gh issue list --repo IA-Generative/onyxia

# Créer une issue
gh issue create --title "Bug trouvé" --body "Description du bug"

# Voir une issue
gh issue view 123

# Fermer une issue
gh issue close 123
```

### Pull Requests

```bash
# Lister les PRs
gh pr list

# Créer une PR
gh pr create --title "Nouvelle fonctionnalité" --body "Description"

# Voir une PR
gh pr view 456

# Merger une PR
gh pr merge 456
```

### Gists

```bash
# Créer un gist
gh gist create mon-fichier.txt

# Lister vos gists
gh gist list
```

### GitHub Actions & Workflows

```bash
# Lister les workflows
gh workflow list

# Voir les runs d'un workflow
gh run list --workflow=ci.yml

# Voir les détails d'un run
gh run view 123456

# Télécharger les artifacts
gh run download 123456

# Re-run un workflow
gh run rerun 123456

# Voir les logs
gh run view 123456 --log
```

## 🔐 Sécurité

### Token GitHub

Le token GitHub doit avoir les permissions suivantes :

1. **Créer le token** : https://github.com/settings/tokens/new
2. **Permissions recommandées** :
   - ✅ **`repo`** (Full control of private repositories)
     - Inclut : Contents, Issues, Pull Requests, etc.
   - ✅ **`workflow`** (Update GitHub Action workflows)
     - Nécessaire pour : Actions, Workflows, Artifacts
   - ✅ **`read:org`** (Read org and team membership)
     - Nécessaire pour : Lister les repos d'une organisation
   - ✅ **`read:project`** (Read access to projects)
     - Nécessaire pour : Accéder aux project boards

### Détail des permissions

| Permission | Scope | Description | Nécessaire pour |
|------------|-------|-------------|-----------------|
| **repo** | Full | Accès complet aux repos | Contents, Issues, PRs, Releases |
| **workflow** | Full | Gestion des workflows | Actions, Workflows, Artifacts |
| **read:org** | Read | Lecture des organisations | Lister repos d'une org |
| **read:project** | Read | Lecture des projets | Project boards |

### Créer le token avec les bonnes permissions

1. Aller sur : https://github.com/settings/tokens/new
2. **Note** : `OpenCode - GitHub Models & CLI`
3. **Expiration** : 90 jours (recommandé)
4. **Cocher les permissions** :
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
5. Cliquer sur **Generate token**
6. **Copier le token** : `github_pat_...`

### Stockage sécurisé

Le token est stocké de manière sécurisée par `gh` dans :
```
~/.config/gh/hosts.yml
```

⚠️ **Important** : Ce fichier contient votre token en clair. Protégez-le :
```bash
chmod 600 ~/.config/gh/hosts.yml
```

## 🧪 Tests

### Test 1 : Vérifier l'authentification

```bash
gh auth status
```

**Résultat attendu** :
```
✓ Logged in to github.com account <username>
- Token scopes: 'repo', 'workflow', 'read:org', 'read:project'
```

### Test 2 : Accéder à un repo

```bash
gh repo view IA-Generative/onyxia
```

**Résultat attendu** : Informations sur le repo

### Test 3 : Lister les repos d'une org

```bash
gh repo list IA-Generative
```

**Résultat attendu** : Liste des repos de l'organisation

## 🔄 Ré-authentification

Si vous devez changer de token ou de compte :

```bash
# Se déconnecter
gh auth logout

# Se reconnecter avec un nouveau token
export GITHUB_TOKEN="nouveau_token"
./init-script-opencode.sh
```

Ou manuellement :
```bash
gh auth login
```

## 🎯 Cas d'usage avec OpenCode

### 1. Analyser un repo GitHub

```bash
# OpenCode peut maintenant accéder aux repos via gh
gh repo clone IA-Generative/onyxia
cd onyxia
opencode "Analyse ce projet et explique sa structure"
```

### 2. Créer des issues automatiquement

```bash
# OpenCode peut créer des issues
opencode "Crée une issue pour documenter le script init-script-opencode.sh"
```

### 3. Travailler avec des PRs

```bash
# OpenCode peut lire et commenter des PRs
gh pr view 123
opencode "Review cette PR et suggère des améliorations"
```

### 4. Gérer les GitHub Actions

```bash
# Voir les workflows et leurs résultats
gh workflow list
gh run list --workflow=ci.yml

# OpenCode peut analyser les échecs
gh run view 123456 --log > logs.txt
opencode "Analyse ces logs et trouve la cause de l'échec"

# Télécharger et analyser les artifacts
gh run download 123456
opencode "Analyse les artifacts téléchargés"
```

## 📊 Comportement du script

### Avec GITHUB_TOKEN défini

```
[INFO] Configuration de GitHub CLI...
[SUCCESS] GitHub CLI authentifié avec succès
[INFO] Permissions configurées : repo, workflow, read:org, read:project
```

### Sans GITHUB_TOKEN

```
[INFO] GITHUB_TOKEN non défini, GitHub CLI non configuré
```

Le script continue normalement, mais `gh` ne sera pas authentifié.

## 🛠️ Dépannage

### Problème : `gh` n'est pas authentifié

**Solution** :
```bash
# Vérifier que le token est défini
echo $GITHUB_TOKEN

# Ré-exécuter le script
./init-script-opencode.sh

# Ou authentifier manuellement
gh auth login
```

### Problème : Permissions insuffisantes

**Solution** :
```bash
# Rafraîchir les permissions
gh auth refresh -h github.com -s repo,workflow,read:org,read:project

# Vérifier
gh auth status
```

### Problème : Token expiré

**Solution** :
1. Créer un nouveau token sur https://github.com/settings/tokens
2. Mettre à jour `.env` avec le nouveau token
3. Ré-exécuter le script

## 📚 Ressources

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitHub CLI Manual](https://cli.github.com/manual/gh)
- [GitHub Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [GitHub CLI Authentication](https://cli.github.com/manual/gh_auth_login)

## ✅ Avantages

1. **Automatisation** : Configuration automatique de `gh` CLI
2. **Sécurité** : Utilise le token existant, pas besoin de le ressaisir
3. **Intégration** : OpenCode peut interagir avec GitHub facilement
4. **Productivité** : Commandes `gh` disponibles immédiatement
5. **Flexibilité** : Fonctionne avec ou sans token

## 🎉 Résumé

Le script configure automatiquement GitHub CLI avec les bonnes permissions, permettant à OpenCode et aux développeurs d'interagir facilement avec GitHub (repos, issues, PRs, etc.).

**Configuration minimale** :
```bash
export GITHUB_TOKEN="github_pat_votre_token"
export SPARK_API_KEY="sk-votre-clé"
./init-script-opencode.sh
```

**Vérification** :
```bash
gh auth status
gh repo view IA-Generative/onyxia
```

C'est tout ! 🚀
