terraform {
  required_version = ">= 1.10.0"

  cloud {}

  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.13"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
