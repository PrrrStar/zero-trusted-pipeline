{{- define "name" -}}
{{ .Release.Name }}
{{- end -}}

{{- define "namespace" -}}
ops
{{- end -}}

{{- define "common.labels" }}
app.kubernetes.io/name: {{ template "name" . }}
{{- if .Values.datadog.enabled }}
tags.datadoghq.com/env: face-{{ .Values.env }}
tags.datadoghq.com/service: {{ .Values.name }}
{{- end }}
{{- end }}
