resource "kubernetes_persistent_volume" "prometheus_pv" {
  metadata {
    name = var.prometheus_pv_name
  }
  spec {
    access_modes = [var.prometheus_pv_access_modes]
    capacity     = {
      storage    = var.prometheus_pv_size
    }
    storage_class_name               = var.prometheus_pv_storage_class_name
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      dynamic nfs {
        for_each = var.prometheus_disk_type == "nfs" ? var.prometheus_disk_param : []
        content {
          path   = lookup(nfs.value, "path",   var.nfs_path )
          server = lookup(nfs.value, "server", var.nfs_endpoint)
        }
      }

      dynamic aws_elastic_block_store {
        for_each = var.prometheus_disk_type == "aws" ? var.prometheus_disk_param : []
        content {
          volume_id = aws_elastic_block_store.value.volume_id
          read_only = lookup(aws_elastic_block_store.value, "read_only", false)
          partition = lookup(aws_elastic_block_store.value, "partition", null)
          fs_type   = lookup(aws_elastic_block_store.value, "fs_type",   null)
        }
      }

      dynamic gce_persistent_disk {
        for_each = var.prometheus_disk_type == "gce" ? var.prometheus_disk_param : []
        content {
          pd_name   = gce_persistent_disk.value.pd_name
          read_only = lookup(gce_persistent_disk.value, "read_only", false)
          partition = lookup(gce_persistent_disk.value, "partition", null)
          fs_type   = lookup(gce_persistent_disk.value, "fs_type",   null)
        }
      }

    }
  }
}
resource "kubernetes_persistent_volume" "alertmanager_pv" {
  metadata {
    name = var.alertmanager_pv_name
  }
  spec {
    access_modes = [var.alertmanager_pv_access_modes]
    capacity     = {
      storage    = var.alertmanager_pv_size
    }
    storage_class_name = var.alertmanager_storage_class_name
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        path   = var.nfs_path
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
    access_modes = [var.grafana_pv_access_modes]
    capacity     = {
      storage    = var.grafana_pv_size
    }
    storage_class_name               = var.grafana_storage_class_name
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      nfs {
        path   = var.nfs_path
        server = var.nfs_endpoint
      }
    }
  }
}