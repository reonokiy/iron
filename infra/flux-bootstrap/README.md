# Flux Bootstrap Infrastructure

This Terraform stack manages Flux installation and the in-cluster Flux resources
that point `iron` at the rendered B2 bundle:

- the Flux controllers and CRDs through the `flux2` Helm chart,
- the `flux-system` namespace,
- the B2 credentials Secret through the Kubernetes Terraform provider,
- the Flux `Bucket` source,
- the Flux `Kustomization`.

State is managed by Terraform Cloud. The `flux-bootstrap` fnox profile for this stack
uses the Terraform Cloud workspace `iron-flux-bootstrap`. Because this stack
talks to the Kubernetes API, configure that workspace for local execution unless
Terraform Cloud can reach the cluster API and has kubeconfig credentials.

## Required Inputs

The `flux-bootstrap` fnox profile passes Terraform Cloud organization and workspace
metadata. This stack reads the B2 stack's Terraform Cloud outputs with
`terraform_remote_state`:

- B2 bucket, endpoint, region, and object prefix,
- Flux read key ID and application key.

The `flux-bootstrap` profile sets `TF_VAR_b2_workspace` to the B2 stack workspace.

The B2 read key is stored in Terraform state as Kubernetes Secret data. It is not
stored in Helm release values.

## Commands

Run from the repository root:

```sh
mise run flux-bootstrap:secrets:check
mise run flux-bootstrap:tf:init
mise run flux-bootstrap:tf:plan
mise run flux-bootstrap:tf:apply
```

## Existing Installs

If Flux controllers or the B2 bootstrap resources already exist from `flux
install` or the previous shell bootstrap script, Terraform and Helm will not
automatically adopt them. Import or remove the existing B2 Secret before the
first apply. Remove the old Flux `Bucket` and `Kustomization`, or add the
required Helm ownership metadata manually.
