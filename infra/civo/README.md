# Civo Kubernetes Infrastructure

This Terraform stack manages the Civo Kubernetes cluster used by `iron`.

State is managed by Terraform Cloud. The `civo` fnox profile for this stack
uses the Terraform Cloud workspace `iron-civo`; create that workspace before
running `terraform init`, or override `TF_WORKSPACE`.

## Required Secrets

The default `fnox.toml` expects these items in the `dev` vault:

- `civo`
  - `API_KEY`: a Civo API token that can manage networks, firewalls, and
    Kubernetes clusters.
- `terraform`
  - `API_TOKEN`

To write `.kube/iron.kubeconfig` under the repository root, configure this workspace
for local execution. If Terraform Cloud runs remotely, `local_sensitive_file`
writes into the remote runner instead; also set `CIVO_TOKEN` as a sensitive
workspace environment variable in the `iron-civo` workspace.

## Commands

Run from the repository root:

```sh
mise run civo:secrets:check
mise run civo:tf:init
mise run civo:tf:plan
mise run civo:tf:apply
```

Terraform creates, by default:

- a Civo network named `iron`,
- a Civo firewall named `iron-k8s`,
- a three-node k3s cluster named `iron` in `phx1` using `g4s.kube.xsmall`
  nodes,
- Cilium as the k3s CNI through the `civo` fnox profile,
- `.kube/iron.kubeconfig` under the repository root, with `0700` directory
  permissions and `0600` file permissions.

Override the region, CNI, node size, node count, or kubeconfig path through the
`TF_VAR_civo_region`, `TF_VAR_cni`, `TF_VAR_node_size`, `TF_VAR_node_count`, and
`TF_VAR_kubeconfig_path` variables.

## Adopting An Existing Cluster

For an existing Civo cluster, import the existing resources into this stack
before the first apply. Set variables such as `TF_VAR_civo_region`,
`TF_VAR_node_size`, and `TF_VAR_node_count` to match the existing cluster before
planning.

```sh
fnox exec --profile civo --no-defaults -- terraform -chdir=infra/civo import 'civo_network.iron[0]' <network-id>
fnox exec --profile civo --no-defaults -- terraform -chdir=infra/civo import 'civo_firewall.iron[0]' <firewall-id>
fnox exec --profile civo --no-defaults -- terraform -chdir=infra/civo import civo_kubernetes_cluster.iron <cluster-id>
```

If you want Terraform to manage only the cluster, set `TF_VAR_network_id` and
`TF_VAR_firewall_id` to existing Civo IDs before importing the cluster.

This stack writes the kubeconfig locally with `local_sensitive_file`. The
kubeconfig is sensitive Terraform state data and the generated `*.kubeconfig`
file is ignored by Git.
