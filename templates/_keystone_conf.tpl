{{- define "keystone-conf" }}
[DEFAULT]
public_endpoint={{ .Values.conf.public_endpoint }}
max_token_size=255

[auth]
methods=external,password,token,oauth1,mapped,application_credential,totp

{{- if .Values.conf.cors.allowed_origin }}
[cors]
allowed_origin={{ .Values.conf.cors.allowed_origin }}
allow_headers=Content-Type,Cache-Control,Content-Language,Expires,Last-Modified,Pragma,X-Auth-Token
{{- end }}

[token]
allow_expired_window=604800
expiration=21600
provider=fernet
revoke_by_id=True

{{- if .Values.conf.rcshib.allowed_hosts }}
[rcshibboleth]
allowed_hosts={{ join "," .Values.conf.rcshib.allowed_hosts }}
{{- end }}

[fernet_tokens]
key_repository=/etc/keystone/fernet-keys
max_active_keys=12

[credential]
key_repository=/etc/keystone/credential-keys

{{- if .Values.conf.cache.memcached_servers }}
[cache]
backend=oslo_cache.memcache_pool
enabled=True
memcached_servers={{ join "," .Values.conf.cache.memcached_servers }}
{{- end }}

[oslo_policy]
policy_file=/etc/keystone/policy.yaml

[database]
connection_recycle_time=60

[oslo_messaging_notifications]
driver=log

{{- end }}
