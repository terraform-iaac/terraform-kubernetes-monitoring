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
    
### If you use our nginx-controller module set next variable:
    metrics_enabled = true
    
#### Helm provider version <=1.2.1
#### Kubernetes provider version <=1.11.1
Template version: 8.13.8


Source: https://github.com/helm/charts/tree/master/stable/prometheus-operator
