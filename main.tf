resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 1 : 0
  metadata {
    annotations = {
      name = var.namespace
    }
    name = var.namespace
  }
}

resource "kubernetes_config_map" "grafana_additional_dashboards" {
  metadata {
    name      = "grafana-additional-dashboards"
    namespace = var.create_namespace ? kubernetes_namespace.namespace[0].id : var.namespace
    labels = {
      "grafana_dashboard" = "1"
    }
  }
  data = {
    "grafana-dashboard-node-exporter.json"    = file("${path.module}/templates/grafana_dashboard_node_exporter.json")
    "grafana-dashboard-node-exporter_en.json" = file("${path.module}/templates/grafana_dashboard_node_exporter_en.json")
    "grafana-dashboard-nginx-controller.json" = file("${path.module}/templates/grafana_dashboard_nginx_controller.json")
  }
}

data "template_file" "grafana_ldap_toml" {
  template = file("${path.module}/templates/ldap.toml")
  vars = {
    host            = var.grafana_ldap_host
    bind_dn         = var.grafana_ldap_bind_dn
    bind_password   = var.grafana_ldap_bind_password
    search_base_dn  = var.grafana_ldap_search_base_dn
    search_filter   = var.grafana_ldap_search_filter
    admin_group_dn  = var.grafana_ldap_admin_group_dn
    editor_group_dn = var.grafana_ldap_editor_group_dn
  }
}

resource "kubernetes_secret" "grafana_ldap_toml" {
  metadata {
    name      = "prometheus-operator-grafana-ldap-toml"
    namespace = var.create_namespace ? kubernetes_namespace.namespace[0].id : var.namespace
  }

  data = {
    ldap-toml = data.template_file.grafana_ldap_toml.rendered
  }
}

resource "helm_release" "prometheus-operator" {
  name            = local.prometheus_chart
  repository      = local.prometheus_repository
  chart           = local.prometheus_chart
  namespace       = var.create_namespace ? kubernetes_namespace.namespace[0].id : var.namespace
  cleanup_on_fail = true
  version         = local.prometheus_chart_version

  # Set grafana.ini with ldap_auth or your custom values
  values = [var.grafana_ldap_enable ? file("${path.module}/templates/grafana.yaml") : "", var.additional_values]

  # Disable unused metrics
  set {
    name  = "kubeEtcd.enabled"
    value = "false"
  }
  set {
    name  = "kubeControllerManager.enabled"
    value = "false"
  }
  set {
    name  = "kubeScheduler.enabled"
    value = "false"
  }

  # Alert Manager
  set {
    name  = "alertmanager.ingress.enabled"
    value = "true"
  }
  set {
    name  = "alertmanager.ingress.pathType"
    value = "ImplementationSpecific"
  }
  set {
    name  = "alertmanager.ingress.hosts[0]"
    value = "${var.alertmanager_subdomain}${var.domain}"
  }
  set {
    name  = "alertmanager.ingress.tls[0].hosts[0]"
    value = "${var.alertmanager_subdomain}${var.domain}"
  }
  set {
    name  = "alertmanager.ingress.tls[0].secretName"
    value = var.alertmanager_tls == null ? var.tls : var.alertmanager_tls
  }
  set {
    name  = "alertmanager.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/whitelist-source-range"
    value = replace(var.alertmanager_whitelist == null ? var.cidr_whitelist : var.alertmanager_whitelist, ",", "\\,")
    type  = "string"
  }
  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.volumeName"
    value = kubernetes_persistent_volume.alertmanager_pv.id
  }
  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.accessModes[0]"
    value = var.alertmanager_pv_access_modes
  }
  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.storageClassName"
    value = kubernetes_persistent_volume.alertmanager_pv.spec.0.storage_class_name
  }
  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage"
    value = kubernetes_persistent_volume.alertmanager_pv.spec.0.capacity.storage
  }

  # Prometheus
  set {
    name  = "prometheus.ingress.enabled"
    value = "true"
  }
  set {
    name  = "prometheus.ingress.pathType"
    value = "ImplementationSpecific"
  }
  set {
    name  = "prometheus.ingress.hosts[0]"
    value = "${var.prometheus_subdomain}${var.domain}"
  }
  set {
    name  = "prometheus.ingress.tls[0].hosts[0]"
    value = "${var.prometheus_subdomain}${var.domain}"
  }
  set {
    name  = "prometheus.ingress.tls[0].secretName"
    value = var.prometheus_tls == null ? var.tls : var.prometheus_tls
  }
  set {
    name  = "prometheus.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/whitelist-source-range"
    value = replace(var.prometheus_whitelist == null ? var.cidr_whitelist : var.prometheus_whitelist, ",", "\\,")
    type  = "string"
  }
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.volumeName"
    value = kubernetes_persistent_volume.prometheus_pv.id
  }
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0]"
    value = var.prometheus_pv_access_modes
  }
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = kubernetes_persistent_volume.prometheus_pv.spec.0.storage_class_name
  }
  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = kubernetes_persistent_volume.prometheus_pv.spec.0.capacity.storage
  }
  set {
    name  = "prometheus.prometheusSpec.retentionSize"
    value = var.prometheus_retentionSize == null ? "${kubernetes_persistent_volume.prometheus_pv.spec.0.capacity.storage}B" : var.prometheus_retentionSize
  }
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = var.prometheus_retention
  }

  # Grafana
  set {
    name  = "grafana.ingress.enabled"
    value = "true"
  }
  set {
    name  = "grafana.ingress.pathType"
    value = "ImplementationSpecific"
  }
  set {
    name  = "grafana.ingress.hosts[0]"
    value = "${var.grafana_subdomain}${var.domain}"
  }
  set {
    name  = "grafana.ingress.tls[0].hosts[0]"
    value = "${var.grafana_subdomain}${var.domain}"
  }
  set {
    name  = "grafana.ingress.tls[0].secretName"
    value = var.grafana_tls == null ? var.tls : var.grafana_tls
  }
  set {
    name  = "grafana.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/whitelist-source-range"
    value = replace(var.grafana_whitelist == null ? var.cidr_whitelist : var.grafana_whitelist, ",", "\\,")
    type  = "string"
  }
  set {
    name  = "grafana.sidecar.dashboards.enabled"
    value = "true"
  }
  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }
  set {
    name  = "grafana.ldap.enabled"
    value = var.grafana_ldap_enable
  }
  set {
    name  = "grafana.ldap.existingSecret"
    value = kubernetes_secret.grafana_ldap_toml.metadata[0].name
  }
  set {
    name  = "grafana.persistence.enabled"
    value = "true"
  }
  set {
    name  = "grafana.persistence.storageClassName"
    value = kubernetes_persistent_volume.grafana_pv.spec.0.storage_class_name
  }
  set {
    name  = "grafana.persistence.volumeName"
    value = kubernetes_persistent_volume.grafana_pv.id
  }
  set {
    name  = "grafana.persistence.accessModes[0]"
    value = var.grafana_pv_access_modes
  }
  set {
    name  = "grafana.persistence.size"
    value = kubernetes_persistent_volume.grafana_pv.spec.0.capacity.storage
  }
  set {
    name  = "grafana.persistence.subPath"
    value = "grafana"
  }

  dynamic "set" {
    for_each = var.additional_set
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  depends_on = [kubernetes_persistent_volume.prometheus_pv, kubernetes_persistent_volume.alertmanager_pv, kubernetes_persistent_volume.grafana_pv, kubernetes_config_map.grafana_additional_dashboards]
}