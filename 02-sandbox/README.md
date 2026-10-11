# 02-sandbox

Sandbox para estudar templates Helm com funcoes e condicionais.

## O que tem aqui
- Funcoes: `lower`, `replace`, `default`, `quote`, `printf`, `trunc`, `trimSuffix`
- Condicionais por ambiente (`dev` e `prod`)
- Flag de feature (`features.enableCanary`)

## Arquivos
- `values.yaml`: valores de entrada
- `templates/sandbox.yaml`: exemplo renderizado em ConfigMap

## Comandos
```bash
helm lint .
helm template demo .
```

Com ambiente prod:
```bash
helm template demo . --set app.env=prod
```

Com canary ligado:
```bash
helm template demo . --set features.enableCanary=true
```

