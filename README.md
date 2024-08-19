# init-script-beta.sh

## Vue d'ensemble
Ce script, `init-script-beta.sh`, est conçu pour automatiser la configuration et la mise en place d'un environnement de développement utilisant VS Code Server et l'extension Privy. Il offre également des mécanismes pour créer et restaurer des sauvegardes des fichiers de configuration clés et des paquets installés.

**Important** : assurez-vous de remplir le fichier `/home/onyxia/work/apt_requirements.txt` avec les noms des paquets que vous souhaitez installer automatiquement lors de la restauration.

## Fonctionnalités
- **Installation de l'extension VS Code Server** : Installe automatiquement l'extension Privy pour VS Code Server.
- **Configuration de VS Code** : Ajoute des paramètres personnalisés à la configuration de VS Code pour l'intégration avec les services Privy spécifiques.
- **Sauvegarde et restauration** : Fournit un script pour sauvegarder périodiquement les répertoires et fichiers de configuration essentiels, ainsi qu'un autre script pour restaurer à partir de la dernière sauvegarde.

## Détail du script

### 1. Configuration de VS Code Server

- **Installation de l'extension Privy** :
  ```bash
  code-server --install-extension privy.privy-vscode
  ```
  Cette commande installe l'extension `privy-vscode`, nécessaire pour les configurations ultérieures.

- **Mise à jour des paramètres de VS Code** :
  ```bash
  jq '. + {
    "privy.providerBaseUrl": "https://ollama.c1.cloud-pi-native.com/",
    "privy.autocomplete.model": "deepseek-coder:1.3b-base",
    "privy.model": "custom",
    "privy.customModel": "gemma2:27b"
  }' /home/onyxia/.local/share/code-server/User/settings.json > /home/onyxia/.local/share/code-server/User/settings_tmp.json
  mv /home/onyxia/.local/share/code-server/User/settings_tmp.json /home/onyxia/.local/share/code-server/User/settings.json
  ```
  Ce bloc modifie les paramètres existants de VS Code pour configurer l'extension Privy avec des modèles et des URLs spécifiques.

### 2. Scripts de sauvegarde et de restauration

- **Restauration de la sauvegarde** :
  ```bash
  if [ ! -e "/home/onyxia/work/restore_backup.sh" ] ;then
    # Création du script restore_backup.sh
    ...
  fi
  ```
  - **Script de restauration de la sauvegarde** :
    - Définit le répertoire de sauvegarde.
    - Récupère la sauvegarde la plus récente.
    - Restaure les fichiers et répertoires de sauvegarde, et installe les paquets requis à l'aide de `apt-get`.

- **Création des sauvegardes** :
  - **backup_script.sh** :
    - Crée des sauvegardes périodiques des fichiers et répertoires clés, y compris les clés SSH, la configuration de VS Code, et d'autres configurations locales.
    - Sauvegarde optionnelle des paquets Python.
    - Nettoie automatiquement les anciennes sauvegardes, ne conservant que les 10 dernières.

### 3. Exécution et permissions
- Si le script de restauration n'existe pas, il sera créé avec le script de sauvegarde, et les deux scripts seront rendus exécutables.
- Si le script de restauration existe, l'opération de restauration est effectuée immédiatement, suivie du démarrage du processus de sauvegarde en arrière-plan.

## Utilisation
1. **Configuration initiale** : Exécutez `init-script-beta.sh` pour installer l'extension VS Code nécessaire, appliquer les configurations, et configurer les scripts de sauvegarde/restauration.
2. **Sauvegarde automatique** : Le script commencera automatiquement à créer des sauvegardes toutes les 90 secondes, ne conservant que les 10 dernières.
3. **Restauration** : Si nécessaire, le script restaurera automatiquement la sauvegarde la plus récente lors des exécutions suivantes.

## Fichiers et répertoires
- **Répertoire de sauvegarde** : `/home/onyxia/work/backup`
- **Scripts** :
  - `/home/onyxia/work/restore_backup.sh`
  - `/home/onyxia/work/backup_script.sh`
- **Configuration de VS Code** : `/home/onyxia/.local/share/code-server/User/settings.json`
- **Liste des paquets apt** : `/home/onyxia/work/apt_requirements.txt` (à remplir par l'utilisateur)

## Remarques
- Assurez-vous que `code-server` est installé et en cours d'exécution avant d'exécuter ce script.
- Le processus de sauvegarde fonctionne indéfiniment en arrière-plan, sauf s'il est arrêté manuellement.

## Licence
Ce script est fourni tel quel sous la [licence MIT](LICENSE), sans aucune garantie. Utilisez-le à vos risques et périls.
