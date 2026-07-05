variable "kubeconfig_path" {
  description = "Optional kubeconfig path. Null uses the Kubernetes provider default lookup."
  type        = string
  default     = null
}

variable "kube_context" {
  description = "Optional kubeconfig context."
  type        = string
  default     = null
}

variable "tfc_hostname" {
  description = "Terraform Cloud hostname used by the B2 stack."
  type        = string
  default     = "app.terraform.io"
}

variable "tfc_organization" {
  description = "Terraform Cloud organization containing the B2 workspace."
  type        = string
}

variable "b2_workspace" {
  description = "Terraform Cloud workspace name for the B2 stack."
  type        = string
}

variable "namespace" {
  description = "Namespace where Flux controllers and source resources live."
  type        = string
  default     = "flux-system"
}

variable "external_secrets_namespace" {
  description = "Namespace where External Secrets Operator and its bootstrap token Secret live."
  type        = string
  default     = "external-secrets"
}

variable "flux_chart_repository" {
  description = "Helm repository containing the Flux chart."
  type        = string
  default     = "https://fluxcd-community.github.io/helm-charts"
}

variable "flux_chart_version" {
  description = "Flux Helm chart version."
  type        = string
  default     = "2.18.4"
}

variable "flux_install_crds" {
  description = "Whether the Flux Helm chart should install Flux CRDs."
  type        = bool
  default     = true
}

variable "flux_log_level" {
  description = "Flux controller log level."
  type        = string
  default     = "info"
}

variable "flux_watch_all_namespaces" {
  description = "Whether Flux controllers watch all namespaces."
  type        = bool
  default     = true
}

variable "flux_image_controllers_enabled" {
  description = "Whether to install Flux image automation and image reflector controllers."
  type        = bool
  default     = false
}

variable "secret_name" {
  description = "Kubernetes Secret name for Flux B2 credentials."
  type        = string
  default     = "b2-iron-config"
}

variable "onepassword_service_account_token" {
  description = "1Password service account token used by External Secrets Operator."
  type        = string
  sensitive   = true
  nullable    = false
}

variable "onepassword_service_account_secret_name" {
  description = "Kubernetes Secret name that stores the 1Password service account token for ESO."
  type        = string
  default     = "onepassword-service-account-token"
}

variable "onepassword_service_account_secret_key" {
  description = "Kubernetes Secret data key that stores the 1Password service account token for ESO."
  type        = string
  default     = "token"
}

variable "onepassword_service_account_token_revision" {
  description = "Revision for the write-only 1Password service account token Secret data. Increment to rotate the token."
  type        = number
  default     = 1
}

variable "bucket_source_name" {
  description = "Flux Bucket source name."
  type        = string
  default     = "iron-config"
}

variable "kustomization_name" {
  description = "Flux Kustomization name."
  type        = string
  default     = "iron"
}

variable "bucket_interval" {
  description = "Flux Bucket reconciliation interval."
  type        = string
  default     = "1m"
}

variable "bucket_timeout" {
  description = "Flux Bucket reconciliation timeout."
  type        = string
  default     = "60s"
}

variable "kustomization_interval" {
  description = "Flux Kustomization reconciliation interval."
  type        = string
  default     = "5m"
}

variable "kustomization_retry_interval" {
  description = "Flux Kustomization retry interval."
  type        = string
  default     = "1m"
}

variable "kustomization_timeout" {
  description = "Flux Kustomization reconciliation timeout."
  type        = string
  default     = "5m"
}

variable "kustomization_path" {
  description = "Path inside the Bucket artifact for the cluster kustomization."
  type        = string
  default     = "./clusters/iron"
}
