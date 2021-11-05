# Kubernetes monitoring (Prometheus+Alertmanager+Grafana)

Terraform module for monitoring your kubernetes cluster resources.

## Wokrflow

This module creates all necessary resources for monitor important objects inside your kubernetes cluster. Previously you need to create kubernetes secret with certificate to your domain name or create separate certs for grafana, alertmanager nad prometheus.
Also, optional (default ***false***), you can enable grafana ldap module to grant access for users from your LDAP server or use default admin account.

## Software Requirements

Name | Description
--- | --- |
Terraform | >= 0.14.9
Helm provider | >= 2.1.0
Kubernetes provider | >= 1.11.1

## Usage

```
module "monitoring" {
  source = "../"

  nfs_endpoint = "10.10.10.10"
  domain = "example.com"
  tls = "secret-tls"
  grafana_admin_password = "password"
  
  additional_set = [
    {
      name  = "coreDns.enabled"
      value = "false"
    },
    {
      name  = "kubeApiServer.enabled"
      value = "false"
    },
    {
      name  = "kubeProxy.enabled"
      value = "false"
    }
  ]


  grafana_ldap_enable = true
  grafana_ldap_host = "domain.com"
  grafana_ldap_bind_dn = "cn=reader,ou=users,ou=company,dc=example,dc=com"
  grafana_ldap_bind_password = "password"
  grafana_ldap_search_base_dn = "ou=company,dc=example,dc=com"
  grafana_ldap_search_filter = "(&(sAMAccountName=%s)(memberOf=cn=grafana_users,ou=groups,ou=company,dc=example,dc=com))"
  grafana_ldap_admin_group_dn = "cn=grafana_admin,ou=groups,ou=company,dc=example,dc=com"
  grafana_ldap_editor_group_dn = "cn=grafana_editor,ou=groups,ou=company,dc=example,dc=com"
}
```
### Note: If you want to see nginx-ingress-conroller metrics in grafana, please add next set to nginx-ingress-controller:
    {
      name = "controller.metrics.enabled"
      value = "true"
    },
    {
      name = "controller.metrics.serviceMonitor.enabled"
      value = "true"
    },
    {
      name = "controller.metrics.serviceMonitor.additionalLabels.release"
      value = "prometheus-operator"
    }

### If you use our nginx-controller module (https://registry.terraform.io/modules/terraform-iaac/nginx-controller/helm/latest) set next variable:
    metrics_enabled = true

## Inputs

