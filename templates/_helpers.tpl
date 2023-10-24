{{/*
Expand the name of the chart.
*/}}
{{- define "headscale-webui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "headscale-webui.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "headscale-webui.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "headscale-webui.labels" -}}
helm.sh/chart: {{ include "headscale-webui.chart" . }}
{{ include "headscale-webui.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "headscale-webui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "headscale-webui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Headscale SecretKey
*/}}
{{- define "headscale-webui.secretkey" -}}
{{- $secret := lookup "v1" "Secret" .Release.Namespace ( include "headscale-webui.fullname" . ) -}}
{{- if and $secret $secret.data.flaskSecretKey -}}
{{ $secret.data.flaskSecretKey | b64dec }}
{{- else -}}
{{ randAlphaNum 64 }}
{{- end -}}
{{- end -}}

{{/*
Return true if a PVC object should be created
*/}}
{{- define "headscale-webui.createPVC" -}}
{{- if .Values.persistence.enabled }}
	{{- true -}}
{{- end -}}
{{- end -}}

{{/* 
get PVC name
*/}}
{{- define "headscale-webui.claimName" -}}
{{- if and .Values.persistence.existingClaim }}
	{{- printf "%s" (tpl .Values.persistence.existingClaim $) -}}
{{- else -}}
	{{- printf "%s" (include "headscale-webui.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "headscale-webui.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "headscale-webui.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

