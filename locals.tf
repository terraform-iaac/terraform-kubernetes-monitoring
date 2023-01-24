locals {
  prometheus_chart      = "kube-prometheus-stack"
  prometheus_repository = "https://prometheus-community.github.io/helm-charts"
  grafana_ldap_auth     = [var.grafana_ldap_enable ? file("${path.module}/templates/grafana.yaml") : ""]

  grafana_ldap_toml = templatefile(
    "${path.module}/templates/ldap.toml",
    {
      host            = var.grafana_ldap_host
      bind_dn         = var.grafana_ldap_bind_dn
      bind_password   = var.grafana_ldap_bind_password
      search_base_dn  = var.grafana_ldap_search_base_dn
      search_filter   = var.grafana_ldap_search_filter
      admin_group_dn  = var.grafana_ldap_admin_group_dn
      editor_group_dn = var.grafana_ldap_editor_group_dn
    }
  )
}