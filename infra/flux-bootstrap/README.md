# Flux Bootstrap Infrastructure

This Terraform stack manages Flux installation and the in-cluster Flux resources
that point `iron` at the rendered B2 bundle:

- the Flux controllers and CRDs through the `flux2` Helm chart,
- the `flux-system` namespace,
- the B2 credentials Secret through the Kubernetes Terraform provider,
- the Flux `Bucket` source,
- the Flux `Kustomization`.

State is managed by Terraform Cloud. The default fnox profile for this stack
uses the Terraform Cloud workspace `iron-flux-bootstrap`. Because this stack
talks to the Kubernetes API, configure that workspace for local execution unless
Terraform Cloud can reach the cluster API and has kubeconfig credentials.

## Required Inputs

The default `fnox.toml` profile passes Terraform Cloud organization and workspace
metadata. This stack reads the B2 stack's Terraform Cloud outputs with
`terraform_remote_state`:

- B2 bucket, endpoint, region, and object prefix,
- Flux read key ID and application key.

The bootstrap profile sets `TF_VAR_b2_workspace` from the `Terraform
Cloud/workspace` 1Password field, which should point at the B2 stack workspace.

The B2 read key is stored in Terraform state as Kubernetes Secret data. It is not
stored in Helm release values.

## Commands

Run from the repository root:

```sh
mise run bootstrap:tf:init
mise run bootstrap:tf:plan
mise run bootstrap:tf:apply
```

The legacy task name still works and now runs Terraform:

```sh
mise run flux:bootstrap-b2
```

## Existing Installs

If Flux controllers or the B2 bootstrap resources already exist from `flux
install` or the previous shell bootstrap script, Terraform and Helm will not
automatically adopt them. Import or remove the existing B2 Secret before the
first apply. Remove the old Flux `Bucket` and `Kustomization`, or add the
required Helm ownership metadata manually.
