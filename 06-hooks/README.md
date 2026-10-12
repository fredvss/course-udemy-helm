# Helm Hooks

Exemplo mínimo de hook no Helm.

## Ideia

- o hook roda antes do install/upgrade
- é útil para migrar dados, preparar schema ou validar ambiente
- o recurso do hook fica em `templates/` com anotações do Helm

## Estrutura

```text
06-hooks/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── pre-install-job.yaml
│   └── deployment.yaml
└── README.md
```

## Hook usado

```yaml
metadata:
  annotations:
    "helm.sh/hook": pre-install,pre-upgrade
    "helm.sh/hook-weight": "-5"
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
```

## Comandos

```bash
helm lint .
helm template demo .
helm install demo . -n demo --create-namespace
kubectl get jobs -n demo
kubectl logs job/demo-migration -n demo
```

## Regra prática

Use hook para tarefas curtas e críticas, como migrar banco ou preparar estado. Evite hook para coisas permanentes e difíceis de acompanhar.
