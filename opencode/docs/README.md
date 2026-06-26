# OpenCode — Init script pour Onyxia

Configure automatiquement OpenCode sur un service Onyxia.

## Variables d'environnement

| Variable | Requis | Description |
|----------|--------|-------------|
| `API_KEY` | oui | Clé API du provider |
| `API_URL` | oui | URL de base de l'API (ex: `https://…/ollama/v1`) |

## Usage Onyxia

```yaml
init:
  personalInit: "https://raw.githubusercontent.com/IA-Generative/onyxia/main/opencode/scripts/init-script-opencode.sh"

env:
  API_KEY:
    fromSecret: "api-key"
  API_URL:
    fromSecret: "api-url"
```

## Usage local

```bash
cp opencode/config/.env.example .env
# éditer .env avec vos valeurs
source .env
bash opencode/scripts/init-script-opencode.sh
```

## Ce que fait le script

1. Installe [proto](https://moonrepo.dev/proto) (toolchain manager) et l'ajoute au `PATH` dans `~/.bashrc`
2. Installe **Node.js LTS** via proto
3. Installe **pnpm** (latest) via proto
4. Installe OpenCode (si absent)
5. Génère `~/.config/opencode/opencode.json` avec le provider spark (`qwen3.5:122b`), les agents et le MCP searchcode

Ce fichier se fusionne avec `opencode.json` (racine du projet, basé sur [dnum-mi/starter-kit-opencode](https://github.com/dnum-mi/starter-kit-opencode)).
