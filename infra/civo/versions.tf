terraform {
  required_version = ">= 1.10.0"

  cloud {}

  required_providers {
    civo = {
      source  = "civo/civo"
      version = "~> 1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
