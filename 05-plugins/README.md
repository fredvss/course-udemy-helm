# Helm Plugins

Plugins ajudam a evoluir o fluxo de Helm sem complicar o setup.

## 1) Helm Dashboard

- Repo: https://github.com/komodorio/helm-dashboard
- Uso: visualiza releases, recursos e status do cluster em UI local.

```bash
helm plugin install https://github.com/komodorio/helm-dashboard.git
helm dashboard
```

## 2) Helm Unittest

- Repo: https://github.com/helm-unittest/helm-unittest
- Uso: testa templates e regras do chart sem precisar instalar no cluster.

```bash
helm plugin install https://github.com/helm-unittest/helm-unittest.git
helm unittest ./my-chart
```

## 3) Helm Diff

- Repo: https://github.com/databus23/helm-diff
- Uso: mostra a diferença entre o que vai mudar antes do upgrade.

```bash
helm plugin install https://github.com/databus23/helm-diff.git
helm diff upgrade my-release ./my-chart
```

## Regra prática

- `dashboard`: ver a situação da release
- `unittest`: validar templates
- `diff`: revisar mudanças antes de aplicar

## Lista rápida

```bash
helm plugin list
```

> Em geral, estes plugins não são obrigatórios, mas ajudam bastante no dia a dia quando o chart começa a crescer.
