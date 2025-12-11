{{- define "n8n.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "n8n.fullname" -}}
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

{{- define "n8n.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "n8n.labels" -}}
helm.sh/chart: {{ include "n8n.chart" . }}
{{ include "n8n.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "n8n.selectorLabels" -}}
app.kubernetes.io/name: {{ include "n8n.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
N8N Image Configuration
*/}}
{{- define "n8n.image.repository" -}}
{{- .Values.n8n.image.repository | default "n8nio/n8n" }}
{{- end }}

{{- define "n8n.image.tag" -}}
{{- .Values.n8n.image.tag | default "latest" }}
{{- end }}

{{- define "n8n.image.pullPolicy" -}}
{{- .Values.n8n.image.pullPolicy | default "IfNotPresent" }}
{{- end }}

{{/*
PostgreSQL Configuration
*/}}
{{- define "postgresql.image.repository" -}}
{{- .Values.postgresql.image.repository | default "postgres" }}
{{- end }}

{{- define "postgresql.image.tag" -}}
{{- .Values.postgresql.image.tag | default "13" }}
{{- end }}

{{- define "postgresql.image.pullPolicy" -}}
{{- .Values.postgresql.image.pullPolicy | default "IfNotPresent" }}
{{- end }}

{{- define "postgresql.replicas" -}}
{{- .Values.postgresql.replicas | default 1 }}
{{- end }}

{{- define "postgresql.port" -}}
{{- .Values.postgresql.port | default 5432 }}
{{- end }}

{{- define "postgresql.storage.size" -}}
{{- .Values.postgresql.storage.size | default "5Gi" }}
{{- end }}

{{- define "postgresql.storage.storageClassName" -}}
{{- .Values.postgresql.storage.storageClassName | default "" }}
{{- end }}

{{- define "postgresql.enabled" -}}
{{- .Values.postgresql.enabled | default true }}
{{- end }}

{{/*
Redis Configuration
*/}}
{{- define "redis.image.repository" -}}
{{- .Values.redis.image.repository | default "redis" }}
{{- end }}

{{- define "redis.image.tag" -}}
{{- .Values.redis.image.tag | default "6.2" }}
{{- end }}

{{- define "redis.image.pullPolicy" -}}
{{- .Values.redis.image.pullPolicy | default "IfNotPresent" }}
{{- end }}

{{- define "redis.replicas" -}}
{{- .Values.redis.replicas | default 1 }}
{{- end }}

{{- define "redis.port" -}}
{{- .Values.redis.port | default 6379 }}
{{- end }}

{{- define "redis.storage.size" -}}
{{- .Values.redis.storage.size | default "1Gi" }}
{{- end }}

{{- define "redis.storage.storageClassName" -}}
{{- .Values.redis.storage.storageClassName | default "" }}
{{- end }}

{{- define "redis.enabled" -}}
{{- .Values.redis.enabled | default true }}
{{- end }}

{{/*
N8N Main Configuration
*/}}
{{- define "n8n.main.enabled" -}}
{{- .Values.n8n.main.enabled | default true }}
{{- end }}

{{- define "n8n.main.replicas" -}}
{{- .Values.n8n.main.replicas | default 1 }}
{{- end }}

{{- define "n8n.main.storage" -}}
{{- .Values.n8n.main.storage | default "5Gi" }}
{{- end }}

{{- define "n8n.main.storageClass" -}}
{{- .Values.n8n.main.storageClass | default "" }}
{{- end }}

{{/*
N8N Worker Configuration
*/}}
{{- define "n8n.worker.enabled" -}}
{{- .Values.n8n.worker.enabled | default true }}
{{- end }}

{{- define "n8n.worker.replicas" -}}
{{- .Values.n8n.worker.replicas | default 1 }}
{{- end }}

{{/*
N8N Config Defaults
*/}}
{{- define "n8n.config.dbType" -}}
{{- .Values.n8n.config.dbType | default "postgres" }}
{{- end }}

{{- define "n8n.config.dbHost" -}}
{{- .Values.n8n.config.dbHost | default "postgresql" }}
{{- end }}

{{- define "n8n.config.dbPort" -}}
{{- .Values.n8n.config.dbPort | default 5432 }}
{{- end }}

{{- define "n8n.config.dbDatabase" -}}
{{- .Values.n8n.config.dbDatabase | default .Values.postgresql.auth.database }}
{{- end }}

{{- define "n8n.config.dbUser" -}}
{{- .Values.n8n.config.dbUser | default .Values.postgresql.auth.username }}
{{- end }}

{{- define "n8n.config.dbSchema" -}}
{{- .Values.n8n.config.dbSchema | default "public" }}
{{- end }}

{{- define "n8n.config.executionsMode" -}}
{{- .Values.n8n.config.executionsMode | default "queue" }}
{{- end }}

{{- define "n8n.config.queueBullRedisHost" -}}
{{- .Values.n8n.config.queueBullRedisHost | default "redis" }}
{{- end }}

{{- define "n8n.config.queueBullRedisPort" -}}
{{- .Values.n8n.config.queueBullRedisPort | default 6379 }}
{{- end }}

{{- define "n8n.config.queueBullRedisDb" -}}
{{- .Values.n8n.config.queueBullRedisDb | default 1 }}
{{- end }}

{{- define "n8n.config.port" -}}
{{- .Values.n8n.config.port | default 5678 }}
{{- end }}

{{- define "n8n.config.secureCookie" -}}
{{- .Values.n8n.config.secureCookie | default "true" }}
{{- end }}

{{- define "n8n.config.blockEnvAccessInNode" -}}
{{- .Values.n8n.config.blockEnvAccessInNode | default "true" }}
{{- end }}

{{- define "n8n.config.payloadSizeMax" -}}
{{- .Values.n8n.config.payloadSizeMax | default "16" }}
{{- end }}

{{- define "n8n.config.executionsDataSaveOnError" -}}
{{- .Values.n8n.config.executionsDataSaveOnError | default "all" }}
{{- end }}

{{- define "n8n.config.executionsDataSaveOnSuccess" -}}
{{- .Values.n8n.config.executionsDataSaveOnSuccess | default "none" }}
{{- end }}

{{- define "n8n.config.executionsDataPrune" -}}
{{- .Values.n8n.config.executionsDataPrune | default "true" }}
{{- end }}

{{- define "n8n.config.executionsDataMaxAge" -}}
{{- .Values.n8n.config.executionsDataMaxAge | default "336" }}
{{- end }}

{{- define "n8n.config.timezone" -}}
{{- .Values.n8n.config.timezone | default "UTC" }}
{{- end }}

{{/*
Service Configuration
*/}}
{{- define "service.type" -}}
{{- .Values.service.type | default "ClusterIP" }}
{{- end }}

{{- define "service.port" -}}
{{- .Values.service.port | default 5678 }}
{{- end }}

{{- define "service.targetPort" -}}
{{- .Values.service.targetPort | default 5678 }}
{{- end }}

{{/*
Backup Configuration
*/}}
{{- define "backup.schedule" -}}
{{- .Values.backup.schedule | default "0 2 * * *" }}
{{- end }}

{{- define "backup.image.repository" -}}
{{- .Values.backup.image.repository | default "alpine/k8s" }}
{{- end }}

{{- define "backup.image.tag" -}}
{{- .Values.backup.image.tag | default "1.23.12" }}
{{- end }}

{{- define "backup.image.pullPolicy" -}}
{{- .Values.backup.image.pullPolicy | default "IfNotPresent" }}
{{- end }}

{{- define "backup.storage.pv.size" -}}
{{- .Values.backup.storage.persistentVolume.size | default "5Gi" }}
{{- end }}

{{- define "backup.storage.pv.storageClassName" -}}
{{- .Values.backup.storage.persistentVolume.storageClassName | default "" }}
{{- end }}


