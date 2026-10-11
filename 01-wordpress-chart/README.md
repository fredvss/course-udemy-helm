# Helm: install, delete, update e rollback

## 0) Variaveis
```bash
RELEASE=my-wordpress
CHART=bitnami/wordpress
VERSION=34.1.3
VALUES=custom-values.yaml
```

Opcional (namespace):
```bash
NAMESPACE=default
```

## 1) Preparar repositorio
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm search repo bitnami/wordpress
```

## 2) Install
Sem values custom:
```bash
helm install $RELEASE $CHART --version $VERSION
```

Com arquivo custom:
```bash
helm install $RELEASE $CHART --version $VERSION -f $VALUES
```

Validacao rapida:
```bash
helm list
helm get values $RELEASE
```

## 3) Update (upgrade)
Aplicando novo values:
```bash
helm upgrade $RELEASE $CHART --version $VERSION --values $VALUES
```

Mantendo valores antigos + novos ajustes:
```bash
helm upgrade $RELEASE $CHART --version $VERSION --reuse-values --values $VALUES
```

Upgrade mais seguro (faz rollback automatico em falha):
```bash
helm upgrade $RELEASE $CHART \
	--version $VERSION \
	--values $VALUES \
	--atomic \
	--timeout 5m
```

## 4) Rollback
Ver revisoes:
```bash
helm history $RELEASE
```

Voltar para revisao especifica:
```bash
REVISION=4
helm rollback $RELEASE $REVISION
```

## 5) Delete (uninstall)
```bash
helm uninstall $RELEASE
helm list
```

## Comandos uteis
```bash
helm show chart bitnami/wordpress
helm repo list
```
