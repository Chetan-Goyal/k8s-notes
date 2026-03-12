{{- define "mongo-stack.name" -}}
{{- .Chart.Name -}}
{{- end }}

{{- define "mongo-stack.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "mongo-stack.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}