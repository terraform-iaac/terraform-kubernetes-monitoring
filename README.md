# Prometheus + Alertmanager + Grafana
## Modules design to work with NFS
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
    
Source: https://github.com/helm/charts/tree/master/stable/prometheus-operator