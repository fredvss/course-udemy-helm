# Helm Charts — guia visual e prático

> **Ideia central:** Helm é um gerenciador de pacotes/templates para Kubernetes. Um **Chart** reúne templates de recursos Kubernetes e valores de configuração. O Helm renderiza esses templates em manifestos YAML, que depois podem ser aplicados ao cluster.

## 1. Mapa mental: como tudo se conecta

```text
                  CHART (pasta do projeto)
                   │
      ┌────────────┼───────────────────────┐
      │            │                       │
  Chart.yaml   values.yaml             templates/
  Metadados    Configuração            Recursos com
  e deps       padrão                  placeholders
      │            │                       │
      │     values-prod.yaml                │
      │     (override opcional)            │
      │            └──────────┐            │
      └───────────────────────┼────────────┘
                              ▼
                     HELM RENDERIZA
               (helm template / install / upgrade)
                              │
                  YAML Kubernetes final
                              │
                 ┌────────────┼─────────────┐
                 ▼            ▼             ▼
              Deployment    Service       Ingress
                 │            │             │
                 ▼            ▼             ▼
                Pods      Rede interna   Roteamento

  charts/ = dependências (subcharts) usadas na renderização
```

## 2. Estrutura típica

```text
meu-chart/
├── Chart.yaml            # Identidade, versão e dependências
├── values.yaml           # Valores padrão usados nos templates
├── values-prod.yaml      # Exemplo opcional de valores por ambiente
├── charts/               # Dependências baixadas (subcharts)
├── templates/
│   ├── deployment.yaml   # ReplicaSet/Pods por meio do Deployment
│   ├── service.yaml      # Acesso estável aos Pods
│   ├── ingress.yaml      # Roteamento HTTP(S), se necessário
│   ├── configmap.yaml    # Configuração não sensível, se necessário
│   ├── _helpers.tpl      # Templates auxiliares reutilizáveis
│   ├── NOTES.txt         # Texto mostrado após install/upgrade
│   └── tests/            # Testes opcionais executáveis com helm test
├── .helmignore           # Arquivos ignorados ao empacotar
├── README.md             # Documentação (opcional)
└── LICENSE               # Licença (opcional)
```

| Item | Papel | É enviado diretamente ao Kubernetes? |
|---|---|---|
| `Chart.yaml` | `apiVersion: v2`, `name`, `version`, `appVersion`, `dependencies` | Não |
| `values.yaml` | Parâmetros padrão, acessados via `.Values` | Não |
| `templates/*.yaml` | Modelos que geram Deployment, Service, etc. | **O YAML renderizado, sim** |
| `templates/_helpers.tpl` | Funções/nomeações via `define` e `include` | Não, auxilia a renderização |
| `charts/` | Subcharts referenciados como dependências | Seus recursos renderizados, sim |
| `README.md`, `LICENSE`, `.helmignore` | Documentação, licença e empacotamento | Não |

## 3. Exemplo completo e pequeno

**Chart.yaml** — define *qual Chart é este*, não configura diretamente o Deployment:

```yaml
apiVersion: v2
name: my-application
version: 0.1.0      # versão do Chart
appVersion: "1.4.2"  # versão informativa da aplicação
```

**values.yaml** — valores padrão:

```yaml
replicaCount: 2
image:
  repository: example.com/my-application
  tag: "1.4.2"
service:
  port: 80
  targetPort: 4000
```

**templates/deployment.yaml** — os `{{ ... }}` são expressões de template Go usadas pelo Helm:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-my-application
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: my-application
  template:
    metadata:
      labels:
        app: my-application
    spec:
      containers:
        - name: my-application
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          ports:
            - containerPort: {{ .Values.service.targetPort }}
```

**templates/service.yaml** — o selector encontra os Pods com o label `app: my-application`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-my-application
spec:
  selector:
    app: my-application
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
```

Ao executar:

```bash
helm template minha-release ./meu-chart
```

