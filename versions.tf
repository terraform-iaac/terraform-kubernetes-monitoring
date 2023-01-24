terraform {
  required_version = ">= 1.0.0"

  required_providers {
    kubernetes = ">= 2.1.0"
    helm       = ">= 2.5.0"
  }
}