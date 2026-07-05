terraform {
  required_version = ">= 1.11.0"

  cloud {}

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.2.1, < 4.0.0"
    }
  }
}
