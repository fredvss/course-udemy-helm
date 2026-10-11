# nginx Helm Chart

Chart simples para subir um Nginx no Kubernetes com Deployment e Service.

## Estrutura
- templates/deployment.yaml
- templates/service.yaml
- values.yaml

## Valores principais
```yaml
replicaCount: 1
image:
  repository: nginx
  tag: "1.27.0"
  pullPolicy: IfNotPresent

containerPort: 80

service:
  type: ClusterIP
  port: 80
  targetPort: 80
  nodePort: null
```

Para usar NodePort:
```yaml
service:
  type: NodePort
  port: 80
  targetPort: 80
  nodePort: 30080 # opcional
```

## Comandos
Validar:
```bash
helm lint .
helm template meu-nginx .
```

Instalar:
```bash
helm install meu-nginx .
```

Instalar com NodePort:
```bash
helm install meu-nginx . --set service.type=NodePort
```

Instalar com NodePort fixo:
```bash
helm install meu-nginx . \
  --set service.type=NodePort \
  --set service.nodePort=30080
```

Atualizar:
```bash
helm upgrade meu-nginx . -f values.yaml
```

Atualizar para NodePort:
```bash
helm upgrade meu-nginx . --set service.type=NodePort
```

Ver porta publicada:
```bash
kubectl get svc
kubectl describe svc meu-nginx-nginx
```

Rollback:
```bash
helm history meu-nginx
helm rollback meu-nginx <REVISION>
```

Remover:
```bash
helm uninstall meu-nginx
```
