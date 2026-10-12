# Subcharts

Exemplo enxuto de chart pai com app web e subchart de banco.

## Estrutura

```text
04-subcharts/
├── Chart.yaml
├── values.yaml
├── templates/
│   └── app.yaml
├── charts/
│   └── postgresql/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           └── db.yaml
└── README.md
```

## Ideia

- o chart pai monta a app web em Nginx
- o HTML da página fica em `.Values.app.html`
- o subchart `postgresql` representa o banco do sistema
- o pai usa dados do subchart em `.Values.postgresql.*`

## O que fica mais rico aqui

Em vez de apenas um ConfigMap simples, o pai mostra um cenário realista:

- app web servindo HTML customizado
- deploy do Nginx
- Service com NodePort
- banco via subchart

## Override rápido

```yaml
app:
  service:
    type: NodePort
    nodePort: 30080
  html: |
    <h1>Minha página customizada</h1>

postgresql:
  auth:
    username: appdb
    database: appdb
```

## Comandos

```bash
helm dependency update
helm lint .
helm template demo .
helm install demo . --create-namespace --namespace demo
kubectl get svc -n demo
kubectl get pods -n demo
```
