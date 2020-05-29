output "namespace" {
  value = var.namespace
}
output "prometheus_url" {
  value = "${var.prometheus_subdomain}${var.domain}"
}
output "alertmanager_url" {
  value = "${var.alertmanager_subdomain}${var.domain}"
}
output "grafana_url" {
  value = "${var.grafana_subdomain}${var.domain}"
}