O Helm substitui as expressões por valores concretos. Por exemplo, o Deployment resultante contém:

```yaml
metadata:
  name: minha-release-my-application
spec:
  replicas: 2
  # ...
          image: "example.com/my-application:1.4.2"
```

O Helm **não cria Pods diretamente**: ele envia o `Deployment` à API do Kubernetes; o controlador de Deployment/ReplicaSet cuida dos Pods. O `Service` seleciona esses Pods pelos labels.

## 4. Valores padrão, overrides e precedência

```text
values.yaml (padrão)
       +
values-prod.yaml (-f)
       +
--set replicaCount=4
       ▼
Valores finais usados em .Values
```

```yaml
# values-prod.yaml
replicaCount: 3
image:
  tag: "1.5.0"
```

```bash
helm upgrade --install my-application ./meu-chart \
  --namespace apps --create-namespace \
  -f values-prod.yaml \
  --set replicaCount=4
```

Neste caso, `replicaCount` termina em **4** e `image.tag` em **1.5.0**. Em geral, os valores de arquivos `-f` sobrescrevem os defaults; o último arquivo fornecido tem prioridade, e `--set` prevalece sobre `-f`.

## 5. Dependências: Chart.yaml ↔ charts/

```yaml
# Chart.yaml
apiVersion: v2
name: my-application
version: 0.1.0
dependencies:
  - name: redis
    version: "20.0.0"   # exemplo ilustrativo
    repository: "https://charts.bitnami.com/bitnami"
```

```bash
helm dependency update ./meu-chart
```

Isso resolve e baixa as dependências para `charts/`, atualizando `Chart.lock`. No momento da renderização, os subcharts também podem gerar recursos Kubernetes. **Versão do Chart (`version`) é diferente da versão do aplicativo (`appVersion`).**

## 6. Helm e Argo CD no fluxo de entrega

```text
Git: Chart + values do ambiente
              │
              ▼
       Argo CD detecta mudança
              │
              ▼
     Helm renderiza os templates
              │
              ▼
      YAML Kubernetes desejado
              │
              ▼
   Argo CD compara com o cluster
              │
              ▼
       Sync aplica diferenças
              │
              ▼
   Kubernetes reconcilia recursos
```

**Distinção importante:** no uso usual de *Helm Charts como source* no Argo CD, o Helm funciona como **gerador de YAML**; quem acompanha e sincroniza o estado é o **Argo CD**, e não uma instalação gerenciada como release Helm tradicional.

**ConfigMap/Secret mudou?** Atualizar o objeto não necessariamente reinicia os Pods. Quando a aplicação lê variáveis de ambiente, por exemplo, normalmente é preciso um novo rollout. Uma técnica comum é incluir checksum da configuração no template do Pod para forçar rollout quando ela mudar; montagens de arquivos têm comportamento diferente conforme o tipo de volume e a forma de leitura pela aplicação.

## 7. Comandos para guardar

| Comando | Para que serve |
|---|---|
| `helm create meu-chart` | Gera um Chart inicial |
| `helm lint ./meu-chart` | Verifica problemas comuns |
| `helm template teste ./meu-chart -f values-prod.yaml` | Mostra os YAMLs renderizados sem instalar |
| `helm upgrade --install teste ./meu-chart -n apps --create-namespace` | Instala ou atualiza release gerenciada pelo Helm |
| `helm dependency update ./meu-chart` | Baixa/atualiza dependências e lockfile |
| `helm list -n apps` | Lista releases gerenciadas pelo Helm |
| `helm history teste -n apps` | Histórico de revisões de uma release |
| `helm rollback teste 1 -n apps` | Volta a uma revisão anterior |

## Resumo em uma frase

**`Chart.yaml` identifica o pacote → `values.yaml` fornece dados → `templates/` transformam dados em YAML Kubernetes → Helm renderiza → Helm ou Argo CD aplica → Kubernetes reconcilia os recursos.**
