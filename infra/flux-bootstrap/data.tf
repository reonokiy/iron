data "terraform_remote_state" "b2" {
  backend = "remote"

  config = {
    hostname     = var.tfc_hostname
    organization = var.tfc_organization

    workspaces = {
      name = var.b2_workspace
    }
  }
}

locals {
  b2 = data.terraform_remote_state.b2.outputs
}
