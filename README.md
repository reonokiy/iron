# iron

Flux-managed k3s cluster configuration for `iron`.

The cluster does not pull its desired state from GitHub. GitHub is only the review
and validation boundary:

1. Changes are committed to this repository.
2. GitHub Actions renders the kustomize tree under `clusters/iron`.
3. After checks pass on `main`, the action publishes a rendered cluster bundle to
   Backblaze B2 through the S3-compatible API.
4. Flux in the k3s cluster reconciles from the B2 bucket.

## Repository Layout

- `clusters/iron/`: desired state applied by Flux from B2.
- `infra/civo/`: Terraform-managed Civo Kubernetes cluster.
- `infra/b2/`: Terraform-managed B2 bucket, B2 keys, GitHub Actions secrets,
  and Flux bootstrap outputs.
- `infra/flux-bootstrap/`: Terraform-managed Flux install, B2 source, and
  Kustomization.
- `.github/workflows/sync-b2.yml`: validation and B2 sync pipeline.

## Local Tooling

Tools are managed by mise. Initial Terraform secrets are resolved by fnox from
1Password.

```sh
mise install
```

Terraform state is managed by Terraform Cloud through the `cloud {}` blocks in
each `infra/*` stack. `TF_CLOUD_ORGANIZATION`, `TF_WORKSPACE`, and
`TF_TOKEN_app_terraform_io` are loaded by fnox.

## 1Password Configuration

Create the 1Password vaults referenced by `fnox.toml`, or update `fnox.toml`
and the Terraform variables below to match your vault names.

Before the first Terraform apply, create these 1Password items:

- `b2uswest`
  - `MASTER_KEY_ID`: a B2 key ID that can create buckets and application keys.
  - `MASTER_KEY`: the matching B2 application key.
- `terraform`
  - `API_TOKEN`: Terraform Cloud user/team token.
- `civo`
  - `API_KEY`: a Civo API token that can manage networks, firewalls, and
    Kubernetes clusters.
- `github-reonokiy-iron` in the `iron.nokiy.net` vault
  - `API_TOKEN`: a GitHub token that can manage this repository's Actions
    secrets.

fnox loads the GitHub token as `GITHUB_TOKEN` for local Terraform runs. For
Terraform Cloud remote execution, set `GITHUB_TOKEN` as a sensitive workspace
environment variable.

The Civo stack uses a separate Terraform Cloud workspace named `iron-civo` by
default. If Terraform Cloud runs it remotely, set `CIVO_TOKEN` as a sensitive
workspace environment variable in that workspace.

The Flux bootstrap stack uses a separate Terraform Cloud workspace named
`iron-flux-bootstrap` by default. Configure it for local execution unless
Terraform Cloud can reach the Kubernetes API and has kubeconfig credentials.

Then export a 1Password service account token with access to that vault:

```sh
export OP_SERVICE_ACCOUNT_TOKEN='<ops_...>'
```

Or sign in to the local 1Password CLI before running fnox:

```sh
op signin
```

## Terraform

### Civo Cluster

Initialize and apply the Civo Kubernetes cluster stack:

```sh
mise run civo:secrets:check
mise run civo:tf:init
mise run civo:tf:plan
mise run civo:tf:apply
```

By default this manages a Civo network named `iron`, a firewall named
`iron-k8s`, and a three-node k3s cluster named `iron` in `phx1` with Cilium.
It writes `.kube/iron.kubeconfig` under the repository root when the stack runs locally.
Existing Civo resources can be imported before the first apply; see
`infra/civo/README.md`.

### B2 Source

Initialize and apply the B2, GitHub Actions, and Flux bootstrap infrastructure:

```sh
mise run b2:secrets:check
mise run b2:tf:init
mise run b2:tf:plan
mise run b2:tf:apply
```

Terraform creates:

- a private B2 bucket for Flux cluster config,
- a prefix-scoped B2 write key for GitHub Actions,
- a bucket-scoped read-only B2 key for Flux,
- GitHub Actions repository secrets for the B2 write key,
- sensitive Terraform Cloud outputs for the Flux read key and bucket metadata.

By default the bucket name is `reonokiy-iron-flux` and the B2 region is
`us-west-004`. Override them by setting `TF_VAR_b2_bucket_name` and
`TF_VAR_b2_region` through your shell or fnox.

### Flux Bootstrap

After the B2 stack has published its Terraform Cloud outputs, install Flux and
create/update the in-cluster B2 Secret, Bucket source, and Kustomization:
The `flux-bootstrap` profile uses `.kube/iron.kubeconfig` by default.

```sh
mise run flux-bootstrap:secrets:check
mise run flux-bootstrap:tf:init
mise run flux-bootstrap:tf:plan
mise run flux-bootstrap:tf:apply
```

## GitHub Configuration

GitHub Actions does not read from 1Password. Terraform writes these repository
secrets directly during `mise run b2:tf:apply`:

- `B2_BUCKET`
- `B2_ENDPOINT`
- `B2_REGION`
- `B2_KEY_ID`
- `B2_APPLICATION_KEY`

The workflow renders this local path:

```text
clusters/iron
```

and publishes a revisioned rendered object plus a stable pointer:

```text
s3://$B2_BUCKET/clusters/iron/kustomization.yaml
s3://$B2_BUCKET/clusters/iron/releases/<revision>/rendered.yaml
```

The update avoids in-place directory syncs. Each `rendered.yaml` contains the
full rendered desired state as a single object under a revisioned path, and
`kustomization.yaml` is the stable entrypoint uploaded last to switch Flux to
that revision.

After the GitHub workflow has published the rendered bundle to B2, Flux
reconciles the `iron` Kustomization from the bucket. The cluster never reads
desired state from GitHub directly.
