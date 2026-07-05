# B2 Infrastructure

This Terraform stack creates the B2 bucket, prefix-scoped application keys,
GitHub Actions repository secrets, and Flux bootstrap Terraform Cloud outputs.

State is managed by Terraform Cloud. The `cloud {}` block is intentionally empty
so fnox can provide these environment variables:

- `TF_CLOUD_ORGANIZATION`
- `TF_WORKSPACE`
- `TF_TOKEN_app_terraform_io`

The workspace must exist in Terraform Cloud before `terraform init`.

## Required 1Password Items

The `b2` fnox profile expects these 1Password items:

- `b2uswest`
  - `MASTER_KEY_ID`
  - `MASTER_KEY`
- `terraform`
  - `API_TOKEN`
- `github-reonokiy-iron` in the `iron.nokiy.net` vault
  - `API_TOKEN`

fnox loads the GitHub token as `GITHUB_TOKEN` for local Terraform runs. For
Terraform Cloud remote execution, set `GITHUB_TOKEN` as a sensitive workspace
environment variable.

## Commands

Run from the repository root:

```sh
mise run b2:secrets:check
mise run b2:tf:init
mise run b2:tf:plan
mise run b2:tf:apply
```

After apply, Terraform writes the generated bucket metadata and scoped B2 keys to
these destinations:

- the GitHub Actions B2 write key goes directly to repository secrets,
- the Flux B2 read key and bucket metadata go to sensitive Terraform Cloud
  outputs consumed by the `infra/flux-bootstrap` stack.

The GitHub Actions write key can list, read, and write objects under the cluster
prefix, but it does not have delete permission.
