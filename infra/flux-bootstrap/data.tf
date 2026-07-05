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

  external_secrets_namespace              = "external-secrets"
  onepassword_service_account_secret_name = "onepassword-service-account-token"
  onepassword_service_account_secret_key  = "token"
}
