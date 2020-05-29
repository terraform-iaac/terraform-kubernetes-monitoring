resource "kubernetes_persistent_volume" "prometheus_pv" {
  metadata {
    name = var.prometheus_pv_name
  }
  spec {
    access_modes = ["${var.prometheus_pv_access_modes}"]
    capacity = {
      storage = var.prometheus_pv_size
    }
    storage_class_name = var.prometheus_pv_storage_class_name
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        path = var.nfs_path
        server = var.nfs_endpoint
      }
    }
  }
}
resource "kubernetes_persistent_volume" "alertmanager_pv" {
  metadata {
    name = var.alertmanager_pv_name
  }
  spec {
    access_modes = ["${var.alertmanager_pv_access_modes}"]
    capacity = {
      storage = var.alertmanager_pv_size
    }
    storage_class_name = var.alertmanager_storage_class_name
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        path = var.nfs_path
        server = var.nfs_endpoint
      }
    }
  }
}
resource "kubernetes_persistent_volume" "grafana_pv" {
  metadata {
    name = var.grafana_pv_name
  }
  spec {
    access_modes = ["${var.grafana_pv_access_modes}"]
    capacity = {
      storage = var.grafana_pv_size
    }
    storage_class_name = var.grafana_storage_class_name
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        path = var.nfs_path
        server = var.nfs_endpoint
      }
    }
  }
}
/*
resource "kubernetes_persistent_volume_claim" "prometheus_pvс" {
  metadata {
    name = "prometheus-data"
    namespace = kubernetes_namespace.namespace.id
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = var.prometheus_pv_size
      }
    }
    volume_name = kubernetes_persistent_volume.prometheus_pv.metadata.0.name
    storage_class_name = kubernetes_persistent_volume.prometheus_pv.spec.0.storage_class_name
  }

  depends_on = [kubernetes_persistent_volume.prometheus_pv]
}
resource "kubernetes_persistent_volume_claim" "alertmanager_pvс" {
  metadata {
    name = "alertmanager-data"
    namespace = kubernetes_namespace.namespace.id
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = var.alertmanager_pv_size
      }
    }
    volume_name = kubernetes_persistent_volume.alertmanager_pv.metadata.0.name
    storage_class_name = kubernetes_persistent_volume.alertmanager_pv.spec.0.storage_class_name
  }

  depends_on = [kubernetes_persistent_volume.alertmanager_pv]
}*/
/*
resource "kubernetes_persistent_volume_claim" "grafana_pvс" {
  metadata {
    name = "grafana-data"
    namespace = kubernetes_namespace.namespace.id
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = var.grafana_pv_size
      }
    }
    volume_name = kubernetes_persistent_volume.grafana_pv.metadata.0.name
    storage_class_name = kubernetes_persistent_volume.grafana_pv.spec.0.storage_class_name
  }

  depends_on = [kubernetes_persistent_volume.grafana_pv]
}
*/
