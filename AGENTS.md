# Agent Instructions

- This repository is GitOps-driven. Manage cluster workload and operator changes through local Flux manifests under `clusters/iron`; do not create, patch, or delete those resources directly in the live cluster.
- Direct cluster commands are allowed for read-only inspection and validation. Live mutations are allowed only when the user explicitly asks for them or when operating the Terraform bootstrap stacks that are already designed to manage infrastructure.
