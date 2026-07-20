{{/*
Vault annotations
*/}}
{{- define "keystone.vaultAnnotations" -}}
vault.hashicorp.com/role: "{{ .Values.vault.role }}"
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/agent-pre-populate-only: "true"
vault.hashicorp.com/agent-inject-status: "update"
vault.hashicorp.com/secret-volume-path-secrets.conf: /etc/keystone/keystone.conf.d
vault.hashicorp.com/agent-inject-secret-secrets.conf: "{{ .Values.vault.settings_secret }}"
vault.hashicorp.com/agent-inject-template-secrets.conf: |
  {{ print "{{- with secret \"" .Values.vault.settings_secret "\" -}}" }}
  {{ print "[identity]" }}
  {{ print "password_reset_token={{ .Data.data.password_reset_token }}" }}
  {{ print "[rcshibboleth]" }}
  {{ print "admin_token={{ .Data.data.rcshib_admin_token }}" }}
  {{ print "[database]" }}
  {{ print "connection={{ .Data.data.database_connection }}" }}
  {{ print "[DEFAULT]" }}
  {{ print "transport_url={{ .Data.data.transport_url }}" }}
  {{ print "{{- end -}}" }}
{{- if .Values.sentry.enabled }}
vault.hashicorp.com/agent-inject-secret-sentry.env: "{{ .Values.vault.settings_secret }}"
vault.hashicorp.com/agent-inject-template-sentry.env: |
  {{ print "{{- with secret \"" .Values.vault.settings_secret "\" -}}" }}
  {{ print "{{- with .Data.data.sentry_dsn }}SENTRY_DSN={{ . }}{{ end }}" }}
  {{ print "{{- end -}}" }}
{{- end }}
{{- end }}
