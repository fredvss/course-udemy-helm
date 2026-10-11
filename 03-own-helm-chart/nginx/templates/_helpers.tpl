{{/* Chart name */}}
{{- define "nginx.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Full resource name */}}
{{- define "nginx.fullname" -}}
{{- if .Release.Name -}}
{{- printf "%s-%s" .Release.Name (include "nginx.name" .) | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- include "nginx.name" . -}}
{{- end -}}
{{- end -}}

{{/* Common labels */}}
{{- define "nginx.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "nginx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* Selector labels */}}
{{- define "nginx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nginx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
