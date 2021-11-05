terraform {
  required_version = ">= 0.14.9"

  required_providers {
    kubernetes = ">= 2.1.0"
    helm       = ">= 1.11.1"
  }
}