Name | Description | Type | Default | Example | Required
--- | --- | --- | --- |--- |--- 
prometheus_chart_version | Prometheus Chart version | `string` | `15.2.0` | n/a | no
additional_set | Add additional set for helm prometheus-operator | <pre>list(object({<br>    name  = string<br>    value = string<br>    type  = string // Optional<br>  }))</pre> | `[]` | n/a | no |
additional_values | Add additional values (FILE) | `list(any)` | `[]` | `[file("../alertmanager_helm_config.yaml, file("../prom_helm_config.yaml]")` | no
namespace | Name of namespace where you want to deploy monitoring | `string` | `monitoring` | n/a | no
create_namespace | Create namespace by module? true or false | `bool` | true | n/a | no
nfs_endpoint | NFS with config files endpoint | `string` | `10.10.10.10` | n/a | yes
nfs_path | (Optional) Path on NFS, where volumes will create. (Need create manually and give permissions) | `string` | `"/"` | `/my_path` | no

### Persitant Volumes
Name | Description | Type | Default | Example | Required
--- | --- | --- | --- |--- |--- 
prometheus_disk_type | Prometheus disk type (nfs,gce,aws) | `string` | `nfs` | `aws` | no
prometheus_disk_param | Param for disk | `list(object)` | `[{}]` | n/a | no
prometheus_pv_name | Prometheus Persistant volume name | `string` | `monitoring-prometheus-pv` | n/a | no
prometheus_pv_size | Prometheus Persistant volume size | `string` | `10Gi` | n/a | no
prometheus_pv_storage_class_name | Prometheus Persistant volume storage class name | `string` |` monitoring-nfs-prometheus-pv` | n/a | no
prometheus_pv_access_modes | Prometheus Persitant volume access modes | `string` | `ReadWriteMany` | n/a | no
alertmanager_pv_name | Alertmanager Persistant volume name | `string` | `monitoring-alertmanager-pv` | n/a | no
alertmanager_pv_size | Alertmanager Persistant volume size | `string` | `2Gi` | n/a | no
alertmanager_pv_storage_class_name | Alertmanager Persistant volume storage class name | `string` | `monitoring-nfs-alertmanager-pv` | n/a | no
alertmanager_pv_access_modes | Alertmanager Persitant volume access modes | `string` | `ReadWriteMany` | n/a | no
prometheus_retentionSize | Used Storage Prometheus shall retain data for | `string` | `50GiB` | n/a | no
prometheus_retention | Time duration Prometheus shall retain data for. Must match the regular expression [0-9]+(ms/s/m/h/d/w/y) (milliseconds seconds minutes hours days weeks years) | `string` | `10d` | n/a | no
grafana_pv_name | Grafana Persistant volume name | `string` | `monitoring-grafana-pv` | n/a | no
grafana_pv_size | Grafana Persistant volume size | `string` | `10Gi` | n/a | no
grafana_storage_class_name | Grafana Persistant volume storage class name | `string` | `monitoring-nfs-grafana-pv` | n/a | no
grafana_pv_access_modes | Grafana Persitant volume access modes | `string` | `ReadWriteMany` | n/a | no

### Ingress
Name | Description | Type | Default | Example | Required
--- | --- | --- | --- |--- |--- 
domain | Name of main domain for all URLs | `string` | n/a | `example.com` | yes
alertmanager_subdomain | Sub-domain for access to alertmanager via web-browser | `string` | `alertmanager.` | n/a | no
prometheus_subdomain | Sub-domain for access to prometheus via web-browser | `string` | `prometheus.` | n/a | no
grafana_subdomain | Sub-domain for access to grafana via web-browser | `string` | `grafana.` | n/a | no
cidr_whitelist | General allow list for remote IP addresses | `string` | `0.0.0.0/0` | `8.8.8.8/32,192.168.1.1/16` | no
prometheus_whitelist | General allow list for remote IP addresses to access to prometheus | `string` | null | `8.8.8.8/32,192.168.1.1/16` | no
alertmanager_whitelist | General allow list for remote IP addresses to access to alertmanager | `string` | null | `8.8.8.8/32,192.168.1.1/16` | no
grafana_whitelist | General allow list for remote IP addresses to access to grafana | `string` | null | `8.8.8.8/32,192.168.1.1/16` | no
tls | TLS Secret name for all URLs | `string` | n/a | `secret-tls` | yes
prometheus_tls | Overwrite tls instead of general whitelist for prometheus | `string` | null | `prometheus-secret-tls` | no
alertmanager_tls | Overwrite tls instead of general whitelist for alertmanager | `string` | null | `alertmanager-secret-tls` | no
grafana_tls | Overwrite tls instead of general whitelist for grafana | `string` | null | `grafana-secret-tls` | no

### Grafana Auth
Name | Description | Type | Default | Example | Required
--- | --- | --- | --- |--- |--- 
grafana_admin_password | Grafana Admin Password ( Please redefine ) | `string` | `GrafanaSuperPassword` | `My?SeCrEtP@sSsF(W)0RD` | yes
grafana_ldap_enable | Ldap configs load | `bool` | false | n/a | no
grafana_ldap_host | grafana_ldap_host | `string` | `ldap.com` | `local.ldap.my` | no
grafana_ldap_bind_dn | Bind DN ( ussualy reader ) | `string` | `cn=reader,ou=users,ou=company,dc=ldap,dc=com` | n/a | no
grafana_ldap_bind_password | Password for Bind DN | `string` | `SecurePassword` | n/a | no
grafana_ldap_search_base_dn | Search Base DN | `string` | `ou=company,dc=ldap,dc=com` | n/a | no
grafana_ldap_search_filter | Search filter | `string` | `(&(sAMAccountName=%s)(memberOf=cn=grafana_users,ou=groups,ou=company,dc=ldap,dc=com))` | n/a | no
grafana_ldap_admin_group_dn | DN group for admin access | `string` | `cn=grafana_admin,ou=groups,ou=company,dc=ldap,dc=com` | n/a | no
grafana_ldap_editor_group_dn | DN group for editor access | `string` | `cn=grafana_editor,ou=groups,ou=company,dc=ldap,dc=com` | n/a | no

## Outputs
Name | Description
--- | --- 
namespace | Name of namespace where dashboard deployed
prometheus_url | URL for access to prometheus via web-browser
alertmanager_url | URL for access to alertmanager via web-browser
grafana_url | URL for access to grafana via web-browser
