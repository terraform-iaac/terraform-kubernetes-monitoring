locals {
  prometheus_chart = "prometheus-operator"
  prometheus_chart_version = "8.13.8"
  prometheus_repository = "https://kubernetes-charts.storage.googleapis.com"
}

variable "additional_set" {
  description = "Add additional set for helm prometheus-operator"
  default = []
}

variable "additional_values" {
  description = "Add additional values (FILE)"
  default = ""
}

# Namespace
variable "namespace" {
  description = "Namespace name"
  type = string
  default = "monitoring"
}
variable "create_namespace" {
  description = "Create namespace by module ? true or false"
  type = bool
  default = true
}

# NFS
variable "nfs_endpoint" {
  description = "NFS endpoint"
  type = string
}
variable "nfs_path" {
  description = "(Optional) Path on NFS, where volumes will create. (Need create manually and give permissions). Also you can set '/' "
  type = string
  default = "/monitoring"
}

# Persitant Volumes
variable "prometheus_pv_name" {
  description = "Prometheus Persistant volume name"
  type = string
  default = "monitoring-prometheus-pv"
}
variable "prometheus_pv_size" {
  description = "Prometheus Persistant volume size"
  type = string
  default = "10Gi"
}
variable "prometheus_pv_storage_class_name" {
  description = "Prometheus Persistant volume storage class name"
  type = string
  default = "monitoring-nfs-prometheus-pv"
}
variable "prometheus_pv_access_modes" {
  description = "Prometheus Persitant volume access modes"
  type = string
  default = "ReadWriteMany"
}

variable "alertmanager_pv_name" {
  description = "Alertmanager Persistant volume name"
  type = string
  default = "monitoring-alertmanager-pv"
}
variable "alertmanager_pv_size" {
  description = "Alertmanager Persistant volume size"
  type = string
  default = "2Gi"
}
variable "alertmanager_storage_class_name" {
  description = "Alertmanager Persistant volume storage class name"
  type = string
  default = "monitoring-nfs-alertmanager-pv"
}
variable "alertmanager_pv_access_modes" {
  description = "Alertmanager Persitant volume access modes"
  type = string
  default = "ReadWriteMany"
}
variable "prometheus_retentionSize" {
  description = "Used Storage Prometheus shall retain data for. Example 50GiB (50 Gigabyte)"
  default = null
}
variable "prometheus_retention" {
  description = "Time duration Prometheus shall retain data for. Must match the regular expression [0-9]+(ms|s|m|h|d|w|y) (milliseconds seconds minutes hours days weeks years)"
  default = "10d"
}

variable "grafana_pv_name" {
  description = "Grafana Persistant volume name"
  type = string
  default = "monitoring-grafana-pv"
}
variable "grafana_pv_size" {
  description = "Grafana Persistant volume size"
  type = string
  default = "10Gi"
}
variable "grafana_storage_class_name" {
  description = "Grafana Persistant volume storage class name"
  type = string
  default = "monitoring-nfs-grafana-pv"
}
variable "grafana_pv_access_modes" {
  description = "Grafana Persitant volume access modes"
  type = string
  default = "ReadWriteMany"
}

# Ingress
variable "domain" {
  description = "(Required) Domain for all URLs"
  type = string
}
variable "alertmanager_subdomain" {
  description = "Subdomain to url. Must consist '.' "
  type = string
  default = "alertmanager."
}
variable "prometheus_subdomain" {
  description = "Subdomain to url. Must consist '.' "
  type = string
  default = "prometheus."
}
variable "grafana_subdomain" {
  description = "Subdomain to url. Must consist '.' "
  type = string
  default = "grafana."
}
variable "cidr_whitelist" {
  description = "General Whitelist for all URLs"
  type = string
  default = "0.0.0.0/0"
}
variable "prometheus_whitelist" {
  description = "Overwrite whitelist instead of general whitelist"
  type = string
  default = null
}
variable "alertmanager_whitelist" {
  description = "Overwrite whitelist instead of general whitelist"
  type = string
  default = null
}
variable "grafana_whitelist" {
  description = "Overwrite whitelist instead of general whitelist"
  type = string
  default = null
}

variable "tls" {
  description = "General TLS for all URLs"
  type = string
}
variable "prometheus_tls" {
  description = "Overwrite tls instead of general whitelist"
  type = string
  default = null
}
variable "alertmanager_tls" {
  description = "Overwrite tls instead of general whitelist"
  type = string
  default = null
}
variable "grafana_tls" {
  description = "Overwrite tls instead of general whitelist"
  type = string
  default = null
}

# Grafana Auth
variable "grafana_admin_password" {
  description = "Grafana Admin Password ( Please redefine )"
  type = string
  default = "GrafanaSuperPassword"
}

variable "grafana_ldap_enable" {
  description = "Ldap configs load"
  type = bool
  default = false
}
variable "grafana_ldap_host" {
  description = "Ldap Host"
  type = string
  default = "ldap.com"
}
variable "grafana_ldap_bind_dn" {
  description = "Bind DN ( ussualy reader )"
  type = string
  default = "cn=reader,ou=users,ou=company,dc=ldap,dc=com"
}
variable "grafana_ldap_bind_password" {
  description = "Password for Bind DN"
  type = string
  default = "SecurePassword"
}
variable "grafana_ldap_search_base_dn" {
  description = "Search Base DN"
  type = string
  default = "ou=company,dc=ldap,dc=com"
}
variable "grafana_ldap_search_filter" {
  description = "Search filter"
  type = string
  default = "(&(sAMAccountName=%s)(memberOf=cn=grafana_users,ou=groups,ou=company,dc=ldap,dc=com))"
}
variable "grafana_ldap_admin_group_dn" {
  description = "DN group for admin access"
  type = string
  default = "cn=grafana_admin,ou=groups,ou=company,dc=ldap,dc=com"
}
variable "grafana_ldap_editor_group_dn" {
  description = "DN group for editor access"
  type = string
  default = "cn=grafana_editor,ou=groups,ou=company,dc=ldap,dc=com"